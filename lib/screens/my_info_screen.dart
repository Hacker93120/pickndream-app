import 'package:flutter/material.dart';

class MyInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('Mes informations'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Photo de profil
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/profile.png'),
                backgroundColor: Colors.grey.shade200,
              ),
            ),
            SizedBox(height: 24),
            
            // Informations personnelles
            _buildInfoSection('Informations personnelles', [
              _buildInfoItem('Nom complet', 'Ahmed Benali', Icons.person),
              _buildInfoItem('Email', 'ahmed.benali@email.com', Icons.email),
              _buildInfoItem('Téléphone', '+212 6 12 34 56 78', Icons.phone),
              _buildInfoItem('Date de naissance', '15 Mars 1990', Icons.cake),
              _buildInfoItem('Sexe', 'Homme', Icons.wc),
            ]),
            
            SizedBox(height: 24),
            
            // Informations du compte
            _buildInfoSection('Informations du compte', [
              _buildInfoItem('Membre depuis', '15 Janvier 2024', Icons.calendar_today),
              _buildInfoItem('Statut', 'Membre Premium', Icons.star, statusColor: Colors.orange),
              _buildInfoItem('Réservations totales', '12 séjours', Icons.hotel),
              _buildInfoItem('Points fidélité', '2,450 points', Icons.loyalty, statusColor: Colors.green),
            ]),
            
            SizedBox(height: 24),
            
            // Préférences
            _buildInfoSection('Préférences', [
              _buildInfoItem('Langue', 'Français', Icons.language),
              _buildInfoItem('Devise', 'Euro (EUR)', Icons.attach_money),
              _buildInfoItem('Notifications', 'Activées', Icons.notifications, statusColor: Colors.blue),
            ]),
            
            SizedBox(height: 32),
            
            // Bouton modifier
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/edit-profile');
                },
                icon: Icon(Icons.edit),
                label: Text('Modifier mes informations'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon, {Color? statusColor}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade100, width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.blue.shade600, size: 20),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: statusColor ?? Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
