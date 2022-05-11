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
import 'sale_detail.dart';
import 'add_sale.dart';
import 'services/fetch_image.dart';

final oCcy = NumberFormat("#,##0.00", "en_US");

class AllSales extends StatefulWidget {
  AllSales({
    Key? key,
    required this.DataStore,
    required this.Storage,
    required this.Auth,
  }) : super(key: key);

  final AmplifyDataStore DataStore;
  final AmplifyStorageS3 Storage;
  final AmplifyAuthCognito Auth;

  @override
  _AllSalesState createState() => _AllSalesState();
}

class _AllSalesState extends State<AllSales> {
  late StreamSubscription<QuerySnapshot<Sale>> _subscription;
  bool _isLoading = true;
  List<Sale> _sales = [];
  // Username of potential buyer
  String customer = '';

  // Search Features
  bool sortByDate = false;
  bool sortByRelevance = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String?> args =
        ModalRoute.of(context)!.settings.arguments as List<String?>;
    customer = args[0].toString();

    if (_isLoading) {
      getSalesStream();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffA682FF),
        title: Text("All Sales"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SalesList(sales: _sales, customer: customer),
    );
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
}

class SalesList extends StatelessWidget {
  final List<Sale> sales;
  final String customer;
  SalesList({required this.sales, required this.customer});

  @override
  Widget build(BuildContext context) {
    return sales.length >= 1
        ? SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
                children: sales
                    .map((sale) => SaleItem(sale: sale, customer: customer))
                    .toList()))
        : Center(child: Text('No sales in your area!'));
  }
}

class SaleItem extends StatefulWidget {
  SaleItem({required this.sale, required this.customer});
  final Sale sale;
  final String customer;
  @override
  State<SaleItem> createState() => _SaleItemState();
}

class _SaleItemState extends State<SaleItem> {
  late List<SaleImage> saleImages;
  late List<Tag> tags;
  @override
  void initState() {
    saleImages = [];
    tags = [];
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await getSaleImages(widget.sale);
      await getSaleTags(widget.sale);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var heading = widget.sale.title;
    var subheading = '\$${oCcy.format(int.parse(widget.sale.price!))}';
    var cardImage = fetchImage(saleImages);
    var supportingText = widget.sale.description;
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SaleDetailView(
                    sale: widget.sale,
                    saleImages: saleImages,
                    tags: tags,
                    customer: widget.customer)),
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
                    subheading,
                    style: TextStyle(color: Colors.green),
                  ),
                  trailing:
                      IconButton(onPressed: () {}, icon: Icon(Icons.favorite)),
                ),
                cardImage,
                Container(
                  padding: EdgeInsets.all(16.0),
                  alignment: Alignment.centerLeft,
                  child: Text(supportingText!),
                ),
              ],
            )));
  }

  Future<List<SaleImage>?> getSaleImages(Sale sale) async {
    List<SaleImage> images = (await Amplify.DataStore.query(SaleImage.classType,
        where: SaleImage.SALEID.eq(sale.id)));
    setState(() {
      saleImages = images;
    });
    return images;
  }

  Future<List<Tag>?> getSaleTags(Sale sale) async {
    List<Tag> saleTags = (await Amplify.DataStore.query(Tag.classType,
        where: Tag.SALEID.eq(sale.id)));
    setState(() {
      tags = saleTags;
    });
    return saleTags;
  }
}
