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
  Future<String?>? _onLogin(BuildContext context, LoginData data) async {
    print(data);
  }

  Future<String> _onSignup(LoginData data) async {
    try {
      await Amplify.Auth.signUp(
        username: data.name,
        password: data.password,
        options: CognitoSignUpOptions(userAttributes: {
          'email': data.name,
        }),
      );
      //_data = data;
    } on AuthException catch (e) {
      return '${e.message} - ${e.recoverySuggestion}'
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Craigslist',
      onLogin: (LoginData data) => _onLogin(context, data),
      onRecoverPassword: (_) => Future.value(''),
      onSignup: (LoginData data) => _onSignup(context, data),
      theme: LoginTheme(primaryColor: Theme.of(context).primaryColor),
      onSubmitAnimationCompleted: () {},
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