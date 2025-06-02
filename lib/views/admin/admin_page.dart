import 'package:flutter/material.dart';
import 'package:friendly_card_web/controllers/users_controller.dart';
import 'package:friendly_card_web/loading_page.dart';
import 'package:friendly_card_web/views/admin/drawer_admin.dart';
import 'package:get/get.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    UsersController usersController = Get.find<UsersController>();

    return usersController.loading.value
        ? const LoadingPage()
        : SafeArea(
            child: Scaffold(
              appBar: AppBar(),
              body: const Text('data'),
              drawer: const DrawerAdmin(),
            ),
          );
  }
}
