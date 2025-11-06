import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../models/booking.dart';
import '../models/hotel.dart';
import 'auth_service.dart';
import 'hotel_service.dart';

/// Service pour gérer les réservations
class BookingService {
  final AuthService _authService = AuthService();
  final HotelService _hotelService = HotelService();

  /// Créer une nouvelle réservation
  Future<Map<String, dynamic>> createBooking({
    required String hotelId,
    required String hotelName,
    required DateTime checkIn,
    required DateTime checkOut,
    required int guests,
    required double totalPrice,
  }) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Vous devez être connecté pour réserver',
        };
      }

      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.bookingsEndpoint}');

      final response = await http
          .post(
            url,
            headers: ApiConstants.authHeaders(token),
            body: jsonEncode({
              'hotelId': hotelId,
              'hotelName': hotelName,
              'checkIn': checkIn.toIso8601String(),
              'checkOut': checkOut.toIso8601String(),
              'guests': guests,
              'totalPrice': totalPrice,
              'status': 'confirmed',
            }),
          )
          .timeout(const Duration(seconds: ApiConstants.connectionTimeout));

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final booking = _convertToBooking(data['booking']);

        return {
          'success': true,
          'booking': booking,
          'message': 'Réservation créée avec succès',
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['error'] ?? 'Erreur lors de la réservation',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur de réservation: ${e.toString()}',
      };
    }
  }

  /// Récupérer toutes les réservations de l'utilisateur connecté
  Future<Map<String, dynamic>> getMyBookings() async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Vous devez être connecté',
          'bookings': <Booking>[],
        };
      }

      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.bookingsEndpoint}');

      final response = await http
          .get(
            url,
            headers: ApiConstants.authHeaders(token),
          )
          .timeout(const Duration(seconds: ApiConstants.connectionTimeout));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        List<Booking> bookings = [];
        if (data['bookings'] != null && data['bookings'] is List) {
          bookings = (data['bookings'] as List)
              .map((bookingData) => _convertToBooking(bookingData))
              .toList();
        }

        return {
          'success': true,
          'bookings': bookings,
          'count': data['count'] ?? bookings.length,
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de la récupération des réservations',
          'bookings': <Booking>[],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur: ${e.toString()}',
        'bookings': <Booking>[],
      };
    }
  }

  /// Récupérer une réservation spécifique par ID
  Future<Map<String, dynamic>> getBookingById(String bookingId) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Vous devez être connecté',
        };
      }

      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.bookingsEndpoint}/$bookingId');

      final response = await http
          .get(
            url,
            headers: ApiConstants.authHeaders(token),
          )
          .timeout(const Duration(seconds: ApiConstants.connectionTimeout));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final booking = _convertToBooking(data['booking']);

        return {
          'success': true,
          'booking': booking,
        };
      } else {
        return {
          'success': false,
          'message': 'Réservation non trouvée',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur: ${e.toString()}',
      };
    }
  }

  /// Annuler une réservation
  Future<Map<String, dynamic>> cancelBooking(String bookingId) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Vous devez être connecté',
        };
      }

      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.bookingsEndpoint}/$bookingId');

      final response = await http
          .delete(
            url,
            headers: ApiConstants.authHeaders(token),
          )
          .timeout(const Duration(seconds: ApiConstants.connectionTimeout));

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Réservation annulée avec succès',
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['error'] ?? 'Erreur lors de l\'annulation',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur: ${e.toString()}',
      };
    }
  }

  /// Convertir les données JSON en objet Booking
  /// Note: Cette méthode nécessite que les données incluent l'objet hotel complet
  Booking _convertToBooking(Map<String, dynamic> data) {
    // Extraire les données de l'hôtel du booking
    Hotel hotel;
    if (data['hotel'] != null) {
      // Si l'API retourne l'objet hotel complet
      hotel = _convertToHotel(data['hotel']);
    } else {
      // Sinon, créer un hotel basique avec les infos disponibles
      hotel = Hotel(
        id: data['hotelId']?.toString() ?? '',
        name: data['hotelName'] ?? 'Hôtel',
        description: 'Hôtel',
        address: '',
        city: '',
        country: 'France',
        latitude: 48.8566,
        longitude: 2.3522,
        rating: 0.0,
        reviewCount: 0,
        pricePerNight: 0.0,
        images: ['https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&q=80'],
        amenities: ['WiFi'],
        isAvailable: true,
      );
    }

    // Convertir le status string en BookingStatus enum
    BookingStatus status = BookingStatus.pending;
    if (data['status'] != null) {
      switch (data['status'].toString().toUpperCase()) {
        case 'PENDING':
          status = BookingStatus.pending;
          break;
        case 'CONFIRMED':
          status = BookingStatus.confirmed;
          break;
        case 'CANCELLED':
          status = BookingStatus.cancelled;
          break;
        case 'COMPLETED':
          status = BookingStatus.completed;
          break;
      }
    }

    // Récupérer les infos utilisateur
    final userName = data['user']?['name'] ?? data['guestName'] ?? 'Guest';
    final userEmail = data['user']?['email'] ?? data['guestEmail'] ?? 'guest@example.com';

    return Booking(
      id: data['id']?.toString() ?? '',
      hotel: hotel,
      checkIn: data['checkIn'] != null
          ? DateTime.parse(data['checkIn'])
          : DateTime.now(),
      checkOut: data['checkOut'] != null
          ? DateTime.parse(data['checkOut'])
          : DateTime.now().add(const Duration(days: 1)),
      guests: data['guests'] ?? 1,
      totalPrice: (data['totalPrice'] is int)
          ? (data['totalPrice'] as int).toDouble()
          : (data['totalPrice'] ?? 0.0),
      status: status,
      bookingDate: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'])
          : DateTime.now(),
      guestName: userName,
      guestEmail: userEmail,
    );
  }

  /// Convertir les données JSON de l'API en objet Hotel
  /// (Copie de HotelService pour éviter la dépendance circulaire)
  Hotel _convertToHotel(Map<String, dynamic> data) {
    return Hotel(
      id: data['id']?.toString() ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? 'Hôtel confortable',
      address: data['address'] ?? '',
      city: data['city'] ?? '',
      country: data['country'] ?? 'France',
      latitude: data['latitude'] ?? 48.8566,
      longitude: data['longitude'] ?? 2.3522,
      rating: (data['rating'] is int)
          ? (data['rating'] as int).toDouble()
          : (data['rating'] ?? 0.0),
      reviewCount: data['reviewCount'] ?? 0,
      pricePerNight: (data['pricePerNight'] is int)
          ? (data['pricePerNight'] as int).toDouble()
          : (data['pricePerNight'] ?? 0.0),
      images: data['photoUrl'] != null
          ? [data['photoUrl']]
          : data['photos'] != null
              ? List<String>.from(data['photos'].map((p) => p['url'] ?? ''))
              : ['https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&q=80'],
      amenities: data['amenities'] != null
          ? List<String>.from(data['amenities'])
          : ['WiFi', 'Climatisation'],
      isAvailable: data['status'] == 'ACTIVE' || data['isAvailable'] == true,
    );
  }
}
