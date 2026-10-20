// ELEMENTS VISUALS REUTILITZABLES: fons de selva, ambre amb emoji i targeta de jugador

import 'dart:math';
import 'package:flutter/material.dart';
import 'tema.dart';

enum MomentDia { nit, dia }

// Pantalla base: fons animat (nit/dia) + Scaffold transparent
class PantallaJoc extends StatelessWidget {
  final MomentDia moment;
  final PreferredSizeWidget? appBar;
  final Widget body;
  final bool safeArea;

  const PantallaJoc({
    super.key,
    required this.body,
    this.moment = MomentDia.nit,
    this.appBar,
    this.safeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    return FonsJoc(
      moment: moment,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBar,
        body: safeArea ? SafeArea(child: body) : body,
      ),
    );
  }
}

class FonsJoc extends StatelessWidget {
  final MomentDia moment;
  final Widget child;

  const FonsJoc({super.key, required this.moment, required this.child});

  @override
  Widget build(BuildContext context) {
    final nit = moment == MomentDia.nit;
    const durada = Duration(milliseconds: 900);
    return Stack(
      fit: StackFit.expand,
      children: [
        // cel
        AnimatedContainer(
          duration: durada,
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: nit
                  ? const [ColorsJoc.nitAlt, ColorsJoc.nitBaix]
                  : const [ColorsJoc.diaAlt, ColorsJoc.diaBaix],
            ),
          ),
        ),
        // llum: lluna a la nit, sol a l'alba
        AnimatedContainer(
          duration: durada,
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: nit ? const Alignment(0.8, -1.0) : const Alignment(0.0, -1.05),
              radius: nit ? 0.55 : 1.0,
              colors: nit
                  ? const [Color(0x40EFE6CF), Color(0x00EFE6CF)]
                  : const [Color(0x66FFD27A), Color(0x00FFD27A)],
            ),
          ),
        ),
        // falgueres del fons
        Align(
          alignment: Alignment.bottomCenter,
          child: IgnorePointer(
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(end: nit ? 0.0 : 1.0),
              duration: durada,
              builder: (context, v, _) {
                return CustomPaint(
                  size: const Size(double.infinity, 150),
                  painter: _SilueteJungla(
                    darrere: Color.lerp(const Color(0xFF0C1D14), const Color(0xFF1F5237), v)!,
                    davant: Color.lerp(const Color(0xFF050B08), const Color(0xFF0B2419), v)!,
                  ),
                );
              },
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class _SilueteJungla extends CustomPainter {
  final Color darrere;
  final Color davant;

  _SilueteJungla({required this.darrere, required this.davant});

  @override
  void paint(Canvas canvas, Size size) {
    _capa(canvas, size, darrere, 3, 1.0, const [0.0, 0.2, 0.45, 0.68, 0.9, 1.0]);
    _capa(canvas, size, davant, 9, 0.6, const [0.08, 0.32, 0.56, 0.8, 0.98]);
  }

  void _capa(Canvas canvas, Size size, Color color, int seed, double escala,
      List<double> mates) {
    final rnd = Random(seed);
    final pintura = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    for (final x in mates) {
      final base = Offset(size.width * x, size.height + 6);
      const fulles = 8;
      for (int i = 0; i < fulles; i++) {
        final angle = -pi / 2 +
            (i - (fulles - 1) / 2) * 0.3 +
            (rnd.nextDouble() - 0.5) * 0.15;
        final llarg = size.height * escala * (0.6 + rnd.nextDouble() * 0.5);
        _fulla(canvas, pintura, base, angle, llarg);
      }
    }
    canvas.drawRect(
      Rect.fromLTWH(0, size.height - 8, size.width, 8),
      pintura,
    );
  }

  // una fulla de falguera: una llavor corbada
  void _fulla(Canvas canvas, Paint pintura, Offset base, double angle, double llarg) {
    final dir = Offset(cos(angle), sin(angle));
    final perp = Offset(-dir.dy, dir.dx);
    final doblec = (angle >= -pi / 2 ? 1.0 : -1.0) * llarg * 0.18;
    final ample = llarg * 0.07;
    final mig = base + dir * (llarg * 0.5);
    final c1 = mig + perp * (doblec + ample);
    final c2 = mig + perp * (doblec - ample);
    final punta = base + dir * llarg + perp * (doblec * 1.2);
    final cami = Path()
      ..moveTo(base.dx, base.dy)
      ..quadraticBezierTo(c1.dx, c1.dy, punta.dx, punta.dy)
      ..quadraticBezierTo(c2.dx, c2.dy, base.dx, base.dy)
      ..close();
    canvas.drawPath(cami, pintura);
  }

  @override
  bool shouldRepaint(covariant _SilueteJungla old) =>
      old.darrere != darrere || old.davant != davant;
}

// Emoji dins d'una gota d'ambre (com un fòssil)
class AmbreEmoji extends StatelessWidget {
  final String emoji;
  final double mida;

  const AmbreEmoji(this.emoji, {super.key, this.mida = 72});

  @override
  Widget build(BuildContext context) {
    final d = mida * 1.9;
    return Container(
      width: d,
      height: d,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          center: Alignment(-0.35, -0.4),
          radius: 0.95,
          colors: [ColorsJoc.ambreClar, ColorsJoc.ambre, ColorsJoc.ambreFosc],
          stops: [0.0, 0.55, 1.0],
        ),
        border: Border.all(color: const Color(0x66FFF1CC), width: 2),
        boxShadow: const [
          BoxShadow(color: Color(0x55F2A413), blurRadius: 36, spreadRadius: 2),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: d * 0.12,
            left: d * 0.2,
            child: Transform.rotate(
              angle: -0.6,
              child: Container(
                width: d * 0.26,
                height: d * 0.11,
                decoration: BoxDecoration(
                  color: const Color(0x66FFFFFF),
                  borderRadius: BorderRadius.circular(d * 0.06),
                ),
              ),
            ),
          ),
          Center(child: Text(emoji, style: TextStyle(fontSize: mida))),
        ],
      ),
    );
  }
}

// Targeta amb un jugador i el seu rol (els morts surten ratllats)
class TargetaJugador extends StatelessWidget {
  final String emoji;
  final String nom;
  final String rol;
  final bool viu;

  const TargetaJugador({
    super.key,
    required this.emoji,
    required this.nom,
    required this.rol,
    this.viu = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: ColorsJoc.vidre,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorsJoc.vora),
      ),
      child: ListTile(
        leading: Text(emoji, style: const TextStyle(fontSize: 32)),
        title: Text(
          nom,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            decoration: viu ? null : TextDecoration.lineThrough,
            color: viu ? ColorsJoc.os : ColorsJoc.osSuau,
          ),
        ),
        subtitle: Text(rol),
      ),
    );
  }
}
