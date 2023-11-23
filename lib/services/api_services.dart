import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:grok_ai_demo/constants/api_consts.dart';
import 'package:grok_ai_demo/models/chat_model.dart';
import 'package:grok_ai_demo/models/models_model.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  static Future<List<ModelsModel>> getModels() async {
    try {
      var response = await http.get(Uri.parse("$Base_Url/models"), headers: {
        'Authorization': 'Bearer $API_KEY',
      });

      Map jsnResponse = jsonDecode(response.body);
      if (jsnResponse["error"] != null) {
        jsnResponse["error"]["message"];
        throw HttpException(jsnResponse["error"]["message"]);
      }
      // print(jsnResponse);
      List temp = [];
      for (var value in jsnResponse["data"]) {
        temp.add(value);
        // log("Temp $value");
      }
      return ModelsModel.modelsFromSnapshot(temp);
    } catch (error) {
      log("error: $error");
      rethrow;
    }
  }

  //send msg

  static Future<List<ChatModel>> sendMessage(
      {required String message, required String modelID}) async {
    try {
      var response = await http.post(Uri.parse("$Base_Url/chat/completions"),
          headers: {
            'Authorization': 'Bearer $API_KEY',
            "Content-Type": "application/json"
          },
          body: jsonEncode({
            "model": modelID,
            "messages": [
              {"role": "user", "content": message}
            ],
            "temperature": 0.7
          }));

      Map jsnResponse = jsonDecode(response.body);
      if (jsnResponse.containsKey('error')) {
        final errorMessage = jsnResponse['error']['message'];
        log('Error: $errorMessage');
        throw HttpException(errorMessage);
      }
      List<ChatModel> chatlist = [];
      if (jsnResponse.containsKey('choices') &&
          jsnResponse['choices'].isNotEmpty) {
        final content = jsnResponse['choices'][0]["message"]['content'];
        log('Response content: $content');
        chatlist = List.generate(jsnResponse["choices"].length, (index) {
          final content = jsnResponse['choices'][index]["message"]['content'];
          return ChatModel(msg: content, chtIndex: 1);
        });

        //print('Response content: $content');
      }
      return chatlist;
    } catch (error) {
      log('Error: $error');
      rethrow;
    }
  }
}
