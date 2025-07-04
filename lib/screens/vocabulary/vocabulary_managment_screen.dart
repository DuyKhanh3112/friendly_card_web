// ignore_for_file: invalid_use_of_protected_member, avoid_unnecessary_containers, sized_box_for_whitespace, deprecated_member_use, sort_child_properties_last

import 'package:flexible_grid_view/flexible_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:friendly_card_web/components/custom_button.dart';
import 'package:friendly_card_web/controllers/topic_controller.dart';
import 'package:friendly_card_web/controllers/users_controller.dart';
import 'package:friendly_card_web/controllers/vocabulary_controller.dart';
import 'package:friendly_card_web/models/vocabulary.dart';
import 'package:friendly_card_web/utils/app_color.dart';
import 'package:friendly_card_web/widget/loading_page.dart';
import 'package:get/get.dart';

class VocabularyManagmentScreen extends StatelessWidget {
  const VocabularyManagmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    VocabularyController vocabularyController =
        Get.find<VocabularyController>();
    TopicController topicController = Get.find<TopicController>();

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
                  // padding: EdgeInsets.symmetric(
                  //   horizontal: Get.width * 0.025,
                  // ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Get.width * 0.025,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: Get.width * 0.4,
                            ),
                            Container(
                              width: Get.width * 0.05,
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
                                onClicked: () async {},
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

  Widget vocabularyItem(Vocabulary item) {
    UsersController usersController = Get.find<UsersController>();
    VocabularyController vocabularyController =
        Get.find<VocabularyController>();
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
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
                                  titleTextStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  title: const Text('Kích hoạt'),
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

  Widget boldMainText(String example, String text) {
    List<String> parts = example.split(text.toLowerCase());
    String before = example;
    String after = '';
    if (parts.length >= 2) {
      before = parts[0];
      after = parts[1];
    }
    return Row(
      children: [
        Text(
          before,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 18,
            color: AppColor.blue,
          ),
        ),
        Text(
          text,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 18,
            color: AppColor.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          after,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 18,
            color: AppColor.blue,
          ),
        ),
      ],
    );
  }
}
