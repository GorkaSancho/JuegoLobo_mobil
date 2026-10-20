import 'package:flutter/material.dart';
import 'tema.dart';
import 'widgets_tema.dart';

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
              titulo: 'Objectiu',
              texto:
                  'A l\'illa s\'amaguen un o més dinosaures camuflats entre '
                  'els exploradors. Els exploradors han de descobrir qui són '
                  'i eliminar-los abans que devorin tota l\'expedició.',
            ),
            _Seccion(
              titulo: 'Els rols',
              texto:
                  '🧭 Explorador: no té cap poder. Només pot observar, '
                  'debatre i votar.\n\n'
                  '🦖 Dinosaure: sap que és un dinosaure i la seva missió és '
                  'passar desapercebut mentre va devorant exploradors.\n\n'
                  '🦴 Paleontòloga: cada nit tria un jugador i n\'analitza '
                  'l\'ADN per descobrir quin rol té. Ha d\'utilitzar aquesta '
                  'informació sense delatar-se.\n\n'
                  '🧪 Bruixa: té dues pocions d\'un sol ús. Una és de '
                  'curació i serveix per salvar la víctima dels dinosaures. '
                  'L\'altra és de verí i serveix per eliminar un jugador.\n\n'
                  '🏹 Caçador: quan mor, ja sigui de nit o per votació, '
                  'tria un jugador viu i se l\'emporta amb ell.',
            ),
            _Seccion(
              titulo: 'La nit',
              texto:
                  'Quan cau la nit, el campament dorm i la selva es desperta. '
                  'Es desperten per torns, en aquest ordre:\n\n'
                  '1. La paleontòloga tria un jugador i descobreix el seu rol.\n'
                  '2. Els dinosaures trien en secret una víctima per devorar. '
                  'Se sentirà un rugit!\n'
                  '3. La bruixa veu qui ha estat atacat i decideix si fa '
                  'servir alguna de les seves pocions.',
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
                  '✅ L\'expedició guanya si elimina tots els dinosaures.\n\n'
                  '❌ Els dinosaures guanyen si queden tants dinosaures com '
                  'exploradors (o més).',
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
