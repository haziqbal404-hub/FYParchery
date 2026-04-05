import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'theme.dart';

// Import all the pages we created
import 'pages/login_page.dart';
import 'pages/coach_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ArcheryMentalStateApp());
}

class ArcheryMentalStateApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Archery Mental Edge',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: ArcheryColors.forestGreen,
        scaffoldBackgroundColor: ArcheryColors.carbonBlack,
        colorScheme: ColorScheme.dark(
          primary: ArcheryColors.forestGreen,
          secondary: ArcheryColors.targetGold,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: ArcheryColors.forestGreen,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontSize: 20,
          ),
        ),
      ),
      // The Root widget decides where to send the user
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 1. Listen to Authentication State (Is user logged in?)
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator(color: ArcheryColors.targetGold)));
        }

        if (snapshot.hasData) {
          // 2. User is logged in, now check their Role in Firestore
          return RoleRedirector(uid: snapshot.data!.uid);
        }

        // 3. User is not logged in
        return LoginPage();
      },
    );
  }
}

// Inside lib/main.dart
class RoleRedirector extends StatelessWidget {
  final String uid;
  RoleRedirector({required this.uid});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      // CHANGE THIS: If your Firestore collection is named 'archers', use 'archers'
      future: FirebaseFirestore.instance.collection('users').doc(uid).get(), 
      builder: (context, snapshot) {
        // ... rest of the code
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator(color: ArcheryColors.targetGold)));
        }

        if (snapshot.hasData && snapshot.data!.exists) {
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          String role = userData['role'] ?? 'archer';

          if (role == 'coach') {
            return CoachDashboard();
          } else {
            // Placeholder for Archer's own view (if they log in themselves)
            return ArcherSelfView(); 
          }
        }

        // If something goes wrong, back to login
        return LoginPage();
      },
    );
  }
}

// Simple placeholder for when an Archer logs in
class ArcherSelfView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MY MENTAL STATE"),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: () => FirebaseAuth.instance.signOut())
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 80, color: ArcheryColors.targetBlue),
            SizedBox(height: 20),
            Text("Welcome, Archer!", style: TextStyle(fontSize: 22, color: Colors.white)),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("Your coach is currently monitoring your performance.", textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}