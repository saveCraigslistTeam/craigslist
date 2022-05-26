import 'dart:async';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late SignupData signUpData;
  late LoginData loginData;
  bool isSignedIn = false;

  Future<String?> _onLogin(loginData) async {
    try {
      final res = await Amplify.Auth.signIn(
        username: loginData.name,
        password: loginData.password,
      );

      isSignedIn = res.isSignedIn;
    } on AuthException catch (e) {
      isSignedIn ? Amplify.Auth.signOut() : isSignedIn = false;
      return '${e.message} - ${e.recoverySuggestion}';
    }
    return null;
  }

  Future<String?> _onSignup(signUpData) async {
    try {
      await Amplify.Auth.signUp(
        username: signUpData.name,
        password: signUpData.password,
        options: CognitoSignUpOptions(userAttributes: {
          CognitoUserAttributeKey.email: signUpData.name,
        }),
      );
    } on AuthException catch (e) {
      return '${e.message} - ${e.recoverySuggestion}';
    }
    return null;
  }

  Future<String?>? _onConfirmSignup(confirmationCode, loginData) async {
    try {
      final res = await Amplify.Auth.confirmSignUp(
        username: loginData.name,
        confirmationCode: confirmationCode,
      );

      if (res.isSignUpComplete) {
        await Amplify.Auth.signIn(
            username: loginData.name, password: loginData.password);
      }

    } on AuthException catch (e) {
      return '${e.message} - ${e.recoverySuggestion}';
    }
    return null;
  }

  Future<String?> _onResendCode(signUpData) async {
    try {
      await Amplify.Auth.resendSignUpCode(
        username: signUpData.name,
      );
    } on AuthException catch (e) {
      return '${e.message} - ${e.recoverySuggestion}';
    }
    return null;
  }

  //reset/forgot password, if needed function would use LoginData object
  Future<String?>? _onRecoverPassword(String username) async {
    try {
      await Amplify.Auth.resetPassword(username: username);
    } on AuthException catch (e) {
      return '${e.message} - ${e.recoverySuggestion}';
    }
    return null;
  }

  //onConfirm recover is to confirm the new/temp password you just reset
  Future<String?>? _onConfirmRecover(
      String newPasswordConfirmationCode, LoginData loginData) async {
    try {
      await Amplify.Auth.confirmResetPassword(
        username: loginData.name,
        newPassword: loginData.password,
        confirmationCode: newPasswordConfirmationCode,
      );
    } on AuthException catch (e) {
      return '${e.message} - ${e.recoverySuggestion}';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Craigslist',
      onLogin: _onLogin,
      onRecoverPassword: _onRecoverPassword,
      onConfirmRecover: _onConfirmRecover,
      onSignup: _onSignup,
      onConfirmSignup: _onConfirmSignup,
      onResendCode: _onResendCode,
      theme: LoginTheme(primaryColor: Theme.of(context).primaryColor),
      onSubmitAnimationCompleted: () {
        isSignedIn
            ? Navigator.of(context).pushReplacementNamed('/home')
            : Navigator.of(context).pushReplacementNamed('/');
      },
    );
  }
}
