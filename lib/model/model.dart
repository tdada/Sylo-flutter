import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

import '../app.dart';
import 'draft_model.dart';

class RelationModel {
  String text;
  int index;

  RelationModel({this.text, this.index});
}

class TabIconData {
  String imagePath;
  String selctedImagePath;
  String label;
  bool isSelected;
  int index;
  AnimationController animationController;

  TabIconData(
      {this.imagePath = '',
      this.index = 0,
      this.selctedImagePath = "",
      this.isSelected = false,
      this.animationController,
      this.label});

  static List<TabIconData> tabIconsList = [
    TabIconData(
        imagePath: App.ic_tab1,
        selctedImagePath: App.ic_tab1_s,
        index: 0,
        isSelected: false,
        animationController: null,
        label: "Qcasts"),
    TabIconData(
        imagePath: App.ic_tab2,
        selctedImagePath: App.ic_tab2_S,
        index: 1,
        isSelected: false,
        animationController: null,
        label: "Qcam"),
    TabIconData(
        imagePath: App.ic_tab3,
        selctedImagePath: App.ic_tab3_S,
        index: 2,
        isSelected: false,
        animationController: null,
        label: "Shared"),
    TabIconData(
        imagePath: App.ic_tab4,
        selctedImagePath: App.ic_tab4_S,
        index: 3,
        isSelected: false,
        animationController: null,
        label: "Account"),
  ];
}

class MediaItemModel {
  String name;
  String content_type;

  MediaItemModel(this.name, this.content_type);
}

class SyloProfileModel {
  String recipientName;
  String displayName;
  String recipientEmail;
  String recipientBDay;
  String recipientAge;
  String recipientRelationship;
  String recipientFamilyRelationship;
  String recipientCoName;
  String recipientCoEmail;

  SyloProfileModel(
      {this.recipientName,
      this.displayName,
      this.recipientEmail,
      this.recipientBDay,
      this.recipientAge,
      this.recipientRelationship,
      this.recipientFamilyRelationship,
      this.recipientCoName,
      this.recipientCoEmail});
}
class TagModel {
  String name;

  TagModel({this.name});
}

class SoundBiteItem {
  String name;
  bool isCheck;

  SoundBiteItem(this.name, this.isCheck);
}

class NotificationItem {
  NotificationItem({
    this.numberOfNotictions,
    this.notificationList,
    this.isNotificationOn,
  });

  int numberOfNotictions;
  List<NotificationList> notificationList;
  bool isNotificationOn;

  factory NotificationItem.fromJson(Map<String, dynamic> json) => NotificationItem(
    numberOfNotictions: json["NumberOfNotictions"],
    notificationList: List<NotificationList>.from(json["NotificationList"].map((x) => NotificationList.fromJson(x))),
    isNotificationOn: json["IsNotificationOn"],
  );

  Map<String, dynamic> toJson() => {
    "NumberOfNotictions": numberOfNotictions,
    "NotificationList": List<dynamic>.from(notificationList.map((x) => x.toJson())),
  };
}

class NotificationItemDatabase {
  NotificationItemDatabase({
    this.numberOfNotictions,
    this.notificationList,
    this.isNotificationOn,
  });

  int numberOfNotictions;
  List<NotificationListDatabase> notificationList;
  bool isNotificationOn;

  factory NotificationItemDatabase.fromJson(Map<String, dynamic> json) => NotificationItemDatabase(
    numberOfNotictions: json["NumberOfNotictions"],
    notificationList: List<NotificationListDatabase>.from(json["NotificationList"].map((x) => NotificationListDatabase.fromJson(x))),
    isNotificationOn: json["IsNotificationOn"],
  );

  Map<String, dynamic> toJson() => {
    "NumberOfNotictions": numberOfNotictions,
    "NotificationList": List<dynamic>.from(notificationList.map((x) => x.toJson())),
  };
}

class NotificationList {
  NotificationList({
    this.notifyId,
    this.title,
    this.description,
    this.userId,
    this.readUnread,
    this.notifyType,
  });

  int notifyId;
  String title;
  String description;
  int userId;
  bool readUnread;
  String notifyType;

  factory NotificationList.fromJson(Map<String, dynamic> json) => NotificationList(
    notifyId: json["notifyId"],
    title: json["title"],
    description: json["description"],
    userId: json["userId"],
    readUnread: json["readUnread"],
    notifyType: json["notifyType"],
  );

  Map<String, dynamic> toJson() => {
    "notifyId": notifyId,
    "title": title,
    "description": description,
    "userId": userId,
    "readUnread": readUnread,
    "notifyType": notifyType,
  };


}

class NotificationListDatabase {
  NotificationListDatabase({
    this.notifyId,
    this.id,
    this.title,
    this.description,

  });

  int id;
  int notifyId;
  String title;
  String description;


  factory NotificationListDatabase.fromJson(Map<String, dynamic> json) => NotificationListDatabase(
    id: json["id"],
    notifyId: json["notifyId"],
    title: json["title"],
    description: json["description"],

  );



  Map<String, dynamic> toJson() => {
    "id": id,
    "notifyId": notifyId,
    "title": title,
    "description": description,
  };

  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['notifyId'] = notifyId;
    map['title'] = title;
    map['description'] = description;


    return map;}

  static Map<String, dynamic> toMap1(NotificationListDatabase notificationListDatabase) => {
    'id' : notificationListDatabase.id,
    'notifyId' : notificationListDatabase.notifyId,
    'title' : notificationListDatabase.title,
    'description' : notificationListDatabase.description,
  };

  static String encode(List<NotificationListDatabase> musics) => json.encode(musics
      .map<Map<String, dynamic>>((music) => NotificationListDatabase.toMap1(music))
      .toList(),
  );

  static List<NotificationListDatabase> decode(String musics) =>
      (json.decode(musics) as List<dynamic>)
          .map<NotificationListDatabase>((item) => NotificationListDatabase.fromJson(item))
          .toList();

  NotificationListDatabase.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id']==null ? 0 : map['id'];
    this.notifyId = map['notifyId']==null ? 0 : map['notifyId'];
    this.title = map['title']==null ? null : map['title'];
    this.description = map['description']==null ? null : map['description'];
    }
}

class PromptCreateForm {
  String title;

  PromptCreateForm({this.title});
}

class RepostModel {
  String icon;
  String title;
  var nextPage;
  String link;
  bool isCheck = false;
  RePostApplication status;

  RepostModel({this.icon, this.title, this.nextPage, this.isCheck,
    this.link,
    this.status});

}

class SongModel {
  String icon;
  String title;
  var nextPage;
  String link;
  bool isCheck = false;
  SongsApplication status;

  SongModel({this.icon, this.title, this.nextPage, this.isCheck,
  this.link,
  this.status});

}

class SyloItemModel {
  String icon;
  String name;
  int post;
  String time;
  bool isCheck;

  SyloItemModel({this.icon, this.name, this.post, this.time, this.isCheck=false});
}

class CompletedSyloImageModel {
  String image;
  bool isSquare = true;

  CompletedSyloImageModel({this.image, this.isSquare});
}

class PostPhotoModel {
  File image;
  String link;
  bool isCircle;

  PostPhotoModel({this.image, this.link, this.isCircle = true});
  factory PostPhotoModel.fromMyDraftMedia(MyDraftMedia myDraftMedia) => PostPhotoModel(
    image: myDraftMedia.image!=null ? File(myDraftMedia.image) : null,
    link: myDraftMedia.link,
    isCircle: myDraftMedia.isCircle!=null ? myDraftMedia.isCircle.toLowerCase() == true.toString().toLowerCase() : false,
  );
}

class ThemeModel {
  String title;
  String icon;
  String description;

  ThemeModel({this.title, this.icon, this.description});
}