// dart async library we will refer to when setting up real time updates
import 'dart:core';
import 'package:craigslist/views/sales/services/fetch_image.dart';
import 'package:flutter/material.dart';
import '../../models/ModelProvider.dart';
import 'edit_sale.dart';

class SaleDetailView extends StatefulWidget {
  const SaleDetailView(
      {Key? key,
      required this.sale,
      required this.saleImages,
      required this.customer})
      : super(key: key);
  final Sale sale;
  final List<SaleImage>? saleImages;
  final String customer;

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
      appBar: AppBar(
        backgroundColor: const Color(0xffA682FF),
        title: Text('${widget.sale.title}'),
      ),
      body: Center(
        child: Column(
          children: [
            fetchImage(widget.saleImages),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text('${widget.sale.title}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text('Seller: ${widget.sale.user}'),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text('Price: ${widget.sale.price}'),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text('Description: ${widget.sale.description}'),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text('Condition: ${widget.sale.condition}'),
            ),
            ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/msgDetail', arguments: [
                    widget.customer,
                    widget.sale.id,
                    widget.sale.user
                  ]);
                },
                style: ElevatedButton.styleFrom(primary: Color(0xffA682FF)),
                icon: Icon(Icons.message, size: 18),
                label: Text('Message ${widget.sale.user}'))
          ],
        ),
      ),
    );
  }
}
