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

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:collection/collection.dart';
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
  final double? _price;
  final String? _user;
  final List<Tag>? _Tags;
  final List<SaleImage>? _SaleImages;
  final String? _category;
  final TemporalDateTime? _date;
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
  
  double? get price {
    return _price;
  }
  
  String? get user {
    return _user;
  }
  
  List<Tag>? get Tags {
    return _Tags;
  }
  
  List<SaleImage>? get SaleImages {
    return _SaleImages;
  }
  
  String? get category {
    return _category;
  }
  
  TemporalDateTime? get date {
    return _date;
  }
  
  TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Sale._internal({required this.id, title, description, condition, zipcode, price, user, Tags, SaleImages, category, date, createdAt, updatedAt}): _title = title, _description = description, _condition = condition, _zipcode = zipcode, _price = price, _user = user, _Tags = Tags, _SaleImages = SaleImages, _category = category, _date = date, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Sale({String? id, String? title, String? description, String? condition, String? zipcode, double? price, String? user, List<Tag>? Tags, List<SaleImage>? SaleImages, String? category, TemporalDateTime? date}) {
    return Sale._internal(
      id: id == null ? UUID.getUUID() : id,
      title: title,
      description: description,
      condition: condition,
      zipcode: zipcode,
      price: price,
      user: user,
      Tags: Tags != null ? List<Tag>.unmodifiable(Tags) : Tags,
      SaleImages: SaleImages != null ? List<SaleImage>.unmodifiable(SaleImages) : SaleImages,
      category: category,
      date: date);
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
      _user == other._user &&
      DeepCollectionEquality().equals(_Tags, other._Tags) &&
      DeepCollectionEquality().equals(_SaleImages, other._SaleImages) &&
      _category == other._category &&
      _date == other._date;
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
    buffer.write("price=" + (_price != null ? _price!.toString() : "null") + ", ");
    buffer.write("user=" + "$_user" + ", ");
    buffer.write("category=" + "$_category" + ", ");
    buffer.write("date=" + (_date != null ? _date!.format() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Sale copyWith({String? id, String? title, String? description, String? condition, String? zipcode, double? price, String? user, List<Tag>? Tags, List<SaleImage>? SaleImages, String? category, TemporalDateTime? date}) {
    return Sale._internal(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      condition: condition ?? this.condition,
      zipcode: zipcode ?? this.zipcode,
      price: price ?? this.price,
      user: user ?? this.user,
      Tags: Tags ?? this.Tags,
      SaleImages: SaleImages ?? this.SaleImages,
      category: category ?? this.category,
      date: date ?? this.date);
  }
  
  Sale.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _title = json['title'],
      _description = json['description'],
      _condition = json['condition'],
      _zipcode = json['zipcode'],
      _price = (json['price'] as num?)?.toDouble(),
      _user = json['user'],
      _Tags = json['Tags'] is List
        ? (json['Tags'] as List)
          .where((e) => e?['serializedData'] != null)
          .map((e) => Tag.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null,
      _SaleImages = json['SaleImages'] is List
        ? (json['SaleImages'] as List)
          .where((e) => e?['serializedData'] != null)
          .map((e) => SaleImage.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null,
      _category = json['category'],
      _date = json['date'] != null ? TemporalDateTime.fromString(json['date']) : null,
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'title': _title, 'description': _description, 'condition': _condition, 'zipcode': _zipcode, 'price': _price, 'user': _user, 'Tags': _Tags?.map((Tag? e) => e?.toJson()).toList(), 'SaleImages': _SaleImages?.map((SaleImage? e) => e?.toJson()).toList(), 'category': _category, 'date': _date?.format(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };

  static final QueryField ID = QueryField(fieldName: "sale.id");
  static final QueryField TITLE = QueryField(fieldName: "title");
  static final QueryField DESCRIPTION = QueryField(fieldName: "description");
  static final QueryField CONDITION = QueryField(fieldName: "condition");
  static final QueryField ZIPCODE = QueryField(fieldName: "zipcode");
  static final QueryField PRICE = QueryField(fieldName: "price");
  static final QueryField USER = QueryField(fieldName: "user");
  static final QueryField TAGS = QueryField(
    fieldName: "Tags",
    fieldType: ModelFieldType(ModelFieldTypeEnum.model, ofModelName: (Tag).toString()));
  static final QueryField SALEIMAGES = QueryField(
    fieldName: "SaleImages",
    fieldType: ModelFieldType(ModelFieldTypeEnum.model, ofModelName: (SaleImage).toString()));
  static final QueryField CATEGORY = QueryField(fieldName: "category");
  static final QueryField DATE = QueryField(fieldName: "date");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Sale";
    modelSchemaDefinition.pluralName = "Sales";
    
    modelSchemaDefinition.authRules = [
      AuthRule(
        authStrategy: AuthStrategy.PUBLIC,
        operations: [
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
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Sale.DESCRIPTION,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Sale.CONDITION,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Sale.ZIPCODE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Sale.PRICE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Sale.USER,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.hasMany(
      key: Sale.TAGS,
      isRequired: false,
      ofModelName: (Tag).toString(),
      associatedKey: Tag.SALEID
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.hasMany(
      key: Sale.SALEIMAGES,
      isRequired: false,
      ofModelName: (SaleImage).toString(),
      associatedKey: SaleImage.SALEID
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Sale.CATEGORY,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Sale.DATE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _SaleModelType extends ModelType<Sale> {
  const _SaleModelType();
  
  @override
  Sale fromJson(Map<String, dynamic> jsonData) {
    return Sale.fromJson(jsonData);
  }
}