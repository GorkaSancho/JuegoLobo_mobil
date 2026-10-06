import 'package:flutter/material.dart';

import 'main_menu.dart';

// Punto de entrada de la app: Flutter siempre empieza por aquí.
void main() {
  runApp(const MiJuegoApp());
}

// Widget raíz: configura el tema y decide cuál es la primera pantalla.
class MiJuegoApp extends StatelessWidget {
  const MiJuegoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JOC DEL LLOP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      home: const MainMenuScreen(), // Primera pantalla: el menú principal
    );
  }
}