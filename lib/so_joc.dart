// TOTS ELS SONS DEL JOC

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

enum So {
  nit('assets/sounds/nit.mp3', true), // inici de la nit: grills i vent
  rugit('assets/sounds/rugit.mp3', false), // els dinosaures ataquen
  genetista('assets/sounds/vident.mp3', false), // actua la genetista
  metgessa('assets/sounds/bruixa.mp3', false), // actua la metgessa
  cacador('assets/sounds/caçador.mp3', false), // actua el caçador
  ocells('assets/sounds/dia.mp3', true); // inici del dia

  final String asset;
  final bool ambient; // els ambients i els efectes tenen reproductor propi i no es trepitgen
  const So(this.asset, this.ambient);
}

class SoJoc {
  final AudioPlayer _ambient = AudioPlayer();
  final AudioPlayer _efectes = AudioPlayer();

  Future<void> reproduir(So so) async {
    final reproductor = so.ambient ? _ambient : _efectes;
    try {
      await reproductor.stop();
      await reproductor.setAsset(so.asset);
      await reproductor.play();
    } catch (error) {
      debugPrint('No s\'ha pogut reproduir ${so.asset}: $error');
    }
  }

  Future<void> reproduirPrevisualitzacio(So so) async {
    await _ambient.stop();
    await _efectes.stop();
    await reproduir(so);
  }

  Future<void> dispose() async {
    await _ambient.dispose();
    await _efectes.dispose();
  }
}
