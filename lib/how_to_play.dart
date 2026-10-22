import 'package:flutter/material.dart';
import 'tema.dart';
import 'widgets_tema.dart';

const String _historiaInauguracio =
    'Avui, el parc obre les portes per primera vegada. Entre '
    'aplaudiments i flaixos, els científics presenten la seva '
    'gran fita: dinosaures creats amb ADN de diverses espècies. '
    'Però alguna cosa falla al laboratori. Escolteu trets dins el laboratori, '
    'els llums s\'apaguen i el sistema de seguretat cau.\n\n'
    'En el caos, ADN de dinosaure ha contaminat alguns visitants. '
    'Quan arriba la nit, els primers comencen a transformar-se. '
    'Les portes del parc són tancades. Ningú no pot sortir. '
    'I entre vosaltres, algú ja no és del tot humà.';

class HistoriaIntroScreen extends StatelessWidget {
  const HistoriaIntroScreen({super.key, required this.alContinuar});

  final VoidCallback alContinuar;

  @override
  Widget build(BuildContext context) {
    return PantallaJoc(
      moment: MomentDia.nit,
      appBar: AppBar(title: const Text('La inauguració')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AmbreEmoji('🚨', mida: 72),
                const SizedBox(height: 28),
                Text(
                  'LA NIT DE L\'OBERTURA',
                  textAlign: TextAlign.center,
                  style: estilTitol(30, color: ColorsJoc.ambre),
                ),
                const SizedBox(height: 24),
                const Text(
                  _historiaInauguracio,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, height: 1.55),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: alContinuar,
                    child: const Text('Preparar la partida'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Pantalla "Com es juga"
class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PantallaJoc(
      appBar: AppBar(title: const Text('Com es juga')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Seccion(
              titulo: 'El dia de la inauguració',
              texto: _historiaInauguracio,
            ),
            _Seccion(
              titulo: 'Objectiu',
              texto:
                  'Entre els visitants hi ha persones que s\'han transformat '
                  'en dinosaures. La resta ha de descobrir qui són i '
                  'eliminar-los abans que els dinosaures els devorin.',
            ),
            _Seccion(
              titulo: 'Els rols',
              texto:
                  '🎟️ Visitant: no té cap poder. Només pot observar, '
                  'debatre i votar.\n\n'
                  '🦖 Dinosaure: sap que és un dinosaure i la seva missió és '
                  'passar desapercebut mentre va devorant visitants.\n\n'
                  '🦴 Paleontòloga: cada nit tria un jugador i n\'analitza '
                  'l\'ADN per descobrir quin rol té. Ha d\'utilitzar aquesta '
                  'informació sense delatar-se.\n\n'
                  '🧪 Científica: té dues dosis experimentals d\'un sol ús. '
                  'El sèrum pot revertir la transformació i salvar la '
                  'víctima dels dinosaures; el compost pot eliminar un '
                  'jugador.\n\n'
                  '🔫 Caçador: quan mor, ja sigui de nit o per votació, '
                  'fa un últim tret amb l\'escopeta i tria un jugador viu '
                  'per endur-se amb ell.',
            ),
            _Seccion(
              titulo: 'La nit',
              texto:
                  'Quan cau la nit, el parc tanca les portes, però els '
                  'dinosaures surten a caçar. Els rols actuen per torns, en '
                  'aquest ordre:\n\n'
                  '1. La paleontòloga tria un jugador i descobreix el seu rol.\n'
                  '2. Els dinosaures trien en secret una víctima per devorar. '
                  'Se sentirà un rugit!\n'
                  '3. La científica veu qui ha estat atacat i decideix si '
                  'fa servir alguna de les seves dosis.',
            ),
            _Seccion(
              titulo: 'El dia',
              texto:
                  'Amb el cant dels ocells s\'esbrina qui ha estat eliminat '
                  'durant la nit. Els supervivents debaten, s\'acusen i es '
                  'defensen, i al final voten qui creuen que és un dinosaure. '
                  'El jugador més votat queda eliminat.',
            ),
            _Seccion(
              titulo: 'Com es guanya',
              texto:
                  '✅ Els visitants guanyen si eliminen tots els dinosaures.\n\n'
                  '❌ Els dinosaures guanyen si queden tants dinosaures com '
                  'visitants (o més).',
            ),
            _Seccion(
              titulo: 'Consells',
              texto:
                  'Fixa\'t en qui acusa sense motiu, en qui defensa sempre '
                  'els mateixos i en qui es manté massa callat. Si ets '
                  'dinosaure, actua amb naturalitat!',
            ),
          ],
        ),
      ),
    );
  }
}

// Bloc reutilitzable: un títol i un paràgraf a sota.
class _Seccion extends StatelessWidget {
  const _Seccion({required this.titulo, required this.texto});

  final String titulo;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: estilTitol(22, color: ColorsJoc.ambre)),
          const SizedBox(height: 10),
          Text(
            texto,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.45),
          ),
        ],
      ),
    );
  }
}
