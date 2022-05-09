import 'package:flutter/material.dart';

fetchImage(saleImages) {
  return NetworkImage(saleImages![0].imageURL.toString());
}
