import 'dart:convert';

import 'package:frontend/features/auth/domain/entities/session.dart';

class SessionModel extends Session {
  SessionModel({
    required super.userID,
    required super.accessToken,
    required super.refreshToken,
  });

  factory SessionModel.fromMap(Map<String, dynamic> map) => SessionModel(
        userID: map['uid'],
        accessToken: map['access'],
        refreshToken: map['refresh'],
      );

  Map<String, dynamic> toMap() => {
        'uid': userID,
        'access': accessToken,
        'refresh': refreshToken,
      };

  factory SessionModel.fromJson({required String source}) =>
      SessionModel.fromMap((jsonDecode(source) as Map<String, dynamic>));

  String toJson() => jsonEncode(toMap());
}
