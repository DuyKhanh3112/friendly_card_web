import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friendly_card_web/controllers/main_controller.dart';
import 'package:friendly_card_web/models/users.dart';
import 'package:get/get.dart';

class UsersController extends GetxController {
  RxBool loading = false.obs;
  RxString role = ''.obs;
  Rx<Users> user = Users.initUser().obs;

  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  bool checkLogin() {
    if (user.value.id == '' || !['admin', 'teacher'].contains(role.value)) {
      return false;
    }
    return true;
  }

  Future<bool> login(String uname, String pword) async {
    loading.value = true;
    final snapshot = await usersCollection
        .where('username', isEqualTo: uname)
        .where('password', isEqualTo: pword)
        .where('active', isEqualTo: true)
        .where('role', whereIn: ['admin', 'teacher']).get();
    if (snapshot.docs.isNotEmpty) {
      Map<String, dynamic> data =
          snapshot.docs[0].data() as Map<String, dynamic>;
      data['id'] = snapshot.docs[0].id;
      user.value = Users.fromJson(data);

      role.value = user.value.role;
      loading.value = false;

      if (role.value == 'admin') {
        Get.toNamed('/admin');
      }
      if (role.value == 'teacher') {
        Get.toNamed('/teacher');
      }
      return true;
    }
    loading.value = false;
    return false;
  }

  Future<void> logout() async {
    loading.value = true;
    MainController mainController = Get.find<MainController>();
    mainController.numPageAdmin.value = 0;
    user.value = Users.initUser();
    role.value = '';
    Get.toNamed('/');
    loading.value = false;
  }

  Future<void> updateInformationUser() async {
    loading.value = true;
    user.value.update_at = Timestamp.now();
    await usersCollection.doc(user.value.id).update(user.value.toVal());
    loading.value = false;
  }
}
