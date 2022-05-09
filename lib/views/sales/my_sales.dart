import 'dart:async';
import 'dart:core';
import 'package:craigslist/views/sales/edit_sale.dart';
import 'package:intl/intl.dart';

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
import 'services/image_container.dart';
import 'services/fetch_image.dart';

final oCcy = NumberFormat("#,##0.00", "en_US");

class MySales extends StatefulWidget {
  MySales(
      {Key? key,
      required this.DataStore,
      required this.Storage,
      required this.Auth})
      : super(key: key);

  final AmplifyDataStore DataStore;
  final AmplifyStorageS3 Storage;
  final AmplifyAuthCognito Auth;

  @override
  _MySalesState createState() => _MySalesState();
}

class _MySalesState extends State<MySales> {
  late StreamSubscription<QuerySnapshot<Sale>> _subscription;
  bool _isLoading = true;
  List<Sale> _sales = [];
  String username = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> getSalesStream() async {
    _subscription = widget.DataStore.observeQuery(Sale.classType,
            where: (Sale.USER.eq(username)))
        .listen((QuerySnapshot<Sale> snapshot) {
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
    username = args[0].toString();

    if (_isLoading) {
      getSalesStream();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffA682FF),
        title: Text("${username}'s Sales"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddSaleForm(username: username)),
                );
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SalesList(sales: _sales),
    );
  }
}

class SalesList extends StatelessWidget {
  final List<Sale> sales;

  SalesList({required this.sales});

  @override
  Widget build(BuildContext context) {
    return sales.length >= 1
        ? SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
                children: sales.map((sale) => SaleItem(sale: sale)).toList()))
        : Center(child: Text('Tap button below to add a sale!'));
  }
}

class SaleItem extends StatefulWidget {
  final Sale sale;

  SaleItem({required this.sale});

  @override
  State<SaleItem> createState() => _SaleItemState();
}

class _SaleItemState extends State<SaleItem> {
  late List<SaleImage> saleImages;
  @override
  void initState() {
    getSaleImages(widget.sale);
    saleImages = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildCard();
  }

  InkWell buildCard() {
    var heading = widget.sale.title;
    var subheading = widget.sale.price;
    var cardImage = fetchImage(saleImages);
    var supportingText = widget.sale.description;
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditSaleForm(
                      sale: widget.sale,
                      saleImages: saleImages,
                    )),
          );
        },
        child: Card(
            shadowColor: const Color(0xffA682FF),
            elevation: 4.0,
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    heading!,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '\$${oCcy.format(int.parse(widget.sale.price!))}',
                    style: TextStyle(color: Colors.green),
                  ),
                  trailing: IconButton(
                      onPressed: () {
                        _deleteSale(context);
                      },
                      icon: Icon(Icons.delete)),
                ),
                Container(
                  height: 200.0,
                  child: Ink.image(
                    image: cardImage,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  alignment: Alignment.centerLeft,
                  child: Text(supportingText!),
                ),
              ],
            )));
  }

  void _deleteSale(BuildContext context) async {
    List<SaleImage> saleImage = (await Amplify.DataStore.query(
        SaleImage.classType,
        where: SaleImage.SALEID.eq(widget.sale.id)));
    try {
      // Delete the sale and the associated image
      await Amplify.DataStore.delete(widget.sale);
      await Amplify.DataStore.delete(saleImage[0]);
    } catch (e) {
      debugPrint('An error occurred while deleting Todo: $e');
    }
  }

  Future<List<SaleImage>?> getSaleImages(Sale sale) async {
    List<SaleImage> images = (await Amplify.DataStore.query(SaleImage.classType,
        where: SaleImage.SALEID.eq(sale.id)));
    String? image = images[0].imageURL;
    setState(() {
      saleImages = images;
    });
    return images;
  }
}
