// ignore_for_file: prefer_const_constructors, sort_child_properties_last, invalid_use_of_protected_member, sized_box_for_whitespace, deprecated_member_use, unrelated_type_equality_checks

import 'package:flexible_grid_view/flexible_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:friendly_card_web/components/custom_button.dart';
import 'package:friendly_card_web/components/custom_search_field.dart';
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
    RxInt currentPage = 0.obs;
    teacherController.loadAllData();
    return Obx(
      () {
        return usersController.loading.value || teacherController.loading.value
            ? const LoadingPage()
            : Scaffold(
                body: Column(
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
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
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
                                    Users.initTeacher();
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
                                  .where((t) => t.active == (currentPage == 0))
                                  .map(
                                    (item) => itemTeacher(item),
                                  )
                                  .toList(),
                            ),
                          ),
                  ],
                ),
                backgroundColor: AppColor.lightBlue,
                bottomNavigationBar: BottomNavigationBar(
                  elevation: 15,
                  type: BottomNavigationBarType.fixed,
                  selectedFontSize: 16,
                  unselectedFontSize: 13,
                  selectedIconTheme: const IconThemeData(
                    size: 32,
                  ),
                  unselectedIconTheme: const IconThemeData(
                    size: 24,
                  ),
                  showUnselectedLabels: true,
                  backgroundColor: AppColor.blue,
                  unselectedItemColor: AppColor.labelBlue,
                  unselectedLabelStyle: TextStyle(color: AppColor.labelBlue),
                  selectedLabelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  selectedItemColor: Colors.white,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.check_circle),
                      label:
                          'Đang hoạt động (${teacherController.listTeachers.where((t) => t.active).length})',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.cancel),
                      label:
                          'Đã bị khóa (${teacherController.listTeachers.where((t) => !t.active).length})',
                    ),
                  ],
                  currentIndex: currentPage.value,
                  onTap: (value) {
                    currentPage.value = value;
                  },
                ),
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
            Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  height: Get.height * 0.3,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage((item.avatar != null &&
                              item.avatar != '')
                          ? item.avatar!
                          : 'https://res.cloudinary.com/drir6xyuq/image/upload/v1749203203/logo_icon.png'),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: Get.width * 0.01,
                    right: Get.width * 0.01,
                  ),
                  child: PopupMenuButton<String>(
                    child: Icon(
                      Icons.circle,
                      color: item.active ? AppColor.blue : Colors.grey,
                    ),
                    onSelected: (value) async {
                      Users teacher = teacherController.listTeachers.value
                              .firstWhereOrNull((t) => t.id == item.id) ??
                          Users.initUser();
                      teacher.active = value == 'active';
                      await teacherController.updateTeacher(teacher);
                    },
                    color: AppColor.lightBlue,
                    itemBuilder: (context) => [
                      item.active
                          ? PopupMenuItem(
                              value: 'block',
                              child: ListTile(
                                leading: Icon(
                                  Icons.circle,
                                  color: Colors.grey,
                                ),
                                textColor: Colors.grey,
                                titleTextStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                title: Text('Khóa'),
                              ),
                            )
                          : PopupMenuItem(
                              value: 'active',
                              child: ListTile(
                                leading: Icon(
                                  Icons.circle,
                                  color: AppColor.blue,
                                ),
                                textColor: AppColor.blue,
                                titleTextStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                title: Text('Kích hoạt'),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
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
            ),
            Container(
              padding: EdgeInsets.all(Get.height * 0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.phone),
                  Text(
                    ' ${item.phone ?? ''}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(Get.height * 0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.email),
                  Text(
                    ' ${item.email ?? ''}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // height: 100 + Random().nextInt(100).toDouble(),
    );
  }
}
