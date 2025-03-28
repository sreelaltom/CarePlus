abstract class ApiUrls {
  static String get baseUrl => _baseUrl;
  //real device
  // static const _baseUrl = 'http://192.168.201.180:8000';
  //desktop
  // static const _baseUrl = 'http://127.0.0.1:8000';
  //virtual device
  static const _baseUrl = 'http://10.0.2.2:8000';
  static const register = '/register/';
  static const login = '/login/';
  static const refreshToken = '/token/refresh/';
  static const uploadMedicalRecord = '/upload/';
  static const getMedicalRecords = '/files/';
  static String deleteMedicalRecord(int fileId) => '/files/$fileId/delete/';
}
