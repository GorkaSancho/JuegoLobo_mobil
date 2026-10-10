import 'package:flutter/material.dart';
import 'ConfiguracioPartida.dart';
import 'repartiment_rols.dart';
class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  int _numJugadors = 6;
  int _numLlops = 1;
  bool _hiHaVident = false;
  bool _hihaBruixa = false;
  bool _hihaCazador = false;
  final List<TextEditingController> _controllersNoms = [];

  int get _maxLlops => (_numJugadors - 1) ~/ 2;
  int get _rolsEspecials =>
      (_hiHaVident ? 1 : 0) + (_hihaBruixa ? 1 : 0) + (_hihaCazador ? 1 : 0);
  int get _numVilatans => _numJugadors - _numLlops - _rolsEspecials;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuració')),
      body: ListView(
        children: [
          Text('Jugadors: $_numJugadors'),
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
          Text('Llops: $_numLlops'),
          if (_maxLlops > 1)
            Slider(
              value: _numLlops.toDouble(),
              min: 1,
              max: _maxLlops.toDouble(),
              divisions: _maxLlops - 1,
              onChanged: (v) => setState(() => _numLlops = v.round()),
            ),
          SwitchListTile(
            title: const Text('Vident'),
            value: _hiHaVident,
            onChanged: (v) => setState(() => _hiHaVident = v),
          ),
          SwitchListTile(
              title: const Text('Bruixa'),
              value: _hihaBruixa,
              onChanged: (v) => setState(() => _hihaBruixa = v)
          ),
          SwitchListTile(
              title: const Text('Caçador'),
              value: _hihaCazador,
              onChanged: (v) => setState(()=> _hihaCazador = v)
          ),
          Text('Vilatans: $_numVilatans'),
          for (int i = 0; i < _numJugadors; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: TextField(
                controller: _controllersNoms[i],
                decoration: InputDecoration(
                  labelText: 'Nom del jugador ${i + 1}',
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
          ElevatedButton(
            onPressed: () {
              final config = ConfiguracioPartida(
                nJugadors: _numJugadors,
                nLlops: _numLlops,
                vident: _hiHaVident,
                bruixa: _hihaBruixa,
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
            child: const Text('Començar'),
          ),
        ],
      ),
    );
  }
}