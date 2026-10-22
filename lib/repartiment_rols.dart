import 'package:flutter/material.dart';
import 'ConfiguracioPartida.dart';
import 'jugador.dart';
import 'ronda.dart';
import 'partida.dart';
import 'tema.dart';
import 'widgets_tema.dart';

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
      if (widget.config.cientifica) Rol.cientifica,
      if (widget.config.cazador) Rol.cazador,
    ];
    while (rols.length < widget.config.nJugadors) {
      rols.add(Rol.visitant);
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
    return PantallaJoc(
      moment: MomentDia.nit,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: acabat
            ? _vistaFinal()
            : _mostrantRol
                ? _vistaRol(_jugadors[_actual])
                : _vistaNom(_jugadors[_actual]),
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
            const Text(
              'Passa el mòbil a',
              style: TextStyle(fontSize: 20, color: ColorsJoc.osSuau),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                jugador.nom,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: estilTitol(44),
              ),
            ),
            const SizedBox(height: 64),
            const Icon(Icons.keyboard_arrow_up, size: 48, color: ColorsJoc.ambre),
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
          Text(
            jugador.nom,
            style: const TextStyle(fontSize: 20, color: ColorsJoc.osSuau),
          ),
          const SizedBox(height: 20),
          AmbreEmoji(jugador.rol.emoji, mida: 72),
          const SizedBox(height: 24),
          Text(jugador.rol.nom, style: estilTitol(40)),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              jugador.rol.descripcio,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 17, height: 1.4),
            ),
          ),
          const SizedBox(height: 40),
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
          const AmbreEmoji('🌙', mida: 60),
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Tothom ja té el seu rol',
              textAlign: TextAlign.center,
              style: estilTitol(30),
            ),
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
