// //import 'package:flutter/material.dart';
// import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
// import 'package:amplify_flutter/amplify_flutter.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_login/flutter_login.dart';
// //import 'package:flutter_login/flutter_login.dart';

// class UserProvider extends ChangeNotifier {
//   // ignore: unused_field
//   //String username, password;
//   bool _isLoggedIn = false;
//   //UserProvider(this._isLoggedIn, this.username, this.password);

//   Future<bool> isLoggedIn(loginData) async {
//     bool _isLoggedIn = false;
//     try {
//       final user = await Amplify.Auth.signIn(
//           username: loginData.name, password: loginData.password);
//       user.isSignedIn ? _isLoggedIn = true : _isLoggedIn = false;
//       notifyListeners();
//     } on AuthException catch (e) {
//       debugPrint;
//       '${e.message} - ${e.recoverySuggestion}';
//     }
//     return _isLoggedIn;
//   }

//   void isUserSignedIn() {
//     _isLoggedIn = isLoggedIn(LoginData) as bool;
//     notifyListeners();
//   }
// }



//   // if (!user.isSignedIn) {
//   //   try {
//   //     await Amplify.Auth.signOut(
//   //         options: const SignOutOptions(globalSignOut: true));
//   //   } on AmplifyException catch (e) {
//   //     return '${e.message} - ${e.recoverySuggestion}';
//   //   }
//   // }