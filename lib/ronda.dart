// GUARDEM TOTA LA INFORMACIÓ D'UNA RONDA

import 'dart:async';

import 'package:flutter/material.dart';
import 'jugador.dart';
import 'partida.dart';
import 'escollir_jugador.dart';
import 'final_partida.dart';
import 'opcions.dart';
import 'so_joc.dart';
import 'tema.dart';
import 'widgets_tema.dart';

// Els torns de la nit, en ordre. El número és la posició dins la llista.
// Per canviar l'ordre de la nit només cal canviar l'ordre d'aquesta llista.
enum Fase {
  pobleDorm, // torn 0: el campament dorm durant 5 segons
  tornGenetista, // torn 1: la genetista es desperta i descobreix un rol
  genetistaDorm, // torn 2: la genetista s'adorm durant 5 segons
  tornLlops, // torn 3: els dinosaures es desperten i trien la víctima
  llopsDormen, // torn 4: els dinosaures s'adormen (5 segons)
  tornMetgessa,
  metgessaDorm,
  tornCacador,
  anunciMort,
  dia,
  anunciEliminat,
  tornCacadorDia,
  anunciVictimaCacador,
  fiRonda,
  // aqui posem la resta de tornsp endents
}

// la ronda que conte els jugadors i l'estat de joc
class RondaScreen extends StatefulWidget {
  final Partida partida;

  const RondaScreen({super.key, required this.partida});

  @override
  State<RondaScreen> createState() => _RondaScreenState();
}

class _RondaScreenState extends State<RondaScreen> {
  final SoJoc _so = SoJoc();

  // Número del torn actual (enum fase)
  int torn = 0;

  // La fase que toca ara
  Fase get fase => Fase.values[torn];

  // Fins al torn del caçador és de nit; després ja és de dia
  MomentDia get _moment =>
      fase.index <= Fase.tornCacador.index ? MomentDia.nit : MomentDia.dia;

  // Jugador que la genetista ha triat
  Jugador? jugadorAnalitzat;

  // Jugador que el poble ha triat a la votació del dia
  Jugador? jugadorEliminat;
  Jugador? victimaCacadorDia;
  Jugador? victimaMetgessa;
  bool metgessaHaSalvat = false;
  bool triantVictimaMetgessa = false;
  List<Jugador> mortsNit = [];

  @override
  void initState() {
    super.initState();
    // TORN 0: comença la primera nit
    widget.partida.registre.add('Comença la inauguració del parc.');
    widget.partida.registre.add('Nit 1: el parc queda a les fosques.');
    _programarSoNit();
    esperar(OpcionsJoc.duradaEntreFases, seguentTorn);
  }

  @override
  void dispose() {
    unawaited(_so.dispose());
    super.dispose();
  }

  // So que acompanya l'inici de cada fase.
  // Sona sempre, passi el que passi dins del torn, perquè el mòbil el sent tothom
  // i així no es filtra què ha fet cada rol.
  void _sonarFase() {
    switch (fase) {
      case Fase.pobleDorm:
        _programarSoNit();
        break;
      case Fase.tornLlops:
        unawaited(_so.reproduir(So.rugit)); // rugit de dinosaure
        break;
      case Fase.tornGenetista:
        unawaited(_so.reproduir(So.genetista));
        break;
      case Fase.tornMetgessa:
        unawaited(_so.reproduir(So.metgessa));
        break;
      case Fase.tornCacador:
      case Fase.tornCacadorDia:
        unawaited(_so.reproduir(So.cacador)); // actua el caçador
        break;
      case Fase.anunciMort:
        unawaited(_so.reproduir(So.ocells)); // surt el sol i canten els ocells
        break;
      default:
        break;
    }
  }

  void _programarSoNit() {
    unawaited(_so.reproduir(So.nit));
  }

  // esperem per donar temps a q tanquin els ulls i no es filtrin rols
  void esperar(int segons, VoidCallback despres) {
    Future.delayed(Duration(seconds: segons), () { // delay de 5 segons
      // si el jugador ha sortit de la pantalla, no fem res
      if (mounted) {
        despres();
      }
    });
  }

