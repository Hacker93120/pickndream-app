import 'package:flutter/material.dart';
import '../widgets/wave_header.dart';
import '../utils/translations.dart';

class CurrencyScreen extends StatelessWidget {
  final List<Map<String, String>> countries = [
    {'name': 'Maroc', 'flag': '🇲🇦', 'currency': 'MAD'},
    {'name': 'France', 'flag': '🇫🇷', 'currency': 'EUR'},
    {'name': 'États-Unis', 'flag': '🇺🇸', 'currency': 'USD'},
    {'name': 'Royaume-Uni', 'flag': '🇬🇧', 'currency': 'GBP'},
    {'name': 'Allemagne', 'flag': '🇩🇪', 'currency': 'EUR'},
    {'name': 'Espagne', 'flag': '🇪🇸', 'currency': 'EUR'},
    {'name': 'Italie', 'flag': '🇮🇹', 'currency': 'EUR'},
    {'name': 'Canada', 'flag': '🇨🇦', 'currency': 'CAD'},
    {'name': 'Japon', 'flag': '🇯🇵', 'currency': 'JPY'},
    {'name': 'Australie', 'flag': '🇦🇺', 'currency': 'AUD'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          WaveHeader(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.attach_money,
                  size: 60,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: countries.length,
              itemBuilder: (context, index) {
                final country = countries[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Text(
                      country['flag']!,
                      style: TextStyle(fontSize: 24),
                    ),
                    title: Text(
                      country['name']!,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    trailing: Text(
                      country['currency']!,
                      style: TextStyle(
                        color: Colors.blue.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context, country);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
