import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePrise extends StatefulWidget {
  final void Function(File image) onPhotoSelectionnee;
  const ImagePrise({super.key, required this.onPhotoSelectionnee});

  @override
  State<ImagePrise> createState() => _ImagePriseState();
}

class _ImagePriseState extends State<ImagePrise> {
  File? _photoSelectionnee;

  Future<void> _prendrePhoto() async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 800,
    );
    if (photo == null) return;
    final fichier = File(photo.path);
    setState(() => _photoSelectionnee = fichier);
    widget.onPhotoSelectionnee(fichier);
  }

  @override
  Widget build(BuildContext context) {
    if (_photoSelectionnee != null) {
      return GestureDetector(
        onTap: _prendrePhoto,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                _photoSelectionnee!,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.camera_alt_rounded,
                        color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'Changer',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: _prendrePhoto,
      child: Container(
        width: double.infinity,
        height: 130,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F8F4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF9FE1CB),
            style: BorderStyle.solid,
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt_rounded,
                color: Color(0xFF0D9E75), size: 32),
            SizedBox(height: 8),
            Text(
              'Prendre une photo',
              style: TextStyle(
                color: Color(0xFF0D9E75),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}