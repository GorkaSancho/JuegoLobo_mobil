import 'dart:async';

import 'package:flutter/material.dart';

import 'so_joc.dart';
import 'tema.dart';
import 'widgets_tema.dart';

class OpcionsJoc {
  static int duradaEntreFases = 10;
  static double volum = 1;
}

class OpcionsScreen extends StatefulWidget {
  const OpcionsScreen({super.key});

  @override
  State<OpcionsScreen> createState() => _OpcionsScreenState();
}

class _OpcionsScreenState extends State<OpcionsScreen> {
  late double _durada = OpcionsJoc.duradaEntreFases.toDouble();
  late double _volum = OpcionsJoc.volum;

  @override
  Widget build(BuildContext context) {
    return PantallaJoc(
      appBar: AppBar(title: const Text('Opcions')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        children: [
          Row(
            children: [
              const Icon(Icons.timelapse, color: ColorsJoc.ambre),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Temps entre fases i rondes',
                  style: estilTitol(20),
                ),
              ),
              Text(
                '${_durada.round()} s',
                style: estilTitol(20, color: ColorsJoc.ambre),
              ),
            ],
          ),
          Slider(
            value: _durada,
            min: 5,
            max: 20,
            divisions: 15,
            label: '${_durada.round()} s',
            onChanged: (value) => setState(() {
              _durada = value;
              OpcionsJoc.duradaEntreFases = value.round();
            }),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              const Icon(Icons.volume_down, color: ColorsJoc.ambre),
              const SizedBox(width: 12),
              Expanded(child: Text('Volum del joc', style: estilTitol(20))),
              Text(
                '${(_volum * 100).round()}%',
                style: estilTitol(20, color: ColorsJoc.ambre),
              ),
            ],
          ),
          Slider(
            value: _volum,
            min: 0,
            max: 1,
            divisions: 10,
            label: '${(_volum * 100).round()}%',
            onChanged: (value) {
              setState(() => _volum = value);
              unawaited(SoJoc.actualitzarVolum(value));
            },
          ),
        ],
      ),
    );
  }
}
