import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class DateSelectionScreen extends StatefulWidget {
  final String selectedCity;

  const DateSelectionScreen({Key? key, required this.selectedCity}) : super(key: key);

  @override
  _DateSelectionScreenState createState() => _DateSelectionScreenState();
}

class _DateSelectionScreenState extends State<DateSelectionScreen> {
  DateTime? checkInDate;
  DateTime? checkOutDate;
  int adults = 2;
  int children = 0;
  int babies = 0;
  int pets = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Réserver à ${widget.selectedCity}'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Destination sélectionnée
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_city, color: Colors.blue.shade600),
                  SizedBox(width: 12),
                  Text(
                    'Destination: ${widget.selectedCity}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // Sélection des dates
            Text(
              'Sélectionnez vos dates',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            
            SizedBox(height: 16),
            
            // Date d'arrivée
            GestureDetector(
              onTap: () => _selectCheckInDate(context),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.blue.shade600),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Date d\'arrivée', style: TextStyle(color: Colors.grey.shade600)),
                          Text(
                            checkInDate != null 
                                ? '${checkInDate!.day}/${checkInDate!.month}/${checkInDate!.year}'
                                : 'Sélectionner une date',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 16),
            
            // Date de départ
            GestureDetector(
              onTap: checkInDate != null ? () => _selectCheckOutDate(context) : null,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: checkInDate != null ? Colors.grey.shade300 : Colors.grey.shade200,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today, 
                      color: checkInDate != null ? Colors.blue.shade600 : Colors.grey.shade400,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date de départ', 
                            style: TextStyle(
                              color: checkInDate != null ? Colors.grey.shade600 : Colors.grey.shade400,
                            ),
                          ),
                          Text(
                            checkOutDate != null 
                                ? '${checkOutDate!.day}/${checkOutDate!.month}/${checkOutDate!.year}'
                                : 'Sélectionner une date',
                            style: TextStyle(
                              fontSize: 16, 
                              fontWeight: FontWeight.w500,
                              color: checkInDate != null ? Colors.black : Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 24),
            
            // Sélection des voyageurs
            Text(
              'Voyageurs',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            
            SizedBox(height: 16),
            
            // Adultes
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.person, color: Colors.blue.shade600),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Adultes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        Text('13 ans et plus', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: adults > 1 ? () => setState(() => adults--) : null,
                    icon: Icon(Icons.remove_circle_outline),
                  ),
                  Text('$adults', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: () => setState(() => adults++),
                    icon: Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 12),
            
            // Enfants
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.child_care, color: Colors.orange.shade600),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Enfants', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        Text('2-12 ans', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: children > 0 ? () => setState(() => children--) : null,
                    icon: Icon(Icons.remove_circle_outline),
                  ),
                  Text('$children', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: () => setState(() => children++),
                    icon: Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 12),
            
            // Bébés
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.baby_changing_station, color: Colors.pink.shade600),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bébés', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        Text('0-2 ans', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: babies > 0 ? () => setState(() => babies--) : null,
                    icon: Icon(Icons.remove_circle_outline),
                  ),
                  Text('$babies', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: () => setState(() => babies++),
                    icon: Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 12),
            
            // Animaux
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.pets, color: Colors.green.shade600),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Animaux', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        Text('Chiens, chats...', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: pets > 0 ? () => setState(() => pets--) : null,
                    icon: Icon(Icons.remove_circle_outline),
                  ),
                  Text('$pets', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: () => setState(() => pets++),
                    icon: Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // Bouton de recherche
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canSearch() ? () => _searchHotels(context) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Rechercher des hôtels',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            
            SizedBox(height: 20), // Espace en bas pour éviter le débordement
          ],
        ),
      ),
    );
  }

  Future<void> _selectCheckInDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        checkInDate = picked;
        // Reset checkout date if it's before checkin
        if (checkOutDate != null && checkOutDate!.isBefore(picked)) {
          checkOutDate = null;
        }
      });
    }
  }

  Future<void> _selectCheckOutDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: checkInDate!.add(Duration(days: 1)),
      firstDate: checkInDate!.add(Duration(days: 1)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        checkOutDate = picked;
      });
    }
  }

  bool _canSearch() {
    return checkInDate != null && checkOutDate != null;
  }

  void _searchHotels(BuildContext context) {
    final provider = context.read<AppProvider>();
    provider.searchHotels(widget.selectedCity);
    
    // Créer le message de confirmation
    String guestMessage = '';
    List<String> guestParts = [];
    
    if (adults > 0) guestParts.add('$adults adulte${adults > 1 ? 's' : ''}');
    if (children > 0) guestParts.add('$children enfant${children > 1 ? 's' : ''}');
    if (babies > 0) guestParts.add('$babies bébé${babies > 1 ? 's' : ''}');
    if (pets > 0) guestParts.add('$pets animal${pets > 1 ? 'aux' : ''}');
    
    guestMessage = guestParts.join(', ');
    
    // Retourner à l'écran d'accueil avec les résultats
    Navigator.of(context).popUntil((route) => route.isFirst);
    
    // Afficher un message de confirmation après un délai
    Future.delayed(Duration(milliseconds: 500), () {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Recherche d\'hôtels à ${widget.selectedCity} du ${checkInDate!.day}/${checkInDate!.month} au ${checkOutDate!.day}/${checkOutDate!.month} pour $guestMessage',
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 4),
          ),
        );
      }
    });
  }
}
