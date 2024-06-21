import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:test_token/bloc/request/request_state.dart';
import 'package:test_token/database/shared_preference.dart';
import '../../api_interceptors/interceptor.dart';
import 'request_event.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  RequestBloc(): super(InitialState()){
    on<AlreadySignedUpEvent>(alreadySignedUpEvent);
    on<SignUpEvent>(signUpEvent);
    on<LogInInitialEvent>(logInInitialEvent);
    on<LogInEvent>(logInEvent);
    on<CheckTokenRequestEvent>(checkAuthorizedToken);
  }
  final Dio dio = Dio();
  static const signUpUrl = 'http://10.0.2.2:8000/api/account/register';
  static const singInUrl = 'http://10.0.2.2:8000/api/account/login';
  static const checkAuthorization = 'http://10.0.2.2:8000/api/user/me';

  FutureOr<void> signUpEvent(SignUpEvent event, Emitter<RequestState> emit) async {
    try{
      final response = await dio.post(
        signUpUrl,
        data: {
          'userName': event.userName,
          'email': event.email,
          'password':event.password,
          'repeat_password': event.newPassword
        },
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );
      print(response.data.toString());
      if (response.data['message']== 'User registration successfull'){
        SharedPreferenceHelper().storeEmail(event.email);
        print("response is $response");
        emit(SignedUpState());

      }
      else{
        emit(SignUpError(errorMessage: response.data['message']));
      }
    } on DioException catch(e){

      if (e.response != null){
        final errorMessage = e.response!.data['errors']['email'] ?? e.response!.data['errors']['password'];
        emit(SignUpError(errorMessage: errorMessage));
      }
      else{
        emit(SignUpError(errorMessage: "connection error"));
      }


    }




  }

  FutureOr<void> logInInitialEvent(LogInInitialEvent event, Emitter<RequestState> emit) async {
    dio.interceptors.add(AuthInterceptor());
    var tokens = await SharedPreferenceHelper().getTokens();
    print(tokens);
    if (tokens[0] !='' && tokens[1] != ''){
      emit(LoggedInState());
    }
    else{
      emit(LogInInitialState());
    }

  }

  FutureOr<void> alreadySignedUpEvent(AlreadySignedUpEvent event, Emitter<RequestState> emit) async {
    dio.interceptors.add(AuthInterceptor());
    var email = await SharedPreferenceHelper().getEmail();
    print("email is $email");
    if (email != null){
      emit(SignedUpState());
    }
    else{
      emit(SignUpState());
    }



  }

  FutureOr<void> logInEvent(LogInEvent event, Emitter<RequestState> emit) async {
    dio.interceptors.add(AuthInterceptor());
    try{
      var data = {
        'email': event.email,
        'password': event.password,
      };
      final response = await dio.post(
        singInUrl,
        data: json.encode(data),
        options: Options(headers: {
          'Content-Type': 'application/json', // set headers
        }),
      );
      print(" response is ${response.data}");
      if (response.data['success']==true){
        SharedPreferenceHelper().storeToken(response.data['accessToken']);
        SharedPreferenceHelper().storeRefreshToken(response.data['refreshToken']);
        emit(LoggedInState());

      }
      else{
        emit(LogInError(errorMessage: response.data['message']));
      }

    } on DioException catch(e){
      print("error is ${e.response}");
      if (e.response != null){
        print("error is ${e.response!.data}");
        final errorResponse =  e.response!.data['message'] ?? e.response!.data['errors']['message'];
        print("obtained error message is $errorResponse");
        emit(LogInError(errorMessage: errorResponse));
      }
      else{
        emit(LogInError(errorMessage: "Connection error"));

      }


    }




  }

  Future<void> checkAuthorizedToken(CheckTokenRequestEvent event, Emitter<RequestState> emit) async {
    Dio dio = Dio();
    dio.interceptors.add(AuthInterceptor());

    try {
      final response = await dio.get(checkAuthorization);
      final data = response.data;
      emit(TokenValidState());
      print("response is $data");
    } catch (e) {
      SharedPreferenceHelper().removeToken();
      emit(SignUpState());
      print("Error: $e");
      // Handle error as needed, e.g., emit an error state
    }
  }
}
