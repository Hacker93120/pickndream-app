/// Configuration des constantes API pour le backend PicknDream
class ApiConstants {
  // URL de base de l'API
  // Production: Backend déployé sur Vercel
  static const String baseUrl = 'https://pickndream-dashboard.vercel.app';

  // Pour développement local, décommenter la ligne ci-dessous:
  // static const String baseUrl = 'http://localhost:3000';

  // Endpoints d'authentification
  static const String loginEndpoint = '/api/auth/login';
  static const String registerEndpoint = '/api/auth/register';

  // Endpoints utilisateur
  static const String profileEndpoint = '/api/user/profile';

  // Endpoints hôtels
  static const String hotelsEndpoint = '/api/hotels';

  // Endpoints réservations
  static const String bookingsEndpoint = '/api/bookings';

  // Endpoint upload
  static const String uploadEndpoint = '/api/upload';

  // Timeout pour les requêtes HTTP (en secondes)
  static const int connectionTimeout = 10; // Réduit pour éviter les blocages
  static const int receiveTimeout = 10;

  // Headers par défaut
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'User-Agent': 'PicknDream-Flutter-App',
  };

  // Headers avec authentification
  static Map<String, String> authHeaders(String token) => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
    'User-Agent': 'PicknDream-Flutter-App',
  };
}
