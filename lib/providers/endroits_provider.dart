// ============================================================
// CONTROLLER (Provider) : endroits_provider.dart
// Gère l'état global de la liste des endroits avec Riverpod v2.
// Architecture MVC → couche CONTROLLER
// ============================================================

import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../modele/endroit.dart';

/// Classe EndroitsNotifier : gère la liste des endroits favoris.
///
/// Hérite de Notifier<List<Endroit>> (syntaxe Riverpod v2).
/// Elle remplace l'ancien StateNotifier désormais déprécié.
class EndroitsNotifier extends Notifier<List<Endroit>> {
  /// Méthode build() : obligatoire avec Riverpod v2.
  /// Remplace le constructeur et retourne l'état initial (liste vide).
  @override
  List<Endroit> build() {
    return []; // Aucun endroit au démarrage de l'application
  }

  /// Ajoute un nouvel endroit en tête de liste.
  ///
  /// Paramètres :
  /// - [nom] : nom saisi par l'utilisateur
  /// - [image] : photo capturée avec la caméra
  /// - [latitude], [longitude] : coordonnées GPS optionnelles
  /// - [adresse] : adresse lisible optionnelle
  void ajouterEndroit({
    required String nom,
    required File image,
    double? latitude,
    double? longitude,
    String? adresse,
  }) {
    // Création d'un nouvel objet Endroit avec l'id généré automatiquement
    final nouvelEndroit = Endroit(
      nom: nom,
      image: image,
      latitude: latitude,
      longitude: longitude,
      adresse: adresse,
    );

    // Réaffectation de state : ajout en tête de liste (plus récent en premier)
    // On utilise un spread pour ne pas muter la liste d'origine
    state = [nouvelEndroit, ...state];
  }

  /// Supprime un endroit de la liste par son identifiant unique.
  ///
  /// Paramètre :
  /// - [id] : identifiant de l'endroit à supprimer
  void supprimerEndroit(String id) {
    // Filtre la liste en excluant l'endroit dont l'id correspond
    state = state.where((endroit) => endroit.id != id).toList();
  }
}

/// Provider global exposé à toute l'application.
///
/// Utilise NotifierProvider (syntaxe Riverpod v2).
/// Accessible via ref.watch(endroitsProvider) ou ref.read(endroitsProvider.notifier).
final endroitsProvider =
    NotifierProvider<EndroitsNotifier, List<Endroit>>(EndroitsNotifier.new);
