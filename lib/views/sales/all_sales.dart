import 'dart:core';
import 'package:craigslist/views/sales/services/convert_date.dart';
import 'package:expandable/expandable.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import '../../models/ModelProvider.dart';
import 'services/convert_price.dart';
import 'services/fetch_image.dart';
import './search.dart';

final oCcy = NumberFormat("#,##0", "en_US");

class AllSales extends StatefulWidget {
  const AllSales({
    Key? key,
    required this.dataStore,
    required this.storage,
    required this.auth,
  }) : super(key: key);

  final AmplifyDataStore dataStore;
  final AmplifyStorageS3 storage;
  final AmplifyAuthCognito auth;

  @override
  _AllSalesState createState() => _AllSalesState();
}

class _AllSalesState extends State<AllSales> {

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

      widget.dataStore.observeQuery(Sale.classType, sortBy: sortQueries)
            .listen((QuerySnapshot<Sale> snapshot) {
      if(mounted) {
        setState(() {
        _sales = snapshot.items;
        if (_isLoading) _isLoading = false;
      });
      }
    });
  }

  Future<void> getSalesStreamByTag(String tagLabel) async {
    /// Pulls the tags that match the given label. This list will
    /// be used to query the sales data. It is set to begins with
    /// in order to pull any closely matched tags.
    widget.dataStore.observeQuery(Tag.classType,
            where: Tag.LABEL.contains(tagLabel))
        .listen((QuerySnapshot<Tag> snapshot) {
      if(mounted) {
        setState(() {
          _sales = [];
          _tags = snapshot.items;
          for (var tag in _tags) {
            getSalesStream(tag.saleID);
          }
        });
      }
    });
  }

  Future<void> getSalesStream(String saleID) async {
    /// Performs an individual query by tags saleID and adds them
    /// to the list. This is a helper function to the tag stream builder.
    widget.dataStore.observeQuery(
      Sale.classType,
      where: Sale.ID.eq(saleID),
    ).listen((QuerySnapshot<Sale> snapshot) {
      if (snapshot.items.isNotEmpty) {
        _sales.add(snapshot.items[0]);
      }
      if(mounted) {
        setState(() {
        dateOrPrice
            ? sortByNewest
                ? _sales.sort((b, a) => a.date!.compareTo(b.date!))
                : _sales.sort((a, b) => a.date!.compareTo(b.date!))
            : sortByPrice
                ? _sales.sort((a, b) => a.price!.compareTo(b.price!))
                : _sales.sort((b, a) => a.price!.compareTo(b.price!));
        if (_isLoading) _isLoading = false;
      });
      }
    });
  }

  List<QuerySortBy> getCurrentQueries() {
    /// Takes the current tags and updates the queries for the search.
    List<QuerySortBy> queries = [];

    dateOrPrice
        ? sortByNewest
            ? queries.add(Sale.DATE.descending())
            : queries.add(Sale.DATE.ascending())
        : sortByPrice
            ? queries.add(Sale.PRICE.ascending())
            : queries.add(Sale.PRICE.descending());

    return queries;
  }

  void toggleSortByPrice() {
    /// Toggles the sort by price to show lowest or highest price.
    
    if(mounted) {
      setState(() {
      dateOrPrice = false;
      sortByPrice = !sortByPrice;
      !sortByRelevance ? getAllSalesStream() : enableAllButton(tag);
      });
    }
  }

  void toggleSortByDate() {
    /// Toggles the sort by date boolean to show newest or oldest.
    if(mounted) {
      setState(() {
      dateOrPrice = true;
      sortByNewest = !sortByNewest;
      !sortByRelevance ? getAllSalesStream() : enableAllButton(tag);
    });
    }
  }

  void setTagString(String saleTag) {
    /// Sets the tag string in order to be used by relevant methods
    /// not inside [Search].
    if(mounted) {
      setState(() {
      tag = saleTag;
      enableAllButton(saleTag);
    });
    }  
  }

  void enableAllButton(String tag) {
    /// Enables the All button and allows interaction when this is toggled.
    if(mounted) {
      setState(() {
      sortByRelevance = true;
      getSalesStreamByTag(tag);
    });
    }
  }

  void showAllSales() {
    /// Disables the All button and performs a search query for all sales.
    if(mounted) {
      setState(() {
      sortByRelevance = false;
      getAllSalesStream();
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String?> args =
        ModalRoute.of(context)!.settings.arguments as List<String?>;
    customer = args[0].toString();

    /// On the start of entering the sale page all sales are populated.
    if (_isLoading && !sortByRelevance) {
      getAllSalesStream();
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffA682FF),
          title: const Text("Buy"),
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

  const SalesList(
      {Key? key,
      required this.sales,
      required this.customer,
      required this.sortByNewest}) 
      : super(key: key);

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
  const SaleItem({Key? key, 
                required this.sale, 
                required this.customer})
                : super(key: key);
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
    getSaleImages(widget.sale);
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await getSaleTags(widget.sale);
      if(mounted) setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var heading = widget.sale.title;
    var subheading = widget.sale.category!;
    var price = convertPrice(widget.sale.price!);
    var cardImage = fetchImage(saleImages);

    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.all(10),
      child: Stack(children: [
        Card(
          shadowColor: Theme.of(context).shadowColor,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: cardImage,
              ),
              ScrollOnExpand(
                scrollOnExpand: true,
                scrollOnCollapse: false,
                child: ExpandablePanel(
                  theme: const ExpandableThemeData(
                    headerAlignment: ExpandablePanelHeaderAlignment.center,
                    tapBodyToCollapse: true,
                  ),
                  header: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        heading!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                  collapsed: Row(
                    children: [
                      Text(
                        subheading,
                        style: const TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Text(
                        widget.sale.user!,
                        style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  expanded: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(children: [
                        Text(
                          subheading,
                          style: const TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Text(
                          widget.sale.user!,
                          style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ]),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text('${widget.sale.description}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text('Condition: ${widget.sale.condition}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                            'Posted ${convertDate(widget.sale.updatedAt)}'),
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.spaceAround,
                        buttonHeight: 52.0,
                        buttonMinWidth: 90.0,
                        children: [
                          ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  primary: Theme.of(context).primaryColorDark),
                              onPressed: () {
                                Navigator.pushNamed(context, '/msgDetail',
                                    arguments: [
                                      widget.customer,
                                      widget.sale.id,
                                      widget.sale.user
                                    ]);
                              },
                              icon: const Icon(
                                Icons.message_rounded,
                                color: Colors.white,
                              ),
                              label: Text('Message ${widget.sale.user}'))
                        ],
                      ),
                    ],
                  ),
                  builder: (_, collapsed, expanded) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      child: Expandable(
                        collapsed: collapsed,
                        expanded: expanded,
                        theme: const ExpandableThemeData(crossFadePoint: 0),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
            decoration: BoxDecoration(
                color: Colors.green,
                border: Border.all(color: Colors.green),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(price,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )),
            ))
      ]),
    ));
  }

  Future<List<SaleImage>?> getSaleImages(Sale sale) async {
    List<SaleImage> images = (await Amplify.DataStore.query(SaleImage.classType,
        where: SaleImage.SALEID.eq(sale.id)));
    if(mounted) {
      setState(() {
      saleImages = images;
    });
    }
    return saleImages;
  }

  Future<List<Tag>?> getSaleTags(Sale sale) async {
    List<Tag> saleTags = (await Amplify.DataStore.query(Tag.classType,
        where: Tag.SALEID.eq(sale.id)));
    if(mounted) {
      setState(() {
      tags = saleTags;
    });
    }
    return saleTags;
  }
}

