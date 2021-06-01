import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:testsylo/app.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/api_request.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/model/prompt_item.dart';
import 'package:testsylo/page/qcast/qcat_tab/questions_page/prompts_page/create_prompts_page/create_prompts_page.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';
import 'package:testsylo/util/util.dart';

class CreatePromptsPageViewModel {
  CreatePromptsPageState state;
  List<String> listPrompts = List();
  InterceptorApi interceptorApi;

  CreatePromptsPageViewModel(this.state) {
    interceptorApi = InterceptorApi(context: state.context);
  }

  addPrompt(String que) {
    listPrompts.add(que);
    state.setState(() {});
  }

  removePrompt(int index) {
    state.setState(() {
      listPrompts.removeAt(index);
    });
  }

  saveCustomPrompt() async {
    hideFocusKeyBoard(state.context);
    if (listPrompts.length > 0) {
      CustomPromptItem customPromptItem = CustomPromptItem(
          title: state.promptsTitleController.text,
          userId: appState.userItem.userId.toString(),
          promptsList: listPrompts);
      var data = await interceptorApi.callSaveCustomPrompt(
          customPromptItem, true);
      if (data != null) {
        print("jsonEncode -> " + jsonEncode(data));
        Iterable qcastList = data;
        List<PromptItem> listPrompt = qcastList.map((model) =>
            PromptItem.fromJson(model)).toList();
        appState.listPrompt = listPrompt;
        print("PromptsListLength -> " + listPrompt.length.toString());
        Navigator.of(state.context).pop(true);
      } else {
        Navigator.of(state.context).pop();
      }
    } else {
      commonAlert(state.context, "Please, Add your Questions.");
    }
  }
}