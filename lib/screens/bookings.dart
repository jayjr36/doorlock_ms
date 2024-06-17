import 'package:flutter/material.dart';
import 'package:guest_ms/services/auth_services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  BookingsScreenState createState() => BookingsScreenState();
}

class BookingsScreenState extends State<BookingsScreen> {
  String? token;
  AuthService apiService = AuthService();
  late Future<List<dynamic>> _futureBookings;

  @override
  void initState() {
    super.initState();
    loadpreferences();
  }

  loadpreferences() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    _futureBookings = apiService.fetchUserBookings(token!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _futureBookings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No bookings found'));
          } else {
            List<dynamic> bookings = snapshot.data!;
            return ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                Booking booking = Booking.fromJson(bookings[index]);
                return ListTile(
                  title: Text('Room ${booking.roomId}'),
                  subtitle: Text(
                      'Password: ${booking.password}\nExpires at: ${DateFormat.yMd().add_jm().format(DateTime.parse(booking.expiresAt))}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class Booking {
  final int id;
  final int roomId;
  final String password;
  final String expiresAt;

  Booking({
    required this.id,
    required this.roomId,
    required this.password,
    required this.expiresAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      roomId: json['room_id'],
      password: json['password'],
      expiresAt: json['expires_at'],
    );
  }
}
