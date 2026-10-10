import 'jugador.dart';

// Classe per guardar la informació de la partida
class Partida {
  final List<Jugador> jugadors; // tots els jugadors
  int nit = 1;
  Jugador? victimaLlops; // la victima pels llops

  Partida(this.jugadors);

  List<Jugador> get vius => jugadors.where((j) => j.viu).toList();// rebem els jugadors v ius

  bool hiHaRol(Rol rol) => jugadors.any((j) => j.rol == rol && j.viu); // per saber si hi ha cert rol

  // Quants llops queden vius
  int get llopsVius => vius.where((j) => j.rol == Rol.llop).length;

  // Definició de final de partida (llops igualen a la resta o no queden llops)
  bool get partidaAcabada {
    int llops = llopsVius;
    int resta = vius.length - llops;
    return llops == 0 || llops >= resta; // guanya poble / guanyen llops
  }

  // si es cert guanyen llops, altrament ha guanyat el poble
  bool get guanyenLlops => llopsVius > 0;
}