# gazaGo Build Requirements

### 1.create models

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 2.install design theme

```bash
npm install -g style-dictionary-figma-flutter
style-dictionary-figma-flutter
```

### build commands Android

```bash
flutter build appbundle --flavor prod -t lib/main_prod.dart
```

### build commands iOS

```bash
flutter build ipa --flavor prod -t lib/main_prod.dart
```

### running commands

```bash
flutter run --flavor dev -t lib/main_dev.dart
flutter run --flavor stage -t lib/main_stage.dart
flutter run --flavor prod -t lib/main_prod.dart
```
