import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:archery2/screens/auth/login_page.dart';

void main() async {
  // This ensures all Flutter widgets are loaded before starting Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // This initializes the connection to your Firebase project
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Archery Mental Prep',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green, // Archery theme!
      ),
      home: const LoginPage(),
    );
  }
}
