// ignore_for_file: invalid_use_of_protected_member, avoid_unnecessary_containers, sized_box_for_whitespace, deprecated_member_use, sort_child_properties_last, prefer_const_constructors

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flexible_grid_view/flexible_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:friendly_card_web/components/custom_button.dart';
import 'package:friendly_card_web/components/custom_text_field.dart';
import 'package:friendly_card_web/controllers/topic_controller.dart';
import 'package:friendly_card_web/controllers/users_controller.dart';
import 'package:friendly_card_web/controllers/vocabulary_controller.dart';
import 'package:friendly_card_web/models/vocabulary.dart';
import 'package:friendly_card_web/utils/app_color.dart';
import 'package:friendly_card_web/widget/loading_page.dart';
import 'package:get/get.dart';
import 'package:image_picker_web/image_picker_web.dart';

class VocabularyManagmentScreen extends StatelessWidget {
  const VocabularyManagmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    VocabularyController vocabularyController =
        Get.find<VocabularyController>();
    TopicController topicController = Get.find<TopicController>();
    UsersController usersController = Get.find<UsersController>();

    RxInt currentPage = 1.obs;
    return Obx(() {
      return vocabularyController.loading.value
          ? const LoadingPage()
          : SafeArea(
              child: Scaffold(
                backgroundColor: AppColor.lightBlue,
                appBar: AppBar(
                  centerTitle: true,
                  title: Text(
                      'Từ vựng thuộc chủ đề: ${topicController.topic.value.name}'),
                  backgroundColor: AppColor.blue,
                  foregroundColor: Colors.white,
                  titleTextStyle: const TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                body: Container(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Get.width * 0.025,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: usersController.user.value.role == 'teacher'
                              ? [
                                  Container(
                                    width: Get.width * 0.4,
                                  ),
                                  Container(
                                    width: Get.width * 0.05,
                                    padding: EdgeInsets.symmetric(
                                        vertical: Get.height * 0.02),
                                    child: IconButton(
                                      onPressed: () async {
                                        await vocabularyController
                                            .loadVocabularyTopic();
                                      },
                                      icon: Icon(
                                        Icons.refresh,
                                        color: AppColor.lightBlue,
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                AppColor.blue),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: Get.width * 0.2,
                                    decoration: const BoxDecoration(),
                                    child: CustomButton(
                                      title: 'Thêm từ vựng',
                                      bgColor: AppColor.blue,
                                      onClicked: () async {
                                        vocabularyController.vocabulary.value =
                                            Vocabulary.initVocabulary();
                                        await formVocabulary();
                                      },
                                    ),
                                  ),
                                  Container(
                                    width: Get.width * 0.2,
                                    decoration: const BoxDecoration(),
                                    child: CustomButton(
                                      title: 'Tạo từ vựng tự động',
                                      bgColor: AppColor.blue,
                                      onClicked: () async {
                                        await vocabularyController
                                            .generateVocabulary();
                                      },
                                    ),
                                  ),
                                ]
                              : [
                                  Container(
                                    width: Get.width * 0.4,
                                  ),
                                  Container(
                                    width: Get.width * 0.05,
                                    padding: EdgeInsets.symmetric(
                                      vertical: Get.height * 0.02,
                                    ),
                                    child: IconButton(
                                      onPressed: () async {
                                        await vocabularyController
                                            .loadVocabularyTopic();
                                      },
                                      icon: Icon(
                                        Icons.refresh,
                                        color: AppColor.lightBlue,
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                AppColor.blue),
                                      ),
                                    ),
                                  ),
                                ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Get.width * 0.025,
                        ),
                        child: Divider(
                          color: AppColor.blue,
                        ),
                      ),
                      Expanded(
                        child: FlexibleGridView(
                            axisCount: GridLayoutEnum.twoElementsInRow,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            children: vocabularyController.listVocabulary.value
                                .where((item) =>
                                    item.active == (currentPage.value == 0))
                                .map((item) {
                              return vocabularyItem(item);
                            }).toList()),
                      ),
                    ],
                  ),
                ),
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
                  selectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  selectedItemColor: Colors.white,
                  items: [
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.check_circle),
                      label:
                          'Đã được duyệt (${vocabularyController.listVocabulary.value.where((t) => t.active).length})',
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.cancel),
                      label:
                          'Đang chờ duyệt (${vocabularyController.listVocabulary.value.where((t) => !t.active).length})',
                    ),
                  ],
                  currentIndex: currentPage.value,
                  onTap: (value) {
                    currentPage.value = value;
                  },
                ),
              ),
            );
    });
  }

  Future<void> formVocabulary() async {
    VocabularyController vocabularyController =
        Get.find<VocabularyController>();
    TopicController topicController = Get.find<TopicController>();
    UsersController usersController = Get.find<UsersController>();
    final formKey = GlobalKey<FormState>();

    RxString imgBase64 = ''.obs;
    RxString imgUrl = vocabularyController.vocabulary.value.image.obs;

    TextEditingController nameController =
        TextEditingController(text: vocabularyController.vocabulary.value.name);
    TextEditingController meanController =
        TextEditingController(text: vocabularyController.vocabulary.value.mean);
    TextEditingController transcriptionController = TextEditingController(
        text: vocabularyController.vocabulary.value.transcription);
    TextEditingController exampleController = TextEditingController(
        text: vocabularyController.vocabulary.value.example);
    TextEditingController meanExampleController = TextEditingController(
        text: vocabularyController.vocabulary.value.mean_example);
    await Get.dialog(
      Obx(
        () => AlertDialog(
          titlePadding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.025,
            vertical: Get.width * 0.01,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.025,
            // vertical: Get.width * 0.01,
          ),
          buttonPadding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.025,
            vertical: Get.width * 0.01,
          ),
          actionsPadding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.025,
            vertical: Get.width * 0.01,
          ),
          title: Column(
            children: [
              Text(
                'Thông tin từ vựng',
                style: TextStyle(
                  fontSize: 28,
                  color: AppColor.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(
                color: AppColor.blue,
              ),
            ],
          ),
          content: Container(
            width: Get.width * 0.5,
            // height: Get.height * 0.3,
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: Get.width * 0.3,
                        child: Column(
                          children: [
                            CustomTextField(
                              label: 'Tên từ vựng',
                              controller: nameController,
                              required: true,
                              readOnly:
                                  usersController.user.value.role != 'teacher',
                            ),
                            CustomTextField(
                              label: 'Nghĩa từ vựng',
                              controller: meanController,
                              required: true,
                              readOnly:
                                  usersController.user.value.role != 'teacher',
                            ),
                            CustomTextField(
                              label: 'Phiên âm',
                              controller: transcriptionController,
                              required: true,
                              readOnly:
                                  usersController.user.value.role != 'teacher',
                            ),
                            CustomTextField(
                              label: 'Chủ đề',
                              controller: TextEditingController(
                                  text: topicController.topic.value.name),
                              // required: true,
                              readOnly: true,
                            ),
                            CustomTextField(
                              label: 'Ví dụ',
                              controller: exampleController,
                              multiLines: true,
                              required: true,
                              readOnly:
                                  usersController.user.value.role != 'teacher',
                            ),
                            CustomTextField(
                              label: 'Nghĩa ví dụ',
                              multiLines: true,
                              controller: meanExampleController,
                              required: true,
                              readOnly:
                                  usersController.user.value.role != 'teacher',
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: usersController.user.value.role != 'teacher'
                            ? null
                            : () async {
                                var result =
                                    await ImagePickerWeb.getImageAsBytes();
                                if (result != null) {
                                  imgBase64.value = base64Encode(result);
                                }
                              },
                        child: Column(
                          children: [
                            Container(
                              height: Get.height * 0.25,
                              width: Get.height * 0.25,
                              padding: EdgeInsets.all(12),
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                // border: Border.all(),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(32),
                                ),
                                image: vocabularyController
                                            .vocabulary.value.id ==
                                        ''
                                    ? imgBase64.value == ''
                                        ? null
                                        : DecorationImage(
                                            image: MemoryImage(
                                                base64Decode(imgBase64.value)),
                                            fit: BoxFit.cover,
                                          )
                                    : imgBase64.value == ''
                                        ? imgUrl.value == ''
                                            ? null
                                            : DecorationImage(
                                                image:
                                                    NetworkImage(imgUrl.value),
                                                fit: BoxFit.cover,
                                              )
                                        : DecorationImage(
                                            image: MemoryImage(
                                                base64Decode(imgBase64.value)),
                                            fit: BoxFit.cover,
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
                              alignment: Alignment.center,
                            ),
                            // usersController.user.value.role == 'teacher'
                            //     ?
                            Text(
                              'Nhấn vào đây để thay đổi ảnh từ vựng.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: AppColor.labelBlue,
                              ),
                            )
                            // : SizedBox(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Column(
              children: [
                Divider(
                  color: AppColor.blue,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.red),
                        foregroundColor: WidgetStatePropertyAll(Colors.white),
                      ),
                      onPressed: () {
                        Get.back();
                      },
                      child: Text('Đóng'),
                    ),
                    usersController.user.value.role == 'teacher'
                        ? Row(
                            children: [
                              SizedBox(
                                width: 64,
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStatePropertyAll(AppColor.blue),
                                  foregroundColor:
                                      WidgetStatePropertyAll(Colors.white),
                                ),
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    if (vocabularyController
                                            .vocabulary.value.id ==
                                        '') {
                                      Vocabulary voca =
                                          Vocabulary.initVocabulary();
                                      voca.name = nameController.text;
                                      voca.mean = meanController.text;
                                      voca.transcription =
                                          transcriptionController.text;
                                      voca.example = exampleController.text;
                                      voca.mean_example =
                                          meanExampleController.text;
                                      voca.topic_id =
                                          topicController.topic.value.id;
                                      voca.user_id =
                                          usersController.user.value.id;
                                      Get.back();
                                      await vocabularyController
                                          .createVocabulary(
                                              voca, imgBase64.value);
                                    } else {
                                      vocabularyController.vocabulary.value
                                          .name = nameController.text;
                                      vocabularyController.vocabulary.value
                                          .mean = meanController.text;
                                      vocabularyController
                                              .vocabulary.value.transcription =
                                          transcriptionController.text;
                                      vocabularyController.vocabulary.value
                                          .example = exampleController.text;
                                      vocabularyController
                                              .vocabulary.value.mean_example =
                                          meanExampleController.text;
                                      Get.back();
                                      await vocabularyController
                                          .updateVocabulary(imgBase64.value);
                                    }
                                    vocabularyController.vocabulary.value =
                                        Vocabulary.initVocabulary();
                                  }
                                },
                                child: Text('Xác nhận'),
                              ),
                            ],
                          )
                        : SizedBox(),
                    usersController.user.value.role == 'admin'
                        ? Row(
                            children: [
                              SizedBox(
                                width: 64,
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStatePropertyAll(AppColor.warm),
                                  foregroundColor:
                                      WidgetStatePropertyAll(Colors.white),
                                ),
                                onPressed: () async {
                                  await vocabularyController
                                      .updateStatusVocabulary(
                                          vocabularyController
                                              .vocabulary.value);
                                },
                                child: Text(
                                    vocabularyController.vocabulary.value.active
                                        ? 'Chờ duyệt'
                                        : 'Duyệt'),
                              ),
                            ],
                          )
                        : SizedBox(),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget vocabularyItem(Vocabulary item) {
    UsersController usersController = Get.find<UsersController>();
    VocabularyController vocabularyController =
        Get.find<VocabularyController>();
    return Stack(
      alignment: Alignment.topRight,
      children: [
        InkWell(
          onTap: () async {
            vocabularyController.vocabulary.value = item;
            await formVocabulary();
          },
          child: Container(
            // width: Get.width * 0.8,
            margin: EdgeInsets.symmetric(
              vertical: Get.height * 0.02,
              horizontal: Get.width * 0.02,
            ),
            padding: EdgeInsets.symmetric(
              vertical: Get.height * 0.02,
              horizontal: Get.width * 0.01,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: Get.width * 0.1,
                  height: Get.width * 0.1,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(18)),
                    image: DecorationImage(
                      image: NetworkImage(item.image == ''
                          ? 'https://res.cloudinary.com/drir6xyuq/image/upload/v1749203203/logo_icon.png'
                          : item.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  width: Get.width * 0.3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '${item.name} (${item.transcription})',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 24,
                          color: AppColor.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(
                        color: AppColor.blue,
                      ),
                      Text(
                        'Nghĩa: ${item.mean}',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColor.blue,
                        ),
                      ),
                      Text(
                        item.example,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColor.blue,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '(${item.mean_example})',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColor.blue,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(
            vertical: Get.height * 0.02,
            horizontal: Get.width * 0.02,
          ),
          padding: EdgeInsets.symmetric(
            vertical: Get.height * 0.02,
            horizontal: Get.width * 0.01,
          ),
          child: PopupMenuButton<String>(
            child: Icon(
              Icons.circle,
              color: item.active ? AppColor.blue : Colors.grey,
            ),
            color: AppColor.lightBlue,
            itemBuilder: (context) =>
                usersController.user.value.role == 'teacher'
                    ? []
                    : [
                        item.active
                            ? const PopupMenuItem(
                                value: 'lock',
                                child: ListTile(
                                  leading: Icon(
                                    Icons.circle,
                                    color: Colors.grey,
                                  ),
                                  textColor: Colors.grey,
                                  titleTextStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  title: Text('Chờ duyệt'),
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
                                  titleTextStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  title: const Text('Duyệt'),
                                ),
                              ),
                      ],
            onSelected: (value) async {
              // await topicController.updateTopicStatus(item);
              await vocabularyController.updateStatusVocabulary(item);
            },
          ),
        ),
      ],
    );
  }
}
