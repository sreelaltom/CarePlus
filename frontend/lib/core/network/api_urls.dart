abstract class ApiUrls {
  static String get baseUrl => _baseUrl;
  //real device
  // static const _baseUrl = 'http://192.168.225.180:8000';
  //desktop
  // static const _baseUrl = 'http://127.0.0.1:8000';
  //virtual devi
  static const _baseUrl = 'http://10.0.2.2:8000';

  static const register = '/register/';
  static const login = '/login/';
  static const refreshToken = '/token/refresh/';

  static const uploadMedicalRecord = '/upload/';
  static const getMedicalRecords = '/files/';
  static String deleteMedicalRecord(int fileId) => '/files/$fileId/delete/';

  static String analysis({
    required String healthParameter,
    required DateTime from,
    required DateTime to,
  }) =>
      '/medical-files/filter/?parameter=$healthParameter&from=${from.year}-${from.month}-${from.day}&to=${to.year}-${to.month}-${to.day}';

  static const predictCancer = '/predict-cancer/';

  static const classifyFood = '/predict/indian-food/';
}
