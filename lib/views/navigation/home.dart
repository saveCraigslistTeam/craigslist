import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool _loadingUserName = true;
  String userName = '';

  @override
  initState() {
    super.initState();
    getUserCredentials();
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

  Future<void> getUserCredentials() async {
    final AuthSession res = (await Amplify.Auth.fetchAuthSession());
    if (res.isSignedIn) {
      final user = await Amplify.Auth.fetchUserAttributes();
      
      for(int i = 0; i < user.length; i++) {
        if(user[i].value.contains('@')) {
          getUserName(user[i].value);
          break;
        }
      }
    }
  }

  void getUserName(String userEmail) {
    final indexOfAt = userEmail.indexOf('@');

    setState(() {
      userName = userEmail.substring(0, indexOfAt);
      _loadingUserName = false;
    });
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
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xffA682FF),
                ),
                child: Text(
                  'Drawer Header',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.message),
                title: const Text('Messages'),
                onTap: () => {Navigator.pushNamed(context, '/inbox', arguments:[userName])},
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () => {Navigator.pushNamed(context, '/home')},
              ),
              ListTile(
                leading: const Icon(Icons.shopping_bag),
                title: const Text('My Sales'),
                onTap: () => {Navigator.pushNamed(context, '/mySales', arguments:[userName])},
              ),
              ListTile(
                leading: const Icon(Icons.shopping_bag),
                title: const Text('All Sales'),
                onTap: () => {Navigator.pushNamed(context, '/allSales', arguments:[userName])},
              ),
              const ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('Account'),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () => {Navigator.pushNamed(context, '/home')},
              ),
            ],
          ),
        ),
    body: _loadingUserName 
        ? Center(
            child: CircularProgressIndicator(color: Theme.of(context).primaryColor)) 
        : Center(child: Text('User: $userName\'s home screen'))   
    );
  }
}
