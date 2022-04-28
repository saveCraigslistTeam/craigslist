// dart async library we will refer to when setting up real time updates
import 'dart:core';
import 'package:flutter/material.dart';
import '../../models/ModelProvider.dart';

class SaleDetailView extends StatefulWidget {
  const SaleDetailView({Key? key, required this.sale, required this.saleImages})
      : super(key: key);
  final Sale sale;
  final List<SaleImage> saleImages;
  // const image = (await DataStore.query(SaleImage)).filter(s => s.saleID === sale.id);

  // SaleItem({required this.sale});

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
        ElevatedButton(onPressed: () {}, child: Text('Edit'))
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
                child: Image.network(
                    'https://craigslist-storage-images174444-staging.s3.amazonaws.com/public/images+(2).jpg',
                    // widget.saleImages[0].imageURL!.toString(),
                    height: 400)),
          ],
        ),
      ),
    );
  }
}
