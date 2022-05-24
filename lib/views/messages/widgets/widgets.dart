import 'package:flutter/material.dart';

/// APPBAR
PreferredSizeWidget? appBar(String title, BuildContext context) {
  /// A simple AppBar for displaying the title, a back button, and
  /// the current color theme.
  
  return AppBar(
    leading: Semantics(child: const BackButton(),
                       button: true),
    title: Text(title),
    backgroundColor: Theme.of(context).primaryColor,
    centerTitle: true,
  );
}

// Circular progress indicator with the main theme color
Widget progressIndicator(BuildContext context) {
  return Center(child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor));
}

// Padding features for the messaging system.
double paddingSides(BuildContext context) {
  /// Adds padding to the sides of the field
  return MediaQuery.of(context).size.width * 0.03;
}

double paddingTopAndBottom(BuildContext context) {
  /// Adds padding to the top and bottom of the form field.
  return MediaQuery.of(context).size.height * 0.01;
}
