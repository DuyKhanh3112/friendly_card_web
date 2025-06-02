import 'package:flutter/material.dart';
import 'package:friendly_card_web/components/custom_button.dart';
import 'package:friendly_card_web/components/custom_text_field.dart';
import 'package:friendly_card_web/controllers/users_controller.dart';
import 'package:friendly_card_web/loading_page.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    UsersController usersController = Get.find<UsersController>();

    final formKey = GlobalKey<FormState>();
    Rx<TextEditingController> usernameController = TextEditingController().obs;
    Rx<TextEditingController> passwordController = TextEditingController().obs;

    return Obx(() {
      return usersController.loading.value
          ? const LoadingPage()
          : SafeArea(
              child: Scaffold(
                body: Center(
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: Get.height * 0.75,
                      minHeight: Get.height * 0.3,
                    ),
                    width: Get.width * 0.4,
                    alignment: Alignment.center,
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
                    child: Container(
                      width: Get.width * 0.3,
                      alignment: Alignment.center,
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'images/logo.png',
                              height: Get.height * 0.15,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: Get.height * 0.02),
                              child: const Text(
                                'Chào mừng bạn đến với FriendlyCard.\n Vui lòng đăng nhập để truy cập hệ thống.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            CustomTextField(
                              label: 'Tài khoản',
                              onChanged: (value) {
                                usernameController.value.text = value;
                              },
                              required: true,
                            ),
                            CustomTextField(
                              label: 'Mật khẩu',
                              onChanged: (value) {
                                passwordController.value.text = value;
                              },
                              required: true,
                              isPassword: true,
                            ),
                            CustomButton(
                              title: 'Đăng nhập',
                              onClicked: () async {
                                if (formKey.currentState!.validate()) {
                                  bool res = await usersController.login(
                                      usernameController.value.text,
                                      passwordController.value.text);
                                  if (!res) {
                                    // await showAlertDialog(
                                    //   context,
                                    //   DialogType.error,
                                    //   'Đăng nhập không thành công!',
                                    //   'Tài khoản hoặc mật khẩu không đúng.',
                                    // );
                                  }
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
    });
  }
}
