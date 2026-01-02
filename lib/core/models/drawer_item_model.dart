import 'package:flutter/material.dart';

class DrawerItemModel {
  String title;
  Widget leading;
  VoidCallback onTap;
  DrawerItemModel({
    required this.title,
    required this.leading,
    required this.onTap,
  });
}
