// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

// String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.id,
    this.displayName,
    this.keyName,
    this.email,
    this.createdAt,
    this.lastSignIn,
    this.photoUrl,
    this.status,
    this.lastUpdate,
  });

  String? id;
  String? displayName;
  String? keyName;
  String? email;
  DateTime? createdAt;
  DateTime? lastSignIn;
  String? photoUrl;
  String? status;
  DateTime? lastUpdate;

  factory UserModel.fromJson(String id, Map<String, dynamic> json) => UserModel(
        id: id,
        displayName: json["displayName"],
        keyName: json["keyName"],
        email: json["email"],
        createdAt: (json["createdAt"] as Timestamp).toDate(),
        lastSignIn: (json["lastSignIn"] as Timestamp).toDate(),
        photoUrl: json["photoUrl"],
        status: json["status"],
        lastUpdate: (json["lastUpdate"] as Timestamp).toDate(),
        // chats:
        //     List<ChatUser>.from(json["chats"].map((x) => ChatUser.fromJson(x)))
        //         .toList(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "displayName": displayName,
        "keyName": keyName,
        "email": email,
        "createdAt": createdAt,
        "lastSignIn": lastSignIn,
        "photoUrl": photoUrl,
        "status": status,
        "lastUpdate": lastUpdate,
        // "chats": List<dynamic>.from(chats!.map((x) => x.toJson())).toList(),
      };
}

class ChatUser {
  ChatUser({
    this.connection,
    this.chatId,
    this.lastTime,
    this.totalUnread = 0,
  });

  String? connection;
  String? chatId;
  DateTime? lastTime;
  int? totalUnread;

  factory ChatUser.fromJson(String id, Map<String, dynamic> json) => ChatUser(
        chatId: id,
        connection: json["connection"],
        lastTime: (json["lastTime"] as Timestamp).toDate(),
        totalUnread: json["total_unread"],
      );

  Map<String, dynamic> toJson() => {
        "connection": connection,
        "lastTime": lastTime,
        "total_unread": totalUnread,
      };
}
