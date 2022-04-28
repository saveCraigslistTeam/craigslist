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


/** This is an auto generated class representing the Messages type in your schema. */
@immutable
class Messages extends Model {
  static const classType = const _MessagesModelType();
  final String id;
  final String? _sale;
  final String? _host;
  final String? _customer;
  final String? _sender;
  final String? _receiver;
  final bool? _senderSeen;
  final bool? _receiverSeen;
  final String? _text;
  final TemporalDateTime? _date;
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
  
  String? get sender {
    return _sender;
  }
  
  String? get receiver {
    return _receiver;
  }
  
  bool? get senderSeen {
    return _senderSeen;
  }
  
  bool? get receiverSeen {
    return _receiverSeen;
  }
  
  String? get text {
    return _text;
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
  
  const Messages._internal({required this.id, sale, host, customer, sender, receiver, senderSeen, receiverSeen, text, date, createdAt, updatedAt}): _sale = sale, _host = host, _customer = customer, _sender = sender, _receiver = receiver, _senderSeen = senderSeen, _receiverSeen = receiverSeen, _text = text, _date = date, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Messages({String? id, String? sale, String? host, String? customer, String? sender, String? receiver, bool? senderSeen, bool? receiverSeen, String? text, TemporalDateTime? date}) {
    return Messages._internal(
      id: id == null ? UUID.getUUID() : id,
      sale: sale,
      host: host,
      customer: customer,
      sender: sender,
      receiver: receiver,
      senderSeen: senderSeen,
      receiverSeen: receiverSeen,
      text: text,
      date: date);
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
      _sender == other._sender &&
      _receiver == other._receiver &&
      _senderSeen == other._senderSeen &&
      _receiverSeen == other._receiverSeen &&
      _text == other._text &&
      _date == other._date;
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
    buffer.write("sender=" + "$_sender" + ", ");
    buffer.write("receiver=" + "$_receiver" + ", ");
    buffer.write("senderSeen=" + (_senderSeen != null ? _senderSeen!.toString() : "null") + ", ");
    buffer.write("receiverSeen=" + (_receiverSeen != null ? _receiverSeen!.toString() : "null") + ", ");
    buffer.write("text=" + "$_text" + ", ");
    buffer.write("date=" + (_date != null ? _date!.format() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Messages copyWith({String? id, String? sale, String? host, String? customer, String? sender, String? receiver, bool? senderSeen, bool? receiverSeen, String? text, TemporalDateTime? date}) {
    return Messages._internal(
      id: id ?? this.id,
      sale: sale ?? this.sale,
      host: host ?? this.host,
      customer: customer ?? this.customer,
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
      senderSeen: senderSeen ?? this.senderSeen,
      receiverSeen: receiverSeen ?? this.receiverSeen,
      text: text ?? this.text,
      date: date ?? this.date);
  }
  
  Messages.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _sale = json['sale'],
      _host = json['host'],
      _customer = json['customer'],
      _sender = json['sender'],
      _receiver = json['receiver'],
      _senderSeen = json['senderSeen'],
      _receiverSeen = json['receiverSeen'],
      _text = json['text'],
      _date = json['date'] != null ? TemporalDateTime.fromString(json['date']) : null,
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'sale': _sale, 'host': _host, 'customer': _customer, 'sender': _sender, 'receiver': _receiver, 'senderSeen': _senderSeen, 'receiverSeen': _receiverSeen, 'text': _text, 'date': _date?.format(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };

  static final QueryField ID = QueryField(fieldName: "messages.id");
  static final QueryField SALE = QueryField(fieldName: "sale");
  static final QueryField HOST = QueryField(fieldName: "host");
  static final QueryField CUSTOMER = QueryField(fieldName: "customer");
  static final QueryField SENDER = QueryField(fieldName: "sender");
  static final QueryField RECEIVER = QueryField(fieldName: "receiver");
  static final QueryField SENDERSEEN = QueryField(fieldName: "senderSeen");
  static final QueryField RECEIVERSEEN = QueryField(fieldName: "receiverSeen");
  static final QueryField TEXT = QueryField(fieldName: "text");
  static final QueryField DATE = QueryField(fieldName: "date");
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
      key: Messages.SENDER,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Messages.RECEIVER,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Messages.SENDERSEEN,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Messages.RECEIVERSEEN,
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