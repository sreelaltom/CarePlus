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

enum MedicalRecordCategory {
  labResult(apiValue: "lab_result", dropdownValue: 'Lab result'),
  prescription(apiValue: "prescription", dropdownValue: 'Prescription'),
  chestCancerReport(
      apiValue: "chest_cancer_report", dropdownValue: 'Chest Cancer Report');

  final String apiValue;
  final String dropdownValue;

  const MedicalRecordCategory({
    required this.apiValue,
    required this.dropdownValue,
  });
}

enum FileSource {
  camera,
  device,
}

enum HealthParameter {
  // bp(unit: "mmHg", dropdownValue: "Blood Pressure" ),
  // cholesterol(unit: "mg/dl", dropdownValue: "Cholesterol"),
  // sugar(unit: "mg/dl", dropdownValue: "Sugar"),
  calcium(unit:"cal", dropdownValue: "Calcium")
  ;

  final String unit;
  final String dropdownValue;
  const HealthParameter({
    required this.unit,
    required this.dropdownValue,
  });
}
