import 'package:flutter/material.dart';
import '../widgets/wave_header.dart';
import '../utils/translations.dart';

class LanguageScreen extends StatelessWidget {
  final List<Map<String, String>> languages = [
    {'name': 'Français', 'flag': '🇫🇷', 'code': 'fr'},
    {'name': 'English', 'flag': '🇺🇸', 'code': 'en'},
    {'name': 'العربية', 'flag': '🇲🇦', 'code': 'ar'},
    {'name': 'Español', 'flag': '🇪🇸', 'code': 'es'},
    {'name': 'Deutsch', 'flag': '🇩🇪', 'code': 'de'},
    {'name': 'Italiano', 'flag': '🇮🇹', 'code': 'it'},
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
                  Icons.language,
                  size: 60,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: languages.length,
              itemBuilder: (context, index) {
                final language = languages[index];
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
                      language['flag']!,
                      style: TextStyle(fontSize: 24),
                    ),
                    title: Text(
                      language['name']!,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context, language);
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
