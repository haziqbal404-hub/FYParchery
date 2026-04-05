import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme.dart';

class MonitorStudentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String coachId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: ArcheryColors.carbonBlack,
      appBar: AppBar(title: Text("STUDENT MENTAL STATE"), backgroundColor: ArcheryColors.targetRed),
      body: StreamBuilder<QuerySnapshot>(
        // Only get students belonging to THIS coach
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'archer')
            .where('coachId', isEqualTo: coachId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          
          var docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(child: Text("No students registered yet.", style: TextStyle(color: Colors.white)));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var data = docs[index].data() as Map<String, dynamic>;
              double hz = (data['latestHz'] ?? 0.0).toDouble();
              
              // 12-15 Hz Logic for UI
              bool isFocused = (hz >= 12.0 && hz <= 15.0);
              
              return Card(
                color: Colors.grey[900],
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: ListTile(
                  leading: Icon(
                    Icons.track_changes, 
                    color: isFocused ? Colors.greenAccent : ArcheryColors.targetRed,
                    size: 40,
                  ),
                  title: Text(data['name'] ?? "Unknown", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text("Level: ${data['level'] ?? 'N/A'}", style: TextStyle(color: Colors.grey)),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${hz.toStringAsFixed(1)} Hz", 
                        style: TextStyle(color: ArcheryColors.targetGold, fontWeight: FontWeight.bold, fontSize: 18)),
                      Text(isFocused ? "READY" : "NOT READY", 
                        style: TextStyle(color: isFocused ? Colors.green : Colors.red, fontSize: 10)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}