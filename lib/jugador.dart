// GUARDEM ELS ROLS I LA SEVA DESCRIPCIÓ
// (els identificadors es mantenen: llop = dinosaure, vident = paleontòloga)

enum Rol {
  visitant(
    'Visitant',
    '🎟️',
    'No tens cap poder especial. Observa, debat i vota per descobrir els dinosaures.',
  ),
  llop(
    'Dinosaure',
    '🦖',
    'Devora els visitants sense que et descobreixin.',
  ),
  vident(
    'Paleontòloga',
    '🦴',
    'Cada nit pots analitzar l\'ADN d\'un jugador i descobrir-ne el rol.',
  ),
  cientifica(
    'Científica',
    '🧪',
    'Tens dues dosis experimentals: una pot revertir una transformació i l\'altra eliminar un jugador.',
  ),
  cazador(
    'Caçador',
    '🔫',
    'Si mors, pots fer un últim tret amb l\'escopeta i endur-te un altre jugador.',
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
