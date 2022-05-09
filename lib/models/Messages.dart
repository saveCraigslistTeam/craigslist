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

import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the Messages type in your schema. */
@immutable
class Messages extends Model {
  static const classType = const _MessagesModelType();
  final String id;
  final String? _sale;
  final String? _host;
  final String? _customer;
  final bool? _hostSent;
  final String? _text;
  final TemporalDateTime? _date;
  final bool? _seen;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get sale {
    return _sale;
  }
  
  String? get host {
    return _host;
  }
  
  String? get customer {
    return _customer;
  }
  
  bool? get hostSent {
    return _hostSent;
  }
  
  String? get text {
    return _text;
  }
  
  TemporalDateTime? get date {
    return _date;
  }
  
  bool? get seen {
    return _seen;
  }
  
  TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Messages._internal({required this.id, sale, host, customer, hostSent, text, date, seen, createdAt, updatedAt}): _sale = sale, _host = host, _customer = customer, _hostSent = hostSent, _text = text, _date = date, _seen = seen, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Messages({String? id, String? sale, String? host, String? customer, bool? hostSent, String? text, TemporalDateTime? date, bool? seen}) {
    return Messages._internal(
      id: id == null ? UUID.getUUID() : id,
      sale: sale,
      host: host,
      customer: customer,
      hostSent: hostSent,
      text: text,
      date: date,
      seen: seen);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Messages &&
      id == other.id &&
      _sale == other._sale &&
      _host == other._host &&
      _customer == other._customer &&
      _hostSent == other._hostSent &&
      _text == other._text &&
      _date == other._date &&
      _seen == other._seen;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Messages {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("sale=" + "$_sale" + ", ");
    buffer.write("host=" + "$_host" + ", ");
    buffer.write("customer=" + "$_customer" + ", ");
    buffer.write("hostSent=" + (_hostSent != null ? _hostSent!.toString() : "null") + ", ");
    buffer.write("text=" + "$_text" + ", ");
    buffer.write("date=" + (_date != null ? _date!.format() : "null") + ", ");
    buffer.write("seen=" + (_seen != null ? _seen!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Messages copyWith({String? id, String? sale, String? host, String? customer, bool? hostSent, String? text, TemporalDateTime? date, bool? seen}) {
    return Messages._internal(
      id: id ?? this.id,
      sale: sale ?? this.sale,
      host: host ?? this.host,
      customer: customer ?? this.customer,
      hostSent: hostSent ?? this.hostSent,
      text: text ?? this.text,
      date: date ?? this.date,
      seen: seen ?? this.seen);
  }
  
  Messages.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _sale = json['sale'],
      _host = json['host'],
      _customer = json['customer'],
      _hostSent = json['hostSent'],
      _text = json['text'],
      _date = json['date'] != null ? TemporalDateTime.fromString(json['date']) : null,
      _seen = json['seen'],
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'sale': _sale, 'host': _host, 'customer': _customer, 'hostSent': _hostSent, 'text': _text, 'date': _date?.format(), 'seen': _seen, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };

  static final QueryField ID = QueryField(fieldName: "messages.id");
  static final QueryField SALE = QueryField(fieldName: "sale");
  static final QueryField HOST = QueryField(fieldName: "host");
  static final QueryField CUSTOMER = QueryField(fieldName: "customer");
  static final QueryField HOSTSENT = QueryField(fieldName: "hostSent");
  static final QueryField TEXT = QueryField(fieldName: "text");
  static final QueryField DATE = QueryField(fieldName: "date");
  static final QueryField SEEN = QueryField(fieldName: "seen");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Messages";
    modelSchemaDefinition.pluralName = "Messages";
    
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
      key: Messages.SALE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Messages.HOST,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Messages.CUSTOMER,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Messages.HOSTSENT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Messages.TEXT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Messages.DATE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Messages.SEEN,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.bool)
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

class _MessagesModelType extends ModelType<Messages> {
  const _MessagesModelType();
  
  @override
  Messages fromJson(Map<String, dynamic> jsonData) {
    return Messages.fromJson(jsonData);
  }
}