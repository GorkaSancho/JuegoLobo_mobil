class ConfiguracioPartida {
  final int nJugadors;
  final int nLlops;
  final bool genetista;
  final bool metgessa;
  final bool cazador;
  final List<String> noms;

  const ConfiguracioPartida({
    required this.nJugadors,
    required this.nLlops,
    required this.noms,
    this.genetista = true,
    this.metgessa = true,
    this.cazador = true,
  });
}