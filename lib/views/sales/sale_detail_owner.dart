// dart async library we will refer to when setting up real time updates
import 'dart:core';
import 'package:flutter/material.dart';
import '../../models/ModelProvider.dart';
import 'edit_sale.dart';

class SaleDetailOwnerView extends StatefulWidget {
  const SaleDetailOwnerView(
      {Key? key, required this.sale, required this.saleImages})
      : super(key: key);
  final Sale sale;
  final List<SaleImage>? saleImages;

  @override
  State<SaleDetailOwnerView> createState() => _SaleDetailOwnerViewState();
}

class _SaleDetailOwnerViewState extends State<SaleDetailOwnerView> {
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
                            saleImages: widget.saleImages!,
                          )));
            },
            child: Text('Edit'))
      ]),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text('Price: ${widget.sale.price}'),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text('Description: ${widget.sale.description}'),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text('Condition: ${widget.sale.condition}'),
            ),
            imageContainer()
          ],
        ),
      ),
    );
  }

  Padding imageContainer() {
    if (widget.saleImages == null) {
      return const Padding(
        padding: EdgeInsets.all(25.0),
        child: Text('No image to display'),
      );
    } else {
      return Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              Image.network(
                widget.saleImages![0].imageURL.toString(),
              ),
            ],
          ));
    }
  }
}
