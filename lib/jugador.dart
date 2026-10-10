// GUARDEM ELS ROLS I LA SEVA DESCRIPCIÓ

enum Rol {
  vilata(
    'Vilatà',
    '🧑‍🌾',
    'Descobreix qui són els llops i elimina\'ls amb el teu vot.',
  ),
  llop(
    'Llop',
    '🐺',
    'Elimina els vilatans sense que et descobreixin.',
  ),
  vident(
    'Vident',
    '🔮',
    'Cada nit pots descobrir el rol d\'un jugador.',
  ),
  bruixa(
    'Bruixa',
    '🧪',
    'Tens dues pocions d\'un sol ús: una per curar i una altra per matar.',
  ),
  cazador(
    'Caçador',
    '🏹',
    'Si mors, t\'emportes un altre jugador amb tu.',
  );

  final String nom;
  final String emoji;
  final String descripcio;

  const Rol(this.nom, this.emoji, this.descripcio);
}

class Jugador {
  final String nom;
  final Rol rol;
  bool viu = true;

  Jugador(this.nom, this.rol);
}