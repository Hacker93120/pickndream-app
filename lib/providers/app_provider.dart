import 'package:flutter/material.dart';
import '../models/hotel.dart';
import '../models/subscription.dart';
import '../models/booking.dart';
import '../services/auth_service.dart';
import '../services/hotel_service.dart';
import '../services/booking_service.dart';
import '../services/favorites_service.dart';
import '../services/firestore_service.dart';

class AppProvider with ChangeNotifier {
  // Services
  final AuthService _authService = AuthService();
  final HotelService _hotelService = HotelService();
  final BookingService _bookingService = BookingService();
  final FavoritesService _favoritesService = FavoritesService();

  // État
  List<Hotel> _hotels = [];
  List<Hotel> _allHotels = []; // Liste complète pour la recherche
  List<Booking> _bookings = [];
  List<String> _favoriteIds = []; // IDs des hôtels favoris
  Subscription? _currentSubscription;
  bool _isLoading = false;
  String _selectedLanguage = 'fr';
  String _searchQuery = '';
  String? _selectedCategory;
  String? _errorMessage;

  // Données utilisateur
  String? _currentUserName;
  String? _currentUserEmail;
  bool _isAuthenticated = false;

  // Constructeur
  AppProvider() {
    // Vérifier l'authentification au démarrage
    checkAuth();
    // Charger les favoris au démarrage
    loadFavorites();
  }

  // Getters
  List<Hotel> get hotels => _hotels;
  List<Booking> get bookings => _bookings;
  List<String> get favoriteIds => _favoriteIds;
  List<Hotel> get favoriteHotels {
    return _allHotels.where((hotel) => _favoriteIds.contains(hotel.id)).toList();
  }
  Subscription? get currentSubscription => _currentSubscription;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String? get selectedCategory => _selectedCategory;
  String? get errorMessage => _errorMessage;
  String? get currentUserName => _currentUserName;
  String? get currentUserEmail => _currentUserEmail;
  bool get isAuthenticated => _isAuthenticated;
  String get selectedLanguage => _selectedLanguage;

  void changeLanguage(String languageCode) {
    _selectedLanguage = languageCode;
    notifyListeners();
  }

  // Vérifier l'authentification au démarrage
  Future<void> checkAuth() async {
    final isLoggedIn = await _authService.isLoggedIn();
    _isAuthenticated = isLoggedIn;
    if (isLoggedIn) {
      final userData = await _authService.getUserData();
      _currentUserName = userData['name'];
      _currentUserEmail = userData['email'];
    }
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  // === MÉTHODES D'AUTHENTIFICATION ===

  /// Connexion utilisateur
  Future<Map<String, dynamic>> login(String email, String password) async {
    setLoading(true);
    setError(null);

    final result = await _authService.login(email: email, password: password);

    if (result['success']) {
      _isAuthenticated = true;
      _currentUserName = result['user']?['name'];
      _currentUserEmail = result['user']?['email'];
      // Charger les hôtels et réservations après connexion
      await loadHotelsFromAPI();
      await loadBookingsFromAPI();
    } else {
      setError(result['message']?.toString() ?? 'Erreur de connexion');
    }

    setLoading(false);
    return result;
  }

  /// Inscription utilisateur
  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    setLoading(true);
    setError(null);

    final result = await _authService.register(
      name: name,
      email: email,
      password: password,
    );

    if (result['success']) {
      _isAuthenticated = true;
      _currentUserName = result['user']?['name'];
      _currentUserEmail = result['user']?['email'];
      // Charger les hôtels après inscription
      await loadHotelsFromAPI();
    } else {
      setError(result['message']?.toString() ?? 'Erreur d\'inscription');
    }

    setLoading(false);
    return result;
  }

  /// Déconnexion
  Future<void> logout() async {
    await _authService.logout();
    _isAuthenticated = false;
    _currentUserName = null;
    _currentUserEmail = null;
    _bookings.clear();
    notifyListeners();
  }

  // === MÉTHODES HÔTELS ===

