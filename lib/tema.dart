// TEMA VISUAL DEL JURÀSSIC: colors, tipografia i estil dels botons

import 'package:flutter/material.dart';

class ColorsJoc {
  // fons de nit (selva fosca) i de dia (dosser verd amb sol)
  static const Color nitAlt = Color(0xFF06100B);
  static const Color nitBaix = Color(0xFF14301F);
  static const Color diaAlt = Color(0xFF2F6B49);
  static const Color diaBaix = Color(0xFF14382A);

  // ambre: l'únic color d'accent (com el mosquit fossilitzat)
  static const Color ambre = Color(0xFFF2A413);
  static const Color ambreClar = Color(0xFFFFD27A);
  static const Color ambreFosc = Color(0xFF9C5A00);
  static const Color ambreSuau = Color(0x33F2A413);
  static const Color tintaAmbre = Color(0xFF1C1203);

  // text color os / pergamí
  static const Color os = Color(0xFFEFE6CF);
  static const Color osSuau = Color(0xB3EFE6CF);
  static const Color vidre = Color(0x1AEFE6CF);
  static const Color vora = Color(0x33EFE6CF);

  static const Color rovell = Color(0xFFC4502F);
}

// Tipografia de títols (s'ha de declarar al pubspec.yaml, família AlfaSlabOne)
const String fontTitol = 'AlfaSlabOne';

TextStyle estilTitol(double mida, {Color color = ColorsJoc.os}) {
  return TextStyle(
    fontFamily: fontTitol,
    fontSize: mida,
    height: 1.1,
    fontWeight: FontWeight.w400,
    color: color,
  );
}

ThemeData construirTema() {
  final base = ColorScheme.fromSeed(
    seedColor: ColorsJoc.ambre,
    brightness: Brightness.dark,
  );
  final scheme = base.copyWith(
    primary: ColorsJoc.ambre,
    onPrimary: ColorsJoc.tintaAmbre,
    surface: ColorsJoc.nitBaix,
    onSurface: ColorsJoc.os,
    error: ColorsJoc.rovell,
  );
  final forma = RoundedRectangleBorder(borderRadius: BorderRadius.circular(16));
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: ColorsJoc.nitAlt,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: estilTitol(22),
      iconTheme: const IconThemeData(color: ColorsJoc.os),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: ColorsJoc.ambre,
        foregroundColor: ColorsJoc.tintaAmbre,
        disabledBackgroundColor: ColorsJoc.vidre,
        disabledForegroundColor: ColorsJoc.vora,
        minimumSize: const Size(0, 56),
        padding: const EdgeInsets.symmetric(horizontal: 28),
        shape: forma,
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ColorsJoc.os,
        side: const BorderSide(color: Color(0x80EFE6CF), width: 1.5),
        minimumSize: const Size(0, 56),
        shape: forma,
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: ColorsJoc.ambreClar),
    ),
    sliderTheme: const SliderThemeData(
      activeTrackColor: ColorsJoc.ambre,
      inactiveTrackColor: ColorsJoc.vora,
      thumbColor: ColorsJoc.ambreClar,
      overlayColor: ColorsJoc.ambreSuau,
      valueIndicatorColor: ColorsJoc.ambre,
    ),
  );
}
