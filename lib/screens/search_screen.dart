import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/city_search_delegate.dart';
import '../widgets/hotel_card.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recherche'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              // Barre de recherche
              Padding(
                padding: EdgeInsets.all(16),
                child: GestureDetector(
                  onTap: () async {
                    await showSearch(
                      context: context,
                      delegate: CitySearchDelegate(),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Colors.blue.shade600),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            provider.searchQuery.isNotEmpty 
                                ? provider.searchQuery 
                                : 'Rechercher une destination en France...',
                            style: TextStyle(
                              color: provider.searchQuery.isNotEmpty 
                                  ? Colors.black 
                                  : Colors.grey.shade600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        if (provider.searchQuery.isNotEmpty)
                          GestureDetector(
                            onTap: () => provider.clearFilters(),
                            child: Icon(Icons.clear, color: Colors.grey),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Résultats
              Expanded(
                child: provider.hotels.isNotEmpty
                    ? ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: provider.hotels.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 16),
                            child: HotelCard(hotel: provider.hotels[index]),
                          );
                        },
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_city,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              provider.searchQuery.isNotEmpty
                                  ? 'Aucun hôtel trouvé pour "${provider.searchQuery}"'
                                  : 'Recherchez une destination en France',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (provider.searchQuery.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(top: 16),
                                child: ElevatedButton(
                                  onPressed: () => provider.clearFilters(),
                                  child: Text('Effacer la recherche'),
                                ),
                              ),
                          ],
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
