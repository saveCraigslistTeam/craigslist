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
import 'widgets/drop_down_menu.dart';
import 'services/fetch_image.dart';

class EditSaleForm extends StatefulWidget {
  const EditSaleForm({Key? key, required this.sale, required this.saleImages})
      : super(key: key);
  final Sale sale;
  final List<SaleImage> saleImages;

  @override
  _EditSaleFormState createState() => _EditSaleFormState();
}

class _EditSaleFormState extends State<EditSaleForm> {
  late String imageURL;
  late String imageFile;
  List<SaleImage> saleImages = [];
  late List<String> tagLabels;
  final picker = ImagePicker();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _zipcodeController;
  late TextEditingController _priceController;
  late String condition = '';
  late String category = '';

  conditionCallback(newCondition) {
    setState(() {
      condition = newCondition;
    });
  }

  categoryCallback(newCategory) {
    setState(() {
      category = newCategory;
    });
  }

  @override
  void initState() {
    getSaleImages(widget.sale);
    imageFile = '';
    tagLabels = [];
    condition = widget.sale.condition!;
    category = widget.sale.category!;
    _titleController = TextEditingController(text: widget.sale.title);
    _descriptionController =
        TextEditingController(text: widget.sale.description);
    _zipcodeController = TextEditingController(text: widget.sale.zipcode);
    _priceController =
        TextEditingController(text: widget.sale.price?.toInt().toString());
    _titleController.addListener(_parseTags);
    _parseTags();
    super.initState();
  }

  Future<List<SaleImage>?> getSaleImages(Sale sale) async {
    List<SaleImage> images = (await Amplify.DataStore.query(SaleImage.classType,
        where: SaleImage.SALEID.eq(sale.id)));
    setState(() {
      saleImages = images;
    });
    return images;
  }

  Future<void> _saveSale() async {
    // get the current text field contents
    String title = _titleController.text;
    String description = _descriptionController.text;
    String zipcode = _zipcodeController.text;
    String price = _priceController.text;
    TemporalDateTime updated = TemporalDateTime.now();

    try {
      // fetch the sale that is going to be updated
      Sale originalSale = (await Amplify.DataStore.query(Sale.classType,
          where: Sale.ID.eq(widget.sale.id)))[0];

      // Create a new sale object from original sale's id and form fields
      Sale updatedSale = originalSale.copyWith(
          id: originalSale.id,
          title: title.isNotEmpty ? title : null,
          description: description.isNotEmpty ? description : null,
          condition: condition.isNotEmpty ? condition : null,
          zipcode: zipcode.isNotEmpty ? zipcode : null,
          price: double.parse(price),
          date: updated);

      // save the sale in DataStore
      await Amplify.DataStore.save(updatedSale);

      // Replace the original image
      if (imageFile != '') {
        // Delete the original image
        (await Amplify.DataStore.query(SaleImage.classType,
                where: SaleImage.SALEID.eq(widget.sale.id)))
            .forEach((element) async {
          try {
            await Amplify.DataStore.delete(element);
            print('Deleted a post');
          } on DataStoreException catch (e) {
            print('Delete failed: $e');
          }
        });

        // upload the new image
        await uploadImage(imageFile);

        // save the image URL to DataStore
        await Amplify.DataStore.save(SaleImage(
          imageURL: imageURL,
          saleID: updatedSale.getId(),
        ));
      }

      // save the tags in DataStore
      for (var label in tagLabels) {
        await Amplify.DataStore.save(Tag(
          label: label,
          saleID: updatedSale.getId(),
        ));
      }

      // Close the form
      Navigator.of(context).pop();
      Navigator.popUntil(context, ModalRoute.withName('/mySales'));
    } catch (e) {
      debugPrint('An error occurred while saving Sale: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffA682FF),
        title: Text('Edit Sale'),
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
            GestureDetector(
                child: imageDisplay(
                  saleImages: saleImages,
                  imageFile: imageFile,
                ),
                onTap: () => {selectImage()}),
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
                controller: _zipcodeController,
                keyboard: TextInputType.number,
                label: 'Zipcode'),
            textFormField(
                context: context,
                controller: _priceController,
                keyboard: const TextInputType.numberWithOptions(decimal: false),
                label: 'Price'),
            DropDownMenu(
              mode: 'Category',
              callback: categoryCallback,
              initialValue: category,
            ),
            DropDownMenu(
                mode: 'Condition',
                callback: conditionCallback,
                initialValue: condition),
            chipList(),
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
      margin: EdgeInsets.symmetric(vertical: 4),
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
  imageDisplay({Key? key, required this.saleImages, required this.imageFile})
      : super(key: key);
  final List<SaleImage> saleImages;
  final String imageFile;

  Container image = Container();
  @override
  Widget build(BuildContext context) {
    if (imageFile != '') {
      image = Container(child: Image.file(File(imageFile)));
    } else if (saleImages.length >= 1) {
      image = fetchImage(saleImages);
    } else {
      return Container(
          padding: EdgeInsets.all(8),
          height: MediaQuery.of(context).size.height * 0.25,
          child: Padding(
              padding: const EdgeInsets.all(8),
              child: FittedBox(
                  fit: BoxFit.contain,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Icon(
                        Icons.add_a_photo_rounded,
                        color: Colors.grey,
                        size: MediaQuery.of(context).size.height * 0.2,
                      )))));
    }
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.35,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Stack(children: [
            FittedBox(fit: BoxFit.contain, child: image),
            Icon(Icons.add_a_photo_rounded, color: Colors.grey)
          ]),
        ),
      ),
    );
  }
}
