import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/wave_header.dart';
import 'login_screen.dart';
import 'about_screen.dart';
import 'contact_screen.dart';
import 'help_screen.dart';
import 'currency_screen.dart';
import 'language_screen.dart';
import 'reservations_screen.dart';
import 'favorites_screen.dart';
import 'history_screen.dart';
import 'edit_profile_screen.dart';
import 'my_info_screen.dart';
import 'change_password_screen.dart';
import 'notifications_screen.dart';
import '../utils/translations.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  String _selectedCurrency = '🇲🇦 MAD';
  String _selectedLanguage = 'Français';
  bool _showAboutInfo = false;
  bool _notificationsEnabled = true; // État des notifications

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      _buildSettingsSection(),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WaveHeader(
      height: 180,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 40),
          Stack(
            children: [
              GestureDetector(
                onTap: _showEditAvatarDialog,
                child: Hero(
                  tag: 'profile_avatar',
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 45,
                      backgroundImage: AssetImage('assets/images/profile.png'),
                      backgroundColor: Colors.white.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _showEditAvatarDialog,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade600,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      size: 16,
                      color: Colors.white,
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

  void _showEditAvatarDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Changer la photo de profil',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildBottomSheetOption(Icons.camera_alt, 'Prendre une photo', () {}),
            _buildBottomSheetOption(Icons.photo_library, 'Choisir dans la galerie', () {}),
            _buildBottomSheetOption(Icons.delete, 'Supprimer la photo', () {}, isDestructive: true),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetOption(IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? Colors.red : Colors.blue.shade600),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : Colors.grey.shade800,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  Widget _buildSettingsSection() {
    final provider = Provider.of<AppProvider>(context);
    final lang = provider.selectedLanguage;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            Translations.get('settings', lang),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
        ),
        _buildSettingsGroup(
          Translations.get('account', lang),
          [
            _buildSettingItemData(Translations.get('edit_profile', lang), Icons.edit_outlined, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfileScreen()),
              );
            }),
            _buildSettingItemData(Translations.get('my_info', lang), Icons.person_outline, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyInfoScreen()),
              );
            }),
            _buildSettingItemData(Translations.get('change_password', lang), Icons.lock_outline, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
              );
            }),
          ],
        ),
        SizedBox(height: 16),
        _buildSettingsGroup(
          Translations.get('reservations_favorites', lang),
          [
            _buildSettingItemData(Translations.get('my_reservations', lang), Icons.hotel_outlined, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReservationsScreen()),
              );
            }),
            _buildSettingItemData(Translations.get('my_favorites', lang), Icons.favorite_outline, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesScreen()),
              );
            }),
            _buildSettingItemData(Translations.get('history', lang), Icons.history, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryScreen()),
              );
            }),
          ],
        ),
        SizedBox(height: 16),
        _buildSettingsGroup(
          Translations.get('preferences', lang),
          [
            _buildSettingItemData(Translations.get('notifications', lang), Icons.notifications_outlined, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsScreen()),
              );
            }, 
              hasSwitch: true, switchValue: _notificationsEnabled, onSwitchChanged: (value) {
                setState(() => _notificationsEnabled = value);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(value ? 'Notifications activées' : 'Notifications désactivées'),
                    backgroundColor: value ? Colors.green : Colors.orange,
                  ),
                );
              }),
            _buildSettingItemData(Translations.get('language', lang), Icons.language, () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LanguageScreen()),
              );
              if (result != null) {
                final provider = Provider.of<AppProvider>(context, listen: false);
                provider.changeLanguage(result['code']);
                setState(() {
                  _selectedLanguage = result['name'];
                });
              }
            }, subtitle: _selectedLanguage),
            _buildSettingItemData(Translations.get('currency', lang), Icons.attach_money, () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CurrencyScreen()),
              );
              if (result != null) {
                setState(() {
                  _selectedCurrency = '${result['flag']} ${result['currency']}';
                });
              }
            }, subtitle: _selectedCurrency),
          ],
        ),
        SizedBox(height: 16),
        _buildSettingsGroup(
          Translations.get('support', lang),
          [
            _buildSettingItemData(Translations.get('help_faq', lang), Icons.help_outline, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpScreen()),
              );
            }),
            _buildSettingItemData(Translations.get('contact_us', lang), Icons.email_outlined, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactScreen()),
              );
            }),
            _buildSettingItemData(Translations.get('about', lang), Icons.info_outline, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutScreen()),
              );
            }),
          ],
        ),
        SizedBox(height: 16),
        _buildSettingsGroup(
          '',
          [
            _buildSettingItemData(Translations.get('logout', lang), Icons.logout, () {
              _showLogoutDialog();
            }, isDestructive: true),
          ],
        ),
      ],
    );
  }

  Widget _buildSettingsGroup(String title, List<Map<String, dynamic>> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Column(
              children: [
                if (index > 0 && title.isNotEmpty) Divider(height: 1, indent: 60),
                _buildSettingItem(
                  item['title'],
                  item['icon'],
                  item['onTap'],
                  isDestructive: item['isDestructive'] ?? false,
                  hasSwitch: item['hasSwitch'] ?? false,
                  switchValue: item['switchValue'],
                  onSwitchChanged: item['onSwitchChanged'],
                  subtitle: item['subtitle'],
                ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Map<String, dynamic> _buildSettingItemData(
    String title,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
    bool hasSwitch = false,
    bool? switchValue,
    Function(bool)? onSwitchChanged,
    String? subtitle,
  }) {
    return {
      'title': title,
      'icon': icon,
      'onTap': onTap,
      'isDestructive': isDestructive,
      'hasSwitch': hasSwitch,
      'switchValue': switchValue,
      'onSwitchChanged': onSwitchChanged,
      'subtitle': subtitle,
    };
  }

  Widget _buildSettingItem(
    String title,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
    bool hasSwitch = false,
    bool? switchValue,
    Function(bool)? onSwitchChanged,
    String? subtitle,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: hasSwitch ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDestructive
                    ? Colors.red.withOpacity(0.1)
                    : Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isDestructive ? Colors.red : Colors.blue.shade600,
                  size: 22,
                ),
              ),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: isDestructive ? Colors.red : Colors.grey.shade800,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (hasSwitch)
                Switch(
                  value: switchValue ?? true,
                  onChanged: onSwitchChanged ?? (value) {},
                  activeColor: Colors.blue.shade600,
                )
              else
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey.shade400,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditProfileDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Modifier le profil',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Nom complet',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Téléphone',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('Annuler'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Profil mis à jour avec succès'),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('Enregistrer', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.logout, color: Colors.red),
            SizedBox(width: 12),
            Text('Se déconnecter'),
          ],
        ),
        content: Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              // Déconnexion via le provider
              final provider = Provider.of<AppProvider>(context, listen: false);
              await provider.logout();

              // Navigation vers l'écran de login
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('Se déconnecter', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
