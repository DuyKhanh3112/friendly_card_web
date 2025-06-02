// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    this.required,
    this.onChanged,
    this.isPassword,
    this.controller,
  });

  final String label;
  final TextEditingController? controller;
  final bool? required;
  final bool? isPassword;
  final void Function(String)? onChanged;

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
          style: const TextStyle(fontSize: 18),
          obscureText: hideContent.value,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.01),
              child: Text(
                '$label:',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
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
                        ? const Icon(
                            Icons.remove_red_eye_outlined,
                            color: Colors.green,
                          )
                        : const Icon(
                            Icons.remove_red_eye_rounded,
                            color: Colors.green,
                          ),
                  )
                : null,
          ),
          validator: (value) {
            if (required == true) {
              if (value == null || value.trim() == '' || value.isEmpty) {
                return 'Vui lòng nhập $label';
              }
            }
            return null;
          },
          onChanged: onChanged ?? (value) {},
        ),
      ),
    );
  }
}
