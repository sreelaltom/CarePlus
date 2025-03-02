abstract class SessionState {}

class SessionInitial extends SessionState {}

class ActiveSession extends SessionState {}

class InactiveSession extends SessionState {
  final String? message;

  InactiveSession({this.message});
}
