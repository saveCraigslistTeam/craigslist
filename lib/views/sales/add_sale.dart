// dart async library we will refer to when setting up real time updates
import 'dart:async';
import 'dart:core';
import 'dart:io';
// flutter and ui libraries
import 'package:craigslist/views/sales/services/parse_tags.dart';
import 'package:flutter/material.dart';
// amplify packages we will need to use
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:image_picker/image_picker.dart';
// amplify configuration and models that should have been generated for you
import '../../models/ModelProvider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class AddSaleForm extends StatefulWidget {
  AddSaleForm({Key? key, required this.username}) : super(key: key);
  final String username;

  @override
  _AddSaleFormState createState() => _AddSaleFormState();
}

class _AddSaleFormState extends State<AddSaleForm> {
  late String imageURL;
  late String imageFile;
  late List<String> tagLabels;
  final picker = ImagePicker();
  @override
  void initState() {
    imageURL = '';
    imageFile = '';
    tagLabels = [];
    _titleController.addListener(_parseTags);

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
    double price = double.parse(_priceController.text);
    TemporalDateTime newDate = TemporalDateTime.now();
    final RoundedLoadingButtonController _btnController1 =
        RoundedLoadingButtonController();

    // create a new Sale from the form values
    Sale newSale = Sale(
        title: title,
        description: description.isNotEmpty ? description : null,
        condition: condition.isNotEmpty ? condition : null,
        zipcode: zipcode.isNotEmpty ? zipcode : null,
        price: price,
        user: widget.username);

    try {
      // upload the image to S3
      await uploadImage(imageFile);

      // save the sale in DataStore
      await Amplify.DataStore.save(newSale);

      // save the tags in DataStore
      for (var label in tagLabels) {
        await Amplify.DataStore.save(Tag(
          label: label,
          saleID: newSale.getId(),
        ));
      }

      // Save the image URL in DataStore
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
        backgroundColor: const Color(0xffA682FF),
        title: Text('Add Sale'),
        actions: <Widget>[
          ElevatedButton(
            onPressed: _saveSale,
            child: const Text(
              'Save',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(primary: Color(0xffA682FF)),
          ),
        ],
      ),
      body: addSaleForm(),
    );
  }

  Container addSaleForm() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            textFormField(
                context: context,
                controller: _titleController,
                keyboard: TextInputType.text,
                label: 'Title'),
            textFormField(
                context: context,
                controller: _descriptionController,
                keyboard: TextInputType.text,
                label: 'Description'),
            textFormField(
                context: context,
                controller: _conditionController,
                keyboard: TextInputType.text,
                label: 'Condition'),
            textFormField(
                context: context,
                controller: _zipcodeController,
                keyboard: TextInputType.number,
                label: 'Zipcode'),
            textFormField(
                context: context,
                controller: _priceController,
                keyboard: const TextInputType.numberWithOptions(decimal: false),
                label: 'Price'),
            chipList(),
            GestureDetector(
                child: imageDisplay(imageFile: imageFile),
                onTap: () => {selectImage()}),
          ],
        ),
      ),
    );
  }

  Container tagLabelList() {
    if (tagLabels.length >= 1) {
      return Container(
        child: Text(
          'Tags: ' + tagLabels.join(", "),
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        margin: const EdgeInsets.all(10.0),
      );
    } else {
      return Container(child: Text('No tags!'));
    }
  }

  _parseTags() {
    String tags = _titleController.text;
    setState(() {
      tagLabels = tags.split(" ");
    });
  }

  void _deleteChip(tag) {
    setState(() {
      tagLabels.remove(tag);
    });
    return;
  }

  chipList() {
    return Wrap(spacing: 10, children: [
      GestureDetector(
        onTap: () {
          _parseTags();
        },
        child: const Chip(
          avatar: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Icon(
              Icons.replay_rounded,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color(0xffA682FF),
          label: Text(
            'Reset Tags',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
          ),
          padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        ),
      ),
      tagChipList()
    ]);
  }

  tagChipList() {
    return Wrap(
      spacing: 10,
      children: tagLabels
          .map((tag) => Chip(
                label: Text(
                  tag,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
                backgroundColor: const Color.fromARGB(255, 4, 148, 134),
                padding:
                    const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                deleteIconColor: Colors.white,
                onDeleted: () => _deleteChip(tag),
              ))
          .toList(),
    );
  }

  Future<String?> getDownloadUrl(key) async {
    try {
      S3GetUrlOptions options = S3GetUrlOptions(
          expires: 604799, accessLevel: StorageAccessLevel.guest);
      final GetUrlResult result =
          await Amplify.Storage.getUrl(options: options, key: key);
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

  Future<void> uploadImage(imageFile) async {
    if (imageFile != '') {
      final options = S3UploadFileOptions(
        accessLevel: StorageAccessLevel.guest,
      );
      final key = DateTime.now().toString();
      final file = File(imageFile);
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
        await getDownloadUrl(key);
      } on StorageException catch (e) {
        debugPrint('Error uploading image: $e');
      }
    }
  }

  Future<void> selectImage() async {
    // Select image from user's gallery
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      debugPrint('No image selected');
      return;
    }
    setState(() {
      imageFile = pickedFile.path;
    });
  }
}

class textFormField extends StatelessWidget {
  const textFormField(
      {Key? key,
      required this.context,
      required this.controller,
      required this.label,
      required this.keyboard})
      : super(key: key);

  final BuildContext context;
  final TextEditingController controller;
  final String label;
  final TextInputType keyboard;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 2,
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(29),
      ),
      child: TextFormField(
          keyboardType: keyboard,
          controller: controller,
          decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              filled: false,
              labelText: label,
              labelStyle: TextStyle(fontSize: 17))),
    );
  }
}

class imageDisplay extends StatelessWidget {
  const imageDisplay({Key? key, required this.imageFile}) : super(key: key);
  final String imageFile;

  @override
  Widget build(BuildContext context) {
    if (imageFile != '') {
      return Container(
        height: MediaQuery.of(context).size.height * 0.25,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: FittedBox(
            fit: BoxFit.contain,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: Image.file(File(imageFile)),
            ),
          ),
        ),
      );
    } else {
      return Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            Icons.add_a_photo_rounded,
            color: Colors.grey,
            size: MediaQuery.of(context).size.height * 0.2,
          ));
    }
  }
}
