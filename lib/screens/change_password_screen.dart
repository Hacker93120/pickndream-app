import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('Changer le mot de passe'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info sécurité
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.security, color: Colors.blue.shade600),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sécurité du mot de passe',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                          Text(
                            'Utilisez au moins 8 caractères avec des lettres, chiffres et symboles',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              
              // Mot de passe actuel
              Text(
                'Mot de passe actuel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _currentPasswordController,
                obscureText: !_showCurrentPassword,
                decoration: InputDecoration(
                  hintText: 'Entrez votre mot de passe actuel',
                  prefixIcon: Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_showCurrentPassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _showCurrentPassword = !_showCurrentPassword),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre mot de passe actuel';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              
              // Nouveau mot de passe
              Text(
                'Nouveau mot de passe',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _newPasswordController,
                obscureText: !_showNewPassword,
                decoration: InputDecoration(
                  hintText: 'Entrez votre nouveau mot de passe',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_showNewPassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _showNewPassword = !_showNewPassword),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nouveau mot de passe';
                  }
                  if (value.length < 8) {
                    return 'Le mot de passe doit contenir au moins 8 caractères';
                  }
                  return null;
                },
                onChanged: (value) => setState(() {}),
              ),
              SizedBox(height: 16),
              
              // Indicateur de force du mot de passe
              _buildPasswordStrengthIndicator(_newPasswordController.text),
              SizedBox(height: 24),
              
              // Confirmer le mot de passe
              Text(
                'Confirmer le nouveau mot de passe',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: !_showConfirmPassword,
                decoration: InputDecoration(
                  hintText: 'Confirmez votre nouveau mot de passe',
                  prefixIcon: Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_showConfirmPassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _showConfirmPassword = !_showConfirmPassword),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez confirmer votre mot de passe';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Les mots de passe ne correspondent pas';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              
              // Boutons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Annuler'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _changePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Changer', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordStrengthIndicator(String password) {
    int strength = _calculatePasswordStrength(password);
    Color color;
    String text;
    
    switch (strength) {
      case 0:
        color = Colors.grey;
        text = '';
        break;
      case 1:
        color = Colors.red;
        text = 'Faible';
        break;
      case 2:
        color = Colors.orange;
        text = 'Moyen';
        break;
      case 3:
        color = Colors.green;
        text = 'Fort';
        break;
      default:
        color = Colors.grey;
        text = '';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: strength / 3,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
        if (password.isNotEmpty) ...[
          SizedBox(height: 8),
          Text(
            _getPasswordRequirements(password),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ],
    );
  }

  int _calculatePasswordStrength(String password) {
    if (password.isEmpty) return 0;
    
    int score = 0;
    if (password.length >= 8) score++;
    if (password.contains(RegExp(r'[A-Z]')) && password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[0-9]')) && password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;
    
    return score;
  }

  String _getPasswordRequirements(String password) {
    List<String> requirements = [];
    if (password.length < 8) requirements.add('8 caractères minimum');
    if (!password.contains(RegExp(r'[A-Z]'))) requirements.add('une majuscule');
    if (!password.contains(RegExp(r'[a-z]'))) requirements.add('une minuscule');
    if (!password.contains(RegExp(r'[0-9]'))) requirements.add('un chiffre');
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) requirements.add('un symbole');
    
    if (requirements.isEmpty) {
      return 'Mot de passe sécurisé ✓';
    } else {
      return 'Manque: ${requirements.join(', ')}';
    }
  }

  void _changePassword() {
    if (_formKey.currentState!.validate()) {
      // Simuler le changement de mot de passe
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 12),
              Text('Succès'),
            ],
          ),
          content: Text('Votre mot de passe a été changé avec succès.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('OK', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }
  }
}
