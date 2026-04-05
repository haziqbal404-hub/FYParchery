import 'package:flutter/material.dart';

class TipsPage extends StatelessWidget {
  const TipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Neurofeedback Training Tips"),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildTipCard(
            "1. Breathing Technique",
            "Focus on deep diaphragmatic breathing. Inhale for 4 seconds, hold for 2, and exhale for 6. This lowers your heart rate and stabilizes your mental state for the shot.",
          ),
          _buildTipCard(
            "2. Imaginary Technique",
            "Close your eyes and visualize the perfect shot. See the arrow hitting the yellow center. Feel the tension in the bow and the release. Mental rehearsal primes your brain for success.",
          ),
          _buildTipCard(
            "3. Brain Activation",
            "Engage in 'Quiet Eye' training. Fix your gaze intensely on the target before drawing the bow. This helps switch your brain into a high-concentration Alpha-wave state.",
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard(String title, String description) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10),
            Text(description, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
