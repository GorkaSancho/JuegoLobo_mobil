class ConfiguracioPartida {
  final int nJugadors;
  final int nLlops;
  final bool vident;
  final bool bruixa;
  final bool cazador;

  const ConfiguracioPartida({
    required this.nJugadors,
    required this.nLlops,
    this.vident = true,
    this.bruixa = true,
    this.cazador = true,
  });
}