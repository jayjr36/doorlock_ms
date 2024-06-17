// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:guest_ms/providers/auth_providers.dart';
import 'package:guest_ms/screens/bookings.dart';
import 'package:guest_ms/screens/rooms.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const Center(
            child: Text('Welcome to the Home Screen!'),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const RoomSelectionPage())));
              },
              child: const Text('ROOMS')),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const BookingsScreen())));
              },
              child: const Text('BOOKINGS'))
        ],
      ),
    );
  }
}
