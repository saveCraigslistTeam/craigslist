import 'package:flutter/material.dart';

class MessageSellerForm extends StatefulWidget {

  const MessageSellerForm({Key? key}) : super(key: key);

  @override
  State<MessageSellerForm> createState() => _MessageSellerFormState();
}

class _MessageSellerFormState extends State<MessageSellerForm> {
  
  // Pull in sale item data, title price image
  final formkey = GlobalKey<FormState>();
  final String saleTitle = 'This is the title of the item for sale';
  final String salePrice = '\$xxx.xxxx';
  final String saleImgUrl = 'https://images.unsplash.com/photo-1605348532760-6753d2c43329?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80';
  final String sellerName = 'p0pkerncs';
  final String notice = 'Notice: You are entering a private conversation with the seller of this item';

  @override
  Widget build(BuildContext context) {
    return (
      Scaffold(
        appBar: AppBar(title: Text('Message $sellerName'),
        leading: BackButton()),
        body: 
        Padding(
          padding: EdgeInsets.all(paddingSides(context)),
          child: Column(
            children: [
              Row(
                children: [
                  Image.network(saleImgUrl,
                  height: 200,
                  alignment: Alignment.center,
                  ),
                  Column(
                    children: [
                      Text(saleTitle),
                      Text(salePrice),
                    ],
              ),
                ],
              ),
              Form(
                child: TextFormField()
              ),
            ],
          ),
        )
      )
    );
  }
}

double paddingSides(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.03;
}

double paddingTopAndBottom(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.01;
}