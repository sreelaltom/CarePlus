class ApiUrls {
  static String get baseUrl => _baseUrl;
  static const _baseUrl = 'http://192.168.1.34:8000';
  // static const _baseUrl = 'http://10.0.2.2:8000';
  static const register = '/register/';
  static const login = '/login/';
  static const refreshToken = '/token/refresh/';
}
