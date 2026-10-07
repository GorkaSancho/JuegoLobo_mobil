import 'package:flutter/material.dart';
import 'ConfiguracioPartida.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuració')),
      body: Column(
        children: [
          Text('Jugadors: $_numJugadors'),
          Slider(
            value: _numJugadors.toDouble(),
            min: 4,
            max: 15,
            divisions: 11,
            onChanged: (v) => setState(() => _numJugadors = v.round()),
          ),
          Text('Llops: $_numLlops'),
          Slider(
            value: _numLlops.toDouble(),
            min: 1,
            max: 8,
            divisions: 8,
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
              title: const Text('Cazador'),
              value: _hihaCazador,
              onChanged: (v) => setState(()=> _hihaCazador = v)
          ),
          ElevatedButton(
            onPressed: () {
              final config = ConfiguracioPartida(
                nJugadors: _numJugadors,
                nLlops: _numLlops,
                vident: _hiHaVident,
                bruixa: _hihaBruixa,
                cazador: _hihaCazador,
              );
            },
            child: const Text('Començar'),
          ),
        ],
      ),
    );
  }
}