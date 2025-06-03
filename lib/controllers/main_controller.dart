import 'package:get/get.dart';

class MainController extends GetxController {
  RxInt numPageAdmin = 0.obs;
  RxList<String> titleAdmin = [
    'Thông tin cá nhân',
    'Quản lý chủ đề',
    'Quản lý từ vựng',
  ].obs;
}
