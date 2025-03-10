class ApiUrls {
  static String get baseUrl => _baseUrl;
  //real device
  // static const _baseUrl = 'http://192.168.1.34:8000';
  //desktop
  // static const _baseUrl = 'http://127.0.0.1:8000';
  //virtual device
  static const _baseUrl = 'http://10.0.2.2:8000';
  static const register = '/register/';
  static const login = '/login/';
  static const refreshToken = '/token/refresh/';
}
