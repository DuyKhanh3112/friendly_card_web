import 'package:flutter/material.dart';
import 'package:friendly_card_web/components/custom_button.dart';
import 'package:friendly_card_web/components/custom_text_field.dart';
import 'package:friendly_card_web/controllers/teacher_controller.dart';
import 'package:friendly_card_web/utils/app_color.dart';
import 'package:friendly_card_web/widget/loading_page.dart';
import 'package:get/get.dart';

class TeacherFormScreen extends StatelessWidget {
  const TeacherFormScreen({super.key});
  @override
  Widget build(BuildContext context) {
    TeacherController teacherController = Get.find<TeacherController>();

    TextEditingController fullnameController =
        TextEditingController(text: teacherController.teacher.value.fullname);
    TextEditingController usernameController =
        TextEditingController(text: teacherController.teacher.value.username);
    TextEditingController phonenameController =
        TextEditingController(text: teacherController.teacher.value.phone);
    TextEditingController emailnameController =
        TextEditingController(text: teacherController.teacher.value.email);
    TextEditingController rolenameController =
        TextEditingController(text: 'Giáo viên');

    return Obx(() {
      return teacherController.loading.value
          ? const LoadingPage()
          : SafeArea(
              child: Scaffold(
                backgroundColor: AppColor.lightBlue,
                appBar: AppBar(
                  title: Text(teacherController.teacher.value.id == ''
                      ? 'Thêm giáo viên chuyên môn'
                      : 'Cập nhật thông tin giáo viên chuyên môn'),
                  backgroundColor: AppColor.blue,
                  foregroundColor: Colors.white,
                ),
                body: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.05,
                      vertical: Get.height * 0.05,
                    ),
                    margin: EdgeInsets.symmetric(
                      vertical: Get.height * 0.05,
                    ),
                    width: Get.width * 0.65,
                    // height: Get.height * 0.8,
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
                            required: true,
                            controller: fullnameController,
                          ),
                        ),
                        Container(
                          width: Get.width * 0.4,
                          child: CustomTextField(
                            label: 'Số điện thoại',
                            controller: phonenameController,
                          ),
                        ),
                        Container(
                          width: Get.width * 0.4,
                          child: CustomTextField(
                            label: 'Email',
                            required: true,
                            type: ContactType.mail,
                            controller: emailnameController,
                          ),
                        ),
                        Container(
                          width: Get.width * 0.4,
                          child: CustomTextField(
                            label: 'Tên tài khoản',
                            required: true,
                            controller: usernameController,
                          ),
                        ),
                        // Container(
                        //   width: Get.width * 0.4,
                        //   child: CustomTextField(
                        //     label: 'Mật khẩu',
                        //     controller: TextEditingController(text: '123'),
                        //   ),
                        // ),
                        Container(
                          width: Get.width * 0.4,
                          child: CustomTextField(
                            label: 'Quyền',
                            readOnly: true,
                            controller:
                                TextEditingController(text: 'Giáo viên'),
                          ),
                        ),
                        Container(
                          width: Get.width * 0.4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: Get.width * 0.4,
                                child: CustomButton(
                                  title: 'Lưu giáo viên',
                                  onClicked: () async {},
                                  bgColor: AppColor.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
    });
  }
}
