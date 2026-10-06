import 'package:flutter/material.dart';

// Pantalla "Cómo se juega" (textos en catalán).
class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // La AppBar incluye automáticamente la flecha para volver al menú.
      appBar: AppBar(title: const Text('Com es juga')),
      // SingleChildScrollView permite hacer scroll si el texto no cabe.
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Seccion(
                titulo: 'Objectiu',
                texto:
                'Al poble s\'amaguen un o més llops disfressats de '
                    'vilatans. Els vilatans han de descobrir qui són els '
                    'llops i eliminar-los abans que es mengin tot el poble.',
              ),
              _Seccion(
                titulo: 'Els rols',
                texto:
                '🧑‍🌾 Vilatà: no té cap poder. Només pot observar, '
                    'debatre i votar.\n\n'
                    '🐺 Llop: sap que és un llop i la seva missió és passar '
                    'desapercebut mentre va eliminant vilatans.\n\n'
                    '🔮 Vident: cada nit tria un jugador i descobreix quin '
                    'rol té. Ha d\'utilitzar aquesta informació sense '
                    'delatar-se.\n\n'
                    '🧪 Bruixa: té dues pocions d\'un sol ús. Una és de '
                    'curació i serveix per salvar la víctima dels llops. '
                    'L\'altra és de verí i serveix per eliminar un jugador.\n\n'
                    '🏹 Caçador: quan mor, ja sigui de nit o per votació, '
                    'dispara i s\'emporta un altre jugador a la seva elecció.',
              ),
              _Seccion(
                titulo: 'La nit',
                texto:
                'Quan cau la nit, el poble dorm. Es desperten per torns, '
                    'en aquest ordre:\n\n'
                    '1. La vident tria un jugador i descobreix el seu rol.\n'
                    '2. Els llops trien en secret una víctima per menjar-se-la.\n'
                    '3. La bruixa veu qui ha estat atacat i decideix si fa '
                    'servir alguna de les seves pocions.',
              ),
              _Seccion(
                titulo: 'El dia',
                texto:
                'A l\'alba s\'esbrina qui ha estat eliminat durant la '
                    'nit. Els supervivents debaten, s\'acusen i es defensen, i '
                    'al final voten a qui creuen que és un llop. El jugador '
                    'més votat queda eliminat.',
              ),
              _Seccion(
                titulo: 'Com es guanya',
                texto:
                '✅ El poble guanya si elimina tots els llops.\n\n'
                    '❌ Els llops guanyen si queden tants llops com vilatans '
                    '(o més).',
              ),
              _Seccion(
                titulo: 'Consells',
                texto:
                'Fixa\'t en qui acusa sense motiu, en qui defensa sempre '
                    'els mateixos i en qui es manté massa callat. Si ets '
                    'llop, actua amb naturalitat!',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Bloque reutilizable: un título y un párrafo debajo.
// Así no repetimos el mismo estilo en cada sección.
class _Seccion extends StatelessWidget {
  const _Seccion({required this.titulo, required this.texto});

  final String titulo;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            texto,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.4),
          ),
        ],
      ),
    );
  }
}