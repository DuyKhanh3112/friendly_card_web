import 'package:friendly_card_web/controllers/main_controller.dart';
import 'package:friendly_card_web/controllers/users_controller.dart';
import 'package:get/get.dart';

class InitalBinding extends Bindings {
  @override
  void dependencies() async {
    Get.put(MainController());
    Get.put(UsersController());
    // Get.find<UsersController>().checkLogin();
  }
}
