class Session {
  final int userID;
  final String accessToken;
  final String refreshToken;

  Session({
    required this.userID,
    required this.accessToken,
    required this.refreshToken,
  });  
}
