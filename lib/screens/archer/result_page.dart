import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';
import 'tips_page.dart';

class ResultPage extends StatefulWidget {
  final bool isReady;
  final double score; // Receive the score

  const ResultPage({super.key, required this.isReady, required this.score});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final AuthService _authService = AuthService();
  bool _isSaved = false;

  void _handleSave() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    await _authService.savePerformanceRecord(
      studentId: uid,
      score: widget.score,
    );
    setState(() => _isSaved = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Performance Recorded Successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Analysis Result")),
      backgroundColor: widget.isReady
          ? Colors.green.shade400
          : Colors.red.shade400,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Focus Score: ${widget.score.toStringAsFixed(1)}%",
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Icon(
                widget.isReady
                    ? Icons.check_circle_outline
                    : Icons.error_outline,
                size: 80,
                color: Colors.white,
              ),
              const SizedBox(height: 10),
              Text(
                widget.isReady ? "READY" : "NOT READY",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),

              // NEW: SAVE BUTTON
              ElevatedButton.icon(
                onPressed: _isSaved ? null : _handleSave,
                icon: Icon(_isSaved ? Icons.cloud_done : Icons.save),
                label: Text(_isSaved ? "Saved to Profile" : "Save This Record"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                ),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TipsPage()),
                ),
                child: const Text("View Training Tips"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
