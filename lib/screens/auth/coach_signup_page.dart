// lib/screens/auth/coach_signup_page.dart
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class CoachSignupPage extends StatefulWidget {
  const CoachSignupPage({super.key});

  @override
  State<CoachSignupPage> createState() => _CoachSignupPageState();
}

class _CoachSignupPageState extends State<CoachSignupPage> {
  // These "Controllers" grab the text the user types
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  void _signup() async {
    String? result = await _authService.registerCoach(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      name: _nameController.text.trim(),
      age: _ageController.text.trim(),
      country: _countryController.text.trim(),
      company: _companyController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    if (result == null) {
      // Success!
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Coach Registered Successfully!")),
      );
      // Here we would navigate to the Dashboard later
    } else {
      // Error!
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $result")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Coach Registration")),
      body: SingleChildScrollView(
        // Allows scrolling when keyboard appears
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Full Name"),
            ),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: "Age"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _countryController,
              decoration: const InputDecoration(labelText: "Country"),
            ),
            TextField(
              controller: _companyController,
              decoration: const InputDecoration(labelText: "Company/Club"),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: "Phone Number"),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _signup,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Sign Up as Coach"),
            ),
          ],
        ),
      ),
    );
  }
}
