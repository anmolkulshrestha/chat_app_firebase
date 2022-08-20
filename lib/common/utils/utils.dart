import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

Future<File?> pickimage(BuildContext context) async{
  File? image;
  try {
    final pickedimage = await ImagePicker().pickImage(
        source: ImageSource.gallery);
    if (image != null) {
      image = File(pickedimage!.path);
    }
  }
catch(e){
  showSnackBar(context: context, content: e.toString());
}
return image;
}

Future<File?> pickVideoFromGallery(BuildContext context) async {
  File? video;
  try {
    final pickedVideo =
    await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (pickedVideo != null) {
      video = File(pickedVideo.path);
    }
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
  return video;
}