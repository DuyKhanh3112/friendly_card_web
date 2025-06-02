import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerAdmin extends StatelessWidget {
  const DrawerAdmin({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.35,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  // leading: Image.asset(
                  //   'assets/images/personal_info_icon.png',
                  //   width: 40,
                  // ),
                  title: const Text(
                    'Thông tin cá nhân',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Get.back();
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