  // Passa al torn següent. Es crida cada vegada que acaba un torn.
  void seguentTorn() {
    // si la partida ha acabat, deixem la ronda i anem a la pantalla final
    final cacadorPotDisparar =
        fase == Fase.tornCacador ||
        fase == Fase.tornCacadorDia ||
        (fase == Fase.anunciEliminat &&
            jugadorEliminat?.rol == Rol.cazador &&
            widget.partida.vius.isNotEmpty);
    if (widget.partida.partidaAcabada && !cacadorPotDisparar) {
      acabarPartida();
      return;
    }
    setState(() {
      torn++;
      jugadorAnalitzat = null;
      // Resol les morts abans del torn del caçador; salta els rols que no actuen.
      while (true) {
        // quan arribem al final de la ronda, comença una nit nova
        if (fase == Fase.fiRonda) {
          novaNit();
        }
        if (fase == Fase.tornCacador) {
          resoldreMortsNit();
        }
        if (!saltarTorn()) {
          break;
        }
        torn++;
      }
      // quan arriba l'anunci de l'eliminació, s'elimina el jugador que ha triat el poble
      if (fase == Fase.anunciEliminat) {
        eliminarEliminat();
      }
      if (fase == Fase.anunciMort) {
        widget.partida.registre.add('Es fa de dia al parc.');
      }
    });
    _sonarFase();
    // els torns en què dormen duren 5 segons i passen sols al següent
    if (tornAutomatic()) {
      esperar(OpcionsJoc.duradaEntreFases, seguentTorn);
    }
  }

  // Cert si el torn actual no s'ha de jugar (el rol no hi és o no actua)
  bool saltarTorn() {
    bool hiHaGenetista = widget.partida.hiHaRol(Rol.genetista);
    bool esTornDeLaGenetista =
      fase == Fase.tornGenetista || fase == Fase.genetistaDorm;
    bool hiHaMetgessa = widget.partida.hiHaRol(Rol.metgessa);
    bool esTornDeLaMetgessa =
      fase == Fase.tornMetgessa || fase == Fase.metgessaDorm;
    bool cacadorMortAquestaNit =
      mortsNit.any((j) => j.rol == Rol.cazador);
    bool esTornDelCacadorSenseAccio = fase == Fase.tornCacador &&
      (!cacadorMortAquestaNit || widget.partida.vius.isEmpty);
    bool cacadorNoEliminatDeDia = fase == Fase.tornCacadorDia &&
        (jugadorEliminat?.rol != Rol.cazador || widget.partida.vius.isEmpty);
    // si el caçador no ha disparat de dia, no hi ha res a anunciar
    bool capDisparDeDia =
        fase == Fase.anunciVictimaCacador && victimaCacadorDia == null;
    return (esTornDeLaGenetista && !hiHaGenetista) ||
      (esTornDeLaMetgessa && !hiHaMetgessa) ||
      esTornDelCacadorSenseAccio ||
      cacadorNoEliminatDeDia ||
      capDisparDeDia;
  }

  // Els torns que consisteixen en esperar per no filtrar info
  bool tornAutomatic() {
    return fase == Fase.pobleDorm ||
        fase == Fase.genetistaDorm ||
      fase == Fase.llopsDormen ||
      fase == Fase.metgessaDorm;
  }

  // Comença una nit nova: tornem al primer torn i esborrem el que va passar abans
  void novaNit() {
    torn = 0;
    widget.partida.nit++;
    widget.partida.registre.add('Nit ${widget.partida.nit}: cau la nit al parc.');
    widget.partida.victimaLlops = null;
    jugadorEliminat = null;
    victimaCacadorDia = null;
    victimaMetgessa = null;
    metgessaHaSalvat = false;
    triantVictimaMetgessa = false;
    mortsNit = [];
  }

