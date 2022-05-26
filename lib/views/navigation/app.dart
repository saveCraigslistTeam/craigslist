import 'package:craigslist/views/navigation/account.dart';
import 'package:craigslist/views/navigation/home.dart';
import 'package:craigslist/views/messages/messages_detail.dart';
import 'package:craigslist/views/navigation/login.dart';
import 'package:craigslist/views/sales/my_sales.dart';
import 'package:craigslist/views/sales/all_sales.dart';
//import '../../amplifyconfiguration.dart';
import '../messages/inbox.dart';
import 'package:flutter/material.dart';
import 'dart:core';
//import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
//import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
//import 'package:craigslist/amplifyconfiguration.dart';
// amplify configuration and models that should have been generated for you
import '../../../../models/ModelProvider.dart';
// ignore: unused_import
import 'package:amplify_authenticator/amplify_authenticator.dart';

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
  final AmplifyAuthCognito _authPlugin = AmplifyAuthCognito();
  final AmplifyStorageS3 storage = AmplifyStorageS3();

  bool configured = false;
  bool authenticated = false;

  @override
  Widget build(BuildContext context) {
    final routes = {
      '/': (context) => const Login(),
      '/home': (context) => const Home(),
      '/account': (context) => const Account(),
      '/mySales': (context) => MySales(
            dataStore: _dataStorePlugin,
            storage: storage,
            auth: _authPlugin,
          ),
      '/allSales': (context) => AllSales(
            dataStore: _dataStorePlugin,
            storage: storage,
            auth: _authPlugin,
          ),
      '/msgDetail': (context) => MessageDetail(dataStore: _dataStorePlugin),
      '/inbox': (context) => InboxPage(dataStore: _dataStorePlugin),
    };

    //return Authenticator is a good option as well
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
      initialRoute: '/',
      routes: routes,
    );
  }
}