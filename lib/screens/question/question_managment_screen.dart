// ignore_for_file: invalid_use_of_protected_member, avoid_unnecessary_containers, sized_box_for_whitespace, deprecated_member_use, sort_child_properties_last, prefer_const_constructors
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flexible_grid_view/flexible_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:friendly_card_web/components/custom_button.dart';
import 'package:friendly_card_web/components/custom_dialog.dart';
import 'package:friendly_card_web/components/custom_dropdown.dart';
import 'package:friendly_card_web/components/custom_text_field.dart';
import 'package:friendly_card_web/controllers/question_controller.dart';
import 'package:friendly_card_web/controllers/topic_controller.dart';
import 'package:friendly_card_web/controllers/users_controller.dart';
import 'package:friendly_card_web/models/option.dart';
import 'package:friendly_card_web/models/question.dart';
import 'package:friendly_card_web/models/question_type.dart';
import 'package:friendly_card_web/utils/app_color.dart';
import 'package:friendly_card_web/utils/tool.dart';
import 'package:friendly_card_web/widget/loading_page.dart';
import 'package:get/get.dart';

class QuestionManagementScreen extends StatelessWidget {
  const QuestionManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TopicController topicController = Get.find<TopicController>();
    QuestionController questionController = Get.find<QuestionController>();

