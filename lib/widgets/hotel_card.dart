import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../models/hotel.dart';
import '../providers/app_provider.dart';
import '../screens/hotel_detail_screen.dart';

class HotelCard extends StatelessWidget {
  final Hotel hotel;

  const HotelCard({Key? key, required this.hotel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HotelDetailScreen(hotel: hotel),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image de l'hôtel avec bouton favori
            Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    color: Colors.grey[300],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: hotel.images.isNotEmpty
                        ? Image.network(
                            hotel.images.first,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: Colors.grey[300],
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: Center(
                                  child: Icon(
                                    Icons.hotel,
                                    size: 50,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(
                            color: Colors.grey[300],
                            child: Center(
                              child: Icon(
                                Icons.hotel,
                                size: 50,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                  ),
                ),
                // Bouton favori
                Positioned(
                  top: 8,
                  right: 8,
                  child: Consumer<AppProvider>(
                    builder: (context, appProvider, child) {
                      final isFavorite = appProvider.isFavorite(hotel.id);
                      return GestureDetector(
                        onTap: () async {
                          await appProvider.toggleFavorite(hotel.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isFavorite
                                    ? 'Retiré des favoris'
                                    : 'Ajouté aux favoris',
                              ),
                              duration: Duration(seconds: 2),
                              backgroundColor: isFavorite
                                  ? Colors.grey.shade700
                                  : Colors.blue.shade600,
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey.shade600,
                            size: 20,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            
            // Informations de l'hôtel
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotel.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${hotel.city}, ${hotel.country}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: hotel.rating,
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 16,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '${hotel.rating} (${hotel.reviewCount} avis)',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          hotel.description,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${hotel.pricePerNight.toStringAsFixed(0)}€',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[600],
                            ),
                          ),
                          Text(
                            'par nuit',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
