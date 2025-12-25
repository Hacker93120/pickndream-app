import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';

/// Service d'authentification pour gérer login, register, logout
class AuthService {
  // Clés pour le stockage local
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';

  /// Connexion de l'utilisateur
  /// Retourne un Map avec les données de l'utilisateur et le token
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.loginEndpoint}');

      final response = await http
          .post(
            url,
            headers: ApiConstants.defaultHeaders,
            body: jsonEncode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: ApiConstants.connectionTimeout));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Sauvegarder le token et les infos utilisateur
        await _saveAuthData(
          token: data['token'] ?? '',
          userId: data['user']?['id']?.toString() ?? '',
          email: data['user']?['email'] ?? '',
          name: data['user']?['name'] ?? '',
        );

        return {
          'success': true,
          'token': data['token'],
          'user': data['user'],
          'message': 'Connexion réussie',
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['error'] ?? 'Email ou mot de passe incorrect',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur de connexion: ${e.toString()}',
      };
    }
  }

  /// Inscription d'un nouvel utilisateur
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.registerEndpoint}');

      final response = await http
          .post(
            url,
            headers: ApiConstants.defaultHeaders,
            body: jsonEncode({
              'name': name,
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: ApiConstants.connectionTimeout));

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Sauvegarder le token et les infos utilisateur
        await _saveAuthData(
          token: data['token'] ?? '',
          userId: data['user']?['id']?.toString() ?? '',
          email: data['user']?['email'] ?? '',
          name: data['user']?['name'] ?? '',
        );

        return {
          'success': true,
          'token': data['token'],
          'user': data['user'],
          'message': 'Inscription réussie',
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['error'] ?? 'Erreur lors de l\'inscription',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur d\'inscription: ${e.toString()}',
      };
    }
  }

  /// Récupérer le profil de l'utilisateur connecté
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final token = await getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Utilisateur non connecté',
        };
      }

      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.profileEndpoint}');

      final response = await http
          .get(
            url,
            headers: ApiConstants.authHeaders(token),
          )
          .timeout(const Duration(seconds: ApiConstants.connectionTimeout));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'user': data['user'],
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de la récupération du profil',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur: ${e.toString()}',
      };
    }
  }

  /// Déconnexion de l'utilisateur
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userNameKey);
  }

  /// Sauvegarder les données d'authentification
  Future<void> _saveAuthData({
    required String token,
    required String userId,
    required String email,
    required String name,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_userEmailKey, email);
    await prefs.setString(_userNameKey, name);
  }

  /// Récupérer le token d'authentification
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Récupérer l'ID de l'utilisateur
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  /// Récupérer l'email de l'utilisateur
  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  /// Récupérer le nom de l'utilisateur
  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  /// Vérifier si l'utilisateur est connecté
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Récupérer toutes les données utilisateur stockées localement
  Future<Map<String, String?>> getUserData() async {
    return {
      'token': await getToken(),
      'userId': await getUserId(),
      'email': await getUserEmail(),
      'name': await getUserName(),
    };
  }
}
