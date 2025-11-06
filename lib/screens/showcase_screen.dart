import 'package:flutter/material.dart';

class ShowcaseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue.shade800, Colors.blue.shade400],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'PicknDream',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Votre partenaire pour des expériences exceptionnelles',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue.shade800,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: Text(
                      'Découvrir nos services',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            
            // Services Section
            Container(
              padding: EdgeInsets.all(50),
              child: Column(
                children: [
                  Text(
                    'Nos Services',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildServiceCard(
                        'Consultation',
                        'Conseils personnalisés pour vos projets',
                        Icons.business_center,
                      ),
                      _buildServiceCard(
                        'Solutions',
                        'Des solutions adaptées à vos besoins',
                        Icons.lightbulb,
                      ),
                      _buildServiceCard(
                        'Support',
                        'Accompagnement tout au long du processus',
                        Icons.support_agent,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // About Section
            Container(
              padding: EdgeInsets.all(50),
              color: Colors.grey.shade100,
              child: Column(
                children: [
                  Text(
                    'À Propos',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'PicknDream est votre partenaire de confiance pour transformer vos idées en réalité. '
                    'Nous offrons des services de qualité avec une approche personnalisée pour chaque client.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade700,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            // Contact Section
            Container(
              padding: EdgeInsets.all(50),
              child: Column(
                children: [
                  Text(
                    'Contactez-nous',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildContactInfo(Icons.email, 'contact@pickndream.fr'),
                      _buildContactInfo(Icons.phone, '+33 1 23 45 67 89'),
                      _buildContactInfo(Icons.location_on, 'Paris, France'),
                    ],
                  ),
                ],
              ),
            ),
            
            // Footer
            Container(
              padding: EdgeInsets.all(30),
              color: Colors.blue.shade800,
              child: Text(
                '© 2024 PicknDream. Tous droits réservés.',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildServiceCard(String title, String description, IconData icon) {
    return Container(
      width: 300,
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 50, color: Colors.blue.shade600),
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          SizedBox(height: 15),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildContactInfo(IconData icon, String info) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.blue.shade600),
        SizedBox(width: 10),
        Text(
          info,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}