  // La partida s'ha acabat: anem a la pantalla final, que diu qui ha guanyat
  void acabarPartida() {
    widget.partida.registre.add(
      widget.partida.guanyenLlops
          ? 'Fi de la partida: han guanyat els dinosaures.'
          : 'Fi de la partida: han guanyat els visitants.',
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => FinalPartidaScreen(partida: widget.partida),
      ),
    );
  }

  // La genetista ha confirmat el jugador que vol analitzar
  void genetistaTriaJugador(Jugador triat) {
    setState(() {
      jugadorAnalitzat = triat;
    });
    widget.partida.registre.add(
      'La genetista ha analitzat ${triat.nom}: és ${triat.rol.nom}.',
    );
  }

  // Els dinosaures han confirmat la víctima
  void llopsTrienVictima(Jugador victima) {
    widget.partida.victimaLlops = victima;
    widget.partida.registre.add(
      'Els dinosaures han triat ${victima.nom} per atacar.',
    );
    debugPrint('Víctima dels dinosaures: ${victima.nom} :(');
    seguentTorn();
  }

  void metgessaAdministraAntidot() {
    if (!widget.partida.pocioReviureDisponible) return;
    widget.partida.pocioReviureDisponible = false;
    metgessaHaSalvat = true;
    final victima = widget.partida.victimaLlops;
    if (victima != null) {
      widget.partida.registre.add(
        'La metgessa ha salvat ${victima.nom} amb l\'antídot.',
      );
    }
    seguentTorn();
  }

  void metgessaTriaSedant() {
    setState(() => triantVictimaMetgessa = true);
  }

  void metgessaTriaVictima(Jugador triada) {
    widget.partida.pocioMatarDisponible = false;
    victimaMetgessa = triada;
    widget.partida.registre.add(
      'La metgessa ha administrat el sedant a ${triada.nom}.',
    );
    seguentTorn();
  }

  void cacadorTriaVictima(Jugador triada) {
    triada.viu = false;
    mortsNit.add(triada);
    widget.partida.registre.add(
      'El caçador ha disparat a ${triada.nom} durant la nit.',
    );
    _continuarDespresDelTret();
  }

  void cacadorTriaVictimaDeDia(Jugador triada) {
    triada.viu = false;
    victimaCacadorDia = triada;
    widget.partida.registre.add(
      'El caçador ha disparat a ${triada.nom} després de la votació.',
    );
    _continuarDespresDelTret();
  }

  void _continuarDespresDelTret() {
    if (widget.partida.partidaAcabada) {
      acabarPartida();
      return;
    }
    seguentTorn();
  }

  // El poble ha confirmat a qui elimina
  void pobleTriaEliminat(Jugador triat) {
    jugadorEliminat = triat;
    widget.partida.registre.add(
      'Els visitants han votat contra ${triat.nom}.',
    );
    debugPrint('Eliminat pel poble: ${triat.nom}');
    seguentTorn();
  }

  void pobleSaltaVotacio() {
    jugadorEliminat = null;
    widget.partida.registre.add('Els visitants no han arribat a cap acord.');
    seguentTorn();
  }

  // Jugadors vius que es poden triar, sense els del rol indicat
  // (la genetista no es pot triar a ella mateixa i els dinosaures no es mengen entre ells)
  List<Jugador> jugadorsPerTriar(Rol rolExclos) {
    List<Jugador> llista = [];
    for (Jugador j in widget.partida.vius) {
      if (j.rol != rolExclos) {
        llista.add(j);
      }
    }
    return llista;
  }

  void resoldreMortsNit() {
    mortsNit = [];
    final victimaLlops = widget.partida.victimaLlops;
    if (victimaLlops != null && !metgessaHaSalvat) {
      victimaLlops.viu = false;
      mortsNit.add(victimaLlops);
      widget.partida.registre.add(
        '${victimaLlops.nom} ha mort durant l\'atac dels dinosaures.',
      );
    }
    final victimaSedant = victimaMetgessa;
    if (victimaSedant != null && victimaSedant.viu) {
      victimaSedant.viu = false;
      mortsNit.add(victimaSedant);
      widget.partida.registre.add(
        '${victimaSedant.nom} ha quedat fora de combat pel sedant.',
      );
    }
    if (mortsNit.isEmpty) {
      widget.partida.registre.add('Aquesta nit no ha mort ningú.');
    }
  }

  void eliminarEliminat() {
    Jugador? eliminat = jugadorEliminat;
    if (eliminat != null) {
      eliminat.viu = false;
      widget.partida.registre.add(
        'Els visitants han eliminat ${eliminat.nom}, que era ${eliminat.rol.nom}.',
      );
    }
  }

  // pantalles
  @override
  Widget build(BuildContext context) {
    return PantallaJoc(
      moment: _moment,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: pantallaActual(),
      ),
    );
  }

  // pantalla que es mostre segons el torn
  Widget pantallaActual() {
    if (fase == Fase.pobleDorm) {
      return pantallaMissatge('🌙', 'El campament dorm',
          detall: 'Tothom tanca els ulls');
    }
    if (fase == Fase.tornGenetista) {
      return tornGenetista();
    }
    if (fase == Fase.genetistaDorm) {
      return pantallaMissatge('🌙', 'La genetista s\'adorm');
    }
    if (fase == Fase.tornLlops) {
      return tornLlops();
    }
    if (fase == Fase.llopsDormen) {
      return pantallaMissatge('🌙', 'Els dinosaures s\'adormen');
    }
    if (fase == Fase.tornMetgessa) {
      return tornMetgessa();
    }
    if (fase == Fase.metgessaDorm) {
      return pantallaMissatge('🌙', 'La metgessa s\'adorm');
    }
    if (fase == Fase.tornCacador) {
      return tornCacador();
    }
    if (fase == Fase.anunciMort) {
      return tornAnunci();
    }
    if (fase == Fase.dia) {
      return tornVotacio();
    }
    if (fase == Fase.anunciEliminat) {
      return tornAnunciEliminat();
    }
    if (fase == Fase.tornCacadorDia) {
      return tornCacadorDeDia();
    }
    if (fase == Fase.anunciVictimaCacador) {
      final victima = victimaCacadorDia;
      if (victima != null) {
        return pantallaMort(victima, 'El caçador ha disparat', 'Ha eliminat...');
      }
    }

    return pantallaMissatge('🏁', 'Fi de la ronda');
  }

  // Pantalla amb un emoji dins l'ambre i un missatge al mig
  Widget pantallaMissatge(String emoji, String text, {String? detall}) {
    return SizedBox.expand(
      key: ValueKey(text),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AmbreEmoji(emoji, mida: 64),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(text, textAlign: TextAlign.center, style: estilTitol(32)),
          ),
          if (detall != null) ...[
            const SizedBox(height: 12),
            Text(
              detall,
              style: const TextStyle(fontSize: 18, color: ColorsJoc.osSuau),
            ),
          ],
        ],
      ),
    );
  }

  // Pantalla d'un jugador que ha mort o ha estat eliminat: en diu el nom i en revela el rol.
  // La fem servir per la víctima dels dinosaures i pel jugador que elimina el poble.
  // frase1 i frase2 són els dos textos de dalt (així es poden canviar a cada anunci).
  Widget pantallaMort(Jugador mort, String frase1, String frase2) {
    return SizedBox.expand(
      // cada torn té un número diferent, així la clau mai es repeteix
      key: ValueKey('mort$torn'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            frase1,
            style: const TextStyle(fontSize: 18, color: ColorsJoc.osSuau),
          ),
          const SizedBox(height: 4),
          Text(
            frase2,
            style: const TextStyle(fontSize: 18, color: ColorsJoc.osSuau),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              mort.nom,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: estilTitol(40),
            ),
          ),
          const SizedBox(height: 20),
          AmbreEmoji(mort.rol.emoji, mida: 60),
          const SizedBox(height: 16),
          Text(mort.rol.nom, style: estilTitol(28, color: ColorsJoc.ambre)),
          const SizedBox(height: 40),
          FilledButton(
            onPressed: seguentTorn,
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }

  // TORNS DELS ROLS ESPECIALS

  // Torn de la genetista: primer tria un jugador i després en veu el rol
  Widget tornGenetista() {
    // còpia local: així Dart sap que no és null quan la fem servir més avall
    final vist = jugadorAnalitzat;

    // encara no ha triat: mostrem la llista de jugadors
    if (vist == null) {
      return SizedBox.expand(
        key: const ValueKey('genetista-triar'),
        child: TriaJugador(
          titol: 'La genetista es desperta.\nTria un jugador per analitzar-ne l\'ADN',
          opcions: jugadorsPerTriar(Rol.genetista),
          alConfirmar: genetistaTriaJugador,
        ),
      );
    }

    // ja ha triat: li ensenyem el rol d'aquest jugador
    return SizedBox.expand(
      key: const ValueKey('genetista-rol'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            vist.nom,
            style: const TextStyle(fontSize: 20, color: ColorsJoc.osSuau),
          ),
          const SizedBox(height: 20),
          AmbreEmoji(vist.rol.emoji, mida: 64),
          const SizedBox(height: 20),
          Text(vist.rol.nom, style: estilTitol(40)),
          const SizedBox(height: 40),
          FilledButton(onPressed: seguentTorn, child: const Text('Entès')),
        ],
      ),
    );
  }

  // Torn dels dinosaures: trien la víctima
  Widget tornLlops() {
    return SizedBox.expand(
      key: const ValueKey('llops'),
      child: TriaJugador(
        titol: 'Els dinosaures es desperten.\nTrieu qui voleu devorar',
        opcions: jugadorsPerTriar(Rol.llop),
        alConfirmar: llopsTrienVictima,
      ),
    );
  }

  Widget tornMetgessa() {
    final victima = widget.partida.victimaLlops;
    final opcionsSedant = widget.partida.vius
        .where((j) => j != victima && j.rol != Rol.metgessa)
        .toList();

    if (triantVictimaMetgessa) {
      return SizedBox.expand(
        key: const ValueKey('metgessa-triar-victima'),
        child: TriaJugador(
          titol: 'Tria a qui vols administrar el sedant',
          opcions: opcionsSedant,
          alConfirmar: metgessaTriaVictima,
        ),
      );
    }

    return SizedBox.expand(
      key: const ValueKey('metgessa'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AmbreEmoji('🩺', mida: 52),
          const SizedBox(height: 24),
          Text('La metgessa es desperta', style: estilTitol(28)),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              victima == null
                  ? 'Els dinosaures no han triat cap víctima'
                  : 'Els dinosaures han atacat ${victima.nom}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(height: 28),
          if (victima != null && widget.partida.pocioReviureDisponible)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: FilledButton(
                onPressed: metgessaAdministraAntidot,
                child: const Text('Administrar l\'antídot'),
              ),
            ),
          if (widget.partida.pocioMatarDisponible && opcionsSedant.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: FilledButton(
                onPressed: metgessaTriaSedant,
                child: const Text('Administrar el sedant'),
              ),
            ),
          TextButton(
            onPressed: seguentTorn,
            child: const Text('No administrar cap tractament'),
          ),
        ],
      ),
    );
  }

  Widget tornCacador() {
    return SizedBox.expand(
      key: const ValueKey('cacador'),
      child: TriaJugador(
        titol: 'El caçador ha mort aquesta nit. Tria algú per endur-te amb tu',
        opcions: widget.partida.vius,
        alConfirmar: cacadorTriaVictima,
      ),
    );
  }

  Widget tornCacadorDeDia() {
    return SizedBox.expand(
      key: const ValueKey('cacador-dia'),
      child: TriaJugador(
        titol: 'El caçador ha estat eliminat. Tria algú per endur-te amb tu',
        opcions: widget.partida.vius,
        alConfirmar: cacadorTriaVictimaDeDia,
      ),
    );
  }

  // Anunci de l'alba: diem qui ha mort durant la nit i en revelem el rol
  Widget tornAnunci() {
    if (mortsNit.isEmpty) {
      return SizedBox.expand(
        key: const ValueKey('anunci-ningu'),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AmbreEmoji('☀️', mida: 64),
            const SizedBox(height: 28),
            const Text(
              'Es fa de dia',
              style: TextStyle(fontSize: 20, color: ColorsJoc.osSuau),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Aquesta nit no ha mort ningú',
                textAlign: TextAlign.center,
                style: estilTitol(30),
              ),
            ),
            const SizedBox(height: 40),
            FilledButton(
              onPressed: seguentTorn,
              child: const Text('Continuar'),
            ),
          ],
        ),
      );
    }

    return SizedBox.expand(
      key: const ValueKey('anunci-morts'),
      child: Column(
        children: [
          const SizedBox(height: 24),
          const AmbreEmoji('☀️', mida: 48),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              mortsNit.length == 1
                  ? 'Es fa de dia. Aquesta nit ha mort:'
                  : 'Es fa de dia. Aquesta nit han mort:',
              textAlign: TextAlign.center,
              style: estilTitol(22),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              children: [
                for (final mort in mortsNit)
                  TargetaJugador(
                    emoji: mort.rol.emoji,
                    nom: mort.nom,
                    rol: mort.rol.nom,
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              onPressed: seguentTorn,
              child: const Text('Continuar'),
            ),
          ),
        ],
      ),
    );
  }

  // TORNS DEL DIA

  // Votació del poble: mentre debaten, trien un jugador de tots els que queden vius
  Widget tornVotacio() {
    return SizedBox.expand(
      key: const ValueKey('votacio'),
      child: TriaJugador(
        titol: 'Els visitants debaten.\nTrieu qui voleu eliminar',
        opcions: widget.partida.vius,
        alConfirmar: pobleTriaEliminat,
        alSaltar: pobleSaltaVotacio,
      ),
    );
  }

  // Anunci de l'eliminació: diem qui ha eliminat el poble i en revelem el rol
  Widget tornAnunciEliminat() {
    final eliminat = jugadorEliminat;

    // ningú ha estat eliminat (s'ha saltat la votació)
    if (eliminat == null) {
      return SizedBox.expand(
        key: const ValueKey('anunci-ningu-eliminat'),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AmbreEmoji('⚖️', mida: 64),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Ningú ha estat eliminat',
                textAlign: TextAlign.center,
                style: estilTitol(30),
              ),
            ),
            const SizedBox(height: 40),
            FilledButton(
              onPressed: seguentTorn,
              child: const Text('Continuar'),
            ),
          ],
        ),
      );
    }

    // ensenyem el nom i el rol del jugador eliminat
    return pantallaMort(eliminat, 'Els visitants han decidit', 'Eliminat...');
  }
}
