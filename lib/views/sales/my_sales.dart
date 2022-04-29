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
import 'sale_detail_view.dart';

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
  // subscription of Todo QuerySnapshots - to be initialized at runtime
  late StreamSubscription<QuerySnapshot<Sale>> _subscription;

  // loading ui state - initially set to a loading state
  bool _isLoading = true;

  // list of Todos - initially empty
  List<Sale> _sales = [];

  @override
  void initState() {
    // kick off app initialization
    _initializeApp();
    super.initState();
  }

  Future<void> _initializeApp() async {
    // Query and Observe updates to Todo models. DataStore.observeQuery() will
    // emit an initial QuerySnapshot with a list of Todo models in the local store,
    // and will emit subsequent snapshots as updates are made
    //
    // each time a snapshot is received, the following will happen:
    // _isLoading is set to false if it is not already false
    // _todos is set to the value in the latest snapshot
    _subscription = widget.DataStore.observeQuery(Sale.classType)
        // _subscription = Amplify.DataStore.observeQuery(Sale.classType)
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
      appBar: AppBar(
        title: Text('My Sales List'),
      ),

      // body: Center(child: CircularProgressIndicator()),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SalesList(sales: _sales),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddSaleForm()),
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
                  builder: (context) => SaleDetailView(
                        sale: sale,
                        saleImages: SaleImages,
                      )));
        },
      ),
    );
  }
}

class AddSaleForm extends StatefulWidget {
  @override
  _AddSaleFormState createState() => _AddSaleFormState();
}

class _AddSaleFormState extends State<AddSaleForm> {
  String? imageURL;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  Future<String?> getDownloadUrl(key) async {
    try {
      final GetUrlResult result = await Amplify.Storage.getUrl(key: key);
      // NOTE: This code is only for demonstration
      // Your debug console may truncate the debugPrinted url string
      debugPrint('Got URL: ${result.url}');
      setState(() {
        imageURL = result.url;
      });
      return result.url;
    } on StorageException catch (e) {
      debugPrint('Error getting download URL: $e');
      return null;
    }
  }

  Future<void> uploadImage() async {
    final options = S3UploadFileOptions(
      accessLevel: StorageAccessLevel.guest,
    );

    // Select image from user's gallery
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      debugPrint('No image selected');
      return;
    }
    // Upload image with the current time as the key
    final key = DateTime.now().toString();
    final file = File(pickedFile.path);
    try {
      final UploadFileResult result = await Amplify.Storage.uploadFile(
          options: options,
          local: file,
          key: key,
          onProgress: (progress) {
            debugPrint("Fraction completed: " +
                progress.getFractionCompleted().toString());
          });
      debugPrint('Successfully uploaded image: ${result.key}');
      getDownloadUrl(key);
    } on StorageException catch (e) {
      debugPrint('Error uploading image: $e');
    }
  }

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _conditionController = TextEditingController();
  final _zipcodeController = TextEditingController();
  final _priceController = TextEditingController();

  Future<void> _saveSale() async {
    // get the current text field contents
    String title = _titleController.text;
    String condition = _conditionController.text;
    String description = _descriptionController.text;
    String zipcode = _zipcodeController.text;
    String price = _priceController.text;

    // create a new Sale from the form values
    Sale newSale = Sale(
      title: title,
      description: description.isNotEmpty ? description : null,
      condition: condition.isNotEmpty ? condition : null,
      zipcode: zipcode.isNotEmpty ? zipcode : null,
      price: price.isNotEmpty ? price : null,
    );

    try {
      await Amplify.DataStore.save(newSale);

      await Amplify.DataStore.save(SaleImage(
        imageURL: imageURL,
        saleID: newSale.getId(),
      ));
      // Close the form
      Navigator.of(context).pop();
    } catch (e) {
      debugPrint('An error occurred while saving Sale: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Sale'),
        actions: <Widget>[
          ElevatedButton(onPressed: _saveSale, child: Text('Save')),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                  controller: _titleController,
                  decoration:
                      InputDecoration(filled: true, labelText: 'Title')),
              TextFormField(
                  controller: _descriptionController,
                  decoration:
                      InputDecoration(filled: true, labelText: 'Description')),
              TextFormField(
                  controller: _conditionController,
                  decoration:
                      InputDecoration(filled: true, labelText: 'Condition')),
              TextFormField(
                  controller: _zipcodeController,
                  decoration:
                      InputDecoration(filled: true, labelText: 'Zipcode')),
              TextFormField(
                  controller: _priceController,
                  decoration:
                      InputDecoration(filled: true, labelText: 'Price')),
              ElevatedButton(
                  onPressed: uploadImage, child: Text('Upload Image')),
            ],
          ),
        ),
      ),
    );
  }
}
