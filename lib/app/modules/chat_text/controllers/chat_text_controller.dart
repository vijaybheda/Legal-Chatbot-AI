import 'dart:convert';

import 'package:chat_gpt_flutter/app_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../common/headers.dart';
import '../../../model/text_completion_model.dart';

class ChatTextController extends GetxController {
  //TODO: Implement ChatTextController

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  List<TextCompletionData> messages = [];

  var state = ApiState.notFound.obs;

  void getTextCompletion(String query) async {
    addMyMessage();

    state.value = ApiState.loading;

    try {
      bool isLegalQuestion = false;
      Map<String, dynamic> rowParams0 = {
        "model": "text-davinci-003",
        // "prompt": 'can you check type of query: $query',
        "prompt": "Determine the user's intend: $query",
        "max_tokens": 200,
        "temperature": 0.5,
      };

      final encodedParams0 = json.encode(rowParams0);

      final response0 = await http.post(
        Uri.parse(endPoint("completions")),
        body: encodedParams0,
        headers: headerBearerOption(OPEN_AI_KEY),
      );
      print("Response body ${response0.body}");
      if (response0.statusCode == 200) {
        // messages =
        //     TextCompletionModel.fromJson(json.decode(response.body)).choices;
        //
        String body = response0.body;
        var appStorage = AppStorage();
        List<String> keys =
            appStorage.getAppConfig()?.filterKeywords?.toList() ??
                [
                  "legal",
                  "action",
                  "law",
                  "disciplinary",
                  "litigation",
                  "rightful",
                  "law procedure",
                  "criminal",
                  "police",
                  "report",
                  "court",
                  "Indian Penal Code",
                  "section"
                ];
        for (var mValue in keys) {
          if (body.contains(mValue)) {
            isLegalQuestion = true;
            break;
          }
        }
        if (!isLegalQuestion) {
          // String a =
          //     '{"id":"cmpl-6wbwIXMvw3GmDBHB2w0FMGtUfCMIX","object":"text_completion","created":1679426882,"model":"text-davinci-003","choices":[{"text":"\n\nThis is not a type of query.","index":0,"logprobs":null,"finish_reason":"stop"}],"usage":{"prompt_tokens":8,"completion_tokens":10,"total_tokens":18}}';
          Map<String, dynamic> _data = json.decode(body);
          _data['choices'][0]['text'] =
              "Unfortunately, this is not a legal question and so I cannot provide an answer. If you have a legal question, please provide more details so that I can help.";
          addServerMessage(TextCompletionModel.fromJson(_data).choices);
          state.value = ApiState.success;
          clearTextField();
          return;
        }
      } else {
        // throw ServerException(message: "Image Generation Server Exception");
        state.value = ApiState.error;
        clearTextField();
      }

      if (!isLegalQuestion) {
        clearTextField();
        return;
      }
      Map<String, dynamic> rowParams = {
        "model": "text-davinci-003",
        "prompt": 'Legal question: $query',
        "max_tokens": 200,
        "temperature": 0.5,
      };

      final encodedParams = json.encode(rowParams);

      final response = await http.post(
        Uri.parse(endPoint("completions")),
        body: encodedParams,
        headers: headerBearerOption(OPEN_AI_KEY),
      );
      print("Response  body     ${response.body}");
      if (response.statusCode == 200) {
        // messages =
        //     TextCompletionModel.fromJson(json.decode(response.body)).choices;
        //
        addServerMessage(
            TextCompletionModel.fromJson(json.decode(response.body)).choices);
        state.value = ApiState.success;
      } else {
        // throw ServerException(message: "Image Generation Server Exception");
        state.value = ApiState.error;
      }
    } catch (e) {
      print("Errorrrrrrrrrrrrrrr  ");
    } finally {
      // searchTextController.clear();
      clearTextField();
      update();
    }
  }

  addServerMessage(List<TextCompletionData> choices) {
    for (int i = 0; i < choices.length; i++) {
      messages.insert(i, choices[i]);
    }
  }

  addMyMessage() {
    // {"text":":\n\nWell, there are a few things that you can do to increase","index":0,"logprobs":null,"finish_reason":"length"}
    TextCompletionData text = TextCompletionData(
        text: searchTextController.text, index: -999999, finish_reason: "");
    messages.insert(0, text);
  }

  clearTextField() {
    searchTextController.clear();
  }

  TextEditingController searchTextController = TextEditingController();
}
