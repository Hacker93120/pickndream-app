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
      // Ajouter source=mobile pour filtrer seulement les hôtels validés par l'admin
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.hotelsEndpoint}?source=mobile');

      final response = await http
          .get(
            url,
            headers: ApiConstants.defaultHeaders,
          )
          .timeout(const Duration(seconds: 10)); // Timeout réduit

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Convertir les données en objets Hotel
        List<Hotel> hotels = [];
        if (data['hotels'] != null && data['hotels'] is List) {
          hotels = (data['hotels'] as List)
              .map((hotelData) => _convertToHotel(hotelData))
              .where((hotel) => hotel.id.isNotEmpty) // Filtrer les hôtels invalides
              .toList();
        }

        return {
          'success': true,
          'hotels': hotels,
          'count': data['count'] ?? hotels.length,
        };
      } else {
        // Retourner les données d'exemple en cas d'erreur API
        return _getSampleHotels();
      }
    } catch (e) {
      print('Erreur API Hotels: $e');
      // Retourner les données d'exemple en cas d'erreur
      return _getSampleHotels();
    }
  }

  /// Retourner une liste vide si l'API ne répond pas
  Map<String, dynamic> _getSampleHotels() {
    return {
      'success': false,
      'hotels': <Hotel>[],
      'count': 0,
      'message': 'Aucun hôtel disponible',
    };
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
    try {
      return Hotel(
        id: data['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: data['name']?.toString() ?? 'Hôtel',
        description: data['description']?.toString() ?? 'Hôtel confortable',
        address: data['address']?.toString() ?? '',
        city: data['city']?.toString() ?? '',
        country: data['country']?.toString() ?? 'France',
        latitude: _parseDouble(data['latitude']) ?? 48.8566,
        longitude: _parseDouble(data['longitude']) ?? 2.3522,
        rating: _parseDouble(data['rating']) ?? 4.0,
        reviewCount: _parseInt(data['reviewCount']) ?? 0,
        pricePerNight: _parseDouble(data['pricePerNight']) ?? 100.0,
        images: _parseImages(data),
        amenities: _parseAmenities(data),
        isAvailable: data['status'] == 'ACTIVE' || data['isAvailable'] == true,
      );
    } catch (e) {
      print('Erreur conversion hôtel: $e');
      // Retourner un hôtel par défaut en cas d'erreur
      return Hotel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'Hôtel',
        description: 'Hôtel confortable',
        address: '',
        city: '',
        country: 'France',
        latitude: 48.8566,
        longitude: 2.3522,
        rating: 4.0,
        reviewCount: 0,
        pricePerNight: 100.0,
        images: ['https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&q=80'],
        amenities: ['WiFi'],
      );
    }
  }

  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  List<String> _parseImages(Map<String, dynamic> data) {
    // Priorité 1: Tableau de photos uploadées
    if (data['photos'] != null && data['photos'] is List) {
      final photosList = (data['photos'] as List)
          .map((p) => p['url']?.toString() ?? '')
          .where((url) => url.isNotEmpty)
          .toList();
      if (photosList.isNotEmpty) {
        return photosList;
      }
    }

    // Priorité 2: Photo principale (photoUrl)
    if (data['photoUrl'] != null && data['photoUrl'].toString().isNotEmpty) {
      return [data['photoUrl'].toString()];
    }

    // Priorité 3: Tableau d'images (ancien format)
    if (data['images'] != null && data['images'] is List) {
      return List<String>.from(data['images']);
    }

    // Pas de photo par défaut - retourner liste vide
    return [];
  }

  List<String> _parseAmenities(Map<String, dynamic> data) {
    if (data['amenities'] != null && data['amenities'] is List) {
      return List<String>.from(data['amenities']);
    }
    return ['WiFi', 'Climatisation'];
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
      queryParams['source'] = 'mobile'; // Filtrer seulement les hôtels validés
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
