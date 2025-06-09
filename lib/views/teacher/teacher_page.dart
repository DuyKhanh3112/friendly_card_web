// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:friendly_card_web/controllers/main_controller.dart';
import 'package:friendly_card_web/controllers/users_controller.dart';
import 'package:friendly_card_web/views/teacher/drawer_teacher.dart';
import 'package:friendly_card_web/widget/loading_page.dart';
import 'package:friendly_card_web/utils/app_color.dart';
import 'package:get/get.dart';

class TeacherPage extends StatelessWidget {
  const TeacherPage({super.key});
  @override
  Widget build(BuildContext context) {
    UsersController usersController = Get.find<UsersController>();
    MainController mainController = Get.find<MainController>();

    return Obx(() {
      return
          // !usersController.checkLogin()
          //     ? const LoginPage()
          //     :
          usersController.loading.value
              ? const LoadingPage()
              : SafeArea(
                  child: Scaffold(
                    backgroundColor: AppColor.lightBlue,
                    appBar: AppBar(
                      centerTitle: true,
                      title: Text(
                        mainController
                            .titleTeacher[mainController.numPageTeacher.value],
                      ),
                      backgroundColor: AppColor.blue,
                      titleTextStyle: const TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      foregroundColor: Colors.white,
                    ),
                    body: mainController
                        .pageTeacher[mainController.numPageTeacher.value],
                    drawer: const DrawerTeacher(),
                  ),
                );
    });
  }
}
