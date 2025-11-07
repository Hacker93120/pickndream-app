import 'package:flutter/material.dart';
import '../constants/french_cities.dart';
import 'date_selection_screen.dart';

class CitySearchDelegate extends SearchDelegate<String> {
  @override
  String get searchFieldLabel => 'Rechercher une destination...';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = FrenchCities.searchCities(query);
    
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final city = results[index];
        return ListTile(
          leading: Icon(Icons.location_city),
          title: Text(city),
          subtitle: Text('France'),
          onTap: () => _selectCity(context, city),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = FrenchCities.searchCities(query);
    
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final city = suggestions[index];
        return ListTile(
          leading: Icon(Icons.location_city),
          title: Text(city),
          subtitle: Text('France'),
          onTap: () => _selectCity(context, city),
        );
      },
    );
  }

  void _selectCity(BuildContext context, String city) {
    // Fermer la recherche et naviguer vers la sélection de dates
    close(context, '');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DateSelectionScreen(selectedCity: city),
      ),
    );
  }
}
