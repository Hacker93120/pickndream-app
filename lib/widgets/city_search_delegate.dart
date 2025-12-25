import 'package:flutter/material.dart';
import '../constants/french_cities.dart';
import 'date_selection_screen.dart';

class CitySearchDelegate extends SearchDelegate<String> {
  @override
  String get searchFieldLabel => 'Rechercher une destination...';

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.blue.shade600),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.grey.shade400),
        border: InputBorder.none,
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: Icon(Icons.clear, color: Colors.grey.shade600),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.blue.shade600),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = FrenchCities.searchCities(query);
    
    return Container(
      color: Colors.white,
      child: results.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 64, color: Colors.grey.shade300),
                  SizedBox(height: 16),
                  Text(
                    'Aucune destination trouvée',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final city = results[index];
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade100),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    leading: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.location_city, color: Colors.blue.shade600, size: 24),
                    ),
                    title: Text(
                      city,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      'France',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
                    onTap: () => _selectCity(context, city),
                  ),
                );
              },
            ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty 
        ? FrenchCities.popularCities 
        : FrenchCities.searchCities(query);
    
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (query.isEmpty)
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Destinations populaires',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                final city = suggestions[index];
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade100),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    leading: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        query.isEmpty ? Icons.star : Icons.location_city,
                        color: Colors.blue.shade600,
                        size: 24,
                      ),
                    ),
                    title: Text(
                      city,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      'France',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
                    onTap: () => _selectCity(context, city),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _selectCity(BuildContext context, String city) {
    close(context, '');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DateSelectionScreen(selectedCity: city),
      ),
    );
  }
}
