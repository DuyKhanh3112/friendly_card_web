// ignore_for_file: invalid_use_of_protected_member, depend_on_referenced_packages, prefer_adjacent_string_concatenation, avoid_function_literals_in_foreach_calls

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friendly_card_web/config.dart';
import 'package:friendly_card_web/controllers/topic_controller.dart';
import 'package:friendly_card_web/controllers/users_controller.dart';
import 'package:friendly_card_web/models/vocabulary.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class VocabularyController extends GetxController {
  RxBool loading = false.obs;

  CollectionReference vocabularyCollection =
      FirebaseFirestore.instance.collection('vocabulary');

  RxList<Vocabulary> listVocabulary = <Vocabulary>[].obs;

  Future<void> loadVocabularyTopic() async {
    loading.value = true;
    listVocabulary.value = [];
    TopicController topicController = Get.find<TopicController>();
    var snapshoot = await vocabularyCollection
        .where('topic_id', isEqualTo: topicController.topic.value.id)
        .get();
    for (var item in snapshoot.docs) {
      Map<String, dynamic> data = item.data() as Map<String, dynamic>;
      data['id'] = item.id;
      listVocabulary.add(Vocabulary.fromJson(data));
    }
    loading.value = false;
  }

  Future<void> createVocabulary(Vocabulary item) async {
    loading.value = true;
    WriteBatch batch = FirebaseFirestore.instance.batch();

    String id = vocabularyCollection.doc().id;
    DocumentReference vocaRef = vocabularyCollection.doc(id);
    item.update_at = Timestamp.now();
    batch.set(vocaRef, item.toVal());

    await batch.commit();
    loading.value = false;
  }

  Future<void> generateVocabulary() async {
    loading.value = true;
    TopicController topicController = Get.find<TopicController>();
    UsersController usersController = Get.find<UsersController>();
    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent');

    final headers = {
      'Content-Type': 'application/json',
      'X-goog-api-key': Config.API_KEY
    };
    String names = '';
    for (var element in listVocabulary.value) {
      names += '${element.name},';
    }
    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {
              "text": "Hãy cho tôi ${Config.num_generate} từ vựng tiếng Anh là danh từ, " +
                  "với chủ đề ${topicController.topic.value.name == '' ? 'Động vật' : topicController.topic.value.name}," +
                  " trả về gồm: từ vựng tiếng Anh, nghĩa tiếng Việt, ví dụ, nghĩa tiếng Việt của ví dụ và phiên âm. " +
                  "Dạng mảng bao gồm: vocabulary, mean, example, mean_example, transcription. ${names != '' ? "Khác các từ : $names" : ''}"
            }
          ]
        }
      ]
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final dataRes = json.decode(response.body);
        final data =
            dataRes['candidates'][0]['content']['parts'][0]['text'].toString();
        final vocabList = parseVocabularyList(data);

        vocabList.forEach((item) async {
          item['id'] = '';
          item['name'] = item['vocabulary'];
          item['user_id'] = usersController.user.value.id;
          item['topic_id'] = topicController.topic.value.id;
          item['active'] = false;
          item['update_at'] = Timestamp.now();
          item['image'] =
              'https://res.cloudinary.com/drir6xyuq/image/upload/v1749203203/logo_icon.png';

          await createVocabulary(Vocabulary.fromJson(item));
        });
      }
      await loadVocabularyTopic();
      loading.value = false;
    } catch (e) {
      loading.value = false;
    }
  }

  String extractJsonArray(String input) {
    final regex = RegExp(r'```json\s*(\[.*?\])\s*```', dotAll: true);
    final match = regex.firstMatch(input);
    if (match != null) {
      return match.group(1)!;
    }
    return '[]';
  }

  List<Map<String, dynamic>> parseVocabularyList(String rawText) {
    final jsonArrayString = extractJsonArray(rawText);
    final parsed = json.decode(jsonArrayString);
    return List<Map<String, dynamic>>.from(parsed);
  }

  Future<String> getImages(String key, String topic) async {
    final Uri uri = Uri.https('api.pexels.com', '/v1/search', {
      'query': 'Looking for pictures cute of $key with $topic themes',
      'per_page': '1', // Lấy 1 ảnh đầu tiên
    });

    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': Config.API_KEY_PEXELS,
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['photos'][0]['src']['original'];
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  Future<void> updateStatusVocabulary(Vocabulary item) async {
    loading.value = true;
    item.update_at = Timestamp.now();
    item.active = !item.active;
    await vocabularyCollection.doc(item.id).update(item.toVal());
    await loadVocabularyTopic();
    loading.value = false;
  }
}
