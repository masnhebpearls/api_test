
class ConstantClass {
  static const signUpUrl = 'http://10.0.2.2:8000/api/account/register';
  static const singInUrl = 'http://10.0.2.2:8000/api/account/login';
  static const checkAuthorization = 'http://10.0.2.2:8000/api/user/me';

  static const emailKey = "email";
  static const tokenKey = "token";
  static const refreshTokenKey = "refreshToken";

  static const successSignUpMessage = 'User registration successfull';

  static const successLogin = "success";
  static const connectionError = "Connection error";

  static const validToken = "valid token";
  static const invalidToken = "invalid token";

  static const jsonHeader = 'application/json';

  static const userNameHeader = 'userName';
  static const emailHeader = 'email';
  static const passwordHeader = 'password';
  static const repeatPasswordHeader = 'repeat_password';
  static const repeatPasswordHead= "re enter password";

  static const errorHeader = 'errors';
  static const accessTokenHeader = 'accessToken';
  static const refreshTokenHeader = 'refreshToken';

  static const emailLengthError = "invalid email length";
  static const invalidEmailError = "invalid email";

  static const userNameLengthError = "username should be at least 3 characters";


  static const passwordLengthError = "password must be at least 5 characters long";
  static const passwordUnmatchedError = "password does not match";

  static const signUp = "Do not have a account, Sign up ?";
  static const login = "Already have a account, Log in ? ";

  static const signUpButton = "Sign up";
  static const logInButton = "Log in";
  static const checkTokenButton = "Check refresh token";



}