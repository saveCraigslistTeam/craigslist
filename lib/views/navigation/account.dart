import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  //signout using amplify api
  Future<void> deleteUser() async {
    try {
      await Amplify.Auth.deleteUser();
      Navigator.pushReplacementNamed(context, '/');
    } on AuthException catch (e) {
      '${e.message} - ${e.recoverySuggestion}';
    }
  }

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
        title: const Text('Account'),
        backgroundColor: const Color(0xffA682FF),
        actions: [
          IconButton(
              onPressed: (() {
                signOut();
              }),
              icon: const Icon(Icons.exit_to_app_outlined))
        ],
        centerTitle: true,
      ),
      body: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 5,
            mainAxisSpacing: 90,
            crossAxisSpacing: 1),
        padding: const EdgeInsets.only(left: 100, right: 100),
        children: <Widget>[
          const SizedBox(
            height: 25,
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.delete_forever_outlined),
            onPressed: () => {deleteUser()},
            label: const Text('Delete Account'),
            style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 186, 128, 230)),
          ),
        ],
      ),
    );
  }
}
