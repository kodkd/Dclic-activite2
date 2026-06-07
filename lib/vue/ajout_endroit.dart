import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/endroits_provider.dart';
import '../widgets/image_prise.dart';
import '../widgets/localisation_prise.dart';

class AjoutEndroit extends ConsumerStatefulWidget {
  const AjoutEndroit({super.key});

  @override
  ConsumerState<AjoutEndroit> createState() => _AjoutEndroitState();
}

class _AjoutEndroitState extends ConsumerState<AjoutEndroit> {
  final _nomController = TextEditingController();
  File? _imageSelectionnee;
  double? _latitude;
  double? _longitude;
  String? _adresse;

  @override
  void dispose() {
    _nomController.dispose();
    super.dispose();
  }

  void _surPhotoSelectionnee(File image) {
    setState(() => _imageSelectionnee = image);
  }

  void _surLocalisationSelectionnee(double lat, double lng, String adresse) {
    setState(() {
      _latitude = lat;
      _longitude = lng;
      _adresse = adresse;
    });
  }

  void _enregistrerEndroit() {
    final nom = _nomController.text.trim();
    if (nom.isEmpty) {
      _snack('Veuillez saisir un nom pour l\'endroit.', isError: true);
      return;
    }
    if (_imageSelectionnee == null) {
      _snack('Veuillez prendre une photo de l\'endroit.', isError: true);
      return;
    }
    ref.read(endroitsProvider.notifier).ajouterEndroit(
          nom: nom,
          image: _imageSelectionnee!,
          latitude: _latitude,
          longitude: _longitude,
          adresse: _adresse,
        );
    Navigator.of(context).pop();
  }

  void _snack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor:
            isError ? const Color(0xFFE24B4A) : const Color(0xFF0D9E75),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F6),
      appBar: AppBar(
        title: const Text('Nouvel endroit'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Nom
            _SectionCard(
              icon: Icons.edit_rounded,
              label: 'Nom de l\'endroit',
              child: TextField(
                controller: _nomController,
                decoration: const InputDecoration(
                  hintText: 'Ex: Ma plage préférée...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
                textCapitalization: TextCapitalization.sentences,
                maxLength: 50,
              ),
            ),
            const SizedBox(height: 16),

            // Section Photo
            _SectionCard(
              icon: Icons.camera_alt_rounded,
              label: 'Photo',
              child: ImagePrise(onPhotoSelectionnee: _surPhotoSelectionnee),
            ),
            const SizedBox(height: 16),

            // Section Localisation
            _SectionCard(
              icon: Icons.location_on_rounded,
              label: 'Localisation',
              child: LocalisationPrise(
                onLocalisationSelectionnee: _surLocalisationSelectionnee,
              ),
            ),
            const SizedBox(height: 28),

            // Bouton enregistrer
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _enregistrerEndroit,
                icon: const Icon(Icons.save_rounded, size: 20),
                label: const Text('Enregistrer l\'endroit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget interne : carte de section avec icône et titre.
class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget child;

  const _SectionCard({
    required this.icon,
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8EDEA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: const Color(0xFF0D9E75)),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: Color(0xFF0D9E75),
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}