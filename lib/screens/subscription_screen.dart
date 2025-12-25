import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/subscription.dart';
import '../providers/app_provider.dart';
import '../widgets/wave_header.dart';
import 'payment_screen.dart';

class SubscriptionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final isSubscribed = provider.currentSubscription?.isActive ?? false;

        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          body: Column(
            children: [
              WaveHeader(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isSubscribed ? Icons.workspace_premium : Icons.store,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      isSubscribed ? 'Mon Abonnement' : 'Devenez Hôte Premium',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      isSubscribed
                          ? 'Profitez de 0% de commission'
                          : 'Postez vos logements sans commission',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      if (!isSubscribed) ...[
                        _buildSubscriptionCard(context),
                        SizedBox(height: 20),
                        _buildFeaturesList(),
                      ] else ...[
                        _buildCurrentSubscription(provider),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSubscriptionCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.workspace_premium, color: Colors.amber, size: 32),
              SizedBox(width: 12),
              Text(
                'Premium',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            '4,90€',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Text(
            'par mois',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Créer un objet subscription simple pour le paiement
                final subscription = Subscription(
                  type: SubscriptionType.seller,
                  name: 'Premium',
                  price: 4.90,
                  features: ['Pas de commission', 'Support prioritaire'],
                );
                
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentScreen(subscription: subscription),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'S\'abonner maintenant',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesList() {
    final features = [
      'Postez vos logements sans commission',
      'Aucun pourcentage prélevé',
      'Gestion de vos annonces',
      'Support prioritaire 24/7',
      'Statistiques détaillées',
      'Badge "Hôte Premium"',
    ];

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Avantages Hôtes',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Voyageurs réservent gratuitement',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(height: 12),
          ...features.map((feature) => Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    feature,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildCurrentSubscription(provider) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.workspace_premium, color: Colors.amber, size: 48),
          SizedBox(height: 16),
          Text(
            'Abonnement Actif',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '4,90€/mois',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '0% de commission sur vos réservations',
              style: TextStyle(
                color: Colors.green[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
