import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

var imageLoading =
    Center(child: Image.asset('assets/images/image_loading.png'));

Container fetchImage(saleImages) {
  if (saleImages.length >= 1) {
    return Container(
        child: CachedNetworkImage(
      fit: BoxFit.contain,
      imageUrl: saleImages![0].imageURL.toString(),
      placeholder: (context, url) => imageLoading,
      errorWidget: (context, url, error) => imageLoading,
    ));
  } else {
    return Container();
  }
}
