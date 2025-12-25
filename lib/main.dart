import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'providers/app_provider.dart';
import 'screens/login_screen.dart';
import 'screens/main_screen.dart';
import 'services/stripe_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Charger les variables d'environnement
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting('fr_FR', null);
  await StripeService.init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: MaterialApp(
        title: 'PicknDream',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

/// Écran de démarrage qui vérifie l'authentification
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    final provider = Provider.of<AppProvider>(context, listen: false);

    try {
      // Vérifier l'authentification de manière asynchrone
      await provider.checkAuth();

      // Attendre un petit délai pour l'affichage du splash
      await Future.delayed(Duration(milliseconds: 300));

      if (!mounted) return;

      // Navigation selon l'état d'authentification
      if (provider.isAuthenticated) {
        // Charger les données en arrière-plan
        provider.loadHotelsFromAPI();

        // Naviguer vers l'écran principal
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => MainScreen()),
        );
      } else {
        // Naviguer vers l'écran de login
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      }
    } catch (e) {
      if (!mounted) return;
      
      // En cas d'erreur, aller vers le login
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade600,
              Colors.blue.shade400,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.hotel,
                size: 80,
                color: Colors.white,
              ),
              SizedBox(height: 24),
              Text(
                'PicknDream',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Réservez vos rêves',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 40),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
