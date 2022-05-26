// dart async library we will refer to when setting up real time updates
import 'dart:core';
import 'dart:io';
// flutter and ui libraries
import 'package:flutter/material.dart';
// amplify packages we will need to use
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:image_picker/image_picker.dart';
// amplify configuration and models that should have been generated for you
import '../../models/ModelProvider.dart';
import 'widgets/drop_down_menu.dart';

class AddSaleForm extends StatefulWidget {
  const AddSaleForm({Key? key, required this.username}) : super(key: key);
  final String username;

  @override
  _AddSaleFormState createState() => _AddSaleFormState();
}

class _AddSaleFormState extends State<AddSaleForm> {
  late String imageURL;
  late String imageFile;
  late List<String> tagLabels;
  final picker = ImagePicker();
  late String condition = '';
  late String category = '';

  conditionCallback(newCondition) {
    setState(() {
      condition = newCondition;
    });
  }

  categoryCallback(newCategory) {
    setState(() {
      tagLabels.remove(category);
      category = newCategory;
      tagLabels.add(category);
    });
  }

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
  final _zipcodeController = TextEditingController();
  final _priceController = TextEditingController();

  Future<void> _saveSale() async {
    // get the current text field contents
    String title = _titleController.text;
    // String condition = _conditionController.text;
    String description = _descriptionController.text;
    String zipcode = _zipcodeController.text;
    double price = double.parse(_priceController.text);
    TemporalDateTime newDate = TemporalDateTime.now();
    // create a new Sale from the form values
    Sale newSale = Sale(
        title: title,
        description: description.isNotEmpty ? description : null,
        condition: condition.isNotEmpty ? condition : null,
        category: category.isNotEmpty ? category : null,
        zipcode: zipcode.isNotEmpty ? zipcode : null,
        price: price,
        user: widget.username,
        date: newDate);

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
        title: const Text('Add Sale'),
        actions: <Widget>[
          ElevatedButton(
            onPressed: _saveSale,
            child: const Text(
              'Save',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(primary: const Color(0xffA682FF)),
          ),
        ],
      ),
      body: addSaleForm(),
    );
  }

  Container addSaleForm() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
                child: ImageDisplay(imageFile: imageFile),
                onTap: () => {selectImage()}),
            CustomTextFormField(
                context: context,
                controller: _titleController,
                keyboard: TextInputType.text,
                label: 'Title'),
            CustomTextFormField(
                context: context,
                controller: _descriptionController,
                keyboard: TextInputType.text,
                label: 'Description'),
            CustomTextFormField(
                context: context,
                controller: _zipcodeController,
                keyboard: TextInputType.number,
                label: 'Zipcode'),
            CustomTextFormField(
                context: context,
                controller: _priceController,
                keyboard: const TextInputType.numberWithOptions(decimal: false),
                label: 'Price'),
            DropDownMenu(mode: 'Category', callback: categoryCallback),
            DropDownMenu(mode: 'Condition', callback: conditionCallback),
            chipList(),
          ],
        ),
      ),
    );
  }

  Container tagLabelList() {
      return Container(
        child: Text(
          'Tags: ' + tagLabels.join(", "),
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        margin: const EdgeInsets.all(10.0),
      );
  }

  _parseTags() {
    String tags = _titleController.text;
    if (tags != '') {
      setState(() {
        tagLabels = tags.split(" ");
      });
    }
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
          tagLabels.add(category);
        },
        child: const Chip(
          avatar: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Icon(
              Icons.replay_rounded,
              color: Colors.white,
            ),
          ),
          backgroundColor: Color(0xffA682FF),
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

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
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
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
              labelStyle: const TextStyle(fontSize: 17))),
    );
  }
}

class ImageDisplay extends StatelessWidget {
  const ImageDisplay({Key? key, required this.imageFile}) : super(key: key);
  final String imageFile;

  @override
  Widget build(BuildContext context) {
    if (imageFile != '') {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.35,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: FittedBox(
            fit: BoxFit.contain,
            child: Image.file(File(imageFile)),
          ),
        ),
      );
    } else {
      return Container(
          padding: const EdgeInsets.all(8),
          height: MediaQuery.of(context).size.height * 0.25,
          child: Padding(
              padding: const EdgeInsets.all(8),
              child: FittedBox(
                  fit: BoxFit.contain,
                  child: Icon(
                    Icons.add_a_photo_rounded,
                    color: Colors.grey,
                    size: MediaQuery.of(context).size.height * 0.35,
                  ))));
    }
  }
}
