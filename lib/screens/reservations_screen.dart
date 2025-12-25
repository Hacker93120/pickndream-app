import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReservationsScreen extends StatefulWidget {
  @override
  _ReservationsScreenState createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  String _selectedFilter = 'Toutes';
  String _searchQuery = '';

  // Données d'exemple des réservations
  final List<Map<String, dynamic>> reservations = [
    {
      'id': 'RES001',
      'hotelName': 'Hôtel Marrakech Palace',
      'location': 'Marrakech, Maroc',
      'checkIn': DateTime(2024, 12, 15),
      'checkOut': DateTime(2024, 12, 18),
      'guests': 2,
      'rooms': 1,
      'totalPrice': 360.0,
      'status': 'confirmée',
      'image': 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400',
    },
    {
      'id': 'RES002',
      'hotelName': 'Villa Casablanca',
      'location': 'Casablanca, Maroc',
      'checkIn': DateTime(2024, 11, 20),
      'checkOut': DateTime(2024, 11, 22),
      'guests': 1,
      'rooms': 1,
      'totalPrice': 190.0,
      'status': 'terminée',
      'image': 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=400',
    },
    {
      'id': 'RES003',
      'hotelName': 'Resort Agadir Beach',
      'location': 'Agadir, Maroc',
      'checkIn': DateTime(2025, 1, 10),
      'checkOut': DateTime(2025, 1, 15),
      'guests': 4,
      'rooms': 2,
      'totalPrice': 750.0,
      'status': 'à venir',
      'image': 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=400',
    },
  ];

  List<Map<String, dynamic>> get filteredReservations {
    var filtered = reservations.where((reservation) {
      // Filtre par recherche
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!reservation['hotelName'].toLowerCase().contains(query) &&
            !reservation['location'].toLowerCase().contains(query) &&
            !reservation['id'].toLowerCase().contains(query)) {
          return false;
        }
      }
      
      // Filtre par statut
      if (_selectedFilter != 'Toutes') {
        return reservation['status'] == _selectedFilter.toLowerCase();
      }
      
      return true;
    }).toList();
    
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = filteredReservations;
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('Mes Réservations'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Barre de recherche et filtres
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Barre de recherche
                TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Rechercher par hôtel, ville ou numéro...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                SizedBox(height: 12),
                // Filtres par statut
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['Toutes', 'Confirmée', 'À venir', 'Terminée'].map((filter) {
                      final isSelected = _selectedFilter == filter;
                      return Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (selected) => setState(() => _selectedFilter = filter),
                          backgroundColor: Colors.grey.shade100,
                          selectedColor: Colors.blue.shade100,
                          checkmarkColor: Colors.blue.shade600,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          // Liste des réservations
          Expanded(
            child: filtered.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      return _buildReservationCard(context, filtered[index]);
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
          Icon(Icons.hotel_outlined, size: 64, color: Colors.grey.shade400),
          SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty 
                ? 'Aucun résultat pour "${_searchQuery}"'
                : _selectedFilter != 'Toutes'
                    ? 'Aucune réservation ${_selectedFilter.toLowerCase()}'
                    : 'Aucune réservation',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Vos réservations apparaîtront ici',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReservationCard(BuildContext context, Map<String, dynamic> reservation) {
    final dateFormat = DateFormat('dd MMM yyyy', 'fr_FR');
    final status = reservation['status'] as String;
    
    Color statusColor;
    IconData statusIcon;
    
    switch (status) {
      case 'confirmée':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'à venir':
        statusColor = Colors.blue;
        statusIcon = Icons.schedule;
        break;
      case 'terminée':
        statusColor = Colors.grey;
        statusIcon = Icons.done_all;
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
    }

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
          // Image et statut
          Stack(
            children: [
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
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        status.toUpperCase(),
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
            ],
          ),
          
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nom de l'hôtel
                Text(
                  reservation['hotelName'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
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
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Arrivée',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              dateFormat.format(reservation['checkIn']),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward, color: Colors.blue.shade400),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Départ',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              dateFormat.format(reservation['checkOut']),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                
                // Détails de la réservation
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDetailItem(Icons.people, '${reservation['guests']} voyageurs'),
                    _buildDetailItem(Icons.hotel, '${reservation['rooms']} chambre(s)'),
                    _buildDetailItem(Icons.confirmation_number, reservation['id']),
                  ],
                ),
                SizedBox(height: 12),
                
                // Prix et actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${reservation['totalPrice'].toStringAsFixed(0)}€',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade600,
                      ),
                    ),
                    Row(
                      children: [
                        if (status == 'confirmée' || status == 'à venir')
                          OutlinedButton.icon(
                            onPressed: () => _showCancelDialog(context, reservation),
                            icon: Icon(Icons.cancel_outlined, size: 16),
                            label: Text('Annuler'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: BorderSide(color: Colors.red),
                            ),
                          ),
                        SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () => _showReservationDetails(context, reservation),
                          icon: Icon(Icons.visibility, size: 16),
                          label: Text('Détails'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            foregroundColor: Colors.white,
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
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade500),
        SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
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
              'Détails de la réservation',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildDetailRow('Numéro de réservation', reservation['id']),
            _buildDetailRow('Hôtel', reservation['hotelName']),
            _buildDetailRow('Localisation', reservation['location']),
            _buildDetailRow('Arrivée', DateFormat('dd MMMM yyyy', 'fr_FR').format(reservation['checkIn'])),
            _buildDetailRow('Départ', DateFormat('dd MMMM yyyy', 'fr_FR').format(reservation['checkOut'])),
            _buildDetailRow('Voyageurs', '${reservation['guests']} personne(s)'),
            _buildDetailRow('Chambres', '${reservation['rooms']} chambre(s)'),
            _buildDetailRow('Prix total', '${reservation['totalPrice'].toStringAsFixed(0)}€'),
            _buildDetailRow('Statut', reservation['status']),
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

  void _showCancelDialog(BuildContext context, Map<String, dynamic> reservation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Annuler la réservation'),
        content: Text('Êtes-vous sûr de vouloir annuler cette réservation ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Non'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Réservation annulée'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Oui, annuler', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
