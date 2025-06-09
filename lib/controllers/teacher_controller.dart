// ignore_for_file: invalid_use_of_protected_member

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friendly_card_web/models/users.dart';
import 'package:get/get.dart';

class TeacherController extends GetxController {
  RxBool loading = false.obs;
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  RxList<Users> listTeachers = <Users>[].obs;
  Rx<Users> teacher = Users.initUser().obs;

  Future<void> loadAllData() async {
    loading.value = true;
    listTeachers.value = [];
    final snapshoot =
        await usersCollection.where('role', isEqualTo: 'teacher').get();

    for (var doc in snapshoot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      listTeachers.value.add(Users.fromJson(data));
    }

    loading.value = false;
  }
}
