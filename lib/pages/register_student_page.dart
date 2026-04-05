import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../theme.dart';

class RegisterStudentPage extends StatefulWidget {
  @override
  _RegisterStudentPageState createState() => _RegisterStudentPageState();
}

class _RegisterStudentPageState extends State<RegisterStudentPage> {
  final _auth = AuthService();
  String _level = 'Beginner';
  final controllers = List.generate(4, (i) => TextEditingController()); // Name, Age, Gender, Email

  void _register() async {
    String? err = await _auth.registerStudent(
      name: controllers[0].text,
      age: controllers[1].text,
      gender: controllers[2].text,
      email: controllers[3].text,
      password: "student123", // Default password
      level: _level,
      coachId: FirebaseAuth.instance.currentUser!.uid,
    );
    if (err == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Student Successfully Registered!")));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ArcheryColors.carbonBlack,
      appBar: AppBar(title: Text("ADD NEW ARCHER"), backgroundColor: ArcheryColors.targetBlue),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            _buildField(controllers[0], "Student Full Name", Icons.person),
            _buildField(controllers[1], "Age", Icons.cake),
            _buildField(controllers[2], "Gender", Icons.face),
            _buildField(controllers[3], "Email Address", Icons.email),
            SizedBox(height: 10),
            DropdownButtonFormField(
              value: _level,
              dropdownColor: ArcheryColors.carbonBlack,
              style: TextStyle(color: Colors.white),
              items: ['Beginner', 'Intermediate', 'Professional'].map((l) => 
                DropdownMenuItem(value: l, child: Text(l))).toList(),
              onChanged: (val) => setState(() => _level = val.toString()),
              decoration: InputDecoration(labelText: "Skill Level", labelStyle: TextStyle(color: Colors.grey)),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _register,
              style: ElevatedButton.styleFrom(backgroundColor: ArcheryColors.forestGreen, minimumSize: Size(double.infinity, 50)),
              child: Text("REGISTER ARCHER", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController ctrl, String hint, IconData icon) {
    return TextField(
      controller: ctrl,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(labelText: hint, labelStyle: TextStyle(color: Colors.grey), prefixIcon: Icon(icon, color: ArcheryColors.targetGold)),
    );
  }
}