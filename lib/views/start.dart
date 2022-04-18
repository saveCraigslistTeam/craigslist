import 'package:flutter/material.dart';

import 'messages/messages_group.dart';

class Start extends StatefulWidget {
  const Start({Key? key}) : super(key: key);

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Craigslist')),
      key: _formKey,
      body: Form(
        child: SingleChildScrollView(
          child: SafeArea(
            minimum: const EdgeInsets.all(10.0),
            child: Column(
              children: _buildNormalContainer(context),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildNormalContainer(BuildContext context) {
    return [
      TextFormField(
        autofocus: true,
        // cursorColor: Theme.of(context).accentColor,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelText: 'Email',
          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        //onSaved: (value) => journal?.ttle = value!,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Email and Password cannot be empty';
          } else {
            return null;
          }
        },
      ),
      const SizedBox(height: 10),
      TextFormField(
        autofocus: true,
        cursorColor: Theme.of(context).colorScheme.secondary,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelText: 'Password',
          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        // onSaved: (value) => journal?.bdy = value!,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Email and Password cannot be empty';
          } else {
            return null;
          }
        },
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).colorScheme.secondary,
                padding: const EdgeInsets.symmetric(
                    horizontal: 22.5, vertical: 12.5),
              ),
              child: Text(
                'Login',
                style: TextStyle(
                  color: darken(Theme.of(context).backgroundColor, 70),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MessagesGroup(
                            title: 'craigslist',
                          )),
                );
              }),
        ],
      ),
    ];
  }

  Color darken(Color c, [int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    var s = 1 - percent / 100;
    return Color.fromARGB(c.alpha, (c.red * s).round(), (c.green * s).round(),
        (c.blue * s).round());
  }
}
