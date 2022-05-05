import 'package:flutter/material.dart';

Drawer drawer(BuildContext context) {
  return Drawer(
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
          onTap: () => {Navigator.pushNamed(context, '/inbox')},
        ),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Home'),
          onTap: () => {Navigator.pushNamed(context, '/home')},
        ),
        ListTile(
          leading: const Icon(Icons.shopping_bag),
          title: const Text('My Sales'),
          onTap: () => {Navigator.pushNamed(context, '/mySales')},
        ),
        ListTile(
          leading: const Icon(Icons.shopping_bag),
          title: const Text('All Sales'),
          onTap: () => {Navigator.pushNamed(context, '/allSales')},
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
  );
}
