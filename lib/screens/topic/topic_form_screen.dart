import 'package:flutter/material.dart';
import 'package:friendly_card_web/components/custom_button.dart';
import 'package:friendly_card_web/components/custom_text_field.dart';
import 'package:friendly_card_web/controllers/topic_controller.dart';
import 'package:friendly_card_web/utils/app_color.dart';
import 'package:friendly_card_web/widget/loading_page.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

class TopicFormScreen extends StatelessWidget {
  const TopicFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TopicController topicController = Get.find<TopicController>();
    TextEditingController nameController =
        TextEditingController(text: topicController.topic.value.name);
    // TextEditingController nameController = TextEditingController(text: topicController.topic.value.name);
    // TextEditingController nameController = TextEditingController(text: topicController.topic.value.name);

    final formKey = GlobalKey<FormState>();

    return Obx(() {
      return topicController.loading.value
          ? LoadingPage()
          : Scaffold(
              backgroundColor: AppColor.lightBlue,
              appBar: AppBar(
                centerTitle: true,
                title: Text(topicController.topic.value.id == ''
                    ? 'Thêm chủ đề'
                    : 'Cập nhật chủ đề'),
                backgroundColor: AppColor.blue,
                foregroundColor: Colors.white,
                titleTextStyle: const TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
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
                  child: Form(
                    key: formKey,
                    child: ListView(
                      children: [
                        CustomTextField(
                          label: 'Tên chủ đề',
                          controller: nameController,
                          required: true,
                        ),
                        CustomTextField(
                          label: 'Trạng thái',
                          controller: TextEditingController(
                              text: topicController.topic.value.active
                                  ? "Đang hiển thị"
                                  : "Đã bị ẩn"),
                          readOnly: true,
                        ),
                        CustomButton(
                          title: 'title',
                          onClicked: () async {},
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
