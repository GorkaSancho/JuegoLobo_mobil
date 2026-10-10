import 'package:flutter/material.dart';
import 'ConfiguracioPartida.dart';
import 'jugador.dart';
import 'ronda.dart';
import 'partida.dart';

class RepartimentRolsScreen extends StatefulWidget {
  final ConfiguracioPartida config;

  const RepartimentRolsScreen({super.key, required this.config});

  @override
  State<RepartimentRolsScreen> createState() => _RepartimentRolsScreenState();
}

class _RepartimentRolsScreenState extends State<RepartimentRolsScreen> {
  late final List<Jugador> _jugadors;
  int _actual = 0;
  bool _mostrantRol = false;

  // repartiment de rols
  @override
  void initState() {
    super.initState();
    final rols = <Rol>[
      for (int i = 0; i < widget.config.nLlops; i++) Rol.llop,
      if (widget.config.vident) Rol.vident,
      if (widget.config.bruixa) Rol.bruixa,
      if (widget.config.cazador) Rol.cazador,
    ];
    while (rols.length < widget.config.nJugadors) {
      rols.add(Rol.vilata);
    }
    rols.shuffle();
    _jugadors = [
      for (int i = 0; i < rols.length; i++)
        Jugador(widget.config.noms[i], rols[i]), // creem els jugadors
    ];
  }

  void _seguent() {
    setState(() {
      _actual++;
      _mostrantRol = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final acabat = _actual >= _jugadors.length;
    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: acabat
              ? _vistaFinal()
              : _mostrantRol
              ? _vistaRol(_jugadors[_actual])
              : _vistaNom(_jugadors[_actual]),
        ),
      ),
    );
  }

  // Mostrem els rols scrollejant
  Widget _vistaNom(Jugador jugador) {
    return GestureDetector(
      key: ValueKey('nom$_actual'),
      behavior: HitTestBehavior.opaque,
      onVerticalDragEnd: (detalls) {
        if ((detalls.primaryVelocity ?? 0) < 0) {
          setState(() => _mostrantRol = true);
        }
      },
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Passa el mòbil a', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            Text(
              jugador.nom,
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 64),
            const Icon(Icons.keyboard_arrow_up, size: 48),
            const Text('Llisca cap amunt per veure el teu rol'),
          ],
        ),
      ),
    );
  }

  Widget _vistaRol(Jugador jugador) {
    final esUltim = _actual == _jugadors.length - 1;
    return SizedBox.expand(
      key: ValueKey('rol$_actual'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(jugador.nom, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 16),
          Text(jugador.rol.emoji, style: const TextStyle(fontSize: 96)),
          Text(
            jugador.rol.nom,
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(jugador.rol.descripcio, textAlign: TextAlign.center),
          ),
          const SizedBox(height: 48),
          FilledButton(
            onPressed: _seguent,
            child: Text(esUltim ? 'Acabar' : 'Següent'),
          ),
        ],
      ),
    );
  }

  Widget _vistaFinal() {
    return SizedBox.expand(
      key: const ValueKey('final'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Tothom ja té el seu rol',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          FilledButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => RondaScreen(partida: Partida(_jugadors)),
                ),
              );
            },
            child: const Text('Començar la primera nit'),
          ),
        ],
      ),
    );
  }
}