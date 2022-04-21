// dart async library we will refer to when setting up real time updates
import 'dart:async';
import 'dart:core';
import 'dart:io';
// flutter and ui libraries
import 'package:flutter/material.dart';
// amplify packages we will need to use
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:image_picker/image_picker.dart';
// amplify configuration and models that should have been generated for you
import '../../amplifyconfiguration.dart';
import '../../models/sale/ModelProvider.dart';
import '../../models/sale/Sale.dart';
import 'upload_image.dart';

class MySales extends StatefulWidget {
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

  // amplify plugins
  final AmplifyDataStore _dataStorePlugin =
      AmplifyDataStore(modelProvider: ModelProvider.instance);
  final AmplifyAPI _apiPlugin = AmplifyAPI();
  final AmplifyAuthCognito _authPlugin = AmplifyAuthCognito();
  final AmplifyStorageS3 storage = AmplifyStorageS3();

  @override
  void initState() {
    // kick off app initialization
    _initializeApp();

    super.initState();
  }

  @override
  void dispose() {
    // to be filled in a later step
    super.dispose();
  }

  Future<void> _initializeApp() async {
    // configure Amplify
    await _configureAmplify();

    // Query and Observe updates to Todo models. DataStore.observeQuery() will
    // emit an initial QuerySnapshot with a list of Todo models in the local store,
    // and will emit subsequent snapshots as updates are made
    //
    // each time a snapshot is received, the following will happen:
    // _isLoading is set to false if it is not already false
    // _todos is set to the value in the latest snapshot
    _subscription = Amplify.DataStore.observeQuery(Sale.classType)
        .listen((QuerySnapshot<Sale> snapshot) {
      setState(() {
        if (_isLoading) _isLoading = false;
        _sales = snapshot.items;
      });
    });
  }

  Future<void> _configureAmplify() async {
    try {
      // add Amplify plugins
      await Amplify.addPlugins(
          [_dataStorePlugin, _apiPlugin, _authPlugin, storage]);
      // configure Amplify
      //
      // note that Amplify cannot be configured more than once!
      await Amplify.configure(amplifyconfig);
    } catch (e) {
      // error handling can be improved for sure!
      // but this will be sufficient for the purposes of this tutorial
      print('An error occurred while configuring Amplify: $e');
    }
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
    try {
      // to delete data from DataStore, we pass the model instance to
      // Amplify.DataStore.delete()
      await Amplify.DataStore.delete(sale);
    } catch (e) {
      print('An error occurred while deleting Todo: $e');
    }
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
                          style: TextStyle(
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
      ),
    );
  }
}

class AddSaleForm extends StatefulWidget {
  @override
  _AddSaleFormState createState() => _AddSaleFormState();
}

class _AddSaleFormState extends State<AddSaleForm> {
  final picker = ImagePicker();

  Future<void> uploadImage() async {
    // Select image from user's gallery
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      print('No image selected');
      return;
    }

    // Upload image with the current time as the key
    final key = DateTime.now().toString();
    final file = File(pickedFile.path);
    try {
      final UploadFileResult result = await Amplify.Storage.uploadFile(
          local: file,
          key: key,
          onProgress: (progress) {
            print("Fraction completed: " +
                progress.getFractionCompleted().toString());
          });
      print('Successfully uploaded image: ${result.key}');
    } on StorageException catch (e) {
      print('Error uploading image: $e');
    }
  }

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _conditionController = TextEditingController();
  final _zipcodeController = TextEditingController();
  final _priceController = TextEditingController();
  // final _postDateController = TextEditingController();

  Future<void> _saveSale() async {
    // get the current text field contents
    String title = _titleController.text;
    String description = _conditionController.text;
    String condition = _descriptionController.text;
    String zipcode = _zipcodeController.text;
    String price = _priceController.text;
    // String postDate = _postDateController.text;

    // create a new Sale from the form values
    Sale newSale = Sale(
      title: title,
      description: description.isNotEmpty ? description : null,
      condition: condition.isNotEmpty ? condition : null,
      zipcode: zipcode.isNotEmpty ? zipcode : null,
      price: price.isNotEmpty ? price : null,
      // postDate: TemporalDateTime(DateTime.now())
    );

    try {
      // to write data to DataStore, we simply pass an instance of a model to
      // Amplify.DataStore.save()
      await Amplify.DataStore.save(newSale);
      uploadImage();
      // after creating a new Todo, close the form
      Navigator.of(context).pop();
    } catch (e) {
      print('An error occurred while saving Sale: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Sale'),
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
              ElevatedButton(onPressed: _saveSale, child: Text('Save')),
              ElevatedButton(
                  onPressed: uploadImage, child: Text('Upload Image')),
            ],
          ),
        ),
      ),
    );
  }
}