    RxInt currentPage = 1.obs;
    return Obx(() {
      return questionController.loading.value
          ? const LoadingPage()
          : SafeArea(
              child: Scaffold(
                backgroundColor: AppColor.lightBlue,
                appBar: AppBar(
                  centerTitle: true,
                  title: Text(
                      'Câu hỏi thuộc chủ đề: ${topicController.topic.value.name}'),
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
                          children: [
                            Container(
                              width: Get.width * 0.4,
                            ),
                            Container(
                              width: Get.width * 0.05,
                              padding: EdgeInsets.symmetric(
                                  vertical: Get.height * 0.02),
                              child: IconButton(
                                onPressed: () async {
                                  await questionController.loadQuestionData();
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
                                title: 'Thêm câu hỏi',
                                bgColor: AppColor.blue,
                                onClicked: () async {
                                  questionController.question.value =
                                      Question.initQuestion();
                                  await formQuestion(context);
                                },
                              ),
                            ),
                            Container(
                              width: Get.width * 0.2,
                              decoration: const BoxDecoration(),
                              child: CustomButton(
                                title: 'Tạo câu hỏi tự động',
                                bgColor: AppColor.blue,
                                onClicked: () async {
                                  await questionController.generateQuestion();
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
                            children: questionController.listQuestion.value
                                .where((item) =>
                                    item.active == (currentPage.value == 0))
                                .map((item) {
                              return questionItem(item, context);
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
                          'Đã được duyệt (${questionController.listQuestion.value.where((t) => t.active).length})',
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.cancel),
                      label:
                          'Đang chờ duyệt (${questionController.listQuestion.value.where((t) => !t.active).length})',
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

  Widget questionItem(Question item, BuildContext context) {
    QuestionController questionController = Get.find<QuestionController>();
    List<Option> listOption = questionController.listOption
        .where((opt) => opt.question_id == item.id)
        .toList();

    return Stack(
      alignment: Alignment.topRight,
      children: [
        InkWell(
          onTap: () async {
            questionController.question.value = item;
            await formQuestion(context);
          },
          child: Container(
            // width: Get.width * 0.8,
            alignment: Alignment.topLeft,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  item.content,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 24,
                    color: AppColor.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '(${item.mean})',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColor.blue,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Divider(
                  color: AppColor.blue,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: listOption
                      .map(
                        (opt) => Container(
                          child: Text(
                            '${Tool.convertNumberToChar(listOption.indexOf(opt))}. ${opt.content}',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColor.blue,
                              fontWeight: opt.is_correct
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              decoration: opt.is_correct
                                  ? TextDecoration.underline
                                  : null,
                              decorationColor: AppColor.blue,
                            ),
                          ),
                        ),
                      )
                      .toList(),
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
                Get.find<UsersController>().user.value.role == 'teacher'
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
              await questionController.updateStatusQuestion(item);
              // await topicController.updateTopicStatus(item);
              // await vocabularyController.updateStatusVocabulary(item);
            },
          ),
        ),
      ],
    );
  }

  Future<void> formQuestion(BuildContext context) async {
    QuestionController questionController = Get.find<QuestionController>();
    UsersController usersController = Get.find<UsersController>();
    final formKey = GlobalKey<FormState>();

    TextEditingController contenController =
        TextEditingController(text: questionController.question.value.content);
    TextEditingController meanContentController =
        TextEditingController(text: questionController.question.value.mean);

    Rx<QuestionType> questionType = (questionController.listQuestionType.value
                .firstWhereOrNull((type) =>
                    type.id ==
                    questionController.question.value.question_type_id) ??
            QuestionType.initQuestionType())
        .obs;
    RxList<Rx<Option>> listOption = <Rx<Option>>[
      Option.initOption().obs,
      Option.initOption().obs,
      Option.initOption().obs,
      Option.initOption().obs,
    ].obs;
    if (questionController.question.value.id != '') {
      listOption.value = questionController.listOption.value
          .where(
              (opt) => opt.question_id == questionController.question.value.id)
          .map((opt) => opt.obs)
          .toList();
      if (listOption.isEmpty) {
        var newOpt = Option.initOption().obs;
        newOpt.value.question_id = questionController.question.value.id;
        listOption.value = [
          newOpt,
          newOpt,
          newOpt,
          newOpt,
        ];
      }
    }
    await Get.dialog(
      Obx(() {
        return AlertDialog(
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
                'Thông tin câu hỏi',
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
                  Container(
                    // width: Get.width * 0.3,
                    child: Column(
                      children: [
                        CustomTextField(
                          label: 'Nội dung',
                          multiLines: true,
                          controller: contenController,
                          required: true,
                          readOnly:
                              usersController.user.value.role != 'teacher',
                        ),
                        CustomTextField(
                          label: 'Nghĩa câu hỏi',
                          multiLines: true,
                          controller: meanContentController,
                          required: true,
                          readOnly:
                              usersController.user.value.role != 'teacher',
                        ),
                        CustomDropdown(
                          items: questionController.listQuestionType.value
                              .map(
                                (item) => DropdownMenuItem(
                                  child: Text(
                                    item.name,
                                    overflow: TextOverflow.ellipsis,
                                    strutStyle: StrutStyle.disabled,
                                  ),
                                  value: item,
                                ),
                              )
                              .toList(),
                          value: questionController.listQuestionType.value
                              .firstWhereOrNull(
                                  (t) => t.id == questionType.value.id)
                              .obs,
                          label: 'Loại câu hỏi',
                          width: Get.width * 0.5,
                          onChanged: (p0) {
                            if (p0 == null) {
                              questionType.value =
                                  QuestionType.initQuestionType();
                            } else {
                              questionType.value = p0;
                            }
                          },
                        ),
                        Column(
                          children: List.generate(
                            questionType.value.num_option,
                            (index) {
                              var item = listOption.value[index].value;
                              TextEditingController optController =
                                  TextEditingController(text: item.content);

                              if (questionType.value.num_option == 1) {
                                item.is_correct = true;
                              }
                              return ListTile(
                                leading: InkWell(
                                  onTap: () {
                                    item.is_correct = true;
                                    for (var element in listOption.value) {
                                      if (listOption.value.indexOf(element) ==
                                          index) {
                                        element.value = item;
                                      } else {
                                        element.value.is_correct = false;
                                      }
                                    }
                                  },
                                  child: Icon(item.is_correct
                                      ? Icons.check_box_outlined
                                      : Icons.check_box_outline_blank),
                                ),
                                title: CustomTextField(
                                  label: questionType.value.num_option == 1
                                      ? 'Đáp án'
                                      : 'Lựa chọn ${index + 1}',
                                  controller: optController,
                                  bgColor:
                                      item.is_correct ? Colors.amber : null,
                                  required: true,
                                  onChanged: (p0) {
                                    item.content = p0;
                                    for (var element in listOption.value) {
                                      if (listOption.value.indexOf(element) ==
                                          index) {
                                        element.value.content = p0;
                                      }
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
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
                      onPressed: () async {
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
                                    if (questionType.value.id == '') {
                                      await showAlertDialog(
                                          context,
                                          DialogType.error,
                                          'Vui lòng chọn loại câu hỏi',
                                          '');
                                      return;
                                    }
                                    if (listOption.value
                                        .where((ele) => ele.value.is_correct)
                                        .isEmpty) {
                                      await showAlertDialog(
                                          context,
                                          DialogType.error,
                                          'Vui lòng chọn lựa chọn đúng',
                                          '');
                                      return;
                                    }

                                    questionController.question.value.content =
                                        contenController.text;
                                    questionController.question.value.mean =
                                        meanContentController.text;
                                    questionController
                                            .question.value.question_type_id =
                                        questionType.value.id;
                                    questionController.question.value.topic_id =
                                        Get.find<TopicController>()
                                            .topic
                                            .value
                                            .id;
                                    questionController.question.value
                                        .update_at = Timestamp.now();
                                    questionController.loading.value = true;
                                    Get.back();
                                    if (questionController.question.value.id ==
                                        '') {
                                      // create

                                      await questionController.createQuestion(
                                          questionController.question.value,
                                          questionType.value.num_option == 1
                                              ? [listOption.value.first.value]
                                              : listOption.value
                                                  .map((ele) => ele.value)
                                                  .toList());
                                    } else {
                                      // update
                                      await questionController.updateQuestion(
                                          questionController.question.value,
                                          questionType.value.num_option == 1
                                              ? [listOption.value.first.value]
                                              : listOption.value
                                                  .map((ele) => ele.value)
                                                  .toList());
                                    }
                                    await questionController.loadQuestionData();
                                    questionController.loading.value = false;
                                  }
                                },
                                child: Text('Xác nhận'),
                              ),
                              // questionController.question.value.id == '' ||
                              //         questionController.question.value.active
                              //     ? SizedBox()
                              //     : SizedBox(
                              //         width: 64,
                              //       ),
                              // ElevatedButton(
                              //   style: ButtonStyle(
                              //     backgroundColor:
                              //         WidgetStatePropertyAll(Colors.red),
                              //     foregroundColor:
                              //         WidgetStatePropertyAll(Colors.white),
                              //   ),
                              //   onPressed: () async {
                              //     await showComfirmDialog(
                              //       context,
                              //       'desc',
                              //       'Bạn có muốn xóa câu hỏi này không?',
                              //       () async {
                              //         Get.back();
                              //         await questionController.deletedQuestion(
                              //           questionController.question.value,
                              //         );
                              //       },
                              //     );
                              //   },
                              //   child: Text('Xóa câu hỏi'),
                              // ),
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
                                  Get.back();
                                  await questionController.updateStatusQuestion(
                                      questionController.question.value);
                                },
                                child: Text(
                                    questionController.question.value.active
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
        );
      }),
    );
  }
}
