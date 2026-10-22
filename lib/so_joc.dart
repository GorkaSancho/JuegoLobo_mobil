// TOTS ELS SONS DEL JOC

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'opcions.dart';

enum So {
  nit('assets/sounds/nit.mp3'), // inici de la nit: grills i vent
  rugit('assets/sounds/rugit.mp3'), // els dinosaures ataquen
  genetista('assets/sounds/vident.mp3'), // actua la genetista
  metgessa('assets/sounds/bruixa.mp3'), // actua la metgessa
  cacador('assets/sounds/caçador.mp3'), // actua el caçador
  ocells('assets/sounds/dia.mp3'); // inici del dia

  final String asset;
  const So(this.asset);
}

class SoJoc {
  static final AudioPlayer _player = AudioPlayer();

  Future<void> reproduir(So so) async {
    try {
      await _player.stop();
      await _player.setVolume(OpcionsJoc.volum);
      await _player.setAsset(so.asset);
      await _player.play();
    } catch (error) {
      debugPrint('No s\'ha pogut reproduir ${so.asset}: $error');
    }
  }

  Future<void> reproduirPrevisualitzacio(So so) async {
    await reproduir(so);
  }

  static Future<void> actualitzarVolum(double volum) async {
    OpcionsJoc.volum = volum;
    try {
      await _player.setVolume(volum);
    } catch (error) {
      debugPrint('No s\'ha pogut canviar el volum: $error');
    }
  }

  Future<void> dispose() async {
    await _player.stop();
  }
}
