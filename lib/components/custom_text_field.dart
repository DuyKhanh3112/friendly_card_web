// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:friendly_card_web/utils/app_color.dart';
import 'package:get/get.dart';

enum ContactType { mail, phone }

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    this.required,
    this.onChanged,
    this.isPassword,
    this.controller,
    this.readOnly,
    this.type,
  });

  final String label;
  final TextEditingController? controller;
  final bool? required;
  final bool? readOnly;
  final bool? isPassword;
  final void Function(String)? onChanged;
  final ContactType? type;

  @override
  Widget build(BuildContext context) {
    RxBool hideContent = (isPassword ?? false).obs;
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(vertical: Get.height * 0.02),
        // width: Get.width * 0.3,
        decoration: const BoxDecoration(),
        child: TextFormField(
          controller: controller,
          style: TextStyle(
            fontSize: 18,
            color: AppColor.blue,
            fontWeight: FontWeight.bold,
          ),
          obscureText: hideContent.value,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
            ),
            prefixIcon: label == ''
                ? null
                : Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.01,
                      // vertical: Get.width * 0.01,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: AppColor.labelBlue,
                        ),
                      ),
                    ),
                    width: Get.width * 0.1,
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColor.labelBlue,
                      ),
                    ),
                  ),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            suffixIcon: isPassword == true
                ? IconButton(
                    onPressed: () {
                      hideContent.value = !hideContent.value;
                    },
                    icon: hideContent.value
                        ? Icon(
                            Icons.remove_red_eye_outlined,
                            color: AppColor.blue,
                          )
                        : Icon(
                            Icons.remove_red_eye_rounded,
                            color: AppColor.blue,
                          ),
                  )
                : null,
          ),
          validator: (value) {
            if (required == true) {
              if (value == null || value.trim() == '' || value.isEmpty) {
                return 'Vui lòng nhập $label';
              }
              if (type == ContactType.mail) {
                final RegExp emailRegExp =
                    RegExp(r"^[\w-\.]+@([\w-]+\.){1,}[\w-]{1,}$");
                if (!emailRegExp.hasMatch(value)) {
                  return '${label} không hợp lệ.';
                }
              }
            }
            return null;
          },
          onChanged: onChanged ?? (value) {},
          readOnly: readOnly ?? false,
        ),
      ),
    );
  }
}
