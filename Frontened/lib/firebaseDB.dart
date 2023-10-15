import 'package:firebase_database/firebase_database.dart';

class User {
  final String userId;
  final String name;
  final String email;

  User({required this.userId, required this.name, required this.email});

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      name: json['name'],
      email: json['email'],
    );
  }

  @override
  String toString() {
    return 'User{userId: $userId, name: $name, email: $email}';
  }
}

class FirebaseDatabaseHelper {
  final FirebaseDatabase _reference;

  FirebaseDatabaseHelper() : _reference = FirebaseDatabase.instance;

  Future<void> addUserData(String userId, String name, String email) async {
    final User user = User(userId: userId, name: name, email: email);
    await _reference.ref(userId).set(user.toJson());
  }

  Future<User?> getUserData(String userId) async {
    final snapshot = await _reference.ref(userId).get();
    if (snapshot.value != null) {
      return User.fromJson(snapshot.value as Map<String, dynamic>);
    }
    return null;
  }
}
