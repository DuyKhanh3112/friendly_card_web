// ignore_for_file: deprecated_member_use, prefer_const_constructors

import 'dart:math';

import 'package:flexible_grid_view/flexible_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:friendly_card_web/components/custom_button.dart';
import 'package:friendly_card_web/components/custom_search_field.dart';
import 'package:friendly_card_web/components/custome_title.dart';
import 'package:friendly_card_web/controllers/teacher_controller.dart';
import 'package:friendly_card_web/controllers/users_controller.dart';
import 'package:friendly_card_web/widget/empty_data.dart';
import 'package:friendly_card_web/widget/loading_page.dart';
import 'package:friendly_card_web/models/users.dart';
import 'package:friendly_card_web/utils/app_color.dart';
import 'package:get/get.dart';

class TeacherManagmentScreent extends StatelessWidget {
  const TeacherManagmentScreent({super.key});

  @override
  Widget build(BuildContext context) {
    UsersController usersController = Get.find<UsersController>();
    TeacherController teacherController = Get.find<TeacherController>();
    List nums = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    teacherController.loadAllData();
    return Obx(
      () {
        return usersController.loading.value || teacherController.loading.value
            ? const LoadingPage()
            : Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.05,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: Get.width * 0.6,
                          child: CustomSearchFiled(
                            hint:
                                'Tìm kiếm giáo viên chuyên môn theo Tên đăng nhập, Họ tên, Email, Số điện thoại.',
                            onChanged: (String value) {},
                            controller: TextEditingController(),
                          ),
                        ),
                        Container(
                          width: Get.width * 0.05,
                          child: IconButton(
                            onPressed: () async {
                              teacherController.loading.value = true;
                              await teacherController.loadAllData();
                              teacherController.loading.value = false;
                            },
                            icon: Icon(
                              Icons.refresh,
                              color: AppColor.lightBlue,
                            ),
                            // color: AppColor.blue,
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  AppColor.blue),
                            ),
                          ),
                        ),
                        Container(
                          width: Get.width * 0.2,
                          decoration: BoxDecoration(),
                          child: CustomButton(
                            title: 'Thêm Giáo viên',
                            bgColor: AppColor.blue,
                            onClicked: () async {
                              teacherController.teacher.value =
                                  Users.initUser();
                              Get.toNamed('/teacher_form');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  teacherController.listTeachers.isEmpty
                      ? EmptyData()
                      : Expanded(
                          child: FlexibleGridView(
                            axisCount: GridLayoutEnum.threeElementsInRow,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            children: teacherController.listTeachers
                                .map(
                                  (item) => itemTeacher(item),
                                )
                                .toList(),
                          ),
                        ),
                ],
              );
      },
    );
  }

  Widget itemTeacher(Users item) {
    TeacherController teacherController = Get.find<TeacherController>();
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Get.width * 0.03,
        vertical: Get.height * 0.05,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          teacherController.teacher.value = item;
          Get.toNamed('/teacher_form');
        },
        child: Column(
          children: [
            Container(
              height: Get.height * 0.3,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage((item.avatar != null && item.avatar != '')
                      ? item.avatar!
                      : 'https://res.cloudinary.com/drir6xyuq/image/upload/v1749203203/logo_icon.png'),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.all(Get.height * 0.01),
              child: Text(
                item.fullname.toUpperCase(),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(Get.height * 0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person),
                  Text(
                    ' ${item.username}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      // height: 100 + Random().nextInt(100).toDouble(),
    );
  }
}
