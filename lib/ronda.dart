// GUARDEM TOTA LA INFORMACIÓ D'UNA RONDA

import 'package:flutter/material.dart';
import 'jugador.dart';
import 'partida.dart';
import 'escollir_jugador.dart';
import 'final_partida.dart';

// Els torns de la nit, en ordre. El número és la posició dins la llista.
// Per canviar l'ordre de la nit només cal canviar l'ordre d'aquesta llista.
enum Fase {
  pobleDorm, // torn 0: el poble dorm durant 5 segons
  tornVident, // torn 1: vident es desperta i descobreix un rol
  videntDorm, // torn 2: la vident s'adorm durant 5 segons
  tornLlops, // torn 3: els llops es desperten i trien la víctima
  llopsDormen, // torn 4: els llops s'adormen (5 segons)
  anunciMort, // torn 5: s'elimina el jugador
  dia, // torn 6: el poble debat i vota a qui eliminar
  anunciEliminat, // torn 7: s'anuncia qui ha eliminat el poble
  fiRonda, // torn 8: final de la ronda, en arribar-hi comença una nit nova
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
  // Número del torn actual (enum fase)
  int torn = 0;

  // La fase que toca ara
  Fase get fase => Fase.values[torn];

  // Jugador que la vident ha triat
  Jugador? jugadorVist;

  // Jugador que el poble ha triat a la votació del dia
  Jugador? jugadorEliminat;

  @override
  void initState() {
    super.initState();
    // TORN 0
    esperar(5, seguentTorn);
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
    if (widget.partida.partidaAcabada) {
      acabarPartida();
      return;
    }
    setState(() {
      torn++;
      jugadorVist = null;
      // quan arribem al final de la ronda, comença una nit nova
      if (fase == Fase.fiRonda) {
        novaNit();
      }
      // si no hi ha vident a la partida, saltem els seus torns
      while (saltarTorn()) {
        torn++;
      }
      // quan arriba l'anunci, s'elimina el jugador que han triat els llops
      if (fase == Fase.anunciMort) {
        eliminarVictima();
      }
      // quan arriba l'anunci de l'eliminació, s'elimina el jugador que ha triat el poble
      if (fase == Fase.anunciEliminat) {
        eliminarEliminat();
      }
    });
    // els torns en què dormen duren 5 segons i passen sols al següent
    if (tornAutomatic()) {
      esperar(5, seguentTorn);
    }
  }

  // Cert si el torn actual és de la vident i no hi ha cap a la partida
  bool saltarTorn() {
    bool hiHaVident = widget.partida.hiHaRol(Rol.vident);
    bool esTornDeLaVident =
        fase == Fase.tornVident || fase == Fase.videntDorm;
    return esTornDeLaVident && !hiHaVident;
  }

  // Els torns que consisteixen en esperar per no filtrar info
  bool tornAutomatic() {
    return fase == Fase.pobleDorm ||
        fase == Fase.videntDorm ||
        fase == Fase.llopsDormen;
  }

  // Comença una nit nova: tornem al primer torn i esborrem el que va passar abans
  void novaNit() {
    torn = 0;
    widget.partida.nit++;
    widget.partida.victimaLlops = null;
    jugadorEliminat = null;
  }

