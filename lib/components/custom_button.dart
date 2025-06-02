// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.title, this.onClicked});

  final String title;
  final void Function()? onClicked;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Get.height * 0.02),
      decoration: const BoxDecoration(),
      child: ElevatedButton(
        onPressed: onClicked ?? () {},
        style: ButtonStyle(
          alignment: Alignment.center,
          backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
        ),
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(vertical: Get.height * 0.01),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
