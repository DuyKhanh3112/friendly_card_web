// ignore_for_file: file_names

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:friendly_card_web/utils/app_color.dart';
import 'package:get/get.dart';

Future<void> showAlertDialog(
  BuildContext context,
  DialogType type,
  String? title,
  String? desc,
) async {
  await AwesomeDialog(
    titleTextStyle: TextStyle(
      color: AppColor.blue,
      fontWeight: FontWeight.bold,
      fontSize: 22,
    ),
    descTextStyle: TextStyle(
      color: AppColor.blue,
      fontSize: 16,
    ),
    context: context,
    dialogType: type,
    animType: AnimType.rightSlide,
    width: Get.width * 0.4,
    title: title,
    desc: desc,
    btnOkColor: AppColor.blue,
    btnOkOnPress: () {},
  ).show();
}
