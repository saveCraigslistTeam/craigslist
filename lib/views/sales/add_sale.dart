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

class AddSaleForm extends StatefulWidget {
  @override
  _AddSaleFormState createState() => _AddSaleFormState();
}

class _AddSaleFormState extends State<AddSaleForm> {
  String imageURL = '';
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
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
              imageSelector(imageURL: imageURL),
            ],
          ),
        ),
      ),
    );
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
}

class imageSelector extends StatelessWidget {
  const imageSelector({Key? key, required this.imageURL}) : super(key: key);
  final String imageURL;

  @override
  Widget build(BuildContext context) {
    return imageURL != ''
        ? Padding(
            padding: const EdgeInsets.all(25.0),
            child: Image.network(imageURL.toString(), height: 400))
        : Container();
  }
}
