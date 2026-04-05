// lib/models/user_model.dart

class CoachModel {
  String? uid;
  String? name;
  String? email;
  String? age;
  String? country;
  String? company;
  String? phoneNumber;
  String? role; // This will always be 'coach'

  CoachModel({
    this.uid,
    this.name,
    this.email,
    this.age,
    this.country,
    this.company,
    this.phoneNumber,
    this.role,
  });

  // This part helps us send data TO Firebase
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'age': age,
      'country': country,
      'company': company,
      'phoneNumber': phoneNumber,
      'role': 'coach',
    };
  }
}

class StudentModel {
  String? uid;
  String? name;
  String? email;
  String? age;
  String? gender;
  String? level; // beginner, intermediate, professional
  String? coachId; // This connects the student to their specific coach
  String? role; // This will always be 'student'

  StudentModel({
    this.uid,
    this.name,
    this.email,
    this.age,
    this.gender,
    this.level,
    this.coachId,
    this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'age': age,
      'gender': gender,
      'level': level,
      'coachId': coachId,
      'role': 'student',
    };
  }
}
