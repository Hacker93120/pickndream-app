# Recommandations Debug - PicknDream App

## Problèmes identifiés

### 1. Performance - Thread principal surchargé
- **Symptôme**: "Skipped 43 frames"
- **Solution**: Déplacer les opérations lourdes vers des isolates Flutter

### 2. Gestion du clavier virtuel
- **Symptôme**: Appels répétitifs à showSoftInput()
- **Solution**: Vérifier la logique de focus des TextFields

## Actions recommandées

### Performance
```dart
// Utiliser des isolates pour les opérations lourdes
import 'dart:isolate';

Future<void> heavyOperation() async {
  await Isolate.spawn(backgroundTask, data);
}
```

### Clavier virtuel
```dart
// Gérer correctement le focus
FocusScope.of(context).unfocus();
```

### Monitoring
- Utiliser Flutter Inspector
- Profiler les performances avec `flutter run --profile`
- Vérifier les fuites mémoire
