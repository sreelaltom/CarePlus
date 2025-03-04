class Session {
  final int userID;
  String accessToken;
  String refreshToken;

  Session({
    required this.userID,
    required this.accessToken,
    required this.refreshToken,
  });

  
}
