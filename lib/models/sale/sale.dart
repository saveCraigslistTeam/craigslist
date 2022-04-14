import 'dart:ffi';

class Sale {
  final int id;
  final int userID;
  final String title;
  final Float price;
  final String description;
  final String condition;

  Sale(
      {required this.id,
      required this.userID,
      required this.title,
      required this.price,
      required this.description,
      required this.condition});

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
        id: json['id'],
        userID: json['userID'],
        title: json['title'],
        price: json['price'],
        description: json['description'],
        condition: json['condition']);
  }
}
