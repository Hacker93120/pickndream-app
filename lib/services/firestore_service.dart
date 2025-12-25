import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/hotel.dart';

class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<List<Hotel>> getHotels() async {
    // Récupérer uniquement les hôtels acceptés (status = ACTIVE)
    final snapshot = await _db
        .collection('hotels')
        .where('status', isEqualTo: 'ACTIVE')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      // Construire la liste d'images à partir de photoUrl
      List<String> images = [];
      if (data['photoUrl'] != null && data['photoUrl'].toString().isNotEmpty) {
        images.add(data['photoUrl']);
      }
      // Ajouter les autres images si elles existent
      if (data['images'] != null) {
        images.addAll(List<String>.from(data['images']));
      }

      return Hotel(
        id: doc.id,
        name: data['name'] ?? '',
        description: data['description'] ?? '',
        address: data['address'] ?? '',
        city: data['city'] ?? '',
        country: data['country'] ?? '',
        pricePerNight: (data['pricePerNight'] ?? 0).toDouble(),
        rating: (data['rating'] ?? 0).toDouble(),
        reviewCount: data['reviewCount'] ?? 0,
        images: images,
        latitude: (data['latitude'] ?? 0).toDouble(),
        longitude: (data['longitude'] ?? 0).toDouble(),
        amenities: List<String>.from(data['amenities'] ?? []),
        isAvailable: data['isAvailable'] ?? true,
      );
    }).toList();
  }

  static Stream<List<Hotel>> getHotelsStream() {
    // Stream temps réel des hôtels acceptés uniquement
    return _db
        .collection('hotels')
        .where('status', isEqualTo: 'ACTIVE')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        // Construire la liste d'images à partir de photoUrl
        List<String> images = [];
        if (data['photoUrl'] != null && data['photoUrl'].toString().isNotEmpty) {
          images.add(data['photoUrl']);
        }
        // Ajouter les autres images si elles existent
        if (data['images'] != null) {
          images.addAll(List<String>.from(data['images']));
        }

        return Hotel(
          id: doc.id,
          name: data['name'] ?? '',
          description: data['description'] ?? '',
          address: data['address'] ?? '',
          city: data['city'] ?? '',
          country: data['country'] ?? '',
          pricePerNight: (data['pricePerNight'] ?? 0).toDouble(),
          rating: (data['rating'] ?? 0).toDouble(),
          reviewCount: data['reviewCount'] ?? 0,
          images: images,
          latitude: (data['latitude'] ?? 0).toDouble(),
          longitude: (data['longitude'] ?? 0).toDouble(),
          amenities: List<String>.from(data['amenities'] ?? []),
          isAvailable: data['isAvailable'] ?? true,
        );
      }).toList();
    });
  }
}
