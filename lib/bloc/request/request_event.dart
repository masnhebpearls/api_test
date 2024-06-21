
sealed class RequestEvent{}

class SignUpEvent extends RequestEvent {
  final String userName;
  final String email;
  final String password;
  final String newPassword;

  SignUpEvent({required this.userName, required this.email, required this.password, required this.newPassword});


}

class LogInInitialEvent extends RequestEvent{}


class LogInEvent extends RequestEvent{
  final String email;
  final String password;

  LogInEvent({required this.email, required this.password});
}


class AlreadySignedUpEvent extends RequestEvent{}


class CheckTokenRequestEvent extends RequestEvent{}

class NavigateToLogInEvent extends RequestEvent {}

