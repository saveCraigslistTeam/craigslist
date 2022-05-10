import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

Container fetchImage(saleImages) {
  if (saleImages.length >= 1) {
    return Container(
      child: CachedNetworkImage(
          fit: BoxFit.contain,
          imageUrl: saleImages![0].imageURL.toString(),
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) =>
              Image.asset('assets/images/image_not_found.png')),
    );
  } else {
    return Container(child: Image.asset('assets/images/image_not_found.png'));
  }
}
