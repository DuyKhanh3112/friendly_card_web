import 'package:friendly_card_web/controllers/users_controller.dart';
import 'package:get/get.dart';

class InitalBinding extends Bindings {
  @override
  void dependencies() async {
    Get.put(UsersController());
  }
}
