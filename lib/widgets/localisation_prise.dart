import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocalisationPrise extends StatefulWidget {
  final void Function(double lat, double lng, String adresse)
      onLocalisationSelectionnee;
  const LocalisationPrise({super.key, required this.onLocalisationSelectionnee});

  @override
  State<LocalisationPrise> createState() => _LocalisationPriseState();
}

class _LocalisationPriseState extends State<LocalisationPrise> {
  double? _latitude;
  double? _longitude;
  String? _adresse;
  bool _chargement = false;

  Future<void> _obtenirLocalisation() async {
    setState(() => _chargement = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _snack('Permission de localisation refusée.');
          setState(() => _chargement = false);
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        _snack('Activez la localisation dans les paramètres.');
        setState(() => _chargement = false);
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);

      String adresse = 'Adresse inconnue';
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        adresse = '${p.locality ?? ''}, ${p.country ?? ''}'.trim();
        if (adresse.startsWith(',')) adresse = adresse.substring(1).trim();
        if (adresse.endsWith(','))
          adresse = adresse.substring(0, adresse.length - 1).trim();
      }

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _adresse = adresse;
        _chargement = false;
      });
      widget.onLocalisationSelectionnee(
          position.latitude, position.longitude, adresse);
    } catch (e) {
      _snack('Impossible d\'obtenir la localisation.');
      setState(() => _chargement = false);
    }
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: const Color(0xFFE24B4A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_chargement) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: CircularProgressIndicator(
            color: Color(0xFF0D9E75),
            strokeWidth: 2.5,
          ),
        ),
      );
    }

    if (_latitude != null && _longitude != null) {
      return Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 180,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(_latitude!, _longitude!),
                  zoom: 14,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('pos'),
                    position: LatLng(_latitude!, _longitude!),
                  ),
                },
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
              ),
            ),
          ),
          if (_adresse != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  const Icon(Icons.location_on_rounded,
                      size: 14, color: Color(0xFF0D9E75)),
                  const SizedBox(width: 4),
                  Text(
                    _adresse!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF7A9E8E),
                    ),
                  ),
                ],
              ),
            ),
        ],
      );
    }

    return GestureDetector(
      onTap: _obtenirLocalisation,
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F8F4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF9FE1CB)),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.my_location_rounded,
                color: Color(0xFF0D9E75), size: 30),
            SizedBox(height: 8),
            Text(
              'Obtenir ma localisation',
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