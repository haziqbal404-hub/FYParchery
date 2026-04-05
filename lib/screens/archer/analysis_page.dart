import 'package:flutter/material.dart';
//import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'result_page.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  bool _isManualMode = true; // Default to manual for testing
  final _scoreController = TextEditingController();

  bool _isConnected = false;
  bool _isScanning = false;
  bool _isReading = false;
  double _readingProgress = 0.0;
  bool _isComplete = false;
  double _finalScore = 0.0;

  void _checkBluetooth() async {
    await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();
    setState(() => _isScanning = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isScanning = false;
      _isConnected = true;
    });
  }

  void _startAnalysis() async {
    if (_isManualMode) {
      // MANUAL LOGIC
      if (_scoreController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter a score first")),
        );
        return;
      }
      _finalScore = double.tryParse(_scoreController.text) ?? 0.0;
    } else {
      // BLUETOOTH LOGIC (Simulated)
      _finalScore = 75.0 + (DateTime.now().second % 20);
    }

    setState(() {
      _isReading = true;
      _readingProgress = 0.0;
    });

    // Simulate the "Processing" time
    for (int i = 0; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() => _readingProgress = i / 10);
    }

    setState(() {
      _isReading = false;
      _isComplete = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Analysis"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            // 1. TOGGLE SWITCH
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Bluetooth"),
                Switch(
                  value: _isManualMode,
                  onChanged: (val) => setState(() => _isManualMode = val),
                ),
                const Text("Manual Entry"),
              ],
            ),
            const SizedBox(height: 20),

            // 2. INPUT SECTION
            if (_isManualMode)
              TextField(
                controller: _scoreController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Enter Mental State Score (0-100)",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.edit),
                ),
              )
            else
              _buildBluetoothStatus(),

            const SizedBox(height: 40),

            // 3. START BUTTON
            ElevatedButton(
              onPressed:
                  (_isManualMode || _isConnected) && !_isReading && !_isComplete
                  ? _startAnalysis
                  : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
                backgroundColor: Colors.orange,
              ),
              child: const Text(
                "READY / START ANALYSIS",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),

            const SizedBox(height: 30),

            // 4. PROGRESS BAR
            if (_isReading) ...[
              const Text("Analyzing..."),
              const SizedBox(height: 10),
              LinearProgressIndicator(value: _readingProgress, minHeight: 10),
            ],

            if (_isComplete) ...[
              const Text(
                "Analysis Complete ✅",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultPage(
                        isReady: _finalScore >= 85, // Threshold is 85
                        score: _finalScore,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("VIEW RESULT"),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBluetoothStatus() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: _isConnected
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _isConnected ? Colors.green : Colors.red),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                _isConnected
                    ? Icons.bluetooth_connected
                    : Icons.bluetooth_disabled,
                color: _isConnected ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 10),
              Text(_isConnected ? "EEG Connected" : "EEG Disconnected"),
            ],
          ),
          if (!_isConnected)
            TextButton(
              onPressed: _checkBluetooth,
              child: Text(_isScanning ? "Scanning..." : "Connect Device"),
            ),
        ],
      ),
    );
  }
}
