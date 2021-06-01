import 'package:flutter/material.dart';

class UserItem {
  String username;
  String email;
  String profilePic;
  int userId;
  String token;

  UserItem({this.username, this.email, this.profilePic, this.userId,this.token});

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['username'] = username;
    map['email'] = email;
    map['profilePic'] = profilePic;
    map['userId'] = userId;
    map['token'] = userId;
    return map;
  }

  UserItem.fromMap(Map data) {
    username = data['username'];
    email = data['email'];
    profilePic = data['profilePic'];
    profilePic = data['token'];
    userId = data.containsKey('userId') ? data['userId'] : 0;
  }

  factory UserItem.fromJson(Map<String, dynamic> json) {
    print("json -> "+json.toString());
    return UserItem(
        username: json["username"],
        email: json["email"],
        profilePic: json["profilePic"],
        userId: json["userId"],
        token: json["token"]);
  }
}
