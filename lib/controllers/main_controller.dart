import 'package:flutter/material.dart';
import 'package:friendly_card_web/controllers/teacher_controller.dart';
import 'package:friendly_card_web/controllers/topic_controller.dart';
import 'package:friendly_card_web/screens/topic/topic_managment_screen.dart';
import 'package:friendly_card_web/screens/user/user_information_screen.dart';
import 'package:friendly_card_web/screens/teacher/teacher_managment_screen.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  RxInt numPageAdmin = 2.obs;
  RxInt numPageTeacher = 1.obs;

  List<String> titleAdmin = [
    'Thông tin cá nhân',
    'Giáo viên chuyên môn',
    'Quản lý chủ đề',
    'Quản lý từ vựng',
  ];
  List<String> titleTeacher = [
    'Thông tin cá nhân',
    'Quản lý chủ đề',
  ];

  List<Widget> pageAdmin = [
    const UserInformationScreen(),
    const TeacherManagmentScreen(),
    const TopicManagmentScreen(),
    const TeacherManagmentScreen(),
  ];

  List<Widget> pageTeacher = [
    const UserInformationScreen(),
    const TopicManagmentScreen(),
  ];

  Future<void> loadAllDataForAdmin() async {
    await Get.find<TeacherController>().loadAllData();
    await Get.find<TopicController>().loadAllTopic();
  }
}
