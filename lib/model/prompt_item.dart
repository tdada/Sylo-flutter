
import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../app.dart';

class PromptItem {
  PromptItem({
    this.text,
    this.promptId,
    this.title,
    this.prompts,
    this.ownedByUser,
    this.isCheck = false,
    this.isExpand = false,
  });

  String text;
  int promptId;
  String title;
  List<String> prompts;
  bool ownedByUser;
  bool isCheck = false;
  bool isExpand = false;

  factory PromptItem.fromJson(Map<dynamic, dynamic> json) => PromptItem(
    promptId: json["promptId"],
    title: json["title"],
    text:  json["title"],
    prompts: List<String>.from(json["prompts"].map((x) => x)),
    ownedByUser: json["ownedByUser"],
    isCheck: false,
    isExpand: false
  );

  Map<String, dynamic> toJson() => {
    "promptId": promptId,
    "title": title,
    "prompts": List<dynamic>.from(prompts.map((x) => x)),
    "ownedByUser": ownedByUser,
  };
}