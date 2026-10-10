// FITXER PQ ELS ROLS QUE HAN DE SELECCIONAR ALGUN ALTRE JUGADOR HO FACIN

import 'package:flutter/material.dart';
import 'jugador.dart';

// Llista de jugadors per triar un i confirmar
class TriaJugador extends StatefulWidget {
  final String titol;
  final List<Jugador> opcions; // els jugadors q pot agafar
  final void Function(Jugador) alConfirmar;

  const TriaJugador({
    super.key,
    required this.titol,
    required this.opcions,
    required this.alConfirmar,
  });

  @override
  State<TriaJugador> createState() => _TriaJugadorState();
}

class _TriaJugadorState extends State<TriaJugador> {
  Jugador? _triat;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 32),
        Text(
          widget.titol,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView(
            children: [
              for (final j in widget.opcions)
                ListTile(
                  title: Text(j.nom),
                  selected: _triat == j,
                  trailing: _triat == j ? const Icon(Icons.check) : null,
                  onTap: () => setState(() => _triat = j),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: _triat == null
                ? null
                : () => widget.alConfirmar(_triat!),
            child: const Text('Confirmar'),
          ),
        ),
      ],
    );
  }
}