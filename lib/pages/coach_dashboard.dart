import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme.dart';
import 'register_student_page.dart';
import 'monitor_students_page.dart';

class CoachDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ArcheryColors.carbonBlack,
      appBar: AppBar(
        title: Text("COACH CONTROL CENTER"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _dashboardButton(
              context, 
              "REGISTER NEW STUDENT", 
              Icons.person_add, 
              ArcheryColors.targetBlue,
              () => Navigator.push(context, MaterialPageRoute(builder: (c) => RegisterStudentPage()))
            ),
            SizedBox(height: 20),
            _dashboardButton(
              context, 
              "MONITOR STUDENT RECORDS", 
              Icons.analytics, 
              ArcheryColors.targetRed,
              () => Navigator.push(context, MaterialPageRoute(builder: (c) => MonitorStudentsPage()))
            ),
          ],
        ),
      ),
    );
  }

  Widget _dashboardButton(BuildContext context, String title, IconData icon, Color col, VoidCallback tap) {
    return InkWell(
      onTap: tap,
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(color: col, borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            SizedBox(height: 10),
            Text(title, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}