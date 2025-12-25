import 'package:flutter/material.dart';
import '../widgets/wave_header.dart';
import '../utils/translations.dart';

class HelpScreen extends StatelessWidget {
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
                  Icons.help_outline,
                  size: 60,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildFaqItem(
                    'Comment réserver un hôtel ?',
                    'Recherchez votre destination, sélectionnez vos dates, choisissez votre hôtel et suivez les étapes de réservation.',
                  ),
                  _buildFaqItem(
                    'Comment annuler ma réservation ?',
                    'Allez dans "Mes réservations" et cliquez sur "Annuler" selon les conditions d\'annulation de l\'hôtel.',
                  ),
                  _buildFaqItem(
                    'Qu\'est-ce que l\'abonnement Premium ?',
                    'L\'abonnement Premium à 4,90€/mois vous permet de réserver sans commission et d\'accéder à des fonctionnalités exclusives.',
                  ),
                  _buildFaqItem(
                    'Comment modifier mon profil ?',
                    'Allez dans "Profil" puis "Modifier le profil" pour changer vos informations personnelles.',
                  ),
                  _buildFaqItem(
                    'Les paiements sont-ils sécurisés ?',
                    'Oui, tous les paiements sont sécurisés et cryptés. Nous utilisons les dernières technologies de sécurité.',
                  ),
                  _buildFaqItem(
                    'Comment contacter le support ?',
                    'Utilisez la section "Nous contacter" ou envoyez un email à support@pickndream.com',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.blue.shade800,
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: TextStyle(
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
