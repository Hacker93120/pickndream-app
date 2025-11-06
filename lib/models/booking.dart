import 'hotel.dart';

enum BookingStatus { pending, confirmed, cancelled, completed }

class Booking {
  final String id;
  final Hotel hotel;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final double totalPrice;
  final BookingStatus status;
  final DateTime bookingDate;
  final String guestName;
  final String guestEmail;

  Booking({
    required this.id,
    required this.hotel,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.totalPrice,
    required this.status,
    required this.bookingDate,
    required this.guestName,
    required this.guestEmail,
  });

  int get nights => checkOut.difference(checkIn).inDays;
}
