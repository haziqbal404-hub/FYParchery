import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth/login_page.dart';
import 'register_student_page.dart';
import 'student_list_page.dart';

class CoachDashboard extends StatefulWidget {
  const CoachDashboard({super.key});

  @override
  State<CoachDashboard> createState() => _CoachDashboardState();
}

class _CoachDashboardState extends State<CoachDashboard> {
  String coachName = "Loading...";

  @override
  void initState() {
    super.initState();
    _getCoachData();
  }

  // Fetch the coach's name from Firestore
  void _getCoachData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        coachName = doc['name'] ?? "Coach";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Coach Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello Coach $coachName",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),

            // Button 1: New Student Registration
            ElevatedButton.icon(
              onPressed: () {
                // Pass the current coach's UID to the registration page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterStudentPage(
                      coachId: FirebaseAuth.instance.currentUser!.uid,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.person_add),
              label: const Text("New Student Registration"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            // Button 2: Students Performance
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StudentListPage(),
                  ),
                );
              },
              icon: const Icon(Icons.bar_chart),
              label: const Text("Students Performance"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
