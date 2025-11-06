# 🧪 Guide de Test - Intégration Backend Complète

## ✅ Intégration terminée !

Tous les fichiers ont été mis à jour pour utiliser le backend pickndream-dashboard déployé sur Vercel.

---

## 📝 Fichiers modifiés

### 1. **Services créés** (`lib/services/`)
- ✅ `auth_service.dart` - Authentification JWT
- ✅ `hotel_service.dart` - Gestion des hôtels
- ✅ `booking_service.dart` - Gestion des réservations

### 2. **Configuration** (`lib/constants/`)
- ✅ `api_constants.dart` - Configuration API Backend

### 3. **Provider**
- ✅ `lib/providers/app_provider.dart` - Intégration complète des services

### 4. **Écrans mis à jour**
- ✅ `lib/main.dart` - SplashScreen avec vérification auth
- ✅ `lib/screens/login_screen.dart` - Login API
- ✅ `lib/screens/register_screen.dart` - Inscription API
- ✅ `lib/screens/home_screen.dart` - Chargement hôtels API + Pull-to-refresh
- ✅ `lib/screens/hotel_detail_screen.dart` - Création réservation API

---

## 🚀 Lancer l'application

### Étape 1 : Installer les dépendances

```bash
cd /home/pck-inc/pickndream
flutter pub get
```

### Étape 2 : Vérifier la configuration

Ouvrez `lib/constants/api_constants.dart` et vérifiez l'URL :

```dart
static const String baseUrl = 'https://pickndream-dashboard.vercel.app';
```

### Étape 3 : Lancer l'application

```bash
flutter run
```

**Pour Android Emulator** :
```bash
flutter run -d emulator-5554
```

**Pour un appareil physique** :
```bash
flutter devices  # Liste les appareils
flutter run -d <device-id>
```

---

## 🧪 Scénarios de test

### TEST 1 : Vérification du SplashScreen ✅

**Objectif** : Vérifier que l'app vérifie l'auth au démarrage

**Étapes** :
1. Lancez l'application
2. Vous devriez voir le **SplashScreen bleu** avec :
   - Logo hôtel
   - Texte "PicknDream"
   - Indicateur de chargement
3. Après ~1 seconde, redirection automatique :
   - → **LoginScreen** si non connecté
   - → **MainScreen** si déjà connecté

**Résultat attendu** :
- ✅ SplashScreen s'affiche
- ✅ Vérification d'auth effectuée
- ✅ Navigation automatique

---

### TEST 2 : Inscription d'un nouvel utilisateur 📝

**Objectif** : Créer un compte via l'API

**Étapes** :
1. Sur l'écran de login, cliquez sur **"Pas de compte ? S'inscrire"**
2. Remplissez le formulaire :
   - Nom : `Test User`
   - Email : `test@pickndream.com`
   - Mot de passe : `password123`
   - Confirmer : `password123`
3. Cliquez sur **"S'inscrire"**

**Résultat attendu** :
- ✅ Indicateur de chargement s'affiche
- ✅ Compte créé dans la base de données
- ✅ Token JWT reçu et stocké
- ✅ Navigation automatique vers MainScreen
- ✅ Hôtels chargés depuis l'API

**Gestion des erreurs** :
- ❌ Champs vides → "Veuillez remplir tous les champs"
- ❌ Mots de passe différents → "Les mots de passe ne correspondent pas"
- ❌ Email invalide → "Veuillez entrer un email valide"
- ❌ Mot de passe < 6 caractères → Message d'erreur
- ❌ Email déjà utilisé → "Cet email est déjà utilisé"

---

### TEST 3 : Connexion avec un compte existant 🔐

**Objectif** : Se connecter avec un compte existant

**Comptes de test** :
- Email : `admin@pickndream.com` / Mot de passe : `password`
- Email : `jean@example.com` / Mot de passe : `password`
- Email : `test@pickndream.com` / Mot de passe : `password123` (si créé)

**Étapes** :
1. Sur l'écran de login, entrez :
   - Email : `admin@pickndream.com`
   - Mot de passe : `password`
2. Cliquez sur **"Se connecter"**

**Résultat attendu** :
- ✅ Indicateur de chargement s'affiche
- ✅ Authentification réussie
- ✅ Token JWT stocké
- ✅ Navigation vers MainScreen
- ✅ Hôtels chargés depuis l'API
- ✅ Nom d'utilisateur visible (si affiché)

**Gestion des erreurs** :
- ❌ Champs vides → "Veuillez remplir tous les champs"
- ❌ Email/mot de passe incorrect → "Email ou mot de passe incorrect"
- ❌ Erreur réseau → Message d'erreur avec détails

---

### TEST 4 : Chargement des hôtels depuis l'API 🏨

**Objectif** : Vérifier que les hôtels sont chargés depuis le backend

