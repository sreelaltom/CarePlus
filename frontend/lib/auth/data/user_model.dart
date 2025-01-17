import 'dart:convert';

import 'package:frontend/auth/domain/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.fullName,
    required super.password,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        id: map['id'] as String,
        fullName: map['full_name'] as String,
        password: map['password'] as String,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'full_name': fullName,
        'password': password,
      };

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source) as Map<String, dynamic>);

  String toJson() => jsonEncode(toMap());
}
