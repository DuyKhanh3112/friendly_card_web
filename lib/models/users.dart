// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String id;
  String username;
  String password;
  String fullname;
  String? email;
  String? phone;
  Timestamp update_at;
  String role;

  Users({
    required this.id,
    required this.username,
    required this.password,
    required this.fullname,
    this.email,
    this.phone,
    required this.update_at,
    required this.role,
  });

  factory Users.initUser() {
    return Users(
      id: '',
      username: '',
      password: '',
      fullname: '',
      update_at: Timestamp.now(),
      role: 'learner',
      email: '',
      phone: '',
    );
  }

  static Users fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      fullname: json['fullname'],
      update_at: json['update_at'],
      role: json['role'],
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'fullname': fullname,
      'update_at': update_at,
      'role': role,
      'email': email ?? '',
      'phone': phone ?? ''
    };
  }

  Map<String, dynamic> toVal() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'fullname': fullname,
      'update_at': update_at,
      'role': role,
      'email': email ?? '',
      'phone': phone ?? ''
    };
  }
}
