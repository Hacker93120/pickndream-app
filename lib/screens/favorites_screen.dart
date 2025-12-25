import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/hotel.dart';
import '../utils/translations.dart';
import 'hotel_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  String _selectedSort = 'Ajout récent';
  String _searchQuery = '';

  List<Hotel> get filteredFavorites {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    var filtered = appProvider.favoriteHotels.where((hotel) {
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        return hotel.name.toLowerCase().contains(query) ||
               hotel.city.toLowerCase().contains(query);
      }
      return true;
    }).toList();

    // Tri
    filtered.sort((a, b) {
      switch (_selectedSort) {
        case 'Prix croissant':
          return a.pricePerNight.compareTo(b.pricePerNight);
        case 'Prix décroissant':
          return b.pricePerNight.compareTo(a.pricePerNight);
        case 'Note':
          return b.rating.compareTo(a.rating);
        case 'Nom A-Z':
          return a.name.compareTo(b.name);
        case 'Nom Z-A':
          return b.name.compareTo(a.name);
        default: // Ajout récent
          return 0;
      }
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final filtered = filteredFavorites;

        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            title: Text(Translations.tr(context, 'my_favorites')),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
          body: Column(
            children: [
              // Barre de recherche et tri
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Barre de recherche
                    TextField(
                      onChanged: (value) => setState(() => _searchQuery = value),
                      decoration: InputDecoration(
                        hintText: 'Rechercher dans mes favoris...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                    SizedBox(height: 12),
                    // Options de tri
                    Row(
                      children: [
                        Icon(Icons.sort, color: Colors.grey.shade600),
                        SizedBox(width: 8),
                        Text('Trier par:', style: TextStyle(fontWeight: FontWeight.w500)),
                        SizedBox(width: 12),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: ['Ajout récent', 'Prix croissant', 'Prix décroissant', 'Note', 'Nom A-Z', 'Nom Z-A'].map((sort) {
                                final isSelected = _selectedSort == sort;
                                return Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: FilterChip(
                                    label: Text(sort, style: TextStyle(fontSize: 12)),
                                    selected: isSelected,
                                    onSelected: (selected) => setState(() => _selectedSort = sort),
                                    backgroundColor: Colors.grey.shade100,
                                    selectedColor: Colors.blue.shade100,
                                    checkmarkColor: Colors.blue.shade600,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Grille des favoris
              Expanded(
                child: filtered.isEmpty
                    ? _buildEmptyState()
                    : Padding(
                        padding: EdgeInsets.all(16),
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            return _buildFavoriteCard(filtered[index], appProvider);
                          },
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 64, color: Colors.grey.shade400),
          SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty
                ? 'Aucun favori trouvé pour "${_searchQuery}"'
                : 'Aucun favori',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Ajoutez des hôtels à vos favoris',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteCard(Hotel hotel, AppProvider appProvider) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HotelDetailScreen(hotel: hotel),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                      color: Colors.grey.shade200,
                    ),
                    child: hotel.images.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.network(
                              hotel.images.first,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.hotel, size: 40, color: Colors.grey);
                              },
                            ),
                          )
                        : Icon(Icons.hotel, size: 40, color: Colors.grey),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () async {
                        await appProvider.removeFromFavorites(hotel.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Retiré des favoris'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Infos
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hotel.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 12, color: Colors.grey.shade500),
                        SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            hotel.city,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${hotel.pricePerNight.toStringAsFixed(0)}€/nuit',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade600,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, size: 12, color: Colors.orange),
                            SizedBox(width: 2),
                            Text(
                              '${hotel.rating.toStringAsFixed(1)}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
