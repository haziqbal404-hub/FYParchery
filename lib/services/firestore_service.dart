import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // inside lib/firestore_service.dart

  Future<void> addBrainwaveReading(String uid, double hz) async {
    String status = (hz >= 8.0 && hz <= 12.0) ? 'Ready' : 'Not Ready';
    
    // 1. Add to history (keep this so we have the graph data)
    await _db.collection('archers').doc(uid).collection('readings').add({
      'hz': hz,
      'status': status,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // 2. NEW: Update the Main Profile with the "Latest" status
    // This allows the Coach list to see it immediately.
    await _db.collection('archers').doc(uid).update({
      'latestStatus': status,
      'latestHz': hz,
      'latestTimestamp': FieldValue.serverTimestamp(),
    });
  }

  // 2. Get All Archers (For Coach)
  Stream<QuerySnapshot> getArchers() {
    return _db.collection('archers').where('role', isEqualTo: 'archer').snapshots();
  }

  // 3. Get Readings for specific Archer (For Graph)
  Stream<QuerySnapshot> getReadings(String uid) {
    return _db
        .collection('archers')
        .doc(uid)
        .collection('readings')
        .orderBy('timestamp', descending: true) // Newest first
        .snapshots();
  }
  // 4. Delete Archer
  Future<void> deleteArcher(String uid) async {
    // Delete the main profile document
    await _db.collection('archers').doc(uid).delete();
    
    // Note: This removes them from the list. 
    // Their historical "readings" sub-collection technically remains in Firebase 
    // but is no longer accessible via the app, which is fine for this app.
  }
}
