import 'package:craigslist/theme/theme_manager.dart';
import 'package:craigslist/views/home.dart';
import 'package:craigslist/views/messages/messages_detail.dart';
import 'package:craigslist/views/start.dart';
import 'package:craigslist/views/sales/my_sales.dart';
import 'package:provider/provider.dart';
import 'views/messages/inbox.dart';
import 'package:flutter/material.dart';
import 'dart:core';
// amplify packages we will need to use
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
// amplify configuration and models that should have been generated for you
import '../../amplifyconfiguration.dart';
import '../../models/ModelProvider.dart';

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

      if (Amplify.isConfigured) {
        isConfigured();
        print("amplify configured");
      } else {
        print('amplify not configured');
      }
    } catch (e) {
      debugPrint('An error occurred while configuring Amplify: $e');
    }
  }

  void isConfigured() {
    if (!Amplify.isConfigured && !configured) {
      setState(() {
        configured = true;
      });
      print("amplify configured");
    } else {
      print('${Amplify.isConfigured}');
      print('$configured');
      print('amplify, not configured');
    }
  }

  @override
  Widget build(BuildContext context) {
    final routes = {
      '/loading': (context) => const Loading(),
      '/': (context) => const Start(),
      '/home': (context) => const Home(),
      '/mySales': (context) => MySales(
          DataStore: _dataStorePlugin, Storage: storage, Auth: _authPlugin),
      '/msgDetail': (context) => MessageDetail(
            title: App.title,
            dataStore: _dataStorePlugin,
          ),
      '/inbox': (context) => InboxPage(dataStore: _dataStorePlugin),
    };

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: context.read<ThemeManager>().themeMode,
      initialRoute: '/mySales',
      routes: routes,
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
        appBar: AppBar(), body: const Center(child: Text('Loading'))));
  }
}
