import 'dart:convert';
import 'package:frontend/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    super.email,
    super.registrationID,
    required super.id,
    required super.username,
    required super.isDoctor,
    required super.isPatient,
    required super.phone,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        id: map['uid'] != null ? (map['uid'] as int).toString() : map['uid'],
        email: map['email'],
        registrationID: map['registration_id'],
        username: map['username'] != null ? map['username'] as String : '',
        // password: map['password'] as String,
        isDoctor: map['is_doctor'] as bool,
        isPatient: map['is_patient'] as bool,
        phone: map['phone_number'] as String,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'username': username,
        'email': email,
        'registration_id': registrationID,
        'is_doctor': isDoctor,
        'is_patient': isPatient,
        'phone_number': phone,
      };

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source) as Map<String, dynamic>);

  String toJson() => jsonEncode(toMap());
}
