import 'package:flutter/material.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/model/albums_item.dart';
import 'package:testsylo/model/api_request.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/page/shared/active_shared_me/send_text/send_letter_post_page.dart';
import 'package:testsylo/page/sylo/open_message_page/edit_open_message_page/success_message_page/success_message_page.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';
import 'package:testsylo/util/navigate_effect.dart';
import 'package:testsylo/util/util.dart';
import '../../../../app.dart';

class SendLetterPostPageViewModel {
  SendLetterPageState state;
  InterceptorApi interceptorApi;
  List<AlbumsItem> albumsItemList = List<AlbumsItem>();
  List<TagModel> tagList = List<TagModel>();

  SendLetterPostPageViewModel(this.state) {
    interceptorApi = InterceptorApi(context: state.context);
  }

  initializeItems() {
    for (int i = 0; i < 6; i++) {
      albumsItemList.add(AlbumsItem(App.ic_place, "John Elder", false));
    }
  }

  changeSelectItem(int index) {
    albumsItemList[index].isCheck = !albumsItemList[index].isCheck;
  }

  initializeTagItems() {
    tagList.add(TagModel(name: "birthday"));
  }

  addTag(String tagName) {
    tagList.add(TagModel(name: tagName));
    state.setState(() {});
  }

  askLetterQuestion() async {
    hideFocusKeyBoard(state.context);
    if (state.formKey.currentState.validate()) {
      String date = state.dateController.text.toString().trim();
      String title = state.titleController.text.toString().trim();
      String message = state.messageController.text.toString().trim();
      print("Sylo Id -> " + appState.sharedSyloItem.syloId.toString());
      bool result = await interceptorApi.callAskSyloQuestions(
          AskSyloQuestionItem(
              syloID: appState.sharedSyloItem.syloId.toString(),
              title: title,
              mediaType: "TEXT",
              txtMsg: message,
              userId: appState.userItem.userId.toString()));
      if(result!=null && result==true) {
        Navigator.pop(state.context);
      }
    }
  }
}
