import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../auth/login_page.dart';

class RegisterStudentPage extends StatefulWidget {
  // We pass the coachId from the Dashboard to this variable
  final String coachId;

  const RegisterStudentPage({super.key, required this.coachId});

  @override
  State<RegisterStudentPage> createState() => _RegisterStudentPageState();
}

class _RegisterStudentPageState extends State<RegisterStudentPage> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _selectedGender = 'Male';
  String _selectedLevel = 'Beginner'; // Beginner, Intermediate, Professional

  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void _registerStudent() async {
    // 1. Validate fields
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    setState(() => _isLoading = true);

    // 2. Create the student
    // Note: widget.coachId is used to keep the link to the Coach safe
    String? result = await _authService.registerStudent(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      name: _nameController.text.trim(),
      age: _ageController.text.trim(),
      gender: _selectedGender,
      level: _selectedLevel,
      coachId: widget.coachId,
    );

    if (result == null) {
      // 3. SUCCESS: Now we explicitly Sign Out the new student immediately
      // This prevents the student session from "messing up" the Coach's next move.
      await _authService.signOut();

      if (mounted) {
        setState(() => _isLoading = false);

        // 4. Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Student Registered! Redirecting to Login..."),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );

        // 5. Navigate back to the very first screen (LoginPage)
        // We use pushAndRemoveUntil to clear all previous screens from memory
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) =>
                  false, // This removes all previous screens (Dashboard, etc.)
            );
          }
        });
      }
    } else {
      // 6. ERROR: Just hide loader and show error
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $result"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register New Student")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Add Archer Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Student Full Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(
                labelText: "Age",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),

            // Gender Dropdown
            DropdownButtonFormField(
              value: _selectedGender,
              decoration: const InputDecoration(
                labelText: "Gender",
                border: OutlineInputBorder(),
              ),
              items: [
                'Male',
                'Female',
              ].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
              onChanged: (val) =>
                  setState(() => _selectedGender = val as String),
            ),
            const SizedBox(height: 15),

            // Level Dropdown
            DropdownButtonFormField(
              value: _selectedLevel,
              decoration: const InputDecoration(
                labelText: "Skill Level",
                border: OutlineInputBorder(),
              ),
              items: [
                'Beginner',
                'Intermediate',
                'Professional',
              ].map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
              onChanged: (val) =>
                  setState(() => _selectedLevel = val as String),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Student Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: "Temporary Password",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),

            const SizedBox(height: 30),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _registerStudent,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 55),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      "Register Archer",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
