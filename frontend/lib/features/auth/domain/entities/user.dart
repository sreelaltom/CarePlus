
import 'package:equatable/equatable.dart';

class User extends Equatable{
  final String? id;
  final String? email;
  final String? registrationID;
  final bool isPatient;
  final bool isDoctor;
  final String username;
  final String phone;


  const User({
    required this.id,
    required this.username,
    this.email,
    this.registrationID,
    required this.isPatient,
    required this.isDoctor,
    required this.phone,
  });
  
  @override
  List<Object?> get props => [id, username, email, registrationID, isPatient, isDoctor, phone];
}
