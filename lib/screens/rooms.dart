import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:guest_ms/screens/payment_screen.dart';
import 'package:guest_ms/services/api.dart';
import 'package:http/http.dart' as http;

class RoomSelectionPage extends StatefulWidget {
  const RoomSelectionPage({super.key});

  @override
  RoomSelectionPageState createState() => RoomSelectionPageState();
}

class RoomSelectionPageState extends State<RoomSelectionPage> {
  List rooms = [];
  int selectedDays = 1;
  double pricePerDay = 100.0;

  @override
  void initState() {
    super.initState();
    fetchRooms();
  }

  void fetchRooms() async {
    final response =
        await http.get(Uri.parse(ApiServices().baseUrl + ApiServices().rooms));

    if (response.statusCode == 200) {
      setState(() {
        rooms = jsonDecode(response.body);
      });
    } else {
      // Handle error
    }
  }

  void selectRoom(BuildContext context, String room) async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              PaymentPage(room, selectedDays, pricePerDay * selectedDays)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Room')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Room ${rooms[index]['number']}'),
                  onTap: () => selectRoom(context, rooms[index]['number']),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Number of Days:'),
                const SizedBox(width: 10),
                DropdownButton<int>(
                  value: selectedDays,
                  items: List.generate(30, (index) => index + 1)
                      .map((e) => DropdownMenuItem<int>(
                            value: e,
                            child: Text('$e'),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDays = value!;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PasswordPage extends StatelessWidget {
  final String password;
  final DateTime expiryTime;

  const PasswordPage(this.password, this.expiryTime, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Password')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Password: $password'),
            CountdownTimer(expiryTime),
          ],
        ),
      ),
    );
  }
}

class CountdownTimer extends StatefulWidget {
  final DateTime expiryTime;

  const CountdownTimer(this.expiryTime, {super.key});

  @override
  CountdownTimerState createState() => CountdownTimerState();
}

class CountdownTimerState extends State<CountdownTimer> {
  Duration? remainingTime;

  @override
  void initState() {
    super.initState();
    remainingTime = widget.expiryTime.difference(DateTime.now());
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        remainingTime = widget.expiryTime.difference(DateTime.now());
        if (remainingTime!.isNegative) {
          timer.cancel();
          // Revert to default password
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
        'Time remaining: ${remainingTime!.inMinutes}:${remainingTime!.inSeconds % 60}');
  }
}
