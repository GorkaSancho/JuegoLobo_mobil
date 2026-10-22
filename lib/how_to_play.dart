import 'dart:async';

import 'package:flutter/material.dart';
import 'so_joc.dart';
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
class HowToPlayScreen extends StatefulWidget {
  const HowToPlayScreen({super.key});

  @override
  State<HowToPlayScreen> createState() => _HowToPlayScreenState();
}

class _HowToPlayScreenState extends State<HowToPlayScreen> {
  final SoJoc _so = SoJoc();

  void _reproduir(So so) {
    unawaited(_so.reproduirPrevisualitzacio(so));
  }

  @override
  void dispose() {
    unawaited(_so.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PantallaJoc(
      appBar: AppBar(title: const Text('Com es juga')),
      body: SingleChildScrollView(
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
                contingut: Column(
                  children: [
                    _RolAmbSo(
                      emoji: '🎟️',
                      nom: 'Visitant',
                      descripcio: 'No té cap poder. Observa, debat i vota.',
                    ),
                    const SizedBox(height: 12),
                    _RolAmbSo(
                      emoji: '🦖',
                      nom: 'Dinosaure',
                      descripcio:
                          'Passa desapercebut mentre caça els visitants.',
                      onPlay: () => _reproduir(So.rugit),
                    ),
                    const SizedBox(height: 12),
                    _RolAmbSo(
                      emoji: '🧬',
                      nom: 'Genetista',
                      descripcio:
                          'Analitza l\'ADN d\'un jugador i descobreix quin rol té.',
                      onPlay: () => _reproduir(So.genetista),
                    ),
                    const SizedBox(height: 12),
                    _RolAmbSo(
                      emoji: '🩺',
                      nom: 'Metgessa',
                      descripcio:
                          'Pot salvar una víctima amb l\'antídot o neutralitzar '
                          'un jugador amb el sedant.',
                      onPlay: () => _reproduir(So.metgessa),
                    ),
                    const SizedBox(height: 12),
                    _RolAmbSo(
                      emoji: '🔫',
                      nom: 'Caçador',
                      descripcio:
                          'Quan mor, fa un últim tret i s\'endú un altre jugador.',
                      onPlay: () => _reproduir(So.cacador),
                    ),
                  ],
                ),
              ),
              _Seccion(
                titulo: 'La nit',
                onPlay: () => _reproduir(So.nit),
                texto:
                    'Quan cau la nit, el parc tanca les portes, però els '
                    'dinosaures surten a caçar. Els rols actuen per torns, en '
                    'aquest ordre:\n\n'
                    '1. La genetista tria un jugador i descobreix el seu rol.\n'
                    '2. Els dinosaures trien en secret una víctima per devorar. '
                    'Se sentirà un rugit!\n'
                    '3. La metgessa veu qui ha estat atacat i decideix si '
                    'fa servir l\'antídot o el sedant.',
              ),
              _Seccion(
                titulo: 'El dia',
                onPlay: () => _reproduir(So.ocells),
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
  const _Seccion({
    required this.titulo,
    this.texto,
    this.contingut,
    this.onPlay,
  });

  final String titulo;
  final String? texto;
  final Widget? contingut;
  final VoidCallback? onPlay;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  titulo,
                  style: estilTitol(22, color: ColorsJoc.ambre),
                ),
              ),
              if (onPlay != null)
                IconButton(
                  tooltip: 'Escoltar so de $titulo',
                  onPressed: onPlay,
                  icon: const Icon(Icons.play_arrow_rounded),
                ),
            ],
          ),
          const SizedBox(height: 10),
          if (contingut != null)
            contingut!
          else
            Text(
              texto!,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(height: 1.45),
            ),
        ],
      ),
    );
  }
}

class _RolAmbSo extends StatelessWidget {
  const _RolAmbSo({
    required this.emoji,
    required this.nom,
    required this.descripcio,
    this.onPlay,
  });

  final String emoji;
  final String nom;
  final String descripcio;
  final VoidCallback? onPlay;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$emoji $nom', style: estilTitol(18)),
              const SizedBox(height: 4),
              Text(
                descripcio,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(height: 1.4),
              ),
            ],
          ),
        ),
        if (onPlay != null)
          IconButton(
            tooltip: 'Escoltar so de $nom',
            onPressed: onPlay,
            icon: const Icon(Icons.play_arrow_rounded),
          ),
      ],
    );
  }
}
