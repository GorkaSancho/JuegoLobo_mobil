// GUARDEM TOTA LA INFORMACIÓ D'UNA RONDA

import 'package:flutter/material.dart';
import 'jugador.dart';
import 'partida.dart';
import 'escollir_jugador.dart';

// la ronda que conte els jugadors i l'estat de joc
class RondaScreen extends StatefulWidget {
  final Partida partida;

  const RondaScreen({super.key, required this.partida});

  @override
  State<RondaScreen> createState() => _RondaScreenState();
}

class _RondaScreenState extends State<RondaScreen> {
  // Rols que es desperten aquesta nit, en l'ordre oficial (només els que hi ha a la partida)
  late final List<Rol> _torns;
  int _torn = -1;
  bool _dormint = true;
  String _missatge = 'El poble dorm';

  @override
  void initState() {
    super.initState();
    _torns = [Rol.vident, Rol.llop].where(widget.partida.hiHaRol).toList();
    _esperar();
  }

  // esperem per donar temps a q tanquin els ulls i no es filtrin rols
  void _esperar() {
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      setState(() {
        _torn++;
        _dormint = false;
      });
    });
  }

  // final de torn
  void _acabarTorn() {
    setState(() {
      _missatge = _missatgeDormir(_torns[_torn]);
      _dormint = true;
    });
    _esperar();
  }

  // enviar el missatge de dormir
  String _missatgeDormir(Rol rol) {
    return switch (rol) {
      Rol.vident => 'La vident s\'adorm',
      Rol.llop => 'Els llops s\'adormen',
      _ => '${rol.nom} s\'adorm',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _vistaActual(),
        ),
      ),
    );
  }

  Widget _vistaActual() {
    if (_dormint) return _vistaMissatge(_missatge);
    if (_torn >= _torns.length) return _vistaMissatge('Es fa de dia. Els jugadors obren els ulls', '☀️');
    return switch (_torns[_torn]) {
      Rol.vident => _TornVident(
        key: ValueKey('torn$_torn'),
        partida: widget.partida,
        alAcabar: _acabarTorn,
      ),
      Rol.llop => _TornLlops(
        key: ValueKey('torn$_torn'),
        partida: widget.partida,
        alAcabar: _acabarTorn,
      ),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _vistaMissatge(String text, [String emoji = '🌙']) {
    return SizedBox.expand(
      key: ValueKey(text),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 80)),
          const SizedBox(height: 16),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// Torn de la vident: tria un jugador i en veu el rol
class _TornVident extends StatefulWidget {
  final Partida partida;
  final VoidCallback alAcabar;

  const _TornVident({super.key, required this.partida, required this.alAcabar});

  @override
  State<_TornVident> createState() => _TornVidentState();
}

class _TornVidentState extends State<_TornVident> {
  Jugador? _vist;

  @override
  Widget build(BuildContext context) {
    final vist = _vist;
    if (vist == null) {
      return SizedBox.expand(
        child: TriaJugador(
          titol: 'La vident es desperta.\nTria un jugador per descobrir el seu rol',
          opcions: widget.partida.vius
              .where((j) => j.rol != Rol.vident)
              .toList(),
          alConfirmar: (j) => setState(() => _vist = j),
        ),
      );
    }
    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(vist.nom, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 16),
          Text(vist.rol.emoji, style: const TextStyle(fontSize: 96)),
          Text(
            vist.rol.nom,
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 48),
          FilledButton(onPressed: widget.alAcabar, child: const Text('Entès')),
        ],
      ),
    );
  }
}

// Torn dels llops: trien la víctima (cap llop apareix a la llista)
class _TornLlops extends StatelessWidget {
  final Partida partida;
  final VoidCallback alAcabar;

  const _TornLlops({super.key, required this.partida, required this.alAcabar});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: TriaJugador(
        titol: 'Els llops es desperten.\nTrieu qui voleu devorar',
        opcions: partida.vius.where((j) => j.rol != Rol.llop).toList(),
        alConfirmar: (j) {
          partida.victimaLlops = j;
          debugPrint('Víctima dels llops: ${j.nom} :(');
          alAcabar();
        },
      ),
    );
  }
}