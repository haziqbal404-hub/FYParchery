import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme.dart';
import 'coach_signup_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _auth = AuthService();

  void _login() async {
    String? error = await _auth.signIn(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ArcheryColors.carbonBlack,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(Icons.track_changes, size: 100, color: ArcheryColors.targetGold),
              SizedBox(height: 20),
              Text(
                "ARCHERY MENTAL EDGE",
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),
              TextField(
                controller: _emailController,
                style: TextStyle(color: Colors.white),
                decoration: _inputDecoration("Email Address", Icons.email),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: _inputDecoration("Password", Icons.lock),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ArcheryColors.forestGreen,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text("LOGIN", style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => CoachSignupPage())),
                child: Text("New Coach? Sign Up here", style: TextStyle(color: ArcheryColors.targetGold)),
              )
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey),
      prefixIcon: Icon(icon, color: ArcheryColors.targetBlue),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
    );
  }
}