import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 1. REGISTER COACH (Requirement #5)
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
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      if (user != null) {
        await _db.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'email': email,
          'age': age,
          'country': country,
          'company': company,
          'phoneNumber': phone,
          'role': 'coach',
        });
      }
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // 2. LOGIN (Requirement #4)
  Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // 3. REGISTER STUDENT (Requirement #7)
  // Note: This links the student to the coach using 'coachId'
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
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      if (user != null) {
        await _db.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'email': email,
          'age': age,
          'gender': gender,
          'level': level,
          'coachId': coachId,
          'role': 'student',
        });
      }
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // 4. SIGNOUT (For logout buttons)
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // 5. SAVE PERFORMANCE RECORD (For Manual/Bluetooth Results)
  // This saves data into a sub-collection so the Coach can see the history
  Future<void> savePerformanceRecord({
    required String studentId,
    required double score,
  }) async {
    try {
      await _db
          .collection('users')
          .doc(studentId)
          .collection('performances')
          .add({
            'score': score,
            'timestamp':
                FieldValue.serverTimestamp(), // Records date automatically
          });
    } catch (e) {
      print("Error saving record: $e");
    }
  }
}
