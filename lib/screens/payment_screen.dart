import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import '../models/subscription.dart';
import '../models/hotel.dart';
import '../providers/app_provider.dart';
import '../widgets/wave_header.dart';
import '../services/stripe_service.dart';

class PaymentScreen extends StatefulWidget {
  final Subscription? subscription;
  final Hotel? hotel;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final int? guests;
  final double? totalPrice;

  const PaymentScreen({
    Key? key, 
    this.subscription,
    this.hotel,
    this.checkInDate,
    this.checkOutDate,
    this.guests,
    this.totalPrice,
  }) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  bool _acceptedTerms = false;
  bool _isProcessing = false;
  String _paymentMethod = 'card'; // 'card' ou 'paypal'

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          WaveHeader(
            height: 160,
            child: Center(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.credit_card, size: 48, color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Résumé de l'abonnement
                    _buildSubscriptionSummary(),
                    SizedBox(height: 16),

                    // Méthode de paiement
                    Text(
                      'Méthode de paiement',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildPaymentMethodSelector(),
                    SizedBox(height: 16),

                    // Formulaire de carte bancaire
                    if (_paymentMethod == 'card') ...[
                      _buildCardForm(),
                    ] else ...[
                      _buildPayPalButton(),
                    ],

                    SizedBox(height: 16),

                    // Conditions générales
                    _buildTermsCheckbox(),
                    SizedBox(height: 12),

                    // Bouton de paiement
                    _buildPaymentButton(),

                    SizedBox(height: 10),

                    // Sécurité
                    _buildSecurityBadges(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionSummary() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade600],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.home_work, color: Colors.white, size: 24),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.subscription?.name ?? 'Abonnement',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Paiement mensuel',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${(widget.subscription?.price ?? 0.0).toStringAsFixed(2)}€',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '/mois',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Row(
      children: [
        Expanded(
          child: _buildPaymentMethodOption(
            'card',
            Icons.credit_card,
            'Carte bancaire',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildPaymentMethodOption(
            'paypal',
            Icons.account_balance,
            'PayPal',
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodOption(String method, IconData icon, String label) {
    final isSelected = _paymentMethod == method;
    return GestureDetector(
      onTap: () {
        setState(() {
          _paymentMethod = method;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue.shade600 : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.blue.shade600 : Colors.grey.shade600,
              size: 28,
            ),
            SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.blue.shade800 : Colors.grey.shade700,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Numéro de carte
        TextFormField(
          controller: _cardNumberController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(16),
            _CardNumberFormatter(),
          ],
          decoration: InputDecoration(
            labelText: 'Numéro de carte',
            hintText: '1234 5678 9012 3456',
            prefixIcon: Icon(Icons.credit_card, size: 20),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Numéro requis';
            }
            if (value.replaceAll(' ', '').length != 16) {
              return '16 chiffres requis';
            }
            return null;
          },
        ),
        SizedBox(height: 12),

        // Titulaire
        TextFormField(
          controller: _cardHolderController,
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(
            labelText: 'Titulaire',
            hintText: 'JEAN DUPONT',
            prefixIcon: Icon(Icons.person, size: 20),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Nom requis';
            }
            return null;
          },
        ),
        SizedBox(height: 12),

        // Date d'expiration et CVV
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _expiryController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                  _ExpiryDateFormatter(),
                ],
                decoration: InputDecoration(
                  labelText: 'Expiration',
                  hintText: 'MM/AA',
                  prefixIcon: Icon(Icons.calendar_today, size: 18),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Requis';
                  }
                  if (value.length != 5) {
                    return 'MM/AA';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: _cvvController,
                keyboardType: TextInputType.number,
                obscureText: true,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                decoration: InputDecoration(
                  labelText: 'CVV',
                  hintText: '123',
                  prefixIcon: Icon(Icons.lock, size: 18),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Requis';
                  }
                  if (value.length != 3) {
                    return '3 chiffres';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPayPalButton() {
    return GestureDetector(
      onTap: _processPayPalPayment,
      child: Container(
        width: double.infinity,
        height: 140,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0070BA), Color(0xFF003087)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance, size: 48, color: Colors.white),
            SizedBox(height: 12),
            Text(
              'Payer avec PayPal',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Paiement sécurisé',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _acceptedTerms,
          onChanged: (value) {
            setState(() {
              _acceptedTerms = value ?? false;
            });
          },
          activeColor: Colors.blue.shade600,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _acceptedTerms = !_acceptedTerms;
              });
            },
            child: Padding(
              padding: EdgeInsets.only(top: 12),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                  children: [
                    TextSpan(text: 'J\'accepte les '),
                    TextSpan(
                      text: 'conditions générales',
                      style: TextStyle(
                        color: Colors.blue.shade600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    TextSpan(text: ' et la '),
                    TextSpan(
                      text: 'politique de confidentialité',
                      style: TextStyle(
                        color: Colors.blue.shade600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentButton() {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _acceptedTerms
              ? [Colors.green.shade600, Colors.green.shade400]
              : [Colors.grey.shade400, Colors.grey.shade300],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: _acceptedTerms
            ? [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ]
            : [],
      ),
      child: ElevatedButton(
        onPressed: _acceptedTerms && !_isProcessing ? _processPayment : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          disabledBackgroundColor: Colors.transparent,
        ),
        child: _isProcessing
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock, color: Colors.white, size: 20),
                  SizedBox(width: 10),
                  Text(
                    'PAYER ${(widget.subscription?.price ?? widget.totalPrice ?? 0.0).toStringAsFixed(2)}€',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSecurityBadges() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.verified_user, color: Colors.green.shade600, size: 16),
            SizedBox(width: 6),
            Text(
              'Paiement 100% sécurisé',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSecurityBadge('SSL'),
            SizedBox(width: 6),
            _buildSecurityBadge('3D Secure'),
            SizedBox(width: 6),
            _buildSecurityBadge('PCI DSS'),
          ],
        ),
      ],
    );
  }

  Widget _buildSecurityBadge(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  void _processPayment() async {
    if (_paymentMethod == 'paypal') {
      _processPayPalPayment();
      return;
    }

    if (_paymentMethod == 'card' && !_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    bool success = false;
    String message = '';

    try {
      // Paiement Stripe pour carte bancaire
      final amount = widget.subscription?.price ?? widget.totalPrice ?? 0.0;
      final description = widget.hotel != null 
          ? 'Réservation ${widget.hotel!.name}'
          : 'Abonnement ${widget.subscription?.name ?? ""}';

      success = await StripeService.processPayment(
        amount: amount,
        currency: 'EUR',
        description: description,
      );
      
      if (success) {
        message = widget.hotel != null 
            ? 'Réservation confirmée avec succès'
            : 'Abonnement activé avec succès';
            
        // Activer l'abonnement si c'est un abonnement
        if (widget.subscription != null) {
          context.read<AppProvider>().setSubscription(widget.subscription!);
        }
      } else {
        message = 'Paiement annulé ou échoué';
      }
    } catch (e) {
      success = false;
      message = 'Erreur: ${e.toString()}';
    }

    setState(() {
      _isProcessing = false;
    });

    if (!mounted) return;

    // Afficher le résultat
    if (success) {
      _showSuccessDialog(message);
    } else {
      _showErrorDialog(message);
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: Colors.green.shade600,
                size: 64,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Paiement réussi !',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
            ),
            SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le dialog
                if (widget.subscription != null) {
                  Navigator.of(context).pop(); // Retour à subscription screen
                  Navigator.of(context).pop(); // Retour à home
                } else {
                  Navigator.of(context).pop(); // Retour à hotel detail
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: Text(
                'Continuer',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                color: Colors.red.shade600,
                size: 64,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Paiement échoué',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade800,
              ),
            ),
            SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: Text(
                'Réessayer',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _processPayPalPayment() async {
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez accepter les conditions générales'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final amount = widget.subscription?.price ?? widget.totalPrice ?? 0.0;
    final description = widget.hotel != null 
        ? 'Réservation ${widget.hotel!.name}'
        : 'Abonnement ${widget.subscription?.name}';

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PaypalCheckoutView(
          sandboxMode: true,
          clientId: "AZ3z5bTPovhDiK4UUjQfnGkI0bzU1TPtI0_f09_8Fp3ia1g5rYHSt27zEbyzYWjg6K75qr-tFCY10GDD",
          secretKey: "ENxwRtXB-f6qYpQy_-hlT-p3S81BZ0yZ_yGc7YKi0P9GPnuBQLJRlp8hXOXf2QhWIRtUDOo5Sl2XMLuv",
          transactions: [
            {
              "amount": {
                "total": amount.toStringAsFixed(2),
                "currency": "EUR",
                "details": {
                  "subtotal": amount.toStringAsFixed(2),
                  "shipping": '0',
                  "shipping_discount": 0
                }
              },
              "description": description,
              "item_list": {
                "items": [
                  {
                    "name": widget.hotel?.name ?? widget.subscription?.name ?? "Service",
                    "quantity": 1,
                    "price": amount.toStringAsFixed(2),
                    "currency": "EUR"
                  }
                ],
              }
            }
          ],
          note: "Merci pour votre achat PicknDream",
          onSuccess: (Map params) async {
            Navigator.pop(context);
            await _handlePayPalSuccess(params);
          },
          onError: (error) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erreur PayPal: $error'), backgroundColor: Colors.red),
            );
          },
          onCancel: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Paiement annulé'), backgroundColor: Colors.orange),
            );
          },
        ),
      ),
    );
  }

  Future<void> _handlePayPalSuccess(Map paypalData) async {
    setState(() => _isProcessing = true);
    
    if (widget.subscription != null) {
      context.read<AppProvider>().setSubscription(widget.subscription!);
    }
    
    setState(() => _isProcessing = false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.green.shade100, shape: BoxShape.circle),
              child: Icon(Icons.check_circle, color: Colors.green.shade600, size: 64),
            ),
            SizedBox(height: 24),
            Text(
              widget.hotel != null ? 'Réservation confirmée !' : 'Paiement PayPal réussi !',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green.shade800)
            ),
            SizedBox(height: 12),
            Text(
              widget.hotel != null 
                  ? 'Votre réservation a été confirmée.'
                  : 'Votre abonnement vendeur est maintenant actif.',
              textAlign: TextAlign.center, 
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700)
            ),
            if (widget.subscription != null) ...[
              SizedBox(height: 8),
              Text('0% de commission sur vos ventes !', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue.shade700)),
            ],
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                if (widget.subscription != null) Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12)),
              child: Text(
                widget.hotel != null ? 'Retour' : 'Commencer', 
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Formatteur pour le numéro de carte (1234 5678 9012 3456)
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i + 1 != text.length) {
        buffer.write(' ');
      }
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

// Formatteur pour la date d'expiration (MM/AA)
class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll('/', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if (i == 1 && text.length > 2) {
        buffer.write('/');
      }
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
