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
  //late LoginData _data;
  late SignupData signUpData;
  late LoginData loginData;
  bool isSignedIn = false;
  //late String confirmationCode;

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
      //_data = data;
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

      // if (res.isSignUpComplete) {
      //   final user = await Amplify.Auth.signIn(
      //     username: loginData.name, password: loginData.password);
      // }
      //   if (user.isSignedIn) {
      //     _isLoggedIn = true;
      //   }
      // if (user.isSignedIn) {
      //   Navigator.pushReplacementNamed(context, '/home');
      // }
      // if (!user.isSignedIn) {
      //   try {
      //     await Amplify.Auth.signOut(
      //         options: const SignOutOptions(globalSignOut: true));
      //   } on AmplifyException catch (e) {
      //     return '${e.message} - ${e.recoverySuggestion}';
      //   }
      // }
      // }
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
      // var res = await Amplify.Auth.resetPassword(username: data.name);
      // if (res.nextStep.updateStep == 'CONFIRM_RESET_PASSWORD_WITH_CODE') {
      //   //navigate to reset class or widget
      // }
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
      // var res = await Amplify.Auth.resetPassword(username: data.name);
      // if (res.nextStep.updateStep == 'CONFIRM_RESET_PASSWORD_WITH_CODE') {
      //   //navigate to reset class or widget
      // }
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
        //Navigator.of(context).pushNamed('/home');
        isSignedIn
            ? Navigator.of(context).pushReplacementNamed('/home')
            : Navigator.of(context).pushReplacementNamed('/');
        //arguments: _data,
      },
    );
  }
}




// final _formKey = GlobalKey<FormState>();

//   //final bool isDark = false;

//   //_LoginState(this.isDark);

//   //get isDark => null;
//   @override
//   Widget build(BuildContext context) {
//     //bool isDark = ThemeMode.light as bool;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Craigslist'),
//         backgroundColor: const Color(0xffA682FF),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.dark_mode),
//             onPressed: () => context.read<ThemeManager>().toggleTheme(),
//           )
//         ],
//       ),
//       key: _formKey,
//       body: Form(
//         child: SingleChildScrollView(
//           child: SafeArea(
//             minimum: const EdgeInsets.all(10.0),
//             child: Column(
//               children: _buildNormalContainer(context),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   List<Widget> _buildNormalContainer(BuildContext context) {
//     return [
//       TextFormField(
//         autofocus: true,
//         cursorColor: const Color(0xffA682FF),
//         decoration: const InputDecoration(
//           floatingLabelBehavior: FloatingLabelBehavior.auto,
//           labelText: 'Email',
//           labelStyle: TextStyle(
//             color: Color(0xffA682FF),
//           ),
//           border: OutlineInputBorder(),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(
//               color: Color(0xffA682FF),
//             ),
//           ),
//         ),
//         //onSaved: (value) => journal?.ttle = value!,
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Email and Password cannot be empty';
//           } else {
//             return null;
//           }
//         },
//       ),
//       const SizedBox(height: 10),
//       TextFormField(
//         autofocus: true,
//         //cursorColor: Theme.of(context).colorScheme.secondary,
//         cursorColor: const Color(0xffA682FF),
//         decoration: const InputDecoration(
//           floatingLabelBehavior: FloatingLabelBehavior.auto,
//           labelText: 'Password',
//           // labelStyle: TextStyle(
//           //   color: Theme.of(context).colorScheme.secondary,
//           // ),
//           labelStyle: TextStyle(
//             color: Color(0xffA682FF),
//           ),
//           border: OutlineInputBorder(),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(
//               //color: Theme.of(context).colorScheme.secondary,
//               color: Color(0xffA682FF),
//             ),
//           ),
//         ),
//         // onSaved: (value) => journal?.bdy = value!,
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Email and Password cannot be empty';
//           } else {
//             return null;
//           }
//         },
//       ),
//       const SizedBox(height: 10),
//       Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: <Widget>[
//           ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 primary: const Color(0xffA682FF),
//                 //primary: Theme.of(context).colorScheme.primary,
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 22.5, vertical: 12.5),
//               ),
//               child: Text(
//                 'Login',
//                 style: TextStyle(
//                   color: darken(Theme.of(context).backgroundColor, 70),
//                 ),
//               ),
//               onPressed: () {
//                 Navigator.pushNamed(context, '/home');
//               }),
//         ],
//       ),
//     ];
//   }

//   Color darken(Color c, [int percent = 10]) {
//     assert(1 <= percent && percent <= 100);
//     var s = 1 - percent / 100;
//     return Color.fromARGB(c.alpha, (c.red * s).round(), (c.green * s).round(),
//         (c.blue * s).round());
//   }