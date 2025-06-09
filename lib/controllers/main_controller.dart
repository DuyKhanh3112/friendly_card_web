import 'package:flutter/material.dart';
import 'package:friendly_card_web/views/screens/admin/admin_information_screen.dart';
import 'package:friendly_card_web/views/screens/teacher/teacher_managment_screen.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  RxInt numPageAdmin = 1.obs;

  List<String> titleAdmin = [
    'Thông tin cá nhân',
    'Giáo viên chuyên môn',
    'Quản lý chủ đề',
    'Quản lý từ vựng',
  ];

  List<Widget> pageAdmin = [
    const AdminInformationScreen(),
    const TeacherManagmentScreent(),
    const TeacherManagmentScreent(),
    const TeacherManagmentScreent(),
  ];
}
