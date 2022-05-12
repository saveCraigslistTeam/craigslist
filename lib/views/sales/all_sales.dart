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
  const AllSales({
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
  bool sortByRelevance = false;
  bool sortByDate = false;
  bool sortByPrice = false;

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
        title: const Text("All Sales"),
      ),
      body: _isLoading
          ? const Center(child: const CircularProgressIndicator())
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
  const SalesList({Key? key, required this.sales, required this.customer});

  @override
  Widget build(BuildContext context) {
    return sales.isNotEmpty
        ? Column(
            children: [
              Expanded(
                flex: 7,
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                        children: sales
                            .map((sale) =>
                                SaleItem(sale: sale, customer: customer))
                            .toList())),
              ),
              const Expanded(
                flex: 3,
                child: Search(),
              )
            ],
          )
        : const Center(child: const Text('No sales in your area!'));
  }
}

class SaleItem extends StatefulWidget {
  const SaleItem({Key? key, required this.sale, required this.customer});
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
    var subheading = '${widget.sale.price!}';
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
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    subheading,
                    style: const TextStyle(color: Colors.green),
                  ),
                  trailing: IconButton(
                      onPressed: () {}, icon: const Icon(Icons.favorite)),
                ),
                cardImage,
                Container(
                  padding: const EdgeInsets.all(16.0),
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

// Search Features
class Search extends StatelessWidget {
  // final Function sortByNewest;
  // final Function sortByClosestMatch;
  // final Function sortByPrice;

  const Search({
    Key? key,
    // required this.sortByNewest,
    // required this.sortByClosestMatch,
    // required this.sortByPrice
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    bool newOrOld = false;
    bool matchOrAll = false;
    bool lowOrHigh = false;

    return Column(
      children: [
        Expanded(
            flex: 2,
            child: buttonRow(newOrOld, matchOrAll, lowOrHigh, context)),
        Expanded(
          flex: 8,
          child: Form(
            key: formKey,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingSides(context),
                        vertical: paddingTopAndBottom(context)),
                    child: Container(
                      color: Colors.white,
                      width: 350,
                      child: TextFormField(
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              suffixIcon: IconButton(
                                  icon: const Icon(Icons.search),
                                  color: Theme.of(context).primaryColor,
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      formKey.currentState!.save();
                                      formKey.currentState?.reset();
                                    }
                                  })),
                          maxLines: 3,
                          minLines: 1,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                          onSaved: (value) {
                            null;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty || value == '') {
                              return 'Please enter a message';
                            } else {
                              return null;
                            }
                          }),
                    ),
                  ),
                ]),
          ),
        )
      ],
    );
  }
}

Widget customButton(String label, BuildContext context) {
  /// Creates a button with [label] and specified function.
  final MaterialStateProperty<Color> buttonColor =
      MaterialStateProperty.all(Theme.of(context).primaryColor);

  return (ElevatedButton(
      onPressed: () {},
      child: Text(label),
      style: ButtonStyle(backgroundColor: buttonColor)));
}

Widget buttonRow(
    bool newOrOld, bool matchOrAll, bool lowOrHigh, BuildContext context) {
  /// Adds three search buttons to the top of the search button.
  String button1 = newOrOld ? 'Oldest' : 'Newest';
  String button2 = matchOrAll ? 'All' : 'Closest Match';
  String button3 = lowOrHigh ? 'Price Highest' : 'Price lowest';

  return (Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Spacer(flex: 1),
      customButton(button1, context), // Sort by newest or oldest.
      const Spacer(flex: 1),
      customButton(button2, context), // Sort by All or closest match.
      const Spacer(flex: 1),
      customButton(button3, context), // Sort by Highest and lowest price.
      const Spacer(flex: 1)
    ],
  ));
}

double paddingSides(BuildContext context) {
  /// Adds padding to the sides of the field
  return MediaQuery.of(context).size.width * 0.03;
}

double paddingTopAndBottom(BuildContext context) {
  /// Adds padding to the top and bottom of the form field.
  return MediaQuery.of(context).size.height * 0.01;
}
