import 'dart:io';

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class DisplayImage extends StatelessWidget {
  final String imagePath;
  final VoidCallback onPressed;
  final bool isEditIcon;

  // Constructor
  const DisplayImage(
      {Key? key,
      required this.imagePath,
      required this.onPressed,
      this.isEditIcon = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const color = AppColors.pinkColor;

    return Center(
        child: Stack(children: [
      buildImage(color),
      isEditIcon
          ? Positioned(
              right: 4,
              top: 10,
              child: buildEditIcon(color),
            )
          : const SizedBox()
    ]));
  }

  // Builds Profile Image
  Widget buildImage(Color color) {
    final image = imagePath.startsWith("assets/")
        ? AssetImage(imagePath)
        : imagePath.contains('https://')
            ? NetworkImage(imagePath)
            : FileImage(File(imagePath));

    return CircleAvatar(
      radius: 75,
      backgroundColor: color,
      child: CircleAvatar(
        backgroundImage: image as ImageProvider,
        radius: 70,
      ),
    );
  }

  // Builds Edit Icon on Profile Picture
  Widget buildEditIcon(Color color) => buildCircle(
      all: 8,
      child: Icon(
        Icons.edit,
        color: color,
        size: 20,
      ));

  // Builds/Makes Circle for Edit Icon on Profile Picture
  Widget buildCircle({
    required Widget child,
    required double all,
  }) =>
      ClipOval(
          child: Container(
        padding: EdgeInsets.all(all),
        color: Colors.white,
        child: child,
      ));
}
