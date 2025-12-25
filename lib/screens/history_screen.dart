import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedSort = 'Plus récent';
  String _searchQuery = '';

  // Historique des réservations passées
  final List<Map<String, dynamic>> history = [
    {
      'id': 'RES004',
      'hotelName': 'Riad Fès Médina',
      'location': 'Fès, Maroc',
      'checkIn': DateTime(2024, 8, 10),
      'checkOut': DateTime(2024, 8, 13),
      'guests': 2,
      'rooms': 1,
      'totalPrice': 240.0,
      'rating': 4.5,
      'image': 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=400',
    },
    {
      'id': 'RES005',
      'hotelName': 'Hotel Atlas Rabat',
      'location': 'Rabat, Maroc',
      'checkIn': DateTime(2024, 6, 15),
      'checkOut': DateTime(2024, 6, 17),
      'guests': 1,
      'rooms': 1,
      'totalPrice': 180.0,
      'rating': 4.2,
      'image': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400',
    },
    {
      'id': 'RES006',
      'hotelName': 'Villa Tanger Bay',
      'location': 'Tanger, Maroc',
      'checkIn': DateTime(2024, 4, 20),
      'checkOut': DateTime(2024, 4, 25),
      'guests': 3,
      'rooms': 2,
      'totalPrice': 450.0,
      'rating': 4.8,
      'image': 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=400',
    },
  ];

  List<Map<String, dynamic>> get filteredHistory {
    var filtered = history.where((reservation) {
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        return reservation['hotelName'].toLowerCase().contains(query) ||
               reservation['location'].toLowerCase().contains(query) ||
               reservation['id'].toLowerCase().contains(query);
      }
      return true;
    }).toList();
    
    // Tri
    filtered.sort((a, b) {
      switch (_selectedSort) {
        case 'Plus récent':
          return b['checkOut'].compareTo(a['checkOut']);
        case 'Plus ancien':
          return a['checkOut'].compareTo(b['checkOut']);
        case 'Prix croissant':
          return a['totalPrice'].compareTo(b['totalPrice']);
        case 'Prix décroissant':
          return b['totalPrice'].compareTo(a['totalPrice']);
        case 'Note':
          return (b['rating'] ?? 0).compareTo(a['rating'] ?? 0);
        default:
          return 0;
      }
    });
    
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = filteredHistory;
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('Historique'),
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
                    hintText: 'Rechercher dans l\'historique...',
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
                          children: ['Plus récent', 'Plus ancien', 'Prix croissant', 'Prix décroissant', 'Note'].map((sort) {
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
          // Liste de l'historique
          Expanded(
            child: filtered.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      return _buildHistoryCard(context, filtered[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: Colors.grey.shade400),
          SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty 
                ? 'Aucun résultat pour "${_searchQuery}"'
                : 'Aucun historique',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Vos réservations passées apparaîtront ici',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, Map<String, dynamic> reservation) {
    final dateFormat = DateFormat('dd MMM yyyy', 'fr_FR');
    
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              image: DecorationImage(
                image: NetworkImage(reservation['image']),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                  ],
                ),
              ),
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: EdgeInsets.all(12),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.done_all, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'TERMINÉE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nom et note
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        reservation['hotelName'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                    if (reservation['rating'] != null)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, size: 16, color: Colors.orange),
                            SizedBox(width: 4),
                            Text(
                              '${reservation['rating']}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4),
                
                // Localisation
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey.shade500),
                    SizedBox(width: 4),
                    Text(
                      reservation['location'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                
                // Dates
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Séjour',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${dateFormat.format(reservation['checkIn'])} - ${dateFormat.format(reservation['checkOut'])}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                
                // Détails et prix
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.people, size: 16, color: Colors.grey.shade500),
                            SizedBox(width: 4),
                            Text(
                              '${reservation['guests']} voyageurs',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.hotel, size: 16, color: Colors.grey.shade500),
                            SizedBox(width: 4),
                            Text(
                              '${reservation['rooms']} chambre(s)',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${reservation['totalPrice'].toStringAsFixed(0)}€',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        Text(
                          reservation['id'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 12),
                
                // Actions
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showReservationDetails(context, reservation),
                        icon: Icon(Icons.visibility, size: 16),
                        label: Text('Voir détails'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showReviewDialog(context, reservation),
                        icon: Icon(Icons.rate_review, size: 16),
                        label: Text('Avis'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showReservationDetails(BuildContext context, Map<String, dynamic> reservation) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Détails du séjour',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildDetailRow('Réservation', reservation['id']),
            _buildDetailRow('Hôtel', reservation['hotelName']),
            _buildDetailRow('Localisation', reservation['location']),
            _buildDetailRow('Arrivée', DateFormat('dd MMMM yyyy', 'fr_FR').format(reservation['checkIn'])),
            _buildDetailRow('Départ', DateFormat('dd MMMM yyyy', 'fr_FR').format(reservation['checkOut'])),
            _buildDetailRow('Voyageurs', '${reservation['guests']} personne(s)'),
            _buildDetailRow('Chambres', '${reservation['rooms']} chambre(s)'),
            _buildDetailRow('Prix payé', '${reservation['totalPrice'].toStringAsFixed(0)}€'),
            if (reservation['rating'] != null)
              _buildDetailRow('Votre note', '${reservation['rating']}/5 ⭐'),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showReviewDialog(BuildContext context, Map<String, dynamic> reservation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Laisser un avis'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Comment était votre séjour à ${reservation['hotelName']} ?'),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) => 
                Icon(Icons.star, color: Colors.orange, size: 32)
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Plus tard'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Merci pour votre avis !')),
              );
            },
            child: Text('Envoyer'),
          ),
        ],
      ),
    );
  }
}
