
import 'package:flutter/material.dart';

class QcastsCheckBoxItem {
  String icon;
  String name;
  String text;
  bool isCheck;

  QcastsCheckBoxItem(this.icon, this.name, this.text, this.isCheck);

  @override
  String toString() {
    return '{ ${this.icon}, ${this.name}, ${this.text}, ${this.isCheck} }';
  }

}