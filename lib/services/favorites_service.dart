import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Service pour gérer les favoris de l'utilisateur
class FavoritesService {
  static const String _favoritesKey = 'user_favorites';

  /// Récupérer la liste des IDs d'hôtels favoris
  Future<List<String>> getFavoriteIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getString(_favoritesKey);

      if (favoritesJson == null) {
        return [];
      }

      final List<dynamic> decoded = jsonDecode(favoritesJson);
      return decoded.map((id) => id.toString()).toList();
    } catch (e) {
      print('Erreur getFavoriteIds: $e');
      return [];
    }
  }

  /// Ajouter un hôtel aux favoris
  Future<bool> addFavorite(String hotelId) async {
    try {
      final favoriteIds = await getFavoriteIds();

      if (!favoriteIds.contains(hotelId)) {
        favoriteIds.add(hotelId);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_favoritesKey, jsonEncode(favoriteIds));
        return true;
      }

      return false;
    } catch (e) {
      print('Erreur addFavorite: $e');
      return false;
    }
  }

  /// Retirer un hôtel des favoris
  Future<bool> removeFavorite(String hotelId) async {
    try {
      final favoriteIds = await getFavoriteIds();

      if (favoriteIds.contains(hotelId)) {
        favoriteIds.remove(hotelId);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_favoritesKey, jsonEncode(favoriteIds));
        return true;
      }

      return false;
    } catch (e) {
      print('Erreur removeFavorite: $e');
      return false;
    }
  }

  /// Vérifier si un hôtel est en favori
  Future<bool> isFavorite(String hotelId) async {
    final favoriteIds = await getFavoriteIds();
    return favoriteIds.contains(hotelId);
  }

  /// Basculer le statut favori d'un hôtel
  Future<bool> toggleFavorite(String hotelId) async {
    final isFav = await isFavorite(hotelId);

    if (isFav) {
      return await removeFavorite(hotelId);
    } else {
      return await addFavorite(hotelId);
    }
  }

  /// Effacer tous les favoris
  Future<bool> clearFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_favoritesKey);
      return true;
    } catch (e) {
      print('Erreur clearFavorites: $e');
      return false;
    }
  }
}
