import 'package:craigslist/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'views/navigation/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitUp
  ]);

  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => ThemeManager())],
    // ignore: prefer_const_constructors
    child: App(),
  ));
}
