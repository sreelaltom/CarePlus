
class User {
  final String? id;
  final String? email;
  final String? registrationID;
  final bool isPatient;
  final bool isDoctor;
  final String username;
  final String phone;


  User({
    required this.id,
    required this.username,
    this.email,
    this.registrationID,
    required this.isPatient,
    required this.isDoctor,
    required this.phone,
  });
}
