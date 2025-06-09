import 'package:flutter/material.dart';
import 'package:friendly_card_web/controllers/main_controller.dart';
import 'package:friendly_card_web/controllers/users_controller.dart';
import 'package:friendly_card_web/utils/app_color.dart';
import 'package:get/get.dart';

class DrawerTeacher extends StatelessWidget {
  const DrawerTeacher({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MainController mainController = Get.find<MainController>();
    UsersController usersController = Get.find<UsersController>();
    return Container(
      width: Get.width * 0.35,
      decoration: BoxDecoration(
        color: AppColor.lightBlue,
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Get.width * 0.01,
                    vertical: Get.height * 0.02,
                  ),
                  child: ListTile(
                    leading: Image.asset(
                      'images/personal_info_icon.png',
                      width: 64,
                    ),
                    title: Text(
                      'Thông tin cá nhân',
                      style: TextStyle(
                        color: AppColor.blue,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      mainController.numPageAdmin.value = 0;
                      Get.back();
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Get.width * 0.01,
                    vertical: Get.height * 0.02,
                  ),
                  child: ListTile(
                    leading: Image.asset(
                      'images/logout_icon.png',
                      width: 64,
                    ),
                    title: Text(
                      'Đăng xuất',
                      style: TextStyle(
                        color: AppColor.blue,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () async {
                      await usersController.logout();
                      // Get.back();
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
