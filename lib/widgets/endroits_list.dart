// ============================================================
// WIDGET : endroits_list.dart
// Affiche la liste des endroits favoris dans un ListView.
// Architecture MVC → composant réutilisable de la couche VIEW
// ============================================================

import 'package:flutter/material.dart';
import '../modele/endroit.dart';
import '../vue/endroit_detail.dart';

/// Widget StatelessWidget qui affiche la liste des endroits favoris.
///
/// Reçoit la liste en paramètre depuis le provider Riverpod (via EndroitsInterface).
/// Gère deux états : liste vide (message informatif) et liste non vide (ListView).
class EndroitsList extends StatelessWidget {
  /// Liste des endroits à afficher, fournie par le provider Riverpod.
  final List<Endroit> endroits;

  const EndroitsList({super.key, required this.endroits});

  @override
  Widget build(BuildContext context) {
    // --- Cas 1 : Liste vide → afficher un message centré ---
    if (endroits.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icône décorative
            Icon(
              Icons.location_off_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun endroit favori pour le moment.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade500,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Appuyez sur + pour en ajouter un.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade400,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // --- Cas 2 : Liste non vide → ListView dynamique ---
    return ListView.builder(
      itemCount: endroits.length,
      itemBuilder: (context, index) {
        final endroit = endroits[index];

        return ListTile(
          // Vignette circulaire de la photo de l'endroit
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: FileImage(endroit.image), // Image depuis le fichier local
          ),

          // Nom principal de l'endroit
          title: Text(
            endroit.nom,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),

          // Adresse affichée en sous-titre si disponible
          subtitle: endroit.adresse != null
              ? Text(
                  endroit.adresse!,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : null,

          // Flèche indiquant que l'élément est cliquable
          trailing: const Icon(Icons.chevron_right),

          // Navigation vers la page de détails de l'endroit
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => EndroitDetail(endroit: endroit),
              ),
            );
          },
        );
      },
    );
  }
}