  // La partida s'ha acabat: anem a la pantalla final, que diu qui ha guanyat
  void acabarPartida() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => FinalPartidaScreen(partida: widget.partida),
      ),
    );
  }

  // La vident ha confirmat el jugador que vol veure
  void videntTriaJugador(Jugador triat) {
    setState(() {
      jugadorVist = triat;
    });
  }

  // Els llops han confirmat la víctima
  void llopsTrienVictima(Jugador victima) {
    widget.partida.victimaLlops = victima;
    debugPrint('Víctima dels llops: ${victima.nom} :(');
    seguentTorn();
  }

  // El poble ha confirmat a qui elimina
  void pobleTriaEliminat(Jugador triat) {
    jugadorEliminat = triat;
    debugPrint('Eliminat pel poble: ${triat.nom}');
    seguentTorn();
  }

  // Jugadors vius que es poden triar, sense els del rol indicat
  // (la vident no es pot triar a ella mateixa i els llops no es mengen entre ells)
  List<Jugador> jugadorsPerTriar(Rol rolExclos) {
    List<Jugador> llista = [];
    for (Jugador j in widget.partida.vius) {
      if (j.rol != rolExclos) {
        llista.add(j);
      }
    }
    return llista;
  }

  void eliminarVictima() {
    Jugador? victima = widget.partida.victimaLlops;
    if (victima != null) {
      victima.viu = false;
    }
  }

  void eliminarEliminat() {
    Jugador? eliminat = jugadorEliminat;
    if (eliminat != null) {
      eliminat.viu = false;
    }
  }

  // pantalles
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: pantallaActual(),
        ),
      ),
    );
  }

  // pantalla que es mostre segons el torn
  Widget pantallaActual() {
    if (fase == Fase.pobleDorm) {
      return pantallaMissatge('🌙', 'El poble dorm');
    }
    if (fase == Fase.tornVident) {
      return tornVident();
    }
    if (fase == Fase.videntDorm) {
      return pantallaMissatge('🌙', 'La vident s\'adorm');
    }
    if (fase == Fase.tornLlops) {
      return tornLlops();
    }
    if (fase == Fase.llopsDormen) {
      return pantallaMissatge('🌙', 'Els llops s\'adormen');
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

    return pantallaMissatge('🏁', 'Fi de la ronda');
  }

  // Pantalla amb un emoji gran i un missatge al mig
  Widget pantallaMissatge(String emoji, String text) {
    return SizedBox.expand(
      key: ValueKey(text),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 80)),
          const SizedBox(height: 16),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Pantalla d'un jugador que ha mort o ha estat eliminat: en diu el nom i en revela el rol.
  // La fem servir per la víctima dels llops i pel jugador que elimina el poble.
  // frase1 i frase2 són els dos textos de dalt (així es poden canviar a cada anunci).
  Widget pantallaMort(Jugador mort, String frase1, String frase2) {
    return SizedBox.expand(
      // cada torn té un número diferent, així la clau mai es repeteix
      key: ValueKey('mort$torn'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(frase1, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 8),
          Text(frase2, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 16),
          Text(
            mort.nom,
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(mort.rol.emoji, style: const TextStyle(fontSize: 96)),
          Text(
            mort.rol.nom,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 48),
          FilledButton(
            onPressed: seguentTorn,
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }

  // TORNS DELS ROLS ESPECIALS

  // Torn de la vident: primer tria un jugador i després en veu el rol
  Widget tornVident() {
    // còpia local: així Dart sap que no és null quan la fem servir més avall
    final vist = jugadorVist;

    // encara no ha triat: mostrem la llista de jugadors
    if (vist == null) {
      return SizedBox.expand(
        key: const ValueKey('vident-triar'),
        child: TriaJugador(
          titol: 'La vident es desperta.\nTria un jugador per descobrir el seu rol',
          opcions: jugadorsPerTriar(Rol.vident),
          alConfirmar: videntTriaJugador,
        ),
      );
    }

    // ja ha triat: li ensenyem el rol d'aquest jugador
    return SizedBox.expand(
      key: const ValueKey('vident-rol'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(vist.nom, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 16),
          Text(vist.rol.emoji, style: const TextStyle(fontSize: 96)),
          Text(
            vist.rol.nom,
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 48),
          FilledButton(onPressed: seguentTorn, child: const Text('Entès')),
        ],
      ),
    );
  }

  // Torn dels llops: trien la víctima
  Widget tornLlops() {
    return SizedBox.expand(
      key: const ValueKey('llops'),
      child: TriaJugador(
        titol: 'Els llops es desperten.\nTrieu qui voleu devorar',
        opcions: jugadorsPerTriar(Rol.llop),
        alConfirmar: llopsTrienVictima,
      ),
    );
  }

  // Anunci de l'alba: diem qui ha mort durant la nit i en revelem el rol
  Widget tornAnunci() {
    final victima = widget.partida.victimaLlops;

    // ningú ha mort aquesta nit (no hauria de passar)
    if (victima == null) {
      return SizedBox.expand(
        key: const ValueKey('anunci-ningu'),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('☀️', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 16),
            const Text('Es fa de dia', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            const Text(
              'Aquesta nit no ha mort ningú',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 48),
            FilledButton(
              onPressed: seguentTorn,
              child: const Text('Continuar'),
            ),
          ],
        ),
      );
    }

    // ha mort algú: ensenyem el seu nom i el seu rol
    return pantallaMort(victima, 'Es fa de dia', 'Aquesta nit ha mort...');
  }

  // TORNS DEL DIA

  // Votació del poble: mentre debaten, trien un jugador de tots els que queden vius
  Widget tornVotacio() {
    return SizedBox.expand(
      key: const ValueKey('votacio'),
      child: TriaJugador(
        titol: 'El poble debat.\nTrieu qui voleu eliminar',
        opcions: widget.partida.vius,
        alConfirmar: pobleTriaEliminat,
      ),
    );
  }

  // Anunci de l'eliminació: diem qui ha eliminat el poble i en revelem el rol
  Widget tornAnunciEliminat() {
    final eliminat = jugadorEliminat;

    // ningú ha estat eliminat (no hauria de passar)
    if (eliminat == null) {
      return pantallaMissatge('⚖️', 'Ningú ha estat eliminat');
    }

    // ensenyem el nom i el rol del jugador eliminat
    return pantallaMort(eliminat, 'El poble ha decidit', 'Eliminat...');
  }
}