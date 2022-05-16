import 'dart:async';
import 'dart:core';
import 'package:craigslist/views/sales/edit_sale.dart';
import 'package:intl/intl.dart';
// Sorting algorithm collections
import 'package:collection/collection.dart';
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
  late StreamSubscription<QuerySnapshot<Tag>> _tagSubscription;

  bool _isLoading = true;
  List<Tag> _tags = [];
  List<Sale> _sales = [];

  // Username of potential buyer
  String customer = '';

  // Tag needed for search query
  String tag = '';

  // Search Features
  bool sortByRelevance = false; // All sales or only relevant sales
  bool sortByNewest = false; // Sort by newest or oldest
  bool sortByPrice = false; // Sort by lowest price or highest price
  // Used for the sort to toggle between searching by date or by price.
  // both are unable to be used at the same time. True is date, false is
  // price.
  bool dateOrPrice = false; 

  @override
  void initState() {
    super.initState();
  }

  Future<void> getAllSalesStream() async {
    /// Performs a query of all sales
    
    List<QuerySortBy> sortQueries = getCurrentQueries();

    _subscription = widget.DataStore.observeQuery(
      Sale.classType,
      sortBy: sortQueries
    ).listen((QuerySnapshot<Sale> snapshot) {
      setState(() {
        _sales = snapshot.items;
        if (_isLoading) _isLoading = false;
      });
    });
  }

  Future<void> getSalesStreamByTag(String tagLabel) async {
    /// Pulls the tags that match the given label. This list will
    /// be used to query the sales data. It is set to begins with
    /// in order to pull any closely matched tags.

    _tagSubscription = widget.DataStore.observeQuery(Tag.classType,
            where: Tag.LABEL.contains(tagLabel))
        .listen((QuerySnapshot<Tag> snapshot) {
      setState(() {
        // if (!_isLoading) _isLoading = true;
        _sales = [];
        _tags = snapshot.items;
        for (var tag in _tags) {
          getSalesStream(tag.saleID);
        }
      });
    });
  }

  Future<void> getSalesStream(String saleID) async {
    /// Performs an individual query by tags saleID and adds them
    /// to the list. This is a helper function to the tag stream builder.

    _subscription = widget.DataStore.observeQuery(
      Sale.classType,
      where: Sale.ID.eq(saleID),
    ).listen((QuerySnapshot<Sale> snapshot) {
      if (snapshot.items.isNotEmpty) {
        _sales.add(snapshot.items[0]);
      }
      setState(() {
        _sales = _sales;
        if (_isLoading) _isLoading = false;
      });
    });
  }

  List<QuerySortBy> getCurrentQueries() {
    /// Takes the current tags and updates the queries for the search.
    List<QuerySortBy> queries = [];

    dateOrPrice 
    ? sortByNewest ? queries.add(Sale.DATE.descending()) : queries.add(Sale.DATE.ascending())
    : sortByPrice ? queries.add(Sale.PRICE.ascending()) : queries.add(Sale.PRICE.descending());

    return queries;
  }

  void toggleSortByPrice() {
    /// Toggles the sort by price to show lowest or highest price.
    setState(() {
      dateOrPrice = false;
      sortByPrice = !sortByPrice;
      !sortByRelevance ? getAllSalesStream() : enableAllButton(tag);
    });
  }

  void toggleSortByDate() {
    /// Toggles the sort by date boolean to show newest or oldest.
    setState(() {
      dateOrPrice = true;
      sortByNewest = !sortByNewest;
      !sortByRelevance ? getAllSalesStream() : enableAllButton(tag);
    });
  }

  void setTagString(String saleTag) {
    /// Sets the tag string in order to be used by relevant methods 
    /// not inside [Search].
    setState(() {
      tag = saleTag;
      enableAllButton(saleTag);
    });
  }

  void enableAllButton(String tag) {
    /// Enables the All button and allows interaction when this is toggled.
    setState(() {
      sortByRelevance = true;
      getSalesStreamByTag(tag);
    });
  }

  void showAllSales() {
    /// Disables the All button and performs a search query for all sales.
    setState(() {
      sortByRelevance = false;
      getAllSalesStream();
    });
  }


  @override
  Widget build(BuildContext context) {
    List<String?> args =
        ModalRoute.of(context)!.settings.arguments as List<String?>;
    customer = args[0].toString();

    /// On the start of entering the sale page all sales are populated.
    if(_isLoading && !sortByRelevance) {
      getAllSalesStream();
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffA682FF),
          title: const Text("All Sales"),
        ),
        body: Column(
          children: [
            _isLoading
                ? const Expanded(
                    flex: 7, child: Center(child: Text('Enter a search')))
                : Expanded(
                    flex: 7,
                    child: SalesList(
                      sales: _sales,
                      customer: customer,
                      sortByNewest: sortByNewest,
                    ),
                  ),
            Expanded(
                flex: 3,
                child: Search(
                    setTagString: setTagString,
                    sortByRelevance: sortByRelevance,
                    showAllSales: showAllSales,
                    toggleSortByDate: toggleSortByDate,
                    sortByNewest: sortByNewest,
                    toggleSortByPrice: toggleSortByPrice,
                    sortByPrice: sortByPrice))
          ],
        ));
  }
}

class SalesList extends StatelessWidget {
  final List<Sale> sales;
  final String customer;
  final bool sortByNewest;

  SalesList(
      {Key? key,
      required this.sales,
      required this.customer,
      required this.sortByNewest});

  @override
  Widget build(BuildContext context) {
    return sales.isNotEmpty
        ? SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
                children: sales
                    .map((sale) => SaleItem(sale: sale, customer: customer))
                    .toList()))
        : const Center(child: Text('No sales match your criteria!'));
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
  /// Toggle the boolean that enables the All button.
  final Function setTagString;
  /// Tells the all button whether to enable (currently searching by tag) or
  /// disable (currently searching by all).
  final bool sortByRelevance;
  /// Toggles the tag search to off and then performs a search for all sales.
  final Function showAllSales;

  /// Toggle the boolean that changes the text for the newest oldest search.
  final Function toggleSortByDate;
  /// Boolean used to update the newest button to oldest so that the user can
  /// change the search criteria.
  final bool sortByNewest;

  /// Sets the toggle to sort the relevant search by price.
  final Function toggleSortByPrice;
  /// Boolean used to update the price button text so that the user can see the
  /// change in criteria.
  final bool sortByPrice;

  const Search({
    Key? key,
    required this.setTagString,
    required this.sortByRelevance,
    required this.showAllSales,
    required this.toggleSortByDate,
    required this.sortByNewest,
    required this.toggleSortByPrice,
    required this.sortByPrice
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String tag = '';

    Widget newestButton = customButton(sortByNewest ? 'Oldest' : 'Newest', 
                                      context, toggleSortByDate);
    Widget priceButton = customButton(sortByPrice ? 'Price Highest' : 'Price lowest',
                                      context, toggleSortByPrice);
    Widget allButton = customAllButton('All', sortByRelevance, context, showAllSales);

    return Column(children: [
      Expanded(
          flex: 2,
          child: buttonRow(newestButton, allButton, priceButton, context)),
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
                                          if (formKey.currentState!
                                              .validate()) {
                                            formKey.currentState!.save();
                                            setTagString(tag);
                                            formKey.currentState?.reset();
                                          }
                                        })),
                                maxLines: 3,
                                minLines: 1,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.text,
                                onSaved: (value) {
                                  tag = value!;
                                },
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value == '') {
                                    return 'Please enter a message';
                                  } else {
                                    return null;
                                  }
                                })))
                  ])))
    ]);
  }
}

Widget customButton(String label, BuildContext context, Function func) {
  /// Creates a button with [label] and specified function.
  final MaterialStateProperty<Color> buttonColor =
      MaterialStateProperty.all(Theme.of(context).primaryColor);

  return (ElevatedButton(
      onPressed: () {
        func();
      },
      child: Text(label),
      style: ButtonStyle(backgroundColor: buttonColor)));
}

Widget customAllButton(String label,
                bool isEnabled,
                BuildContext context, 
                Function func) {
  /// Creates a button with [label] and specified function.
  final MaterialStateProperty<Color> buttonColor =
      MaterialStateProperty.all(Theme.of(context).primaryColor);
  final MaterialStateProperty<Color> offColor =
      MaterialStateProperty.all(Colors.grey);

  return (
    ElevatedButton(
      onPressed: () {
        isEnabled ? func() : null;
      },
      child: Text(label),
      style: ButtonStyle(backgroundColor: isEnabled ? buttonColor : offColor)));
}

Widget buttonRow(Widget button1,
                 Widget button2,
                 Widget button3,
                 BuildContext context) {
  /// Adds three search buttons to the top of the search button.

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Spacer(flex: 1),
      button1, // Sort by newest or oldest.
      const Spacer(flex: 1),
      button2, // Sort by All or closest match.
      const Spacer(flex: 1),
      button3, // Sort by Highest and lowest price.
      const Spacer(flex: 1)
    ]);
}

double paddingSides(BuildContext context) {
  /// Adds padding to the sides of the field
  return MediaQuery.of(context).size.width * 0.03;
}

double paddingTopAndBottom(BuildContext context) {
  /// Adds padding to the top and bottom of the form field.
  return MediaQuery.of(context).size.height * 0.01;
}
