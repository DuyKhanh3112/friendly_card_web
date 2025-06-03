// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:friendly_card_web/controllers/main_controller.dart';
import 'package:friendly_card_web/controllers/users_controller.dart';
import 'package:friendly_card_web/loading_page.dart';
import 'package:friendly_card_web/views/admin/drawer_admin.dart';
import 'package:get/get.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    UsersController usersController = Get.find<UsersController>();
    MainController mainController = Get.find<MainController>();

    return Obx(() {
      return usersController.loading.value
          ? const LoadingPage()
          : SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  title: Text(mainController
                      .titleAdmin.value[mainController.numPageAdmin.value]),
                  backgroundColor: Colors.green,
                ),
                body: const Text('data'),
                drawer: const DrawerAdmin(),
              ),
            );
    });
  }
}
