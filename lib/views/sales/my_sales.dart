import 'dart:async';
import 'dart:core';
import 'package:craigslist/views/sales/edit_sale.dart';
import 'package:craigslist/views/sales/services/convert_date.dart';
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
import 'add_sale.dart';
import 'services/fetch_image.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:expandable/expandable.dart';

final oCcy = NumberFormat("#,##0", "en_US");

class MySales extends StatefulWidget {
  MySales({
    Key? key,
    required this.DataStore,
    required this.Storage,
    required this.Auth,
  }) : super(key: key);

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
        title: Text("$username's Sales"),
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
    return sales.isNotEmpty
        ? SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
                children: sales.map((sale) => SaleItem(sale: sale)).toList()))
        : Center(child: Text('Tap the + button below to add a sale!'));
  }
}

class SaleItem extends StatefulWidget {
  final Sale sale;
  SaleItem({required this.sale});

  @override
  SaleItemState createState() => SaleItemState();
}

class SaleItemState extends State<SaleItem> {
  final GlobalKey<ExpansionTileCardState> cardA = new GlobalKey();
  late List<SaleImage> saleImages;
  late StreamSubscription<QuerySnapshot<SaleImage>> _subscription;
  bool _isLoading = true;
  @override
  void initState() {
    saleImages = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var heading = widget.sale.title;
    var subheading = '\$${oCcy.format(widget.sale.price!)}';
    var cardImage = fetchImage(saleImages);
    var supportingText = widget.sale.description;
    if (_isLoading) {
      getImageStream();
    }
    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: <Widget>[
            cardImage,
            ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                ),
                header: Padding(
                    padding: EdgeInsets.all(10),
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
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacer(),
                    Text(
                      widget.sale.user!,
                      style: const TextStyle(
                        color: Colors.blueGrey,
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
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Spacer(),
                      Text(
                        widget.sale.user!,
                        style: const TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ]),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text('Condition: ${widget.sale.condition}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text('${widget.sale.description}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text('${convertDate(widget.sale.updatedAt)}'),
                    ),
                    ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/msgDetail',
                              arguments: [
                                'username',
                                widget.sale.id,
                                widget.sale.user
                              ]);
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xffA682FF)),
                        icon: Icon(Icons.message, size: 18),
                        label: Text('Message ${widget.sale.user}'))
                  ],
                ),
                builder: (_, collapsed, expanded) {
                  return Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
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
    ));
  }

// class SaleItem extends StatefulWidget {
//   final Sale sale;
//   SaleItem({required this.sale});

//   @override
//   SaleItemState createState() => SaleItemState();
// }

// class SaleItemState extends State<SaleItem> {
//   final GlobalKey<ExpansionTileCardState> cardA = new GlobalKey();
//   late List<SaleImage> saleImages;
//   late StreamSubscription<QuerySnapshot<SaleImage>> _subscription;
//   bool _isLoading = true;
//   @override
//   void initState() {
//     saleImages = [];
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var heading = widget.sale.title;
//     var subheading = '\$${oCcy.format(widget.sale.price!)}';
//     var cardImage = fetchImage(saleImages);
//     var supportingText = widget.sale.description;
//     if (_isLoading) {
//       getImageStream();
//     }
//     return ExpansionTileCard(
//       baseColor: Colors.white,
//       expandedColor: Theme.of(context).selectedRowColor,
//       key: cardA,
//       title: Text(heading!),
//       subtitle: Text(subheading),
//       leading: SizedBox(
//         height: 100.0,
//         width: 100.0,
//         child: cardImage,
//       ),
//       children: [
//         SizedBox(
//             height: MediaQuery.of(context).size.height * 0.3, child: cardImage),
//         Align(
//           alignment: Alignment.centerLeft,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 16.0,
//               vertical: 8.0,
//             ),
//             child: Text(supportingText!,
//                 style: Theme.of(context).textTheme.bodyText2),
//           ),
//         ),
//         ButtonBar(
//           alignment: MainAxisAlignment.spaceAround,
//           buttonHeight: 52.0,
//           buttonMinWidth: 90.0,
//           children: <Widget>[
//             FlatButton(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(4.0)),
//               onPressed: () {
//                 cardA.currentState?.expand();
//               },
//               child: Column(
//                 children: <Widget>[
//                   Icon(Icons.arrow_downward),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 2.0),
//                   ),
//                   Text('Open'),
//                 ],
//               ),
//             ),
//             FlatButton(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(4.0)),
//               onPressed: () {
//                 cardA.currentState?.collapse();
//               },
//               child: Column(
//                 children: <Widget>[
//                   Icon(Icons.arrow_upward),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 2.0),
//                   ),
//                   Text('Close'),
//                 ],
//               ),
//             ),
//             FlatButton(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(4.0)),
//               onPressed: () {},
//               child: Column(
//                 children: <Widget>[
//                   Icon(Icons.swap_vert),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 2.0),
//                   ),
//                   Text('Toggle'),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// class SaleItem extends StatefulWidget {
//   final Sale sale;
//   SaleItem({required this.sale});

//   @override
//   State<SaleItem> createState() => _SaleItemState();
// }

// class _SaleItemState extends State<SaleItem> {
//   late List<SaleImage> saleImages;
//   late StreamSubscription<QuerySnapshot<SaleImage>> _subscription;
//   bool _isLoading = true;
//   @override
//   void initState() {
//     saleImages = [];
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var heading = widget.sale.title;
//     var subheading = '\$${oCcy.format(widget.sale.price!)}';
//     var cardImage = fetchImage(saleImages);
//     var supportingText = widget.sale.description;
//     if (_isLoading) {
//       getImageStream();
//     }
//     return InkWell(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => EditSaleForm(
//                       sale: widget.sale,
//                       saleImages: saleImages,
//                     )),
//           );
//         },
//         child: Card(
//             shadowColor: Theme.of(context).shadowColor,
//             elevation: 6,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10.0),
//             ),
//             margin: EdgeInsets.only(left: 15, right: 15, top: 7.5, bottom: 7.5),
//             child: Column(
//               children: [
//                 ListTile(
//                   dense: true,
//                   tileColor: Theme.of(context).cardColor,
//                   shape: const RoundedRectangleBorder(
//                     borderRadius: BorderRadius.vertical(
//                       top: Radius.circular(10),
//                     ),
//                   ),
//                   title: Text(
//                     heading!,
//                     style: const TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20,
//                     ),
//                   ),
//                   subtitle: Text(
//                     subheading,
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                         color: Colors.green),
//                   ),
//                   trailing: IconButton(
//                       onPressed: () => showAlert(context),
//                       icon: Icon(Icons.delete_rounded)),
//                 ),
//                 SizedBox(
//                     height: MediaQuery.of(context).size.height * 0.3,
//                     child: cardImage),
//                 Container(
//                   padding: EdgeInsets.all(16.0),
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     supportingText!,
//                     style: const TextStyle(
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//               ],
//             )));
  // }

  showAlert(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Delete"),
      onPressed: () {
        _deleteSale(context);
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text(
        "Delete Sale",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: const Text("Are you sure you want to delete this sale?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
      debugPrint('An error occurred while deleting Sale: $e');
    }
  }

  Future<void> getImageStream() async {
    _subscription = Amplify.DataStore.observeQuery(SaleImage.classType,
            where: SaleImage.SALEID.eq(widget.sale.id))
        .listen((QuerySnapshot<SaleImage> snapshot) {
      setState(() {
        if (_isLoading) _isLoading = false;
        saleImages = snapshot.items;
      });
    });
  }
}
