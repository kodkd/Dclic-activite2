// ============================================================
// MODELE : endroit.dart
// Représente un endroit favori avec ses données (nom, image, GPS).
// Architecture MVC → couche MODEL
// ============================================================

import 'dart:io'; // Pour la classe File (image disque)
import 'package:uuid/uuid.dart'; // Pour générer un identifiant unique

/// Instance globale du générateur UUID, utilisée dans le constructeur.
const uuid = Uuid();

/// Modèle de données central : représente un endroit favori.
class Endroit {
  /// Identifiant unique généré automatiquement via uuid.v4().
  final String id;

  /// Nom de l'endroit saisi par l'utilisateur.
  final String nom;

  /// Photo prise avec la caméra, stockée sous forme de fichier local.
  final File image;

  /// Latitude GPS (optionnelle — null si non renseignée).
  final double? latitude;

  /// Longitude GPS (optionnelle — null si non renseignée).
  final double? longitude;

  /// Adresse lisible obtenue par géocodage inverse (ex: "Abidjan, Côte d'Ivoire").
  final String? adresse;

  /// Constructeur principal.
  /// L'id est initialisé automatiquement via la liste d'initialisation Dart.
  Endroit({
    required this.nom,
    required this.image,
    this.latitude,
    this.longitude,
    this.adresse,
  }) : id = uuid.v4(); // Initialisation automatique de l'id unique

  /// Getter : retourne true si des coordonnées GPS sont disponibles.
  /// Utilisé dans EndroitDetail pour décider d'afficher ou non la carte.
  bool get aLocalisation => latitude != null && longitude != null;
}
