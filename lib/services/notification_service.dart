import 'dart:math';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // Messages de notifications pour les hôtels
  final List<Map<String, String>> _hotelNotifications = [
    {
      'title': '🏨 Offre spéciale !',
      'body': 'Trouvez le meilleur hôtel avec -30% sur votre prochaine réservation',
      'type': 'promotion'
    },
    {
      'title': '⭐ Hôtel recommandé',
      'body': 'Découvrez l\'Hôtel Atlas Marrakech - Note 4.8/5 - À partir de 89€',
      'type': 'recommendation'
    },
    {
      'title': '🎯 Dernière chance !',
      'body': 'Plus que 2 chambres disponibles dans votre hôtel favori',
      'type': 'urgency'
    },
    {
      'title': '💎 Hôtel de luxe',
      'body': 'Villa Royal Casablanca vous attend - Spa inclus - Réservez maintenant',
      'type': 'luxury'
    },
    {
      'title': '🌟 Nouveau sur PicknDream',
      'body': 'Riad Fès Médina vient d\'ouvrir - Première réservation -20%',
      'type': 'new'
    },
    {
      'title': '📍 Près de vous',
      'body': 'Hôtel Agadir Beach à 5km - Vue mer exceptionnelle - Dispo ce soir',
      'type': 'location'
    },
    {
      'title': '💰 Prix imbattable',
      'body': 'Trouvé pour vous : Hôtel 4⭐ à 45€/nuit au lieu de 89€',
      'type': 'price'
    },
    {
      'title': '🏖️ Séjour parfait',
      'body': 'Resort Tanger Bay - Piscine + Plage privée - Réservation express',
      'type': 'experience'
    },
    {
      'title': '⏰ Réservation rapide',
      'body': 'Votre recherche sauvegardée : 3 nouveaux hôtels correspondent',
      'type': 'search'
    },
    {
      'title': '🎉 Félicitations !',
      'body': 'Vous avez gagné 500 points fidélité - Utilisez-les maintenant',
      'type': 'reward'
    }
  ];

  final List<Map<String, String>> _bookingNotifications = [
    {
      'title': '✅ Réservation confirmée',
      'body': 'Votre séjour à l\'Hôtel Marrakech Palace est confirmé',
      'type': 'confirmation'
    },
    {
      'title': '📅 Rappel de séjour',
      'body': 'Votre check-in est demain à 15h - Bon voyage !',
      'type': 'reminder'
    },
    {
      'title': '🚗 Préparez votre voyage',
      'body': 'Check-in dans 3 jours - Consultez les infos de votre hôtel',
      'type': 'preparation'
    },
    {
      'title': '📱 Check-in mobile',
      'body': 'Gagnez du temps : effectuez votre check-in depuis l\'app',
      'type': 'checkin'
    },
    {
      'title': '⭐ Évaluez votre séjour',
      'body': 'Comment était votre séjour ? Partagez votre avis',
      'type': 'review'
    }
  ];

  final List<Map<String, String>> _personalizedNotifications = [
    {
      'title': '🎂 Offre anniversaire',
      'body': 'Joyeux anniversaire ! Profitez de -25% sur tous nos hôtels',
      'type': 'birthday'
    },
    {
      'title': '🏆 Membre VIP',
      'body': 'Félicitations ! Vous êtes maintenant membre Premium',
      'type': 'upgrade'
    },
    {
      'title': '💝 Cadeau surprise',
      'body': 'Une nuit gratuite vous attend - Découvrez votre cadeau',
      'type': 'gift'
    },
    {
      'title': '📊 Vos statistiques',
      'body': '12 séjours cette année - Vous êtes un grand voyageur !',
      'type': 'stats'
    }
  ];

  // Simuler l'envoi d'une notification
  Map<String, String> getRandomNotification({String? category}) {
    final random = Random();
    List<Map<String, String>> notifications;

    switch (category) {
      case 'booking':
        notifications = _bookingNotifications;
        break;
      case 'personal':
        notifications = _personalizedNotifications;
        break;
      default:
        notifications = _hotelNotifications;
    }

    return notifications[random.nextInt(notifications.length)];
  }

  // Obtenir une notification spécifique par type
  Map<String, String> getNotificationByType(String type) {
    final allNotifications = [
      ..._hotelNotifications,
      ..._bookingNotifications,
      ..._personalizedNotifications
    ];

    return allNotifications.firstWhere(
      (notification) => notification['type'] == type,
      orElse: () => _hotelNotifications.first,
    );
  }

  // Simuler l'historique des notifications
  List<Map<String, dynamic>> getNotificationHistory() {
    final random = Random();
    final now = DateTime.now();
    
    return List.generate(15, (index) {
      final notification = getRandomNotification();
      return {
        ...notification,
        'id': 'notif_${index + 1}',
        'timestamp': now.subtract(Duration(hours: index * 2)),
        'read': random.nextBool(),
        'category': _getCategoryFromType(notification['type']!),
      };
    });
  }

  String _getCategoryFromType(String type) {
    if (['confirmation', 'reminder', 'preparation', 'checkin', 'review'].contains(type)) {
      return 'booking';
    } else if (['birthday', 'upgrade', 'gift', 'stats'].contains(type)) {
      return 'personal';
    } else {
      return 'hotel';
    }
  }

  // Messages pour différentes situations
  Map<String, String> getWelcomeNotification() {
    return {
      'title': '🎉 Bienvenue sur PicknDream !',
      'body': 'Découvrez les meilleurs hôtels du Maroc - Première réservation -15%',
      'type': 'welcome'
    };
  }

  Map<String, String> getLocationNotification(String city) {
    return {
      'title': '📍 Hôtels à $city',
      'body': 'Trouvez le meilleur hôtel à $city - Prix à partir de 35€/nuit',
      'type': 'location'
    };
  }

  Map<String, String> getPriceAlertNotification(String hotelName, int oldPrice, int newPrice) {
    return {
      'title': '💰 Alerte prix !',
      'body': '$hotelName : ${oldPrice}€ → ${newPrice}€ (-${oldPrice - newPrice}€)',
      'type': 'price_alert'
    };
  }

  Map<String, String> getBookingConfirmation(String hotelName, String date) {
    return {
      'title': '✅ Réservation confirmée',
      'body': '$hotelName - Arrivée le $date - Bon voyage !',
      'type': 'booking_confirmed'
    };
  }
}
