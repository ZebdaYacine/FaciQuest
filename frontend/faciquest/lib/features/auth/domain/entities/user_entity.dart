// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String firstName, lastName, phone, password, username;

  static const empty = UserEntity();
  const UserEntity({
    this.username = '',
    this.id = '',
    this.email = '',
    this.firstName = '',
    this.lastName = '',
    this.phone = '',
    this.password = '',
  });

  UserEntity copyWith({
    String? username,
    String? id,
    String? email,
    String? phone,
    String? lastName,
    String? firstName,
    String? password,
  }) {
    return UserEntity(
      username: username ?? this.username,
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (id != '') 'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      if (password != '') 'password': password,
    };
  }

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    final data = map['Data'] as Map<String, dynamic>? ?? {};
    return UserEntity(
      id: data['_id'] as String? ?? '',
      email: data['email'] as String? ?? '',
      firstName: data['name'] as String? ?? '',
      lastName: data['lastName'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserEntity.fromJson(String source) =>
      UserEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props =>
      [id, email, firstName, lastName, phone, password, username];

  bool get isNotEmpty => this != UserEntity.empty;
  bool get isEmpty => this == UserEntity.empty;
}
