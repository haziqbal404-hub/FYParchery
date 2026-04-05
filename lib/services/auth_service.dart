// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Function to Register a Coach
  Future<String?> registerCoach({
    required String email,
    required String password,
    required String name,
    required String age,
    required String country,
    required String company,
    required String phone,
  }) async {
    try {
      // 1. Create the user in Firebase Authentication
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      // 2. Save the extra details (name, country, etc.) in Firestore
      if (user != null) {
        await _db.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'email': email,
          'age': age,
          'country': country,
          'company': company,
          'phoneNumber': phone,
          'role': 'coach', // We hardcode this so we know they are a coach
        });
      }
      return null; // Return null if everything is successful
    } catch (e) {
      return e.toString(); // Return the error message if something fails
    }
  }
}
