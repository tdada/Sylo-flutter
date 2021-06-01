import 'package:flutter/material.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/model/albums_item.dart';
import 'package:testsylo/model/api_request.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';
import 'package:testsylo/util/util.dart';
import '../../../../app.dart';
import 'send_record_sound_page.dart';

class SendRecordSoundPageViewModel {
  SendRecordSoundPageState state;
  InterceptorApi interceptorApi;
  List<AlbumsItem> albumsItemList = List<AlbumsItem>();
  List<TagModel> tagList = List<TagModel>();

  SendRecordSoundPageViewModel(this.state) {
    interceptorApi = InterceptorApi(context: state.context);
  }

  initializeItems() {
    for (int i = 0; i < 6; i++) {
      albumsItemList.add(AlbumsItem(
          App.ic_place, "John Elder", false));
    }
  }
  changeSelectItem(int index) {
    albumsItemList[index].isCheck = !albumsItemList[index].isCheck;
  }

  initializeTagItems() {
    tagList.add(TagModel(name:"birthday"));
  }

  addTag(String tagName){
    tagList.add(TagModel(name: tagName));
    state.setState(() {
    });
  }

  askAudioQuestion() async {
    hideFocusKeyBoard(state.context);
    if (state.formKey.currentState.validate()) {
      String title = state.titleController.text.toString().trim();
      print("Sylo Id -> " + appState.sharedSyloItem.syloId.toString());
      String mediaId = await interceptorApi.callUploadGetMediaID(state.widget.path, loaderLabel:"Uploading...");
      if (mediaId != null) {
        List<String> mediaIds = List();
        mediaIds.add(mediaId);

        bool result = await interceptorApi.callAskSyloQuestions(
            AskSyloQuestionItem(
                syloID: appState.sharedSyloItem.syloId.toString(),
                title: title,
                mediaType: "AUDIO",
                rawMediaIds: mediaIds,
                userId: appState.userItem.userId.toString()));
        if (result!=null && result==true) {
          Navigator.pop(state.context);
          Navigator.pop(state.context);
        }
      }

    }
  }
}