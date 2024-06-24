import 'dart:convert';
import 'package:dio/dio.dart';
import '../constants/constant_class.dart';
import '../database/shared_preference.dart';
import 'interceptor.dart';

class ApiRequest {
  final Dio dio = Dio();

  Future<String> signUp(String userName, String email, String password,
      String repeatPassword) async {
    try {
      final response = await dio.post(
        ConstantClass.signUpUrl,
        data: {
          'userName': userName,
          'email': email,
          'password': password,
          'repeat_password': repeatPassword
        },
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );
      if (response.data['message'] == ConstantClass.successSignUpMessage) {
        SharedPreferenceHelper().storeEmail(email);
        return ConstantClass.successSignUpMessage;
      }
      else {
        return response.data['message'];
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final errorMessage = e.response!.data['errors']['email'] ??
            e.response!.data['errors']['password'] ??
            e.response!.data['errors']['userName'];
        return errorMessage;
      }
      else {
        return ConstantClass.connectionError;
      }
    }
  }


  Future<String> logIn(String email, String password) async {
    dio.interceptors.add(AuthInterceptor());
    try{
      var data = {
        'email': email,
        'password': password,
      };
      final response = await dio.post(
        ConstantClass.singInUrl,
        data: json.encode(data),
        options: Options(headers: {
          'Content-Type': ConstantClass.jsonHeader, // set headers
        }),
      );
      if (response.data['success']==true){
        SharedPreferenceHelper().storeToken(response.data['accessToken']);
        SharedPreferenceHelper().storeRefreshToken(response.data['refreshToken']);
        return ConstantClass.successLogin;
      }
      else{
        return response.data['message'];
      }

    } on DioException catch(e){
      if (e.response != null){
        final errorResponse =  e.response!.data['message'] ?? e.response!.data['errors']['message'];
        return errorResponse;
      }
      else{
        return ConstantClass.connectionError;

      }
    }
  }

  Future<String> checkAuthorization() async {
    dio.interceptors.add(AuthInterceptor());
    try {
      final response = await dio.get(ConstantClass.checkAuthorization);
      if(response.data !=null){
        return ConstantClass.validToken;
      }
      else{
        SharedPreferenceHelper().removeToken();
        return ConstantClass.invalidToken;
      }
    } catch (e) {
      SharedPreferenceHelper().removeToken();
      return ConstantClass.invalidToken;
    }
  }




}