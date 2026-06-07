# 📍 Endroits Favoris — Application Flutter

Application Flutter de gestion d'endroits favoris avec caméra, géolocalisation et Google Maps.  
Activité n°2 — Cours Développement Mobile (Niveau Approfondi)

---

## 🏗️ Architecture MVC

```
lib/
├── modele/
│   └── endroit.dart            ← MODEL : données de l'endroit
├── providers/
│   └── endroits_provider.dart  ← CONTROLLER : logique métier + état Riverpod
├── vue/
│   ├── endroits_interface.dart ← VIEW : écran principal
│   ├── ajout_endroit.dart      ← VIEW : formulaire d'ajout
│   └── endroit_detail.dart     ← VIEW : détails d'un endroit
├── widgets/
│   ├── endroits_list.dart      ← Composant liste réutilisable
│   ├── image_prise.dart        ← Composant caméra réutilisable
│   └── localisation_prise.dart ← Composant GPS + carte réutilisable
└── main.dart                   ← Point d'entrée + ProviderScope
```

### Rôles MVC dans ce projet

| Couche | Fichier(s) | Responsabilité |
|--------|-----------|----------------|
| **Model** | `endroit.dart` | Structure des données, getter `aLocalisation` |
| **Controller** | `endroits_provider.dart` | Gestion de la liste, ajout, suppression via Riverpod |
| **View** | `vue/*.dart` + `widgets/*.dart` | Affichage, formulaires, navigation |

---

## 📦 Packages utilisés

| Package | Version | Rôle |
|---------|---------|------|
| `uuid` | ^4.0.0 | Génération d'identifiants uniques (UUID v4) |
| `flutter_riverpod` | ^2.4.0 | Gestion d'état globale (Notifier + NotifierProvider) |
| `image_picker` | ^1.0.0 | Accès à la caméra de l'appareil |
| `google_maps_flutter` | ^2.5.0 | Affichage de cartes Google Maps |
| `geolocator` | ^10.0.0 | Récupération de la position GPS |
| `geocoding` | ^2.1.0 | Conversion coordonnées → adresse lisible |

---

## 🚀 Installation et démarrage

### 1. Cloner et installer les dépendances

```bash
cd flutter_endroits_favoris
flutter pub get
```

### 2. Configurer la clé API Google Maps

1. Rendez-vous sur [console.cloud.google.com](https://console.cloud.google.com)
2. Créez un projet → activez **Maps SDK for Android**
3. Créez une clé API dans **APIs & Services → Credentials**
4. Ouvrez `android/app/src/main/AndroidManifest.xml`
5. Remplacez `VOTRE_CLE_API_ICI` par votre clé :

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="AIza...VotreCle..."/>
```

### 3. Contenu de AndroidManifest.xml

Ajoutez ces balises dans votre fichier `android/app/src/main/AndroidManifest.xml` :

**Permissions** (avant `</manifest>`) :
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

**Clé API** (dans `<application>`, après `</activity>`) :
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="VOTRE_CLE_API_ICI"/>
```

### 4. Lancer l'application

```bash
flutter clean
flutter run
```

---

## 📱 Fonctionnalités

| Fonctionnalité | Description |
|---------------|-------------|
| **Liste des endroits** | Affichage en liste avec vignette, nom et adresse |
| **Ajout d'un endroit** | Formulaire avec nom, photo et localisation |
| **Prise de photo** | Caméra native via `image_picker` |
| **Géolocalisation** | Position GPS via `geolocator` + permissions automatiques |
| **Géocodage inverse** | Coordonnées → adresse lisible via `geocoding` |
| **Mini-carte** | Aperçu Google Maps lors de l'ajout |
| **Détails** | Page de détails avec carte plein écran |

---

## 🧪 Tester sur émulateur Android

Sur un émulateur, la position GPS n'est pas réelle. Pour simuler une position :

1. Ouvrir les **Extended Controls** (icône `...` dans la barre d'outils de l'émulateur)
2. Aller dans **Location**
3. Saisir une ville dans la barre de recherche
4. Cliquer sur **Set Location**

Sur un vrai téléphone, la position GPS réelle est utilisée automatiquement.

---

## 📋 Explication technique : Riverpod v2

Ce projet utilise la syntaxe **Riverpod v2** avec `Notifier` et `NotifierProvider` :

```dart
// CONTROLLER
class EndroitsNotifier extends Notifier<List<Endroit>> {
  @override
  List<Endroit> build() => []; // État initial

  void ajouterEndroit({...}) {
    state = [nouvelEndroit, ...state]; // Réaffectation de state
  }
}

// PROVIDER GLOBAL
final endroitsProvider = NotifierProvider<EndroitsNotifier, List<Endroit>>(
  EndroitsNotifier.new,
);
```

**Dans les vues :**
```dart
// Lire la liste (avec reconstruction automatique)
final endroits = ref.watch(endroitsProvider);

// Appeler une méthode du controller
ref.read(endroitsProvider.notifier).ajouterEndroit(...);
```

---

## 💡 Améliorations possibles

- **Persistance** : Ajouter `sqflite` pour sauvegarder les données localement
- **Suppression** : Ajouter un swipe-to-delete sur la liste
- **Modification** : Permettre d'éditer le nom ou la photo d'un endroit
- **Tri** : Trier par date d'ajout ou par nom
- **iOS** : Configurer `Info.plist` pour les permissions caméra et GPS sur iOS
