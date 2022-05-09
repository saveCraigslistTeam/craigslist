// dart async library we will refer to when setting up real time updates
import 'dart:async';
import 'dart:core';
import 'dart:io';
// flutter and ui libraries
import 'package:flutter/material.dart';
// amplify packages we will need to use
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:image_picker/image_picker.dart';
// amplify configuration and models that should have been generated for you
import '../../models/ModelProvider.dart';
import 'sale_detail.dart';
import 'add_sale.dart';

class AllSales extends StatefulWidget {
  AllSales(
      {Key? key,
      required this.DataStore,
      required this.Storage,
      required this.Auth})
      : super(key: key);

  final AmplifyDataStore DataStore;
  final AmplifyStorageS3 Storage;
  final AmplifyAuthCognito Auth;

  @override
  _AllSalesState createState() => _AllSalesState();
}

class _AllSalesState extends State<AllSales> {
  // subscription of Todo QuerySnapshots - to be initialized at runtime
  late StreamSubscription<QuerySnapshot<Sale>> _subscription;

  // loading ui state - initially set to a loading state
  bool _isLoading = true;

  // list of Todos - initially empty
  List<Sale> _sales = [];

  // Username of potential buyer
  String customer = '';

  @override
  void initState() {
    // kick off app initialization
    getSalesStream();
    super.initState();
  }

  Future<void> getSalesStream() async {
    _subscription = widget.DataStore.observeQuery(
      Sale.classType,
    ).listen((QuerySnapshot<Sale> snapshot) {
      setState(() {
        if (_isLoading) _isLoading = false;
        _sales = snapshot.items;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String?> args =
        ModalRoute.of(context)!.settings.arguments as List<String?>;
    customer = args[0].toString();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffA682FF),
        title: Text('All Sales'),
      ),

      // body: Center(child: CircularProgressIndicator()),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SalesList(sales: _sales, customer: customer),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class SalesList extends StatelessWidget {
  final List<Sale> sales;
  final String customer;

  SalesList({required this.sales, required this.customer});

  @override
  Widget build(BuildContext context) {
    return sales.length >= 1
        ? ListView(
            padding: EdgeInsets.all(8),
            children: sales
                .map((sale) => SaleItem(sale: sale, customer: customer))
                .toList())
        : Center(child: Text('Tap button below to add a sale!'));
  }
}

class SaleItem extends StatelessWidget {
  final double iconSize = 24.0;
  final Sale sale;
  final String customer;

  SaleItem({required this.sale, required this.customer});

  void _favoriteSale(BuildContext context) async {}

  Future<List<SaleImage>?> getSaleImage(Sale sale) async {
    List<SaleImage> images = (await Amplify.DataStore.query(SaleImage.classType,
        where: SaleImage.SALEID.eq(sale.id)));
    return images.isNotEmpty ? images : null;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            Expanded(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(sale.title!,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('\$${sale.price}'),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                      icon: const Icon(Icons.favorite),
                      tooltip: 'Favorite this sale',
                      onPressed: () {
                        _favoriteSale(context);
                      })
                ],
              ),
            ),
          ]),
        ),
        onTap: () async {
          List<SaleImage>? SaleImages = await getSaleImage(sale);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SaleDetailView(
                      sale: sale, saleImages: SaleImages, customer: customer)));
        },
      ),
    );
  }
}
