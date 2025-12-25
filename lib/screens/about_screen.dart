import 'package:flutter/material.dart';
import '../widgets/wave_header.dart';

class AboutScreen extends StatelessWidget {
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
                  Icons.info_outline,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  _buildSection(
                    'À propos de PicknDream',
                    'PicknDream est votre compagnon idéal pour réserver vos hôtels de rêve. '
                    'Découvrez des milliers d\'établissements à travers le monde, comparez les prix, '
                    'et réservez en toute simplicité.',
                    Icons.description,
                  ),
                  SizedBox(height: 24),

                  // Fonctionnalités
                  _buildSection(
                    'Fonctionnalités',
                    '',
                    Icons.star,
                    showBullets: true,
                    bullets: [
                      'Recherche d\'hôtels par destination',
                      'Filtrage par catégorie (Luxe, Famille, Business, etc.)',
                      'Réservation en ligne sécurisée',
                      'Gestion de vos réservations',
                      'Favoris pour vos hôtels préférés',
                      'Système d\'abonnement sans commission',
                    ],
                  ),
                  SizedBox(height: 24),

                  // Abonnement
                  _buildSection(
                    'Abonnement Premium',
                    'Avec notre abonnement à seulement 4,90€/mois, profitez de :\n'
                    '• 0% de commission sur vos réservations\n'
                    '• Publication illimitée de logements\n'
                    '• Support client 7j/7\n'
                    '• Statistiques et analyses détaillées',
                    Icons.card_membership,
                  ),
                  SizedBox(height: 24),

                  // Équipe
                  _buildSection(
                    'Notre équipe',
                    'PicknDream est développé par une équipe passionnée de développeurs '
                    'et de spécialistes du voyage, dédiée à vous offrir la meilleure expérience '
                    'de réservation d\'hôtels.',
                    Icons.group,
                  ),
                  SizedBox(height: 24),

                  // Mentions légales
                  _buildLegalSection(context),
                  SizedBox(height: 32),

                  // Footer
                  Center(
                    child: Column(
                      children: [
                        Text(
                          '© 2024 PicknDream',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Tous droits réservés',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Made with ❤️ by PicknDream Team',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content, IconData icon,
      {bool showBullets = false, List<String>? bullets}) {
    return Container(
      padding: EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue.shade600, size: 24),
              SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
          if (content.isNotEmpty) ...[
            SizedBox(height: 12),
            Text(
              content,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
          ],
          if (showBullets && bullets != null) ...[
            SizedBox(height: 12),
            ...bullets.map((bullet) => Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 20,
                        color: Colors.green,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          bullet,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }

  Widget _buildLegalSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.policy, color: Colors.blue.shade600, size: 24),
              SizedBox(width: 12),
              Text(
                'Mentions légales',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildLegalItem('Conditions générales d\'utilisation', () {}),
          Divider(),
          _buildLegalItem('Politique de confidentialité', () {}),
          Divider(),
          _buildLegalItem('Politique de cookies', () {}),
          Divider(),
          _buildLegalItem('Mentions légales', () {}),
        ],
      ),
    );
  }

  Widget _buildLegalItem(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