  /// Charger les hôtels depuis l'API
  Future<void> loadHotelsFromAPI() async {
    if (_isLoading) return;

    setLoading(true);
    setError(null);

    try {
      _allHotels = await FirestoreService.getHotels();
      _hotels = List.from(_allHotels);
      _applyFilters();

      if (_allHotels.isEmpty) {
        print('Info: Aucun hôtel disponible');
      }

    } catch (e) {
      print('Erreur chargement hôtels: $e');
      setError('Erreur de connexion');
      _allHotels = [];
      _hotels = [];
    } finally {
      setLoading(false);
    }
  }

  /// Ne plus charger de données d'exemple - liste vide uniquement
  void loadSampleHotels() {
    _allHotels = [];
    _hotels = [];
    notifyListeners();
  }

  // === MÉTHODES DE FILTRAGE ===

  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = null;
    _hotels = List.from(_allHotels);
    notifyListeners();
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _hotels = _allHotels.where((hotel) {
      // Filtre par recherche
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!hotel.name.toLowerCase().contains(query) &&
            !hotel.city.toLowerCase().contains(query)) {
          return false;
        }
      }

      // Filtre par catégorie
      if (_selectedCategory != null && _selectedCategory!.isNotEmpty) {
        if (!hotel.amenities.any((amenity) => 
            amenity.toLowerCase().contains(_selectedCategory!.toLowerCase()))) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  int getHotelCountForCategory(String category) {
    return _allHotels.where((hotel) => 
        hotel.amenities.any((amenity) => 
            amenity.toLowerCase().contains(category.toLowerCase()))).length;
  }

  void searchHotels(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  // === MÉTHODES ABONNEMENT ===

  void setSubscription(Subscription subscription) {
    _currentSubscription = subscription;
    notifyListeners();
  }

  // === MÉTHODES RÉSERVATIONS ===

  /// Charger les réservations depuis l'API
  Future<void> loadBookingsFromAPI() async {
    if (!_isAuthenticated) return;

    setLoading(true);
    setError(null);

    final result = await _bookingService.getMyBookings();

    if (result['success']) {
      _bookings = result['bookings'] ?? [];
    } else {
      setError(result['message']);
    }

    setLoading(false);
  }

  /// Créer une réservation via l'API
  Future<Map<String, dynamic>> createBooking({
    required String hotelId,
    required String hotelName,
    required DateTime checkIn,
    required DateTime checkOut,
    required int guests,
    required double totalPrice,
  }) async {
    if (!_isAuthenticated) {
      return {
        'success': false,
        'message': 'Vous devez être connecté pour réserver',
      };
    }

    setLoading(true);
    setError(null);

    final result = await _bookingService.createBooking(
      hotelId: hotelId,
      hotelName: hotelName,
      checkIn: checkIn,
      checkOut: checkOut,
      guests: guests,
      totalPrice: totalPrice,
    );

    if (result['success']) {
      // Recharger les réservations
      await loadBookingsFromAPI();
    } else {
      setError(result['message']);
    }

    setLoading(false);
    return result;
  }

  /// Annuler une réservation
  Future<Map<String, dynamic>> cancelBooking(String bookingId) async {
    setLoading(true);
    setError(null);

    final result = await _bookingService.cancelBooking(bookingId);

    if (result['success']) {
      setError(result['message']);
    }

    setLoading(false);
    return result;
  }

  // === MÉTHODES FAVORIS ===

  /// Charger les favoris depuis le stockage local
  Future<void> loadFavorites() async {
    _favoriteIds = await _favoritesService.getFavoriteIds();
    notifyListeners();
  }

  /// Vérifier si un hôtel est en favori
  bool isFavorite(String hotelId) {
    return _favoriteIds.contains(hotelId);
  }

  /// Basculer le statut favori d'un hôtel
  Future<void> toggleFavorite(String hotelId) async {
    final success = await _favoritesService.toggleFavorite(hotelId);

    if (success) {
      await loadFavorites();
    }
  }

  /// Ajouter un hôtel aux favoris
  Future<void> addToFavorites(String hotelId) async {
    final success = await _favoritesService.addFavorite(hotelId);

    if (success) {
      await loadFavorites();
    }
  }

  /// Retirer un hôtel des favoris
  Future<void> removeFromFavorites(String hotelId) async {
    final success = await _favoritesService.removeFavorite(hotelId);

    if (success) {
      await loadFavorites();
    }
  }
}
