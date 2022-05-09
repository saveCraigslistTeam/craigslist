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

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

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
  final String? _price;
  final List<SaleImage>? _SaleImages;
  final String? _user;
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
  
  List<SaleImage>? get SaleImages {
    return _SaleImages;
  }
  
  String? get user {
    return _user;
  }
  
  TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Sale._internal({required this.id, title, description, condition, zipcode, price, SaleImages, user, createdAt, updatedAt}): _title = title, _description = description, _condition = condition, _zipcode = zipcode, _price = price, _SaleImages = SaleImages, _user = user, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Sale({String? id, String? title, String? description, String? condition, String? zipcode, String? price, List<SaleImage>? SaleImages, String? user}) {
    return Sale._internal(
      id: id == null ? UUID.getUUID() : id,
      title: title,
      description: description,
      condition: condition,
      zipcode: zipcode,
      price: price,
      SaleImages: SaleImages != null ? List<SaleImage>.unmodifiable(SaleImages) : SaleImages,
      user: user);
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
      DeepCollectionEquality().equals(_SaleImages, other._SaleImages) &&
      _user == other._user;
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
    buffer.write("user=" + "$_user" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Sale copyWith({String? id, String? title, String? description, String? condition, String? zipcode, String? price, List<SaleImage>? SaleImages, String? user}) {
    return Sale._internal(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      condition: condition ?? this.condition,
      zipcode: zipcode ?? this.zipcode,
      price: price ?? this.price,
      SaleImages: SaleImages ?? this.SaleImages,
      user: user ?? this.user);
  }
  
  Sale.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _title = json['title'],
      _description = json['description'],
      _condition = json['condition'],
      _zipcode = json['zipcode'],
      _price = json['price'],
      _SaleImages = json['SaleImages'] is List
        ? (json['SaleImages'] as List)
          .where((e) => e?['serializedData'] != null)
          .map((e) => SaleImage.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null,
      _user = json['user'],
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'title': _title, 'description': _description, 'condition': _condition, 'zipcode': _zipcode, 'price': _price, 'SaleImages': _SaleImages?.map((SaleImage? e) => e?.toJson()).toList(), 'user': _user, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };

  static final QueryField ID = QueryField(fieldName: "sale.id");
  static final QueryField TITLE = QueryField(fieldName: "title");
  static final QueryField DESCRIPTION = QueryField(fieldName: "description");
  static final QueryField CONDITION = QueryField(fieldName: "condition");
  static final QueryField ZIPCODE = QueryField(fieldName: "zipcode");
  static final QueryField PRICE = QueryField(fieldName: "price");
  static final QueryField SALEIMAGES = QueryField(
    fieldName: "SaleImages",
    fieldType: ModelFieldType(ModelFieldTypeEnum.model, ofModelName: (SaleImage).toString()));
  static final QueryField USER = QueryField(fieldName: "user");
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
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.hasMany(
      key: Sale.SALEIMAGES,
      isRequired: false,
      ofModelName: (SaleImage).toString(),
      associatedKey: SaleImage.SALEID
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Sale.USER,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
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