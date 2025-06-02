// ignore_for_file: file_names

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showAlertDialog(
  BuildContext context,
  DialogType type,
  String? title,
  String? desc,
) async {
  await AwesomeDialog(
    titleTextStyle: const TextStyle(
      color: Colors.green,
      fontWeight: FontWeight.bold,
      fontSize: 22,
    ),
    descTextStyle: const TextStyle(
      color: Colors.green,
      fontSize: 16,
    ),
    context: context,
    dialogType: type,
    animType: AnimType.rightSlide,
    title: title,
    desc: desc,
    btnOkOnPress: () {},
  ).show();
}
