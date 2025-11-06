import 'package:flutter/material.dart';
import '../models/hotel.dart';
import '../models/subscription.dart';
import '../models/booking.dart';
import '../services/auth_service.dart';
import '../services/hotel_service.dart';
import '../services/booking_service.dart';

class AppProvider with ChangeNotifier {
  // Services
  final AuthService _authService = AuthService();
  final HotelService _hotelService = HotelService();
  final BookingService _bookingService = BookingService();

  // État
  List<Hotel> _hotels = [];
  List<Hotel> _allHotels = []; // Liste complète pour la recherche
  List<Booking> _bookings = [];
  Subscription? _currentSubscription;
  bool _isLoading = false;
  String _searchQuery = '';
  String? _selectedCategory;
  String? _errorMessage;

  // Données utilisateur
  String? _currentUserName;
  String? _currentUserEmail;
  bool _isAuthenticated = false;

  // Getters
  List<Hotel> get hotels => _hotels;
  List<Booking> get bookings => _bookings;
  Subscription? get currentSubscription => _currentSubscription;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String? get selectedCategory => _selectedCategory;
  String? get errorMessage => _errorMessage;
  String? get currentUserName => _currentUserName;
  String? get currentUserEmail => _currentUserEmail;
  bool get isAuthenticated => _isAuthenticated;

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
      setError(result['message']);
    }

    setLoading(false);
    return result;
  }

  /// Inscription utilisateur
  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    setLoading(true);
    setError(null);

    final result = await _authService.register(name: name, email: email, password: password);

    if (result['success']) {
      _isAuthenticated = true;
      _currentUserName = result['user']?['name'];
      _currentUserEmail = result['user']?['email'];
      // Charger les hôtels après inscription
      await loadHotelsFromAPI();
    } else {
      setError(result['message']);
    }

    setLoading(false);
    return result;
  }

  /// Déconnexion utilisateur
  Future<void> logout() async {
    await _authService.logout();
    _isAuthenticated = false;
    _currentUserName = null;
    _currentUserEmail = null;
    _bookings = [];
    notifyListeners();
  }

  // === MÉTHODES HOTELS ===

  /// Charger les hôtels depuis l'API
  Future<void> loadHotelsFromAPI() async {
    setLoading(true);
    setError(null);

    final result = await _hotelService.getHotels();

    if (result['success']) {
      _allHotels = result['hotels'] ?? [];
      _hotels = List.from(_allHotels);
      _applyFilters();
    } else {
      setError(result['message']);
      // En cas d'erreur, charger les données d'exemple
      loadSampleHotels();
    }

    setLoading(false);
  }

  /// Charger les données d'exemple (fallback)
  void loadSampleHotels() {
    _allHotels = [
      Hotel(
        id: '1',
        name: 'Hôtel de Luxe Paris',
        description: 'Un magnifique hôtel au cœur de Paris avec vue sur la Tour Eiffel',
        address: '123 Rue de Rivoli',
        city: 'Paris',
        country: 'France',
        latitude: 48.8566,
        longitude: 2.3522,
        rating: 4.8,
        reviewCount: 245,
        pricePerNight: 250.0,
        images: ['https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&q=80'],
        amenities: ['WiFi', 'Piscine', 'Spa', 'Restaurant', 'Luxe'],
      ),
      Hotel(
        id: '2',
        name: 'Boutique Hotel Barcelona',
        description: 'Hôtel moderne près de la Sagrada Familia',
        address: 'Carrer de Mallorca 401',
        city: 'Barcelona',
        country: 'Espagne',
        latitude: 41.4036,
        longitude: 2.1744,
        rating: 4.6,
        reviewCount: 189,
        pricePerNight: 120.0,
        images: ['https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=800&q=80'],
        amenities: ['WiFi', 'Climatisation', 'Bar', 'Business'],
      ),
      Hotel(
        id: '3',
        name: 'Family Resort Nice',
        description: 'Complexe familial en bord de mer avec activités pour enfants',
        address: '15 Promenade des Anglais',
        city: 'Nice',
        country: 'France',
        latitude: 43.6961,
        longitude: 7.2659,
        rating: 4.5,
        reviewCount: 312,
        pricePerNight: 180.0,
        images: ['https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800&q=80'],
        amenities: ['WiFi', 'Piscine', 'Club enfants', 'Restaurant', 'Famille', 'Plage'],
      ),
      Hotel(
        id: '4',
        name: 'Romantic Château Loire',
        description: 'Château romantique dans la vallée de la Loire',
        address: 'Route des Châteaux',
        city: 'Tours',
        country: 'France',
        latitude: 47.3941,
        longitude: 0.6848,
        rating: 4.9,
        reviewCount: 156,
        pricePerNight: 320.0,
        images: ['https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=800&q=80'],
        amenities: ['WiFi', 'Restaurant gastronomique', 'Jardin', 'Spa', 'Romantique', 'Luxe'],
      ),
      Hotel(
        id: '5',
        name: 'Beach Hotel Biarritz',
        description: 'Hôtel de plage avec vue océan et accès direct à la plage',
        address: 'Avenue de la Plage',
        city: 'Biarritz',
        country: 'France',
        latitude: 43.4832,
        longitude: -1.5586,
        rating: 4.7,
        reviewCount: 278,
        pricePerNight: 195.0,
        images: ['https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800&q=80'],
        amenities: ['WiFi', 'Accès plage', 'Surf', 'Restaurant', 'Plage'],
      ),
      Hotel(
        id: '6',
        name: 'Business Center Brussels',
        description: 'Hôtel d\'affaires moderne au centre de Bruxelles',
        address: 'Avenue Louise 250',
        city: 'Brussels',
        country: 'Belgique',
        latitude: 50.8371,
        longitude: 4.3676,
        rating: 4.4,
        reviewCount: 421,
        pricePerNight: 145.0,
        images: ['https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=800&q=80'],
        amenities: ['WiFi', 'Salle de réunion', 'Business center', 'Restaurant', 'Business'],
      ),
      Hotel(
        id: '7',
        name: 'Spa Wellness Alsace',
        description: 'Centre de bien-être avec spa thermal et massages',
        address: 'Route des Vins',
        city: 'Colmar',
        country: 'France',
        latitude: 48.0776,
        longitude: 7.3579,
        rating: 4.8,
        reviewCount: 198,
        pricePerNight: 210.0,
        images: ['https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=800&q=80'],
        amenities: ['WiFi', 'Spa', 'Hammam', 'Massages', 'Restaurant', 'Spa'],
      ),
      Hotel(
        id: '8',
        name: 'Grand Luxe Monaco',
        description: 'Palace 5 étoiles avec casino et vue sur le port',
        address: 'Avenue Monte Carlo',
        city: 'Monaco',
        country: 'Monaco',
        latitude: 43.7384,
        longitude: 7.4246,
        rating: 5.0,
        reviewCount: 512,
        pricePerNight: 580.0,
        images: ['https://images.unsplash.com/photo-1549294413-26f195200c16?w=800&q=80'],
        amenities: ['WiFi', 'Casino', 'Spa', 'Restaurant étoilé', 'Piscine', 'Luxe'],
      ),
    ];
    _hotels = List.from(_allHotels);
    notifyListeners();
  }

  // Recherche d'hôtels par nom, ville ou pays
  void searchHotels(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  // Filtrer par catégorie
  void filterByCategory(String? category) {
    _selectedCategory = category;
    _applyFilters();
  }

  // Réinitialiser les filtres
  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = null;
    _hotels = List.from(_allHotels);
    notifyListeners();
  }

  // Appliquer tous les filtres
  void _applyFilters() {
    _hotels = _allHotels.where((hotel) {
      // Filtre de recherche
      bool matchesSearch = true;
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        matchesSearch = hotel.name.toLowerCase().contains(query) ||
            hotel.city.toLowerCase().contains(query) ||
            hotel.country.toLowerCase().contains(query) ||
            hotel.description.toLowerCase().contains(query);
      }

      // Filtre de catégorie
      bool matchesCategory = true;
      if (_selectedCategory != null && _selectedCategory!.isNotEmpty) {
        matchesCategory = hotel.amenities.any(
          (amenity) => amenity.toLowerCase() == _selectedCategory!.toLowerCase()
        );
      }

      return matchesSearch && matchesCategory;
    }).toList();

    notifyListeners();
  }

  // Compter le nombre d'hôtels par catégorie
  int getHotelCountForCategory(String category) {
    return _allHotels.where((hotel) {
      return hotel.amenities.any(
        (amenity) => amenity.toLowerCase() == category.toLowerCase()
      );
    }).length;
  }

  void setSubscription(Subscription subscription) {
    _currentSubscription = subscription.copyWith(
      isActive: true,
      expiryDate: DateTime.now().add(Duration(days: 30)),
    );
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
      // Recharger les réservations
      await loadBookingsFromAPI();
    } else {
      setError(result['message']);
    }

    setLoading(false);
    return result;
  }

  /// Ajouter une réservation localement (pour compatibilité)
  void addBooking(Booking booking) {
    _bookings.add(booking);
    notifyListeners();
  }
}

extension SubscriptionCopy on Subscription {
  Subscription copyWith({
    SubscriptionType? type,
    String? name,
    double? price,
    List<String>? features,
    bool? isActive,
    DateTime? expiryDate,
  }) {
    return Subscription(
      type: type ?? this.type,
      name: name ?? this.name,
      price: price ?? this.price,
      features: features ?? this.features,
      isActive: isActive ?? this.isActive,
      expiryDate: expiryDate ?? this.expiryDate,
    );
  }
}
