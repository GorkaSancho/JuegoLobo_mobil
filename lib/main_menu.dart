import 'package:flutter/material.dart';
import 'config_menu.dart';
import 'how_to_play.dart';
import 'opcions.dart';
import 'tema.dart';
import 'widgets_tema.dart';

// Pantalla del menú principal.
class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PantallaJoc(
      moment: MomentDia.nit,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AmbreEmoji('🦖', mida: 84),
              const SizedBox(height: 32),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'JURÀSSIC',
                  style: estilTitol(56).copyWith(letterSpacing: 3),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Caos el dia de la inauguració',
                style: TextStyle(fontSize: 18, color: ColorsJoc.osSuau),
              ),
              const SizedBox(height: 48),
              _MenuButton(
                texto: 'Jugar',
                principal: true,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HistoriaIntroScreen(
                        alContinuar: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ConfigScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _MenuButton(
                texto: 'Opcions',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OpcionsScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _MenuButton(
                texto: 'Com jugar',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HowToPlayScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Botó reutilitzable: el principal és ple (ambre) i els altres amb vora.
class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.texto,
    required this.onPressed,
    this.principal = false,
  });

  final String texto;
  final VoidCallback onPressed;
  final bool principal;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 56,
      child: principal
          ? FilledButton(onPressed: onPressed, child: Text(texto))
          : OutlinedButton(onPressed: onPressed, child: Text(texto)),
    );
  }
}
