import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/city_search_delegate.dart';
import '../widgets/hotel_card.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('Recherche', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              // En-tête avec gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.blue.shade600, Colors.blue.shade400],
                  ),
                ),
                child: Column(
                  children: [
                    // Barre de recherche moderne
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: GestureDetector(
                        onTap: () async {
                          await showSearch(
                            context: context,
                            delegate: CitySearchDelegate(),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 0,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(Icons.search, color: Colors.blue.shade600, size: 24),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      provider.searchQuery.isNotEmpty 
                                          ? provider.searchQuery 
                                          : 'Où allez-vous ?',
                                      style: TextStyle(
                                        color: provider.searchQuery.isNotEmpty 
                                            ? Colors.black 
                                            : Colors.grey.shade600,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    if (provider.searchQuery.isEmpty)
                                      Text(
                                        'Rechercher une destination',
                                        style: TextStyle(
                                          color: Colors.grey.shade400,
                                          fontSize: 12,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              if (provider.searchQuery.isNotEmpty)
                                GestureDetector(
                                  onTap: () => provider.clearFilters(),
                                  child: Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.close, color: Colors.grey.shade600, size: 18),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              
              // Résultats
              Expanded(
                child: provider.hotels.isNotEmpty
                    ? ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: provider.hotels.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 16),
                            child: HotelCard(hotel: provider.hotels[index]),
                          );
                        },
                      )
                    : Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.travel_explore,
                                  size: 64,
                                  color: Colors.blue.shade300,
                                ),
                              ),
                              SizedBox(height: 24),
                              Text(
                                provider.searchQuery.isNotEmpty
                                    ? 'Aucun hôtel trouvé'
                                    : 'Trouvez votre destination',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                              SizedBox(height: 12),
                              Text(
                                provider.searchQuery.isNotEmpty
                                    ? 'Aucun résultat pour "${provider.searchQuery}"'
                                    : 'Recherchez parmi des centaines d\'hôtels en France',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              if (provider.searchQuery.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.only(top: 24),
                                  child: ElevatedButton.icon(
                                    onPressed: () => provider.clearFilters(),
                                    icon: Icon(Icons.refresh),
                                    label: Text('Nouvelle recherche'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue.shade600,
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
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
