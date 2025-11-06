import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../models/hotel.dart';
import 'auth_service.dart';

/// Service pour gérer les hôtels
class HotelService {
  final AuthService _authService = AuthService();

  /// Récupérer la liste de tous les hôtels
  Future<Map<String, dynamic>> getHotels() async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.hotelsEndpoint}');

      final response = await http
          .get(
            url,
            headers: ApiConstants.defaultHeaders,
          )
          .timeout(const Duration(seconds: ApiConstants.connectionTimeout));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Convertir les données en objets Hotel
        List<Hotel> hotels = [];
        if (data['hotels'] != null && data['hotels'] is List) {
          hotels = (data['hotels'] as List)
              .map((hotelData) => _convertToHotel(hotelData))
              .toList();
        }

        return {
          'success': true,
          'hotels': hotels,
          'count': data['count'] ?? hotels.length,
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de la récupération des hôtels',
          'hotels': <Hotel>[],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur de connexion: ${e.toString()}',
        'hotels': <Hotel>[],
      };
    }
  }

  /// Récupérer un hôtel spécifique par ID
  Future<Map<String, dynamic>> getHotelById(String hotelId) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.hotelsEndpoint}/$hotelId');

      final response = await http
          .get(
            url,
            headers: ApiConstants.defaultHeaders,
          )
          .timeout(const Duration(seconds: ApiConstants.connectionTimeout));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final hotel = _convertToHotel(data['hotel']);

        return {
          'success': true,
          'hotel': hotel,
        };
      } else {
        return {
          'success': false,
          'message': 'Hôtel non trouvé',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur: ${e.toString()}',
      };
    }
  }

  /// Créer un nouvel hôtel (admin uniquement)
  Future<Map<String, dynamic>> createHotel({
    required String name,
    required String description,
    required String city,
    required String country,
    required double price,
    required String imageUrl,
    required double rating,
    required List<String> amenities,
    String category = 'Hôtel',
    double? latitude,
    double? longitude,
  }) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Vous devez être connecté',
        };
      }

      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.hotelsEndpoint}');

      final response = await http
          .post(
            url,
            headers: ApiConstants.authHeaders(token),
            body: jsonEncode({
              'name': name,
              'description': description,
              'city': city,
              'country': country,
              'price': price,
              'imageUrl': imageUrl,
              'rating': rating,
              'amenities': amenities,
              'category': category,
              if (latitude != null) 'latitude': latitude,
              if (longitude != null) 'longitude': longitude,
            }),
          )
          .timeout(const Duration(seconds: ApiConstants.connectionTimeout));

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final hotel = _convertToHotel(data['hotel']);

        return {
          'success': true,
          'hotel': hotel,
          'message': 'Hôtel créé avec succès',
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['error'] ?? 'Erreur lors de la création de l\'hôtel',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur: ${e.toString()}',
      };
    }
  }

  /// Convertir les données JSON de l'API en objet Hotel Flutter
  Hotel _convertToHotel(Map<String, dynamic> data) {
    // Mapper les données du backend vers le modèle Flutter
    // Backend: id, name, description, city, address, country, rating, pricePerNight, photoUrl
    // Flutter: id, name, description, address, city, country, latitude, longitude, rating, reviewCount, pricePerNight, images, amenities, isAvailable

    return Hotel(
      id: data['id']?.toString() ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? 'Hôtel confortable',
      address: data['address'] ?? '',
      city: data['city'] ?? '',
      country: data['country'] ?? 'France',
      // Coordonnées par défaut (Paris) - À améliorer avec un service de géocodage
      latitude: data['latitude'] ?? 48.8566,
      longitude: data['longitude'] ?? 2.3522,
      rating: (data['rating'] is int)
          ? (data['rating'] as int).toDouble()
          : (data['rating'] ?? 0.0),
      reviewCount: data['reviewCount'] ?? 0,
      pricePerNight: (data['pricePerNight'] is int)
          ? (data['pricePerNight'] as int).toDouble()
          : (data['pricePerNight'] ?? 0.0),
      // Convertir photoUrl (string) en images (list)
      images: data['photoUrl'] != null
          ? [data['photoUrl']]
          : data['photos'] != null
              ? List<String>.from(data['photos'].map((p) => p['url'] ?? ''))
              : ['https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&q=80'],
      // Amenities par défaut basés sur le type d'hôtel
      amenities: data['amenities'] != null
          ? List<String>.from(data['amenities'])
          : ['WiFi', 'Climatisation'],
      isAvailable: data['status'] == 'ACTIVE' || data['isAvailable'] == true,
    );
  }

  /// Rechercher des hôtels par critères
  Future<Map<String, dynamic>> searchHotels({
    String? query,
    String? category,
    double? minPrice,
    double? maxPrice,
    String? city,
  }) async {
    try {
      // Construction de l'URL avec les paramètres de recherche
      final queryParams = <String, String>{};
      if (query != null && query.isNotEmpty) queryParams['q'] = query;
      if (category != null && category.isNotEmpty) queryParams['category'] = category;
      if (minPrice != null) queryParams['minPrice'] = minPrice.toString();
      if (maxPrice != null) queryParams['maxPrice'] = maxPrice.toString();
      if (city != null && city.isNotEmpty) queryParams['city'] = city;

      final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.hotelsEndpoint}')
          .replace(queryParameters: queryParams);

      final response = await http
          .get(
            uri,
            headers: ApiConstants.defaultHeaders,
          )
          .timeout(const Duration(seconds: ApiConstants.connectionTimeout));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        List<Hotel> hotels = [];
        if (data['hotels'] != null && data['hotels'] is List) {
          hotels = (data['hotels'] as List)
              .map((hotelData) => _convertToHotel(hotelData))
              .toList();
        }

        return {
          'success': true,
          'hotels': hotels,
          'count': data['count'] ?? hotels.length,
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de la recherche',
          'hotels': <Hotel>[],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur: ${e.toString()}',
        'hotels': <Hotel>[],
      };
    }
  }
}
