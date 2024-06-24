import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:test_token/bloc/request/request_state.dart';
import 'package:test_token/constants/constant_class.dart';
import 'package:test_token/database/shared_preference.dart';
import '../../api/api_class.dart';
import 'request_event.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  RequestBloc(): super(InitialState()){
    on<AlreadySignedUpEvent>(alreadySignedUpEvent);
    on<SignUpEvent>(signUpEvent);
    on<LogInInitialEvent>(logInInitialEvent);
    on<LogInEvent>(logInEvent);
    on<CheckTokenRequestEvent>(checkAuthorizedToken);
  }
  FutureOr<void> signUpEvent(SignUpEvent event, Emitter<RequestState> emit) async {
    final response = await ApiRequest().signUp(event.userName, event.email, event.password, event.newPassword);
    if (response == ConstantClass.successSignUpMessage) {
          emit(SignedUpState());
    }
    else{
      emit(SignUpError(errorMessage: response));
    }
  }

  FutureOr<void> logInInitialEvent(LogInInitialEvent event, Emitter<RequestState> emit) async {
    var tokens = await SharedPreferenceHelper().getTokens();
    if (tokens[0] !='' && tokens[1] != ''){
      emit(LoggedInState());
    }
    else{
      emit(LogInInitialState());
    }
  }

  FutureOr<void> alreadySignedUpEvent(AlreadySignedUpEvent event, Emitter<RequestState> emit) async {
    var email = await SharedPreferenceHelper().getEmail();
    if (email != null){
      emit(SignedUpState());
    }
    else{
      emit(SignUpState());
    }
  }

  FutureOr<void> logInEvent(LogInEvent event, Emitter<RequestState> emit) async {
    final response = await ApiRequest().logIn(event.email, event.password);
    if (response == ConstantClass.successLogin){
      emit(LoggedInState());
    }
    else {
      emit(LogInError(errorMessage: response));
    }
  }

  Future<void> checkAuthorizedToken(CheckTokenRequestEvent event, Emitter<RequestState> emit) async {
    final response = await ApiRequest().checkAuthorization();
    if (response == ConstantClass.validToken){
      emit(TokenValidState());
    }
    else{
      emit(SignUpState());
    }
  }
}
