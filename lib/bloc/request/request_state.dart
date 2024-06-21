sealed class RequestState {}

class InitialState extends RequestState{}

class SignUpState extends RequestState {}

class SignedUpState extends RequestState{}

class SignUpError extends RequestState{
  final String errorMessage;

  SignUpError({required this.errorMessage});
}

class LogInInitialState extends RequestState {}

class LoggedInState extends RequestState{}

class LogInError extends RequestState{
  final String errorMessage;

  LogInError({required this.errorMessage});
}

class TokenValidState extends RequestState {}
