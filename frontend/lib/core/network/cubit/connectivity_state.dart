import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectivityState {
  final InternetStatus internetStatus;

  ConnectivityState({required this.internetStatus});

  ConnectivityState copyWith({InternetStatus? internetStatus}) =>
      ConnectivityState(internetStatus: internetStatus ?? this.internetStatus);
}
