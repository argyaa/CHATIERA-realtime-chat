// To parse this JSON data, do
//
//     final MessageModel = MessageModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

MessageModel messageModelFromJson(String str) =>
    MessageModel.fromJson(json.decode(str));

String messageModelToJson(MessageModel data) => json.encode(data.toJson());

class MessageModel {
  MessageModel({
    this.connections,
    this.chat,
    this.lastTime,
  });

  List<String>? connections;
  List<Chat>? chat;
  DateTime? lastTime;

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        connections:
            List<String>.from(json["connections"].map((x) => x)).toList(),
        chat:
            List<Chat>.from(json["chat"].map((x) => Chat.fromJson(x))).toList(),
        lastTime: (json['lastTime'] as Timestamp).toDate(),
      );

  Map<String, dynamic> toJson() => {
        "connections": List<dynamic>.from(connections!.map((x) => x)),
        "chat": List<dynamic>.from(chat!.map((x) => x.toJson())),
        "lastTime": lastTime!.toIso8601String(),
      };
}

class Chat {
  Chat({
    this.pengirim,
    this.penerima,
    this.pesan,
    this.time,
    this.isRead,
  });

  String? pengirim;
  String? penerima;
  String? pesan;
  DateTime? time;
  bool? isRead;

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        pengirim: json["pengirim"],
        penerima: json["penerima"],
        pesan: json["pesan"],
        time: (json["time"] as Timestamp).toDate(),
        isRead: json["isRead"],
      );

  Map<String, dynamic> toJson() => {
        "pengirim": pengirim,
        "penerima": penerima,
        "pesan": pesan,
        "time": time!.toIso8601String(),
        "isRead": isRead,
      };
}
