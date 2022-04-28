import 'package:craigslist/theme/theme_manager.dart';
import 'package:craigslist/views/home.dart';
import 'package:craigslist/views/messages/messages_detail.dart';
import 'package:craigslist/views/login.dart';
import 'package:craigslist/views/sales/my_sales.dart';
import 'package:provider/provider.dart';
import 'views/messages/inbox.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'models/model_provider.dart';

class App extends StatefulWidget {
  static const String title = "craigslist";
  const App({Key? key}) : super(key: key);
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  // amplify plugins
  final AmplifyDataStore _dataStorePlugin =
      AmplifyDataStore(modelProvider: ModelProvider.instance);
  final AmplifyAPI _apiPlugin = AmplifyAPI();
  final AmplifyAuthCognito _authPlugin = AmplifyAuthCognito();
  final AmplifyStorageS3 storage = AmplifyStorageS3();

  bool configured = false;
  bool authenticated = false;

  late String amplifyconfig;

  @override
  initState() {
    super.initState();
    _configureAmplify();
  }

  Future<void> _configureAmplify() async {
    try {
      // add Amplify plugins
      await Amplify.addPlugins(
          [_dataStorePlugin, _apiPlugin, _authPlugin, storage]);
      // note that Amplify cannot be configured more than once!
      await Amplify.configure(amplifyconfig);
      setState(() {
        configured = true;
      });
    } catch (e) {
      debugPrint('An error occurred while configuring Amplify: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final routes = {
      '/': (context) => Login(),
      '/home': (context) => const Home(),
      '/mySales': (context) => MySales(
          DataStore: _dataStorePlugin, Storage: storage, Auth: _authPlugin),
      '/msgDetail': (context) => const MessageDetail(title: App.title),
      '/inbox': (context) => Inbox(title: App.title),
    };

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xffA682FF),
        inputDecorationTheme: InputDecorationTheme(
          prefixIconColor: const Color.fromARGB(255, 125, 128, 132),
          filled: true,
          fillColor: Colors.purple.withOpacity(.1),
          contentPadding: EdgeInsets.zero,
          errorStyle: const TextStyle(
            backgroundColor: Color.fromARGB(255, 106, 0, 255),
            color: Colors.white,
          ),
          labelStyle: const TextStyle(fontSize: 12),
          enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Colors.purple.withOpacity(.1), width: 4),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Colors.purple.withOpacity(.1), width: 5),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Colors.purple.withOpacity(.1), width: 7),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Colors.purple.withOpacity(.1), width: 8),
          ),
          disabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 5),
          ),
        ),
      ),
      themeMode: context.read<ThemeManager>().themeMode,
      initialRoute: '/',
      routes: routes,
    );
  }
}
