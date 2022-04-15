/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, file_names, unnecessary_new, prefer_if_null_operators, prefer_const_constructors, slash_for_doc_comments, annotate_overrides, non_constant_identifier_names, unnecessary_string_interpolations, prefer_adjacent_string_concatenation, unnecessary_const, dead_code

import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/foundation.dart';

/** This is an auto generated class representing the Sale type in your schema. */
@immutable
class Sale extends Model {
  static const classType = const _SaleModelType();
  final String id;
  final String? _title;
  final String? _description;
  final String? _condition;
  final String? _zipcode;
  final String? _price;
  final TemporalDateTime? _postDate;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;

  @override
  String getId() {
    return id;
  }

  String? get title {
    return _title;
  }

  String? get description {
    return _description;
  }

  String? get condition {
    return _condition;
  }

  String? get zipcode {
    return _zipcode;
  }

  String? get price {
    return _price;
  }

  TemporalDateTime? get postDate {
    return _postDate;
  }

  TemporalDateTime? get createdAt {
    return _createdAt;
  }

  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }

  const Sale._internal(
      {required this.id,
      title,
      description,
      condition,
      zipcode,
      price,
      postDate,
      createdAt,
      updatedAt})
      : _title = title,
        _description = description,
        _condition = condition,
        _zipcode = zipcode,
        _price = price,
        _postDate = postDate,
        _createdAt = createdAt,
        _updatedAt = updatedAt;

  factory Sale(
      {String? id,
      String? title,
      String? description,
      String? condition,
      String? zipcode,
      String? price,
      TemporalDateTime? postDate}) {
    return Sale._internal(
        id: id == null ? UUID.getUUID() : id,
        title: title,
        description: description,
        condition: condition,
        zipcode: zipcode,
        price: price,
        postDate: postDate);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Sale &&
        id == other.id &&
        _title == other._title &&
        _description == other._description &&
        _condition == other._condition &&
        _zipcode == other._zipcode &&
        _price == other._price &&
        _postDate == other._postDate;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("Sale {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("title=" + "$_title" + ", ");
    buffer.write("description=" + "$_description" + ", ");
    buffer.write("condition=" + "$_condition" + ", ");
    buffer.write("zipcode=" + "$_zipcode" + ", ");
    buffer.write("price=" + "$_price" + ", ");
    buffer.write("postDate=" +
        (_postDate != null ? _postDate!.format() : "null") +
        ", ");
    buffer.write("createdAt=" +
        (_createdAt != null ? _createdAt!.format() : "null") +
        ", ");
    buffer.write(
        "updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  Sale copyWith(
      {String? id,
      String? title,
      String? description,
      String? condition,
      String? zipcode,
      String? price,
      TemporalDateTime? postDate}) {
    return Sale._internal(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        condition: condition ?? this.condition,
        zipcode: zipcode ?? this.zipcode,
        price: price ?? this.price,
        postDate: postDate ?? this.postDate);
  }

  Sale.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        _title = json['title'],
        _description = json['description'],
        _condition = json['condition'],
        _zipcode = json['zipcode'],
        _price = json['price'],
        _postDate = json['postDate'] != null
            ? TemporalDateTime.fromString(json['postDate'])
            : null,
        _createdAt = json['createdAt'] != null
            ? TemporalDateTime.fromString(json['createdAt'])
            : null,
        _updatedAt = json['updatedAt'] != null
            ? TemporalDateTime.fromString(json['updatedAt'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': _title,
        'description': _description,
        'condition': _condition,
        'zipcode': _zipcode,
        'price': _price,
        'postDate': _postDate?.format(),
        'createdAt': _createdAt?.format(),
        'updatedAt': _updatedAt?.format()
      };

  static final QueryField ID = QueryField(fieldName: "sale.id");
  static final QueryField TITLE = QueryField(fieldName: "title");
  static final QueryField DESCRIPTION = QueryField(fieldName: "description");
  static final QueryField CONDITION = QueryField(fieldName: "condition");
  static final QueryField ZIPCODE = QueryField(fieldName: "zipcode");
  static final QueryField PRICE = QueryField(fieldName: "price");
  static final QueryField POSTDATE = QueryField(fieldName: "postDate");
  static var schema =
      Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Sale";
    modelSchemaDefinition.pluralName = "Sales";

    modelSchemaDefinition.authRules = [
      AuthRule(authStrategy: AuthStrategy.PUBLIC, operations: [
        ModelOperation.CREATE,
        ModelOperation.UPDATE,
        ModelOperation.DELETE,
        ModelOperation.READ
      ])
    ];

    modelSchemaDefinition.addField(ModelFieldDefinition.id());

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Sale.TITLE,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Sale.DESCRIPTION,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Sale.CONDITION,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Sale.ZIPCODE,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Sale.PRICE,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Sale.POSTDATE,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)));

    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
        fieldName: 'createdAt',
        isRequired: false,
        isReadOnly: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)));

    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
        fieldName: 'updatedAt',
        isRequired: false,
        isReadOnly: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)));
  });
}

class _SaleModelType extends ModelType<Sale> {
  const _SaleModelType();

  @override
  Sale fromJson(Map<String, dynamic> jsonData) {
    return Sale.fromJson(jsonData);
  }
}












// class Sale {
//   final int id;
//   final int userID;
//   final String title;
//   final Float price;
//   final String description;
//   final String condition;

//   Sale(
//       {required this.id,
//       required this.userID,
//       required this.title,
//       required this.price,
//       required this.description,
//       required this.condition});

//   factory Sale.fromJson(Map<String, dynamic> json) {
//     return Sale(
//         id: json['id'],
//         userID: json['userID'],
//         title: json['title'],
//         price: json['price'],
//         description: json['description'],
//         condition: json['condition']);
//   }
// }
