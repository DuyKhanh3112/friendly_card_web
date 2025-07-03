// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Topic {
  String id;
  String user_id;
  String name;
  Timestamp update_at;
  bool active;
  String image;

  Topic({
    required this.id,
    required this.user_id,
    required this.name,
    required this.update_at,
    required this.active,
    required this.image,
  });

  factory Topic.initTopic() {
    return Topic(
      id: '',
      name: '',
      user_id: '',
      update_at: Timestamp.now(),
      active: false,
      image: '',
    );
  }

  static Topic fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'],
      name: json['name'],
      user_id: json['user_id'],
      active: json['active'],
      update_at: json['update_at'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'user_id': user_id,
      'active': active,
      'update_at': update_at,
      'image': image,
    };
  }

  Map<String, dynamic> toVal() {
    return {
      // 'id': id,
      'name': name,
      'user_id': user_id,
      'active': active,
      'update_at': update_at,
      'image': image,
    };
  }
}
