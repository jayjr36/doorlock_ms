import 'package:flutter/material.dart';
import 'package:guest_ms/providers/auth_providers.dart';
import 'package:guest_ms/screens/home_screen.dart';
import 'package:guest_ms/screens/login_screen.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
   // ChangeNotifierProvider(
   //   create: (context) => AuthProvider(),
       MyApp(),
    //),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guest House Management System',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: LoginScreen(),
      routes: {
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
