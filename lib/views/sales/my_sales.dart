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
import 'sale_detail_owner.dart';
import 'add_sale.dart';
import '../drawer.dart';

class MySales extends StatefulWidget {
  MySales(
      {Key? key,
      required this.DataStore,
      required this.Storage,
      required this.Auth,
      required this.username})
      : super(key: key);

  final AmplifyDataStore DataStore;
  final AmplifyStorageS3 Storage;
  final AmplifyAuthCognito Auth;
  final String username;

  @override
  _MySalesState createState() => _MySalesState();
}

class _MySalesState extends State<MySales> {
  // subscription of Todo QuerySnapshots - to be initialized at runtime
  late StreamSubscription<QuerySnapshot<Sale>> _subscription;

  // loading ui state - initially set to a loading state
  bool _isLoading = true;

  // list of Todos - initially empty
  List<Sale> _sales = [];

  @override
  void initState() {
    // kick off app initialization
    getSalesStream();
    super.initState();
  }

  Future<void> getSalesStream() async {
    _subscription = widget.DataStore.observeQuery(Sale.classType,
            where: (Sale.USER.eq(widget.username)))
        .listen((QuerySnapshot<Sale> snapshot) {
      setState(() {
        if (_isLoading) _isLoading = false;
        _sales = snapshot.items;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(context),
      appBar: AppBar(
        backgroundColor: const Color(0xffA682FF),
        title: Text('My Sales'),
      ),

      // body: Center(child: CircularProgressIndicator()),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SalesList(sales: _sales),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddSaleForm(username: widget.username)),
          );
        },
        tooltip: 'Add Sale',
        label: Row(
          children: [Icon(Icons.add), Text('Add Sale')],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class SalesList extends StatelessWidget {
  final List<Sale> sales;

  SalesList({required this.sales});

  @override
  Widget build(BuildContext context) {
    return sales.length >= 1
        ? ListView(
            padding: EdgeInsets.all(8),
            children: sales.map((sale) => SaleItem(sale: sale)).toList())
        : Center(child: Text('Tap button below to add a sale!'));
  }
}

class SaleItem extends StatelessWidget {
  final double iconSize = 24.0;
  final Sale sale;

  SaleItem({required this.sale});

  void _deleteSale(BuildContext context) async {
    List<SaleImage> saleImage = (await Amplify.DataStore.query(
        SaleImage.classType,
        where: SaleImage.SALEID.eq(sale.id)));
    try {
      // Delete the sale and the associated image
      await Amplify.DataStore.delete(sale);
      await Amplify.DataStore.delete(saleImage[0]);
    } catch (e) {
      debugPrint('An error occurred while deleting Todo: $e');
    }
  }

  Future<List<SaleImage>> getSaleImage(Sale sale) async {
    List<SaleImage> images = (await Amplify.DataStore.query(SaleImage.classType,
        where: SaleImage.SALEID.eq(sale.id)));
    String? image = images[0].imageURL;
    return images;
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
                      icon: const Icon(Icons.delete),
                      tooltip: 'Delete Sale',
                      onPressed: () {
                        _deleteSale(context);
                      })
                ],
              ),
            ),
          ]),
        ),
        onTap: () async {
          List<SaleImage> SaleImages = await getSaleImage(sale);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SaleDetailOwnerView(
                        sale: sale,
                        saleImages: SaleImages,
                      )));
        },
      ),
    );
  }
}
