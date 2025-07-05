import 'dart:convert';

import 'package:friendly_card_web/config.dart';
import 'package:friendly_card_web/controllers/topic_controller.dart';
import 'package:friendly_card_web/controllers/users_controller.dart';
import 'package:friendly_card_web/utils/tool.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;

class QuestionController extends GetxController {
  RxBool loading = false.obs;

  Future<void> generateQuestion() async {
    loading.value = true;
    TopicController topicController = Get.find<TopicController>();
    UsersController usersController = Get.find<UsersController>();
    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent');

    final headers = {
      'Content-Type': 'application/json',
      'X-goog-api-key': Config.API_KEY
    };
    String names = 'lion, ephant, snake';
    // for (var element in listVocabulary.value) {
    //   names += '${element.name},';
    // }
    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {
              // "text": "Hãy cho tôi ${Config.num_generate} câu hỏi bài tập tiếng Anh với dạng câu hỏi là ${'điền khuyết'}," +
              //     " số lựa chọn là ${'4'}, số đáp án đúng là 1 " +
              //     "với chủ đề ${topicController.topic.value.name == '' ? 'Động vật' : topicController.topic.value.name}," +
              //     " trả về mảng json gồm: câu hỏi, nghĩa câu hỏi, các lựa chọn (dạng mảng), lựa chọn đúng; " +
              //     "Dạng mảng bao gồm: question, mean_question, options, awnser. Đáp án liên quan đến : $names"
              "text": "Hãy cho tôi ${Config.num_generate} câu hỏi bài tập tiếng Anh dạng dịch nghĩa 1 từ tiếng việt sang tiếng anh hoặc ngược lại," +
                  " số lựa chọn là ${'4'}, số đáp án đúng là 1 " +
                  "với chủ đề ${topicController.topic.value.name == '' ? 'Động vật' : topicController.topic.value.name}," +
                  " trả về mảng json gồm: câu hỏi tiếng anh,  nghĩa câu hỏi, các lựa chọn (dạng mảng), lựa chọn đúng, " +
                  "Dạng mảng bao gồm: question, mean_question, options, awnser. Đáp án liên quan đến : $names"
              // "text": "Hãy cho tôi ${Config.num_generate} câu hỏi bài tập tiếng Anh với dạng câu hỏi là sắp xếp chữ cái," +
              //     "với chủ đề ${topicController.topic.value.name == '' ? 'Động vật' : topicController.topic.value.name}," +
              //     " trả về mảng json gồm: câu hỏi , nghĩa câu hỏi, các chữ cái gợi ý (dạng mảng, chữ cái gợi ý sắp xếp lộn lộn) , sắp xếp đúng, nghĩa đáp án. " +
              //     "Dạng mảng bao gồm: question, mean_question, goi_y, dung, mean_dung. Đáp án liên quan đến : $names"
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
        final questList = Tool.parseList(data);
        questList.forEach((item) async {
          print(item);
        });

        // vocabList.forEach((item) async {
        //   item['id'] = '';
        //   item['name'] = item['vocabulary'];
        //   item['user_id'] = usersController.user.value.id;
        //   item['topic_id'] = topicController.topic.value.id;
        //   item['active'] = false;
        //   item['update_at'] = Timestamp.now();
        //   item['image'] =
        //       'https://res.cloudinary.com/drir6xyuq/image/upload/v1749203203/logo_icon.png';

        //   await createVocabulary(Vocabulary.fromJson(item), '');
        // });
      }
      // await loadVocabularyTopic();
      loading.value = false;
    } catch (e) {
      loading.value = false;
    }
  }
}
