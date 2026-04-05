import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'student_detail_view.dart';

class StudentListPage extends StatefulWidget {
  const StudentListPage({super.key});

  @override
  State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  String _searchQuery = "";
  final String _currentCoachId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Archers")),
      body: Column(
        children: [
          // 1. SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search student by name...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),

          // 2. REAL-TIME LIST (Firestore Stream)
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              // Query: Get only students belonging to THIS coach
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('role', isEqualTo: 'student')
                  .where('coachId', isEqualTo: _currentCoachId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return const Center(child: Text("Error loading data"));
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Filter the list locally based on the Search Bar text
                var students = snapshot.data!.docs.where((doc) {
                  String name = doc['name'].toString().toLowerCase();
                  return name.contains(_searchQuery);
                }).toList();

                if (students.isEmpty) {
                  return const Center(child: Text("No students found."));
                }

                return ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    var student = students[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(student['name']),
                        subtitle: Text("Level: ${student['level']}"),
                        trailing: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StudentDetailView(
                                  student: student,
                                ), // Pass the student document
                              ),
                            );
                          },
                          child: const Text("Details"),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
