import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Ahmed Benali');
  final _emailController = TextEditingController(text: 'ahmed.benali@email.com');
  final _phoneController = TextEditingController(text: '+212 6 12 34 56 78');
  final _birthdateController = TextEditingController(text: '15/03/1990');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('Modifier le profil'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: Text('Sauvegarder', style: TextStyle(color: Colors.blue.shade600, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Photo de profil
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/profile.png'),
                      backgroundColor: Colors.grey.shade200,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _changeProfilePicture,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade600,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              
              // Formulaire
              _buildTextField('Nom complet', _nameController, Icons.person),
              SizedBox(height: 16),
              _buildTextField('Email', _emailController, Icons.email, keyboardType: TextInputType.emailAddress),
              SizedBox(height: 16),
              _buildTextField('Téléphone', _phoneController, Icons.phone, keyboardType: TextInputType.phone),
              SizedBox(height: 16),
              _buildTextField('Date de naissance', _birthdateController, Icons.cake, readOnly: true, onTap: _selectBirthdate),
              SizedBox(height: 32),
              
              // Bouton sauvegarder
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Sauvegarder les modifications', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ce champ est requis';
        }
        return null;
      },
    );
  }

  void _changeProfilePicture() {
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
            Text('Changer la photo de profil', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.camera_alt, color: Colors.blue.shade600),
              title: Text('Prendre une photo'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: Colors.blue.shade600),
              title: Text('Choisir dans la galerie'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Supprimer la photo'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _selectBirthdate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(1990, 3, 15),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      _birthdateController.text = '${date.day}/${date.month}/${date.year}';
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profil mis à jour avec succès'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }
}
