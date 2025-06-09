import 'package:flutter/material.dart';
import 'package:friendly_card_web/screens/user/user_information_screen.dart';
import 'package:friendly_card_web/screens/teacher/teacher_managment_screen.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  RxInt numPageAdmin = 0.obs;
  RxInt numPageTeacher = 0.obs;

  List<String> titleAdmin = [
    'Thông tin cá nhân',
    'Giáo viên chuyên môn',
    'Quản lý chủ đề',
    'Quản lý từ vựng',
  ];
  List<String> titleTeacher = [
    'Thông tin cá nhân',
    'Quản lý chủ đề',
    'Quản lý từ vựng',
  ];

  List<Widget> pageAdmin = [
    const UserInformationScreen(),
    const TeacherManagmentScreent(),
    const TeacherManagmentScreent(),
    const TeacherManagmentScreent(),
  ];

  List<Widget> pageTeacher = [
    const UserInformationScreen(),
  ];
}
