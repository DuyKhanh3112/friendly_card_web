import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friendly_card_web/models/users.dart';
import 'package:get/get.dart';

class UsersController extends GetxController {
  RxBool loading = false.obs;
  RxString role = ''.obs;
  Rx<Users> user = Users.initUser().obs;

  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<bool> login(String uname, String pword) async {
    loading.value = true;
    final snapshot = await usersCollection
        .where('username', isEqualTo: uname)
        .where('password', isEqualTo: pword)
        .where('active', isEqualTo: true)
        .get();
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
      if (role.value == 'teacher') {}
      return true;
    }
    loading.value = false;
    return false;
  }

  Future<void> logout() async {
    user.value = Users.initUser();
    role.value = '';
  }
}
