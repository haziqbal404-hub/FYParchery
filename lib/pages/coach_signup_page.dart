import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../theme.dart';

class CoachSignupPage extends StatefulWidget {
  @override
  _CoachSignupPageState createState() => _CoachSignupPageState();
}

class _CoachSignupPageState extends State<CoachSignupPage> {
  final _auth = AuthService();
  final controllers = List.generate(7, (i) => TextEditingController());
  // order: name, age, country, company, phone, email, password

  void _handleSignUp() async {
    String? err = await _auth.signUpCoach( // Make sure this says signUpCoach
      name: controllers[0].text, 
      age: controllers[1].text,
      country: controllers[2].text, 
      company: controllers[3].text,
      phone: controllers[4].text, 
      email: controllers[5].text,
      password: controllers[6].text,
    );
    if (err == null) Navigator.pop(context);
    else ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ArcheryColors.carbonBlack,
      appBar: AppBar(title: Text("Coach Registration"), backgroundColor: ArcheryColors.forestGreen),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            _buildField(controllers[0], "Full Name", Icons.person),
            _buildField(controllers[1], "Age", Icons.cake),
            _buildField(controllers[2], "Country", Icons.flag),
            _buildField(controllers[3], "Company/Club", Icons.business),
            _buildField(controllers[4], "Phone Number", Icons.phone),
            _buildField(controllers[5], "Email (Username)", Icons.email),
            _buildField(controllers[6], "Password", Icons.lock, obscure: true),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleSignUp,
              style: ElevatedButton.styleFrom(backgroundColor: ArcheryColors.targetGold, minimumSize: Size(double.infinity, 50)),
              child: Text("CREATE COACH ACCOUNT", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController ctrl, String hint, IconData icon, {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        obscureText: obscure,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: hint, labelStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon, color: ArcheryColors.targetGold),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
        ),
      ),
    );
  }
}