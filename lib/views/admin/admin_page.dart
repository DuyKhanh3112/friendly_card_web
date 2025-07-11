// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:friendly_card_web/controllers/main_controller.dart';
import 'package:friendly_card_web/controllers/users_controller.dart';
import 'package:friendly_card_web/widget/loading_page.dart';
import 'package:friendly_card_web/utils/app_color.dart';
import 'package:friendly_card_web/views/admin/drawer_admin.dart';
import 'package:get/get.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});
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
                            .titleAdmin[mainController.numPageAdmin.value],
                      ),
                      backgroundColor: AppColor.blue,
                      titleTextStyle: const TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      foregroundColor: Colors.white,
                      actions: [
                        PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'logout') {
                              await usersController.logout();
                              return;
                            }
                            if (value == 'profile') {
                              mainController.numPageAdmin.value = 0;
                              return;
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem<String>(
                              value: 'profile',
                              labelTextStyle: WidgetStatePropertyAll(
                                TextStyle(
                                  fontSize: 18,
                                  color: AppColor.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'images/personal_info_icon.png',
                                    width: 32,
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  const Text('Thông tin cá nhân'),
                                ],
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'logout',
                              labelTextStyle: WidgetStatePropertyAll(
                                TextStyle(
                                  fontSize: 18,
                                  color: AppColor.warm,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'images/logout_icon.png',
                                    width: 32,
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  const Text('Đăng xuất'),
                                ],
                              ),
                            ),
                          ],
                          icon: Row(
                            children: [
                              Text(
                                usersController.user.value.fullname,
                                style: const TextStyle(
                                  // fontSize: 28,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(Icons.arrow_drop_down_outlined)
                            ],
                          ),
                          iconColor: Colors.white,
                          iconSize: 24,
                        ),
                      ],
                    ),
                    body: mainController
                        .pageAdmin[mainController.numPageAdmin.value],
                    drawer: const DrawerAdmin(),
                  ),
                );
    });
  }
}
