import 'package:flutter/material.dart';
import 'ConfiguracioPartida.dart';
import 'repartiment_rols.dart';
import 'tema.dart';
import 'widgets_tema.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  int _numJugadors = 6;
  int _numLlops = 1;
  bool _hiHaGenetista = false;
  bool _hihaMetgessa = false;
  bool _hihaCazador = false;
  final List<TextEditingController> _controllersNoms = [];

  int get _maxLlops => (_numJugadors - 2) ~/ 2;
  int get _rolsEspecials =>
      (_hiHaGenetista ? 1 : 0) + (_hihaMetgessa ? 1 : 0) + (_hihaCazador ? 1 : 0);
  int get _numVisitants => _numJugadors - _numLlops - _rolsEspecials;

  @override
  void initState() {
    super.initState();
    _ajustarNoms();
  }

  @override
  void dispose() {
    for (final c in _controllersNoms) {
      c.dispose();
    }
    super.dispose();
  }

  void _ajustarNoms() {
    while (_controllersNoms.length < _numJugadors) {
      _controllersNoms.add(
        TextEditingController(text: 'Player ${_controllersNoms.length + 1}'),
      );
    }
    while (_controllersNoms.length > _numJugadors) {
      _controllersNoms.removeLast().dispose();
    }
  }

  // Fila amb una etiqueta a l'esquerra i un valor gran a la dreta
  Widget _fila(String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: [
          Expanded(child: Text(etiqueta, style: const TextStyle(fontSize: 18))),
          Text(valor, style: estilTitol(30, color: ColorsJoc.ambre)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PantallaJoc(
      appBar: AppBar(title: const Text('Prepara la inauguració')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          _fila('Jugadors', '$_numJugadors'),
          Slider(
            value: _numJugadors.toDouble(),
            min: 4,
            max: 15,
            divisions: 11,
            onChanged: (v) => setState(() {
              _numJugadors = v.round();
              if (_numLlops > _maxLlops) _numLlops = _maxLlops;
              _ajustarNoms();
            }),
          ),
          _fila('🦖  Dinosaures', '$_numLlops'),
          if (_maxLlops > 1)
            Slider(
              value: _numLlops.toDouble(),
              min: 1,
              max: _maxLlops.toDouble(),
              divisions: _maxLlops - 1,
              onChanged: (v) => setState(() => _numLlops = v.round()),
            ),
          const SizedBox(height: 16),
          Text('Rols especials', style: estilTitol(20)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: ColorsJoc.vidre,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: ColorsJoc.vora),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('🧬  Genetista'),
                  value: _hiHaGenetista,
                  onChanged: (v) => setState(() => _hiHaGenetista = v),
                ),
                SwitchListTile(
                  title: const Text('🩺  Metgessa'),
                  value: _hihaMetgessa,
                  onChanged: (v) => setState(() => _hihaMetgessa = v),
                ),
                SwitchListTile(
                  title: const Text('🔫  Caçador'),
                  value: _hihaCazador,
                  onChanged: (v) => setState(() => _hihaCazador = v),
                ),
              ],
            ),
          ),
          _fila('🎟️  Visitants', '$_numVisitants'),
          const SizedBox(height: 24),
          Text('Noms dels jugadors', style: estilTitol(20)),
          const SizedBox(height: 8),
          for (int i = 0; i < _numJugadors; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: TextField(
                controller: _controllersNoms[i],
                decoration: InputDecoration(
                  labelText: 'Nom del jugador ${i + 1}',
                  filled: true,
                  fillColor: ColorsJoc.vidre,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: ColorsJoc.ambre, width: 2),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                final config = ConfiguracioPartida(
                  nJugadors: _numJugadors,
                  nLlops: _numLlops,
                  genetista: _hiHaGenetista,
                  metgessa: _hihaMetgessa,
                  cazador: _hihaCazador,
                  noms: _controllersNoms.map((c) => c.text).toList(),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RepartimentRolsScreen(config: config),
                  ),
                );
              },
              child: const Text('Repartir els rols'),
            ),
          ),
        ],
      ),
    );
  }
}
