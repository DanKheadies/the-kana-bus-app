import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  // final DateTime? updatedAt;
  final String avatarUrl;
  final String id;
  final String email;
  final String name;

  const User({
    required this.avatarUrl,
    required this.email,
    required this.id,
    required this.name,
    // this.updatedAt,
  });

  @override
  List<Object?> get props => [
    avatarUrl,
    email,
    id,
    name,
    // updatedAt,
  ];

  User copyWith({
    // DateTime? updatedAt,
    String? avatarUrl,
    String? email,
    String? id,
    String? name,
  }) {
    return User(
      avatarUrl: avatarUrl ?? this.avatarUrl,
      email: email ?? this.email,
      id: id ?? this.id,
      name: name ?? this.name,
      // updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    // DateTime updatedTime = json['updatedAt'] != null
    //     ? DateTime.parse(json['updatedAt'])
    //     : DateTime.now();

    return User(
      avatarUrl: json['avatarUrl'] ?? '',
      email: json['email'] ?? '',
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      // updatedAt: updatedTime,
    );
  }

  factory User.fromSnapshot(DocumentSnapshot snap) {
    dynamic data = snap.data();
    // DateTime updatedTime = data['updatedAt'] != null
    //     ? (data['updatedAt'] as Timestamp).toDate()
    //     : DateTime.now();

    return User(
      avatarUrl: data['avatarUrl'] ?? '',
      email: data['email'] ?? '',
      id: snap.id,
      name: data['name'] ?? '',
      // updatedAt: updatedTime,
    );
  }

  Map<String, dynamic> toJson(
    // {required bool isFirebase,}
  ) {
    // DateTime updatedDT = updatedAt ?? DateTime.now();

    return {
      'avatarUrl': avatarUrl,
      'email': email,
      'id': id,
      'name': name,
      // 'updatedAt': isFirebase ? updatedDT.toUtc() : updatedDT.toString(),
    };
  }

  static const emptyUser = User(avatarUrl: '', email: '', id: '', name: '');
}