**Étapes** :
1. Une fois connecté, vous êtes sur l'écran d'accueil
2. Observez la liste des hôtels

**Résultat attendu** :
- ✅ Indicateur de chargement pendant la récupération
- ✅ Hôtels affichés depuis la base de données backend
- ✅ Images des hôtels chargées
- ✅ Informations correctes (nom, ville, prix, rating)

**Si aucun hôtel dans la BDD** :
- ⚠️ Message : "Aucun hôtel disponible pour le moment"
- ⚠️ Fallback vers les données d'exemple (optionnel)

---

### TEST 5 : Pull-to-refresh 🔄

**Objectif** : Rafraîchir la liste des hôtels

**Étapes** :
1. Sur l'écran d'accueil
2. Faites glisser vers le bas (pull down) sur la liste
3. Relâchez

**Résultat attendu** :
- ✅ Indicateur de rafraîchissement s'affiche
- ✅ Nouvelle requête API effectuée
- ✅ Liste mise à jour
- ✅ Message d'erreur affiché si échec (avec bouton "Réessayer")

---

### TEST 6 : Recherche d'hôtels 🔍

**Objectif** : Filtrer les hôtels par recherche

**Étapes** :
1. Sur l'écran d'accueil, utilisez la barre de recherche
2. Tapez : `Paris`
3. Observez les résultats

**Résultat attendu** :
- ✅ Filtrage instantané côté client
- ✅ Seuls les hôtels contenant "Paris" sont affichés
- ✅ Titre change en "Résultats de recherche"
- ✅ Bouton "X" pour effacer la recherche

---

### TEST 7 : Filtrage par catégorie 🏷️

**Objectif** : Filtrer les hôtels par catégorie

**Étapes** :
1. Sur l'écran d'accueil, faites défiler le carrousel de catégories
2. Cliquez sur une catégorie (ex: "Luxe", "Famille", "Business")
3. Observez les résultats

**Résultat attendu** :
- ✅ Filtrage instantané
- ✅ Seuls les hôtels de cette catégorie affichés
- ✅ Titre change en "Hôtels [Catégorie]"
- ✅ Compteur du nombre d'hôtels dans la catégorie

---

### TEST 8 : Créer une réservation 📅

**Objectif** : Créer une vraie réservation via l'API

**Prérequis** : Avoir un abonnement actif (ou supprimer cette vérification)

**Étapes** :
1. Cliquez sur un hôtel pour voir les détails
2. Sélectionnez une date de check-in (ex: demain)
3. Sélectionnez une date de check-out (ex: dans 3 jours)
4. Choisissez le nombre d'invités (ex: 2)
5. Cliquez sur **"Réserver maintenant"**

**Résultat attendu** :
- ✅ Vérification : utilisateur connecté
- ✅ Vérification : abonnement actif (si activé)
- ✅ Vérification : dates valides
- ✅ Dialogue de chargement s'affiche
- ✅ Requête POST à `/api/bookings`
- ✅ Réservation créée dans la BDD
- ✅ Message "Réservation confirmée !" (vert)
- ✅ Retour à l'écran précédent

**Gestion des erreurs** :
- ❌ Non connecté → "Vous devez être connecté pour réserver"
- ❌ Pas d'abonnement → "Vous devez avoir un abonnement actif"
- ❌ Dates non sélectionnées → Bouton désactivé
- ❌ Erreur API → Message d'erreur affiché

---

### TEST 9 : Voir mes réservations 📋

**Objectif** : Vérifier que les réservations sont chargées depuis l'API

**Étapes** :
1. Allez dans l'onglet "Profil" (ou "Mes réservations")
2. Observez la liste des réservations

**Résultat attendu** :
- ✅ Réservations chargées depuis `/api/bookings`
- ✅ Informations complètes affichées (hôtel, dates, prix)
- ✅ Statut de la réservation visible
- ⚠️ Si aucune réservation : message approprié

---

### TEST 10 : Déconnexion et persistance 🔓

**Objectif** : Vérifier la gestion de session

**Étapes** :
1. Sur l'écran de profil, cliquez sur **"Déconnexion"**
2. Vous êtes redirigé vers l'écran de login
3. Fermez complètement l'application
4. Relancez l'application

**Résultat attendu après déconnexion** :
- ✅ Token JWT supprimé
- ✅ Données utilisateur effacées
- ✅ Retour à l'écran de login

**Résultat après relance** :
- ✅ SplashScreen s'affiche
- ✅ Redirection vers login (car déconnecté)

---

### TEST 11 : Persistance de session 🔒

**Objectif** : Vérifier que la session persiste

**Étapes** :
1. Connectez-vous avec un compte
2. Fermez complètement l'application
3. Relancez l'application

