import 'package:flutter/material.dart';

import 'main_menu.dart';
import 'tema.dart';

// Punt d'entrada de l'app
void main() {
  runApp(const MiJuegoApp());
}

class MiJuegoApp extends StatelessWidget {
  const MiJuegoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NIT JURÀSSICA',
      debugShowCheckedModeBanner: false,
      theme: construirTema(),
      home: const MainMenuScreen(),
    );
  }
}
