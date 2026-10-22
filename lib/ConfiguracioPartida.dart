class ConfiguracioPartida {
  final int nJugadors;
  final int nLlops;
  final bool vident;
  final bool cientifica;
  final bool cazador;
  final List<String> noms;

  const ConfiguracioPartida({
    required this.nJugadors,
    required this.nLlops,
    required this.noms,
    this.vident = true,
    this.cientifica = true,
    this.cazador = true,
  });
}