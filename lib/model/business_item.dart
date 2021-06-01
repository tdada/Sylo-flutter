
import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'business_inventory_item.dart';
import 'checkbox_item.dart';
import 'drop_down_item.dart';


class BusinessItem {
  List<BusinessInventoryItem> listBusinessInventoryItem = List();
  String businessName="";
  double averageReview = 5.0;
  BusinessItem();
}