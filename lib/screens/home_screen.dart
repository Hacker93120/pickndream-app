import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/app_provider.dart';
import '../widgets/hotel_card.dart';
import '../widgets/wave_header.dart';
import '../widgets/city_search_delegate.dart';
import '../utils/translations.dart';
import 'subscription_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _categoryScrollController;
  bool _showLeftArrow = false;
  bool _showRightArrow = true;
  String _selectedTab = 'hotels'; // 'hotels', 'activites', 'prestations'

  @override
  void initState() {
    super.initState();
    _categoryScrollController = ScrollController();
    _categoryScrollController.addListener(_updateArrowVisibility);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadHotels();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Recharger les hôtels si on revient sur cet écran
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<AppProvider>();
      if (provider.hotels.isEmpty && !provider.isLoading) {
        _loadHotels();
      }
    });
  }

  Future<void> _loadHotels() async {
    final provider = context.read<AppProvider>();
    await provider.loadHotelsFromAPI();

    // Si erreur, afficher un message
    if (provider.errorMessage != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage!),
            backgroundColor: Colors.orange,
            action: SnackBarAction(
              label: 'Réessayer',
              textColor: Colors.white,
              onPressed: () => _loadHotels(),
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _categoryScrollController.dispose();
    super.dispose();
  }

  void _updateArrowVisibility() {
    setState(() {
      _showLeftArrow = _categoryScrollController.offset > 20;
      _showRightArrow = _categoryScrollController.offset <
          _categoryScrollController.position.maxScrollExtent - 20;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          WaveHeader(
            height: 200,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bonjour !',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          'PicknDream',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Trouvez votre hôtel idéal',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubscriptionScreen(),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.workspace_premium,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Consumer<AppProvider>(
              builder: (context, provider, child) {
                return RefreshIndicator(
                  onRefresh: _loadHotels,
                  color: Colors.blue.shade600,
                  child: CustomScrollView(
                    slivers: [
                    // Barre de recherche
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: GestureDetector(
                          onTap: () async {
                            await showSearch(
                              context: context,
                              delegate: CitySearchDelegate(),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.search, color: Colors.blue.shade600),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    provider.searchQuery.isNotEmpty 
                                        ? provider.searchQuery 
                                        : 'Rechercher une destination...',
                                    style: TextStyle(
                                      color: provider.searchQuery.isNotEmpty 
                                          ? Colors.black 
                                          : Colors.grey.shade600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                if (provider.searchQuery.isNotEmpty)
                                  GestureDetector(
                                    onTap: () => provider.clearFilters(),
                                    child: Icon(Icons.clear, color: Colors.grey),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Carrousel de catégories circulaires
                    SliverToBoxAdapter(
                      child: _buildCategoryCarousel(),
                    ),

                    // Section titre
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          _selectedTab == 'activites'
                              ? 'Activité'
                              : _selectedTab == 'prestations'
                                  ? 'Prestation'
                                  : provider.selectedCategory != null
                                      ? 'Hôtels ${provider.selectedCategory}'
                                      : provider.searchQuery.isNotEmpty
                                          ? 'Résultats de recherche'
                                          : 'Hôtels',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ),
                    ),

                    // Liste des hôtels avec SliverList pour de meilleures performances
                    if (provider.isLoading)
                      SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(50),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      )
                    else if (provider.hotels.isEmpty)
                      SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(50),
                            child: Column(
                              children: [
                                Icon(Icons.hotel, size: 64, color: Colors.grey),
                                SizedBox(height: 16),
                                Text(
                                  provider.searchQuery.isNotEmpty || provider.selectedCategory != null
                                      ? 'Aucun hôtel trouvé'
                                      : 'Aucun hôtel disponible',
                                  style: TextStyle(fontSize: 18, color: Colors.grey),
                                ),
                                if (provider.searchQuery.isNotEmpty || provider.selectedCategory != null)
                                  Padding(
                                    padding: EdgeInsets.only(top: 16),
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        provider.clearFilters();
                                      },
                                      icon: Icon(Icons.refresh),
                                      label: Text('Réinitialiser les filtres'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue.shade600,
                                        foregroundColor: Colors.white,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 16),
                                child: HotelCard(hotel: provider.hotels[index]),
                              );
                            },
                            childCount: provider.hotels.length,
                          ),
                        ),
                      ),

                    // Espace en bas pour le padding
                    SliverToBoxAdapter(
                      child: SizedBox(height: 16),
                    ),
                  ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCarousel() {
    // Catégories pour les hôtels
    final hotelCategories = [
      {
        'name': Translations.tr(context, 'luxury'),
        'icon': Icons.diamond,
        'color': Colors.purple,
        'image': 'assets/images/luxe.png',
      },
      {
        'name': Translations.tr(context, 'family'),
        'icon': Icons.family_restroom,
        'color': Colors.green,
        'image': 'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=400&q=80',
      },
      {
        'name': Translations.tr(context, 'business'),
        'icon': Icons.business_center,
        'color': Colors.blue,
        'image': 'https://images.unsplash.com/photo-1497366216548-37526070297c?w=400&q=80',
      },
      {
        'name': Translations.tr(context, 'romantic'),
        'icon': Icons.favorite,
        'color': Colors.pink,
        'image': 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400&q=80',
      },
      {
        'name': 'Spa',
        'icon': Icons.spa,
        'color': Colors.teal,
        'image': 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=400&q=80',
      },
      {
        'name': 'Plage',
        'icon': Icons.beach_access,
        'color': Colors.orange,
        'image': 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=400&q=80',
      },
    ];

    // Catégories pour les activités
    final activityCategories = [
      {
        'name': 'Randonnée',
        'icon': Icons.hiking,
        'color': Colors.green,
        'image': 'https://images.unsplash.com/photo-1551632811-561732d1e306?w=400&q=80',
      },
      {
        'name': 'Plongée',
        'icon': Icons.scuba_diving,
        'color': Colors.blue,
        'image': 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400&q=80',
      },
      {
        'name': 'Ski',
        'icon': Icons.downhill_skiing,
        'color': Colors.cyan,
        'image': 'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=400&q=80',
      },
      {
        'name': 'Vélo',
        'icon': Icons.pedal_bike,
        'color': Colors.orange,
        'image': 'https://images.unsplash.com/photo-1571068316344-75bc76f77890?w=400&q=80',
      },
      {
        'name': 'Yoga',
        'icon': Icons.self_improvement,
        'color': Colors.purple,
        'image': 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400&q=80',
      },
      {
        'name': 'Golf',
        'icon': Icons.golf_course,
        'color': Colors.teal,
        'image': 'https://images.unsplash.com/photo-1535131749006-b7f58c99034b?w=400&q=80',
      },
    ];

    // Catégories pour les prestations
    final prestationCategories = [
      {
        'name': 'Massage',
        'icon': Icons.spa,
        'color': Colors.purple,
        'image': 'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=400&q=80',
      },
      {
        'name': 'Restaurant',
        'icon': Icons.restaurant,
        'color': Colors.red,
        'image': 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400&q=80',
      },
      {
        'name': 'Navette',
        'icon': Icons.airport_shuttle,
        'color': Colors.blue,
        'image': 'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?w=400&q=80',
      },
      {
        'name': 'Lessive',
        'icon': Icons.local_laundry_service,
        'color': Colors.cyan,
        'image': 'https://images.unsplash.com/photo-1582735689369-4fe89db7114c?w=400&q=80',
      },
      {
        'name': 'Concierge',
        'icon': Icons.support_agent,
        'color': Colors.orange,
        'image': 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400&q=80',
      },
      {
        'name': 'Excursions',
        'icon': Icons.tour,
        'color': Colors.green,
        'image': 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=400&q=80',
      },
    ];

    // Sélectionner les bonnes catégories selon l'onglet
    final categories = _selectedTab == 'activites'
        ? activityCategories
        : _selectedTab == 'prestations'
            ? prestationCategories
            : hotelCategories;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => setState(() => _selectedTab = 'activites'),
                  child: Text(
                    'Activité',
                    style: TextStyle(
                      fontSize: _selectedTab == 'activites' ? 18 : 16,
                      fontWeight: _selectedTab == 'activites' ? FontWeight.bold : FontWeight.w600,
                      color: _selectedTab == 'activites' ? Colors.blue.shade800 : Colors.grey.shade600,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _selectedTab = 'hotels'),
                  child: Text(
                    'Catégories',
                    style: TextStyle(
                      fontSize: _selectedTab == 'hotels' ? 20 : 16,
                      fontWeight: _selectedTab == 'hotels' ? FontWeight.bold : FontWeight.w600,
                      color: _selectedTab == 'hotels' ? Colors.blue.shade800 : Colors.grey.shade600,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _selectedTab = 'prestations'),
                  child: Text(
                    'Prestation',
                    style: TextStyle(
                      fontSize: _selectedTab == 'prestations' ? 18 : 16,
                      fontWeight: _selectedTab == 'prestations' ? FontWeight.bold : FontWeight.w600,
                      color: _selectedTab == 'prestations' ? Colors.blue.shade800 : Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Stack(
            children: [
              Container(
                height: 110,
                child: ListView.builder(
                  controller: _categoryScrollController,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: _buildCategoryItem(
                        category['name'] as String,
                        category['icon'] as IconData,
                        category['color'] as MaterialColor,
                        category['image'] as String,
                      ),
                    );
                  },
                ),
              ),
              // Indicateur gauche
              if (_showLeftArrow)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.grey.shade50,
                          Colors.grey.shade50.withOpacity(0),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.chevron_left,
                        color: Colors.blue.shade600,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              // Indicateur droite
              if (_showRightArrow)
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [
                          Colors.grey.shade50,
                          Colors.grey.shade50.withOpacity(0),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.chevron_right,
                        color: Colors.blue.shade600,
                        size: 28,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String name, IconData icon, MaterialColor color, String imageUrl) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final isSelected = provider.selectedCategory == name;
        final hotelCount = provider.getHotelCountForCategory(name);

        return GestureDetector(
          onTap: () {
            if (isSelected) {
              provider.clearFilters();
            } else {
              provider.filterByCategory(name);
            }
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: 80,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: isSelected ? 70 : 65,
                      height: isSelected ? 70 : 65,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: Colors.white, width: 3)
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(isSelected ? 0.5 : 0.3),
                            spreadRadius: isSelected ? 4 : 2,
                            blurRadius: isSelected ? 12 : 8,
                            offset: Offset(0, isSelected ? 6 : 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Image de fond
                            imageUrl.startsWith('assets/')
                                ? Image.asset(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                  )
                                : CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [color.shade400, color.shade600],
                                        ),
                                      ),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [color.shade400, color.shade600],
                                  ),
                                ),
                              ),
                            ),
                            // Overlay gradient pour garder l'icône visible
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: isSelected
                                      ? [
                                          color.shade900.withOpacity(0.7),
                                          color.shade700.withOpacity(0.6),
                                        ]
                                      : [
                                          color.shade700.withOpacity(0.5),
                                          color.shade500.withOpacity(0.4),
                                        ],
                                ),
                              ),
                            ),
                            // Icône au premier plan
                            Center(
                              child: Icon(
                                icon,
                                color: Colors.white,
                                size: isSelected ? 32 : 28,
                                shadows: [
                                  Shadow(
                                    color: Colors.black45,
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Badge avec compteur
                    if (hotelCount > 0)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: AnimatedScale(
                          scale: isSelected ? 1.1 : 1.0,
                          duration: Duration(milliseconds: 300),
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isSelected ? color.shade800 : color.shade600,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              hotelCount.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 8),
                AnimatedDefaultTextStyle(
                  duration: Duration(milliseconds: 300),
                  style: TextStyle(
                    fontSize: isSelected ? 13 : 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? color.shade700 : Colors.grey.shade700,
                  ),
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
