import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import '../drawer.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //signout using amplify api
  Future<void> signOut() async {
    try {
      await Amplify.Auth.signOut();
      Navigator.pushReplacementNamed(context, '/');
    } on AuthException catch (e) {
      '${e.message} - ${e.recoverySuggestion}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // leading: const BackButton(color: Color.fromARGB(255, 166, 130, 255)),
          title: const Text('Home'),
          backgroundColor: const Color(0xffA682FF),
          actions: [
            IconButton(
                onPressed: (() {
                  signOut();
                }),
                icon: const Icon(Icons.exit_to_app_outlined))
          ],
          // centerTitle: true,
        ),
        drawer: drawer(context));
  }
}
