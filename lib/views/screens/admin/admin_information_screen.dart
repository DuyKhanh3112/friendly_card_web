// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:friendly_card_web/components/custom_button.dart';
import 'package:friendly_card_web/components/custom_text_field.dart';
import 'package:friendly_card_web/controllers/users_controller.dart';
import 'package:friendly_card_web/widget/loading_page.dart';
import 'package:friendly_card_web/utils/app_color.dart';
import 'package:get/get.dart';

class AdminInformationScreen extends StatelessWidget {
  const AdminInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UsersController usersController = Get.find<UsersController>();

    return Obx(
      () {
        return usersController.loading.value
            ? const LoadingPage()
            : Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Get.width * 0.05,
                    vertical: Get.height * 0.05,
                  ),
                  width: Get.width * 0.65,
                  height: Get.height * 0.8,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: Get.width * 0.4,
                        child: CustomTextField(
                          label: 'Họ tên',
                          readOnly: true,
                          controller: TextEditingController(
                              text: usersController.user.value.fullname),
                        ),
                      ),
                      Container(
                        width: Get.width * 0.4,
                        child: CustomTextField(
                          label: 'Số điện thoại',
                          readOnly: true,
                          controller: TextEditingController(
                              text: usersController.user.value.phone),
                        ),
                      ),
                      Container(
                        width: Get.width * 0.4,
                        child: CustomTextField(
                          label: 'Email',
                          readOnly: true,
                          controller: TextEditingController(
                              text: usersController.user.value.email),
                        ),
                      ),
                      Container(
                        width: Get.width * 0.4,
                        child: CustomTextField(
                          label: 'Tên tài khoản',
                          readOnly: true,
                          controller: TextEditingController(
                              text: usersController.user.value.username),
                        ),
                      ),
                      Container(
                        width: Get.width * 0.4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: Get.width * 0.15,
                              child: CustomButton(
                                title: 'Lưu thông tin',
                                onClicked: () async {},
                                bgColor: AppColor.blue,
                              ),
                            ),
                            Container(
                              width: Get.width * 0.15,
                              child: CustomButton(
                                title: 'Đổi mật khẩu',
                                bgColor: AppColor.blue,
                                onClicked: () async {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }
}
