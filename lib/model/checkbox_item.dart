
import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../app.dart';

class CheckBoxItem {

  String text;
  DateTime dateTimeFrom = DateTime.now();
  DateTime dateTimeTo = DateTime.now();
  bool isCheck = false;
  IconData iconData;
  CheckBoxItem({this.text, this.isCheck, this.iconData}){
   if(isCheck==null){
     this.isCheck = false;
   }
  }

  String getWorkingHoursLabel(){
    if(!isCheck){
      return "";
    }
    return App.getDateByFormat(dateTimeFrom, App.format12hr) + " " + App.getDateByFormat(dateTimeTo, App.format12hr);
  }



}