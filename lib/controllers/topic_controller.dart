import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friendly_card_web/controllers/users_controller.dart';
import 'package:friendly_card_web/models/topic.dart';
import 'package:get/get.dart';

class TopicController extends GetxController {
  RxBool loading = false.obs;

  CollectionReference topicCollection =
      FirebaseFirestore.instance.collection('topic');

  RxList<Topic> listTopics = <Topic>[].obs;
  Rx<Topic> topic = Topic.initTopic().obs;
  UsersController usersController = Get.find<UsersController>();

  Future<void> loadTopicTeacher() async {
    listTopics.value = [];
    loading.value = true;

    var snapshoot = await topicCollection
        .where('user_id', isEqualTo: usersController.user.value.id)
        .get();
    for (var item in snapshoot.docs) {
      Map<String, dynamic> data = item.data() as Map<String, dynamic>;
      data['id'] = item.id;
      listTopics.value.add(Topic.fromJson(data));
    }
    loading.value = false;
  }

  Future<void> createTopic() async {
    loading.value = true;
    WriteBatch batch = FirebaseFirestore.instance.batch();
    String id = topicCollection.doc().id;
    DocumentReference refTopic = topicCollection.doc(id);
    topic.value.update_at = Timestamp.now();
    batch.set(refTopic, topic.value.toVal());
    await batch.commit();
    await loadTopicTeacher();
    topic.value = Topic.initTopic();
    loading.value = false;
  }
}