**Résultat attendu** :
- ✅ SplashScreen s'affiche
- ✅ Token JWT récupéré depuis le stockage
- ✅ Vérification d'authentification réussie
- ✅ Navigation automatique vers MainScreen
- ✅ Hôtels rechargés depuis l'API
- ✅ **Pas besoin de se reconnecter**

---

### TEST 12 : Gestion des erreurs réseau 🌐

**Objectif** : Vérifier le comportement en cas d'erreur

**Simulation** :
1. Mettez votre appareil en **mode avion**
2. Essayez de vous connecter ou de charger les hôtels

**Résultat attendu** :
- ❌ Message d'erreur : "Erreur de connexion: ..."
- ⚠️ Fallback vers les données d'exemple pour les hôtels
- ⚠️ Bouton "Réessayer" disponible
- ⚠️ Pas de crash de l'application

---

## 🔍 Vérifications Backend

### Vérifier que les données sont dans la BDD

Vous pouvez utiliser le dashboard backend pour vérifier :

1. **Ouvrir le dashboard** : https://pickndream-dashboard.vercel.app
2. Se connecter avec un compte admin
3. Vérifier :
   - Nouveaux utilisateurs créés
   - Réservations créées
   - Hôtels disponibles

### Vérifier les API directement

**Test de l'API avec curl** :

```bash
# Récupérer les hôtels
curl https://pickndream-dashboard.vercel.app/api/hotels

# Se connecter
curl -X POST https://pickndream-dashboard.vercel.app/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@pickndream.com","password":"password"}'

# Créer une réservation (avec token)
curl -X POST https://pickndream-dashboard.vercel.app/api/bookings \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <YOUR_TOKEN>" \
  -d '{
    "hotelId": "hotel_id",
    "hotelName": "Hôtel Paris",
    "checkIn": "2025-01-10",
    "checkOut": "2025-01-15",
    "guests": 2,
    "totalPrice": 600
  }'
```

---

## 🐛 Dépannage

### Problème : "Erreur de connexion"

**Solutions** :
1. Vérifier que le backend est actif :
   ```bash
   curl https://pickndream-dashboard.vercel.app/api/hotels
   ```
2. Vérifier la connexion internet de l'appareil
3. Consulter les logs Flutter :
   ```bash
   flutter run -v
   ```

### Problème : "Email ou mot de passe incorrect"

**Solutions** :
1. Utiliser les comptes de test : `admin@pickndream.com` / `password`
2. Créer un nouveau compte via l'inscription
3. Vérifier que le backend a été seedé avec des données

### Problème : Aucun hôtel affiché

**Solutions** :
1. Vérifier que des hôtels existent dans la BDD backend
2. Vérifier les logs de la console Flutter
3. L'app devrait automatiquement charger les données d'exemple en fallback

### Problème : Réservation ne se crée pas

**Solutions** :
1. Vérifier que vous êtes connecté (token présent)
2. Vérifier que vous avez un abonnement actif
3. Consulter les erreurs retournées par l'API
4. Vérifier le format des dates

---

## 📊 Checklist finale

Avant de considérer l'intégration comme réussie, vérifiez :

- [ ] ✅ SplashScreen fonctionne avec vérification auth
- [ ] ✅ Inscription crée un compte dans la BDD
- [ ] ✅ Login authentifie avec le backend
- [ ] ✅ Token JWT stocké et utilisé
- [ ] ✅ Session persiste après fermeture de l'app
- [ ] ✅ Hôtels chargés depuis l'API
- [ ] ✅ Pull-to-refresh rafraîchit les données
- [ ] ✅ Recherche et filtres fonctionnent
- [ ] ✅ Réservation créée via l'API
- [ ] ✅ Réservations listées depuis l'API
- [ ] ✅ Déconnexion supprime le token
- [ ] ✅ Gestion d'erreurs robuste
- [ ] ✅ Messages d'erreur clairs
- [ ] ✅ Pas de crash en cas d'erreur réseau

---

## 🎉 Félicitations !

Si tous les tests passent, votre application Flutter PicknDream est **entièrement intégrée au backend** !

L'application est maintenant capable de :
- ✅ Authentifier des utilisateurs réels
- ✅ Gérer des sessions persistantes
- ✅ Charger des données depuis PostgreSQL
- ✅ Créer des réservations dans la base de données
- ✅ Fonctionner en production

**Prochaines étapes** :
1. Tester sur un appareil physique
2. Ajouter plus de fonctionnalités (profil, paiement, etc.)
3. Optimiser les performances
4. Préparer pour le déploiement (Play Store / App Store)

---

## 📞 Support

En cas de problème :
1. Consultez le fichier `INTEGRATION_BACKEND.md`
2. Vérifiez les logs : `flutter run -v`
3. Testez les endpoints avec `curl`
4. Vérifiez le dashboard Vercel pour les logs backend

Bonne chance ! 🚀
