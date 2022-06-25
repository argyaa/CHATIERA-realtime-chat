import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String? pengirim, penerima, msg, groupTime;
  DateTime? time;
  bool? isRead;

  ChatModel(
      {this.groupTime,
      this.isRead,
      this.msg,
      this.penerima,
      this.pengirim,
      this.time});

  ChatModel.fromJson(Map<String, dynamic> json) {
    pengirim = json["pengirim"];
    penerima = json["penerima"];
    msg = json["msg"];
    groupTime = json["groupTime"];
    time = (json["time"] as Timestamp).toDate();
    isRead = json["isRead"];
  }

  Map<String, dynamic> toJson() {
    return {
      "pengirim": pengirim,
      "penerima": penerima,
      "msg": msg,
      "groupTime": groupTime,
      "time": time,
      "isRead": isRead
    };
  }
}
