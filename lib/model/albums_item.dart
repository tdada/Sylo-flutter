import 'package:flutter/material.dart';

class AlbumsItem {
  String icon;
  String name;
  bool isCheck;

  AlbumsItem(this.icon, this.name, this.isCheck);

  @override
  String toString() {
    return '{ ${this.icon}, ${this.name}, ${this.isCheck} }';
  }

}