
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../app.dart';

class QuestionItem {

  String que_link;
  String que_thumb;
  int start_time = 0, end_time = 0;


  QuestionItem({this.que_link, this.que_thumb});

  bool isBetTime(double time){

    if(start_time<time && end_time>time){
      return true;
    }
    return false;

  }

}