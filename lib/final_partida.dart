import 'package:flutter/material.dart';
import 'partida.dart';
import 'tema.dart';
import 'widgets_tema.dart';

// classe que diu qui ha guanyat i el rol de cadascú pels curiosos
class FinalPartidaScreen extends StatelessWidget {
  final Partida partida;

  const FinalPartidaScreen({super.key, required this.partida});

  @override
  Widget build(BuildContext context) {
    final dinosaures = partida.guanyenLlops;
    final emoji = dinosaures ? '🦖' : '🎟️';
    final titol = dinosaures
        ? 'Han guanyat els dinosaures!'
      : 'Han guanyat els visitants!';

    return PantallaJoc(
      // si guanyen els dinosaures es queda de nit; si no, surt el sol
      moment: dinosaures ? MomentDia.nit : MomentDia.dia,
      body: Column(
        children: [
          const SizedBox(height: 32),
          AmbreEmoji(emoji, mida: 60),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(titol, textAlign: TextAlign.center, style: estilTitol(30)),
          ),
          const SizedBox(height: 16),
          // llista de tots els jugadors amb el seu rol (els morts surten ratllats)
          Expanded(
            child: ListView(
              children: [
                for (final j in partida.jugadors)
                  TargetaJugador(
                    emoji: j.rol.emoji,
                    nom: j.nom,
                    rol: j.rol.nom,
                    viu: j.viu,
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  // tornem a la primera pantalla de l'app (el menú principal)
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text('Tornar al menú'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
