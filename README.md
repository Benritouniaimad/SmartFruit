# 🍎 SmartFruit - Image Predictor

**Application mobile intelligente multi-plateforme pour la classification de fruits et assistance vocale intégrée**

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Integrated-FFCA28?logo=firebase)](https://firebase.google.com)
[![TensorFlow Lite](https://img.shields.io/badge/TFLite-AI%20Model-FF6F00?logo=tensorflow)](https://www.tensorflow.org/lite)

## 📋 Table des matières

- [À propos](#-à-propos)
- [Fonctionnalités](#-fonctionnalités)
- [Architecture technique](#-architecture-technique)
- [Prérequis](#-prérequis)
- [Installation](#-installation)
- [Utilisation](#-utilisation)
- [Technologies utilisées](#-technologies-utilisées)
- [Structure du projet](#-structure-du-projet)
- [Auteur](#-auteur)

## 🎯 À propos

SmartFruit est une application mobile éducative et démonstrative qui combine la vision par ordinateur, l'intelligence artificielle conversationnelle et une expérience utilisateur interactive. L'application permet de :

- **Classifier des fruits** à partir d'images capturées par caméra ou sélectionnées depuis la galerie
- **Utiliser un modèle de Deep Learning** (ANN/CNN) entraîné et converti en TFLite pour l'inférence en temps réel
- **Interagir via un assistant vocal** avec reconnaissance vocale, appel d'API IA (GPT/Gemini), et restitution en voix, texte et image
- **Gérer les utilisateurs** via l'authentification Firebase pour une utilisation sécurisée

## ✨ Fonctionnalités

### 🔐 Authentification Firebase
- ✅ Inscription et connexion via email et mot de passe
- ✅ Récupération du mot de passe oublié
- ✅ Redirection automatique après connexion
- ✅ Gestion sécurisée des sessions utilisateurs

### 🍊 Classification d'images (Fruit Recognition)
- 📸 Capture photo via caméra ou import depuis galerie
- 🧠 Classification en temps réel avec modèle TFLite embarqué
- 📊 Affichage du résultat :
  - Nom du fruit prédit
  - Score de confiance (%)
  - Image d'illustration du fruit

### 🎤 Assistant vocal intelligent
- 🎙️ Activation du microphone pour commandes vocales
- 🗣️ Conversion voix → texte (Speech-to-Text)
- 🤖 Envoi des requêtes à l'API IA (GPT/Gemini)
- 📝 Restitution des réponses :
  - Texte affiché
  - Synthèse vocale (Text-to-Speech)
  - Images (si disponibles)

### 📱 Menu principal
- 🏠 Accueil (classification de fruits)
- 💬 Assistant vocal (chat vocal/texte)
- 📜 Historique des classifications (optionnel)
- 👤 Profil utilisateur
- ℹ️ À propos / aide

## 🏗️ Architecture technique

### Frontend
- **Framework** : Flutter (Android, iOS, Web, Windows, macOS)
- **UI** : Design réactif et intuitif
- **Plugins clés** :
  - `image_picker` - Caméra et galerie
  - `tflite_flutter` - Inférence du modèle TFLite
  - `speech_to_text` - Reconnaissance vocale
  - `flutter_tts` - Synthèse vocale
  - `firebase_auth` - Authentification
  - `cloud_firestore` - Base de données

### Backend
- **Firebase Authentication** : Gestion des comptes utilisateurs
- **Cloud Firestore** : Stockage des historiques et préférences
- **API externe** : OpenAI GPT / Google Gemini pour l'assistant intelligent

### Modèle de Deep Learning
- **Type** : CNN (Convolutional Neural Network)
- **Framework** : TensorFlow / Keras
- **Format** : TensorFlow Lite (TFLite) pour mobile
- **Intégration** : Modèle embarqué dans `assets/model/`
- **Inférence** : Sur device avec `tflite_flutter`

## 📦 Prérequis

- Flutter SDK 3.0+
- Dart SDK 2.17+
- Android Studio / Xcode (pour émulateurs)
- Compte Firebase configuré
- API Key (OpenAI GPT ou Google Gemini)

## 🚀 Installation

1. **Cloner le dépôt**
```bash
git clone https://github.com/Benritouniaimad/SmartFruit.git
cd SmartFruit
```

2. **Installer les dépendances**
```bash
flutter pub get
```

3. **Configurer Firebase**
```bash
# Installer FlutterFire CLI
dart pub global activate flutterfire_cli

# Configurer votre projet Firebase
flutterfire configure --project=VOTRE_PROJECT_ID
```

4. **Ajouter votre modèle TFLite**
- Placer votre modèle `.tflite` dans `assets/model/`
- Mettre à jour `pubspec.yaml` pour inclure les assets

5. **Configurer l'API IA**
- Ajouter votre API Key dans les variables d'environnement
- Configurer l'endpoint dans le code

6. **Lancer l'application**
```bash
# Android
flutter run -d android

# iOS
flutter run -d ios

# Web
flutter run -d chrome

# Windows
flutter run -d windows
```

## 💡 Utilisation

### Flux utilisateur

1. **Connexion / Inscription**
   - Créer un compte ou se connecter avec email/mot de passe

2. **Classification de fruits**
   - Accéder au menu principal
   - Sélectionner "Classifier un fruit"
   - Capturer ou importer une image
   - Voir la prédiction avec score de confiance

3. **Assistant vocal**
   - Activer le microphone
   - Poser une question vocalement
   - Recevoir la réponse en texte, voix et image

4. **Gestion du profil**
   - Consulter l'historique (optionnel)
   - Modifier les paramètres utilisateur

## 🛠️ Technologies utilisées

| Catégorie | Technologies |
|-----------|-------------|
| **Frontend** | Flutter, Dart |
| **Backend** | Firebase (Auth, Firestore) |
| **IA & ML** | TensorFlow, Keras, TFLite |
| **API** | OpenAI GPT / Google Gemini |
| **Reconnaissance vocale** | speech_to_text |
| **Synthèse vocale** | flutter_tts |
| **Gestion d'images** | image_picker, tflite_flutter |

## 📂 Structure du projet

```
SmartFruit/
├── android/                 # Configuration Android
├── ios/                     # Configuration iOS
├── lib/
│   ├── main.dart           # Point d'entrée de l'application
│   ├── firebase_options.dart  # Configuration Firebase
│   ├── screens/            # Écrans de l'application
│   └── widgets/            # Composants réutilisables
│       └── voice_assistant_widget.dart  # Assistant vocal
├── assets/
│   ├── model/              # Modèles TFLite
│   └── images/             # Images et illustrations
├── web/                    # Configuration Web
├── windows/                # Configuration Windows
├── macos/                  # Configuration macOS
├── pubspec.yaml            # Dépendances Flutter
└── README.md               # Documentation

```

## 🎓 Objectifs pédagogiques

Ce projet démontre les compétences suivantes :

1. ✅ Conception et entraînement d'un modèle CNN pour la classification d'images
2. ✅ Conversion d'un modèle TensorFlow en TFLite pour mobile
3. ✅ Intégration de modèles ML dans une application Flutter
4. ✅ Implémentation d'un assistant vocal multi-modal (voix, texte, image)
5. ✅ Mise en place d'une authentification Firebase sécurisée
6. ✅ Développement d'une application multi-plateforme (Android, iOS, Web, Desktop)

## 📄 Licence

Ce projet est développé dans un cadre éducatif.

## 🙏 Remerciements

- DR.ANIBOU CHAIMAE pour l'encadrement du projet
- La communauté Flutter et TensorFlow
- Firebase pour les services backend

---

**Note** : Ce projet combine vision par ordinateur, intelligence artificielle conversationnelle et expérience utilisateur interactive dans une application mobile éducative et démonstrative.
