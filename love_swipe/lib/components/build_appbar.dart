import 'package:flutter/material.dart';

AppBar buildAppBar(BuildContext context,String title) {
  return AppBar(
    title: Text(title,
        style:
        const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
  );
}