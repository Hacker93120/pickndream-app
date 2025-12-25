import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../models/hotel.dart';
import '../providers/app_provider.dart';
import 'payment_screen.dart';

class HotelDetailScreen extends StatefulWidget {
  final Hotel hotel;

  const HotelDetailScreen({Key? key, required this.hotel}) : super(key: key);

  @override
  _HotelDetailScreenState createState() => _HotelDetailScreenState();
}

class _HotelDetailScreenState extends State<HotelDetailScreen> {
  DateTime? checkInDate;
  DateTime? checkOutDate;
  int guests = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hotel.name),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image principale
            Container(
              height: 250,
              width: double.infinity,
              color: Colors.grey[300],
              child: widget.hotel.images.isNotEmpty
                  ? Image.network(
                      widget.hotel.images.first,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.hotel,
                            size: 80,
                            color: Colors.grey[600],
                          ),
                        );
                      },
                    )
                  : Icon(
                      Icons.hotel,
                      size: 80,
                      color: Colors.grey[600],
                    ),
            ),

            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nom et localisation
                  Text(
                    widget.hotel.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.grey[600], size: 16),
                      SizedBox(width: 4),
                      Text(
                        '${widget.hotel.address}, ${widget.hotel.city}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Rating
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: widget.hotel.rating,
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '${widget.hotel.rating} (${widget.hotel.reviewCount} avis)',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Description
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.hotel.description,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  SizedBox(height: 16),

                  // Équipements
                  Text(
                    'Équipements',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.hotel.amenities.map((amenity) {
                      return Chip(
                        label: Text(amenity),
                        backgroundColor: Colors.blue[50],
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 24),

                  // Sélection des dates
                  Text(
                    'Réservation',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectDate(context, true),
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Arrivée', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                Text(
                                  checkInDate != null 
                                      ? '${checkInDate!.day}/${checkInDate!.month}/${checkInDate!.year}'
                                      : 'Sélectionner',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectDate(context, false),
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Départ', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                Text(
                                  checkOutDate != null 
                                      ? '${checkOutDate!.day}/${checkOutDate!.month}/${checkOutDate!.year}'
                                      : 'Sélectionner',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Nombre d'invités
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Nombre d\'invités'),
                      Row(
                        children: [
                          IconButton(
                            onPressed: guests > 1 ? () => setState(() => guests--) : null,
                            icon: Icon(Icons.remove),
                          ),
                          Text('$guests'),
                          IconButton(
                            onPressed: () => setState(() => guests++),
                            icon: Icon(Icons.add),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Prix et bouton de réservation
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Prix par nuit'),
                            Text(
                              '${widget.hotel.pricePerNight.toStringAsFixed(0)}€',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        if (checkInDate != null && checkOutDate != null) ...[
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total (${checkOutDate!.difference(checkInDate!).inDays} nuits)'),
                              Text(
                                '${(widget.hotel.pricePerNight * checkOutDate!.difference(checkInDate!).inDays).toStringAsFixed(0)}€',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.blue[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                        SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _canBook() ? _bookHotel : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[600],
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Réserver maintenant',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          checkInDate = picked;
          if (checkOutDate != null && checkOutDate!.isBefore(picked)) {
            checkOutDate = null;
          }
        } else {
          if (checkInDate != null && picked.isAfter(checkInDate!)) {
            checkOutDate = picked;
          }
        }
      });
    }
  }

  bool _canBook() {
    return checkInDate != null && checkOutDate != null;
  }

  Future<void> _bookHotel() async {
    final provider = context.read<AppProvider>();

    // Vérifier que l'utilisateur est connecté
    if (!provider.isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vous devez être connecté pour réserver'),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Se connecter',
            textColor: Colors.white,
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
        ),
      );
      return;
    }

    // Calculer le prix total
    final nights = checkOutDate!.difference(checkInDate!).inDays;
    final totalPrice = widget.hotel.pricePerNight * nights;

    // Rediriger vers l'écran de paiement
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          hotel: widget.hotel,
          checkInDate: checkInDate!,
          checkOutDate: checkOutDate!,
          guests: guests,
          totalPrice: totalPrice,
        ),
      ),
    );
  }
}
