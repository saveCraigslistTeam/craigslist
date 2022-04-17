import 'package:flutter/material.dart';

class MessageDetail extends StatelessWidget {

  final String title;
  const MessageDetail({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (
      Scaffold(
      appBar: AppBar(title: Text(title),
                    leading: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      child: GestureDetector(
                        onTap: () => {
                          Navigator.of(context).pop()
                        },
                        child: const Text("<",
                        style: TextStyle(fontSize: 30)
                         ),
                      )
                      )
                    ),
      body: const Text("sup")
      )
    );
  }
  
}