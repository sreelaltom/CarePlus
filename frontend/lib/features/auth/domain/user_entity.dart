
class UserEntity {
  final String? id;
  final String? email;
  final String? registrationID;
  final bool isPatient;
  final bool isDoctor;
  final String username;
  final String phone;


  UserEntity({
    required this.id,
    required this.username,
    this.email,
    this.registrationID,
    required this.isPatient,
    required this.isDoctor,
    required this.phone,
  });
}
