// dart async library we will refer to when setting up real time updates
import 'dart:core';
import 'package:flutter/material.dart';
import '../../models/ModelProvider.dart';
import 'edit_sale.dart';

class SaleDetailView extends StatefulWidget {
  const SaleDetailView({Key? key, required this.sale, required this.saleImages})
      : super(key: key);
  final Sale sale;
  final List<SaleImage> saleImages;

  @override
  State<SaleDetailView> createState() => _SaleDetailViewState();
}

class _SaleDetailViewState extends State<SaleDetailView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.sale.title}'), actions: <Widget>[
        ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditSaleForm(
                            sale: widget.sale,
                            saleImages: widget.saleImages,
                          )));
            },
            child: Text('Edit'))
      ]),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text('${widget.sale.price}'),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text('${widget.sale.description}'),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text('${widget.sale.condition}'),
            ),
            Padding(
                padding: const EdgeInsets.all(25.0),
                child: Image.network(widget.saleImages[0].imageURL.toString(),
                    height: 400)),
          ],
        ),
      ),
    );
  }
}
