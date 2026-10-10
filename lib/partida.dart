import 'jugador.dart';

// Classe per guardar la informació de la partida
class Partida {
  final List<Jugador> jugadors; // tots els jugadors
  int nit = 1; // n de nits q portem jugades
  Jugador? victimaLlops; // la victima pels llops

  Partida(this.jugadors);

  List<Jugador> get vius => jugadors.where((j) => j.viu).toList(); // rebem els jugadors v ius

  bool hiHaRol(Rol rol) => jugadors.any((j) => j.rol == rol); // per saber si hi ha cert rol
}