import 'package:flutter/material.dart';
import 'partida.dart';

// classe que diu qui ha guanyat i el rol de cadascú pels curiosos
class FinalPartidaScreen extends StatelessWidget {
  final Partida partida;

  const FinalPartidaScreen({super.key, required this.partida});

  @override
  Widget build(BuildContext context) {
    // mirem qui ha guanyat i triem l'emoji i el text
    String emoji;
    String titol;
    if (partida.guanyenLlops) {
      emoji = '🐺';
      titol = 'Han guanyat els llops!';
    } else {
      emoji = '🏡';
      titol = 'Ha guanyat el poble!';
    }

    // tota la cosa visual
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 48),
            Text(emoji, style: const TextStyle(fontSize: 80)),
            const SizedBox(height: 16),
            Text(
              titol,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            // llista de tots els jugadors amb el seu rol (els morts surten ratllats)
            Expanded(
              child: ListView(
                children: [
                  for (final j in partida.jugadors)
                    ListTile(
                      leading: Text(
                        j.rol.emoji,
                        style: const TextStyle(fontSize: 28),
                      ),
                      title: Text(
                        j.nom,
                        style: TextStyle(
                          decoration: j.viu ? null : TextDecoration.lineThrough,
                        ),
                      ),
                      subtitle: Text(j.rol.nom),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton(
                onPressed: () {
                  // tornem a la primera pantalla de l'app (el menú principal)
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text('Tornar al menú'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}