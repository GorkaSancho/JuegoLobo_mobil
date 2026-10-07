import 'package:flutter/material.dart';
import "config_menu.dart";
import 'how_to_play.dart';

// Pantalla del menú principal.
class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  // Mensaje temporal para los botones que aún no tienen pantalla.
  void _proximamente(BuildContext context, String nombre) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$nombre: próximamente')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'JOC DEL LLOP',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 64),
              _MenuButton(
                texto: 'Jugar',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ConfigScreen(),
                    ),
                  );
                }),
              const SizedBox(height: 16),
              _MenuButton(
                texto: 'Opcions',
                onPressed: () => _proximamente(context, 'Opciones'),
              ),
              const SizedBox(height: 16),
              _MenuButton(
                texto: 'Com jugar',
                onPressed: () {
                  // Navigator.push apila una pantalla nueva encima de la actual.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HowToPlayScreen(),
                    ),
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

// Botón reutilizable para no repetir el mismo estilo tres veces.
class _MenuButton extends StatelessWidget {
  const _MenuButton({required this.texto, required this.onPressed});

  final String texto;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      height: 56,
      child: FilledButton(
        onPressed: onPressed,
        child: Text(texto, style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}