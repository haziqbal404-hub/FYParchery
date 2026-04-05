import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

// Sign Up Coach
  Future<String?> signUpCoach({
    required String email,
    required String password,
    required String name,
    required String age,
    required String country,
    required String company,
    required String phone,
  }) async {
    // ... logic remains same as provided in previous message

    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      
      await _db.collection('users').doc(result.user!.uid).set({
        'uid': result.user!.uid,
        'name': name,
        'age': age,
        'country': country,
        'company': company,
        'phone': phone,
        'email': email,
        'role': 'coach',
      });
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // Coach Registers a Student
  // Note: This creates a record in Firestore. 
  // In a real app, you'd use a Cloud Function to create the Auth account 
  // without logging the coach out. For now, we store the student profile.
  Future<String?> registerStudent({
    required String email,
    required String password,
    required String name,
    required String age,
    required String gender,
    required String level,
    required String coachId,
  }) async {
    try {
      // Create student record linked to this coach
      DocumentReference studentDoc = _db.collection('users').doc(); 
      await studentDoc.set({
        'uid': studentDoc.id,
        'name': name,
        'age': age,
        'gender': gender,
        'level': level,
        'email': email,
        'password': password, // Stored so student can login later
        'role': 'archer',
        'coachId': coachId, // Linked to the coach who created them
        'latestHz': 0.0,
        'latestStatus': 'No Data',
      });
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  void signOut() => _auth.signOut();
}