// lib/models/performance_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class PerformanceRecord {
  final double score; // The mental state reading (e.g., 0.0 to 100.0)
  final DateTime date;

  PerformanceRecord({required this.score, required this.date});

  // To convert Firestore data into this Model
  factory PerformanceRecord.fromFirestore(DocumentSnapshot doc) {
    return PerformanceRecord(
      score: (doc['score'] ?? 0.0).toDouble(),
      date: (doc['timestamp'] as Timestamp).toDate(),
    );
  }
}