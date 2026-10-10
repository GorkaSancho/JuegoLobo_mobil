enum Rol {
  // rol de vilata
  vilata(
    'Vilatà',
    '🧑‍🌾',
    'Descobreix qui són els llops i elimina\'ls amb el teu vot.',
  ),
  // El llop
  llop(
    'Llop',
    '🐺',
    'Elimina els vilatans sense que et descobreixin.',
  );

  final String nom;
  final String emoji;
  final String descripcio;

  const Rol(this.nom, this.emoji, this.descripcio);
}

// Dades del jugador
class Jugador {
  final String nom;
  final Rol rol;
  bool viu = true;

  Jugador(this.nom, this.rol);
}