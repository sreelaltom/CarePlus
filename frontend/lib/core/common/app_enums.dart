enum AuthSuccessType {
  login("Login Successful"),
  register("Registration Successful");

  final String message;

  const AuthSuccessType(this.message);
}

enum AuthFailureType {
  logout("Logout Successful"),
  sessionExpired("Session Expired!"),
  credentialsExists("Credentials already exist!"),
  usernameExists("Username already exists!"),
  emailExists("Email already exists!"),
  registrationIDExists("Registration ID already exists!"),
  userNotFound("User not Found!"),
  unexpected("An Unexpected error occurred!");

  final String message;

  const AuthFailureType(this.message);
}

enum MedicalRecordType {
  labResult(apiValue: "lab_result", dropdownValue: 'Lab result'),
  prescription(apiValue: "prescription", dropdownValue: 'Prescription');

  final String apiValue;
  final String dropdownValue;

  const MedicalRecordType({
    required this.apiValue,
    required this.dropdownValue,
  });

  
}
