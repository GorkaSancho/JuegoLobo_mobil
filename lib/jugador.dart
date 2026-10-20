// GUARDEM ELS ROLS I LA SEVA DESCRIPCIÓ
// (els identificadors es mantenen: llop = dinosaure, vilata = explorador, vident = paleontòloga)

enum Rol {
  vilata(
    'Explorador',
    '🧭',
    'Descobreix quins són els dinosaures i expulsa\'ls amb el teu vot.',
  ),
  llop(
    'Dinosaure',
    '🦖',
    'Devora els exploradors sense que et descobreixin.',
  ),
  vident(
    'Paleontòloga',
    '🦴',
    'Cada nit pots analitzar l\'ADN d\'un jugador i descobrir-ne el rol.',
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
