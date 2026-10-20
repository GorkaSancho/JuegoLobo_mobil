// FITXER PQ ELS ROLS QUE HAN DE SELECCIONAR ALGUN ALTRE JUGADOR HO FACIN

import 'package:flutter/material.dart';
import 'jugador.dart';
import 'tema.dart';

// Llista de jugadors per triar un i confirmar
class TriaJugador extends StatefulWidget {
  final String titol;
  final List<Jugador> opcions; // els jugadors q pot agafar
  final void Function(Jugador) alConfirmar;
  final VoidCallback? alSaltar;

  const TriaJugador({
    super.key,
    required this.titol,
    required this.opcions,
    required this.alConfirmar,
    this.alSaltar,
  });

  @override
  State<TriaJugador> createState() => _TriaJugadorState();
}

class _TriaJugadorState extends State<TriaJugador> {
  Jugador? _triat;

  Widget _opcio(Jugador j) {
    final triat = _triat == j;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: triat ? ColorsJoc.ambreSuau : ColorsJoc.vidre,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: triat ? ColorsJoc.ambre : ColorsJoc.vora,
            width: triat ? 2 : 1,
          ),
        ),
        child: ListTile(
          title: Text(
            j.nom,
            style: TextStyle(
              fontSize: 18,
              fontWeight: triat ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          trailing: triat
              ? const Icon(Icons.check_circle, color: ColorsJoc.ambre)
              : null,
          onTap: () => setState(() => _triat = j),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            widget.titol,
            textAlign: TextAlign.center,
            style: estilTitol(24),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView(
            children: [for (final j in widget.opcions) _opcio(j)],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _triat == null
                  ? null
                  : () => widget.alConfirmar(_triat!),
              child: const Text('Confirmar'),
            ),
          ),
        ),
        if (widget.alSaltar != null)
          TextButton(
            onPressed: widget.alSaltar,
            child: const Text('Saltar votació'),
          ),
        const SizedBox(height: 8),
      ],
    );
  }
}
