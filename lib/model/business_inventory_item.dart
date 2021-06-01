
import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'checkbox_item.dart';
import 'drop_down_item.dart';


class BusinessInventoryItem {
  List<File> listImages = List();
  List<CheckBoxItem> listWhatList = List();
  List<CheckBoxItem> listRequirements = List();
  String textDescription = "";
  String textRate = "";
  List<DropDownItem> listRate = List();
  DropDownItem selectedHoursTime;
  CheckBoxItem isSameAvailItem;
  List<CheckBoxItem> listWeekCheckBoxItem = List();
  BusinessInventoryItem();
}