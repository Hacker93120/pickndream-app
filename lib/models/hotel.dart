class Hotel {
  final String id;
  final String name;
  final String description;
  final String address;
  final String city;
  final String country;
  final double latitude;
  final double longitude;
  final double rating;
  final int reviewCount;
  final double pricePerNight;
  final List<String> images;
  final List<String> amenities;
  final bool isAvailable;

  Hotel({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.city,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.reviewCount,
    required this.pricePerNight,
    required this.images,
    required this.amenities,
    this.isAvailable = true,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      address: json['address'],
      city: json['city'],
      country: json['country'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      rating: json['rating'].toDouble(),
      reviewCount: json['reviewCount'],
      pricePerNight: json['pricePerNight'].toDouble(),
      images: List<String>.from(json['images']),
      amenities: List<String>.from(json['amenities']),
      isAvailable: json['isAvailable'] ?? true,
    );
  }
}
