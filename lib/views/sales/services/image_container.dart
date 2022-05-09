import 'package:flutter/material.dart';

Padding imageContainer(saleImages) {
  if (saleImages == null) {
    return const Padding(
      padding: EdgeInsets.all(25.0),
      child: Text('No image to display'),
    );
  } else {
    return Padding(
        padding: const EdgeInsets.all(25.0),
        child: Image.network(saleImages![0].imageURL.toString(), errorBuilder:
            (BuildContext context, Object exception, StackTrace? stackTrace) {
          return const Text('Could not retrieve image!');
        }));
  }
}
