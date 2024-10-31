// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String firstName, lastName, phone, password, username;

  final DateTime? birthDate;
  final int? age;
  final String? birthPlace;
  final String? country;
  final String? municipal;
  final String? education;
  final String? workerAt;
  final String? institution;
  final String? socialStatus;
  final String? role;
  final String? profilePicture;

  static const empty = UserEntity();
  const UserEntity({
    this.username = '',
    this.id = '',
    this.email = '',
    this.firstName = '',
    this.lastName = '',
    this.phone = '',
    this.password = '',
    this.birthDate,
    this.age,
    this.birthPlace,
    this.country,
    this.municipal,
    this.education,
    this.workerAt,
    this.institution,
    this.socialStatus,
    this.role,
    this.profilePicture,
  });

  UserEntity copyWith({
    String? username,
    String? id,
    String? email,
    String? phone,
    String? lastName,
    String? firstName,
    String? password,
    String? role,
    String? profilePicture,
    DateTime? birthDate,
    int? age,
    String? birthPlace,
    String? country,
    String? municipal,
    String? education,
    String? workerAt,
    String? institution,
    String? socialStatus,
  }) {
    return UserEntity(
      username: username ?? this.username,
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      role: role ?? this.role,
      profilePicture: profilePicture ?? this.profilePicture,
      birthDate: birthDate ?? this.birthDate,
      age: age ?? this.age,
      birthPlace: birthPlace ?? this.birthPlace,
      country: country ?? this.country,
      municipal: municipal ?? this.municipal,
      education: education ?? this.education,
      workerAt: workerAt ?? this.workerAt,
      institution: institution ?? this.institution,
      socialStatus: socialStatus ?? this.socialStatus,
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
      if (birthDate != null) 'birthDate': birthDate!.millisecondsSinceEpoch,
      if (age != null) 'age': age,
      if (birthPlace != null) 'birthPlace': birthPlace,
      if (country != null) 'country': country,
      if (municipal != null) 'municipal': municipal,
      if (education != null) 'education': education,
      if (workerAt != null) 'workerAt': workerAt,
      if (institution != null) 'institution': institution,
      if (socialStatus != null) 'socialStatus': socialStatus,
      if (role != null) 'role': role,
      if (profilePicture != null) 'profilePicture': profilePicture
    };
  }

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    final data = map['Data'] as Map<String, dynamic>? ?? map;
    return UserEntity(
      id: data['_id'] as String? ?? '',
      email: data['email'] as String? ?? '',
      firstName: data['firstname'] as String? ?? '',
      lastName: data['lastname'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      username: data['username'] as String? ?? '',
      password: data['password'] as String? ?? '',
      role: data['role'] as String? ?? '',
      profilePicture: data['profilePicture'] as String? ?? '',
      birthDate:
          DateTime.fromMillisecondsSinceEpoch(data['birthDate'] as int? ?? 0),
      age: data['age'] as int? ?? 0,
      birthPlace: data['birthPlace'] as String? ?? '',
      country: data['country'] as String? ?? '',
      municipal: data['municipal'] as String? ?? '',
      education: data['education'] as String? ?? '',
      workerAt: data['workerAt'] as String? ?? '',
      institution: data['institution'] as String? ?? '',
      socialStatus: data['socialStatus'] as String? ?? '',
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
