import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:craigslist/amplifyconfiguration.dart';
import 'package:flutter/material.dart';
import '../models/ModelProvider.dart';

final AmplifyDataStore _dataStorePlugin =
    AmplifyDataStore(modelProvider: ModelProvider.instance);
final AmplifyAPI _apiPlugin = AmplifyAPI();
final AmplifyAuthCognito _authPlugin = AmplifyAuthCognito();
final AmplifyStorageS3 storage = AmplifyStorageS3();

bool configured = false;
bool authenticated = false;
bool isSignedIn = false;

Future<void> configureAmplify() async {
  if (!Amplify.isConfigured) {
    try {
      await Amplify.addPlugins(
          [_dataStorePlugin, _apiPlugin, _authPlugin, storage]);
      // Amplify cannot be configured more than once!
      await Amplify.configure(amplifyconfig);
    } catch (e) {
      debugPrint('error: $e');
    }
  }
}

Future<void> isLoggedIn() async {
  try {
    final res = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: false));
    //If getAWSCredentials option is true, result will contain AWS credentials and tokens.
    //If set to false, result will only contain isSignedIn flag.

    res.isSignedIn
        ? Amplify.Auth.signOut()
        : isSignedIn =
            false; //options: const SignOutOptions(globalSignOut: true)

    //notifyListeners();
  } on AuthException catch (e) {
    debugPrint;
    '${e.message} - ${e.recoverySuggestion}';
  }
}
