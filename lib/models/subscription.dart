enum SubscriptionType { seller }

class Subscription {
  final SubscriptionType type;
  final String name;
  final double price;
  final List<String> features;
  final bool isActive;
  final DateTime? expiryDate;

  Subscription({
    required this.type,
    required this.name,
    required this.price,
    required this.features,
    this.isActive = false,
    this.expiryDate,
  });

  static List<Subscription> getAvailableSubscriptions() {
    return [
      Subscription(
        type: SubscriptionType.seller,
        name: 'Abonnement Logement',
        price: 4.90,
        features: [
          '✅ Publiez votre logement en illimité',
          '✅ 0% de commission sur vos réservations',
          '✅ Gestion complète de votre annonce',
          '✅ Support client dédié 7j/7',
          '✅ Statistiques et analyses détaillées',
          '✅ Visibilité maximale sur la plateforme',
          '✅ Modification d\'annonce à tout moment',
          '✅ Photos et descriptions illimitées',
        ],
      ),
    ];
  }
}
