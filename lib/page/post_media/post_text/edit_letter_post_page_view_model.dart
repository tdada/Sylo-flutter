import 'package:flutter/material.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/albums_item.dart';
import 'package:testsylo/model/api_request.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/model/draft_model.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/page/post_media/post_text/edit_letter_post_page.dart';
import 'package:testsylo/page/sylo/open_message_page/edit_open_message_page/success_message_page/success_message_page.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';
import 'package:testsylo/util/navigate_effect.dart';

import '../../../app.dart';

class EditLetterPostPageViewModel {
  EditLetterPostPageState state;
  InterceptorApi interceptorApi;
  List<TagModel> tagList = List<TagModel>();
  List<TagModel> tagListNew = List<TagModel>();
  List<GetAlbum> albumsItemList;
  List<int> albumsItemListSelected = List();
  List<GetUserSylos> userSylosList;

  EditLetterPostPageViewModel(this.state) {
    interceptorApi = InterceptorApi(context: state.context);
    if (isQuickPost) {
      userSylosList = initializeSyloItems(appState.getUserSylosList);
    } else {
      albumsItemList = appState.albumList;
      initializeAlbumItems();
    }
  }

  initializeAlbumItems() {
    albumsItemList.forEach((element) {
      if (element.isCheck) {
        element.isCheck = false;
      }
    });
  }

  changeSelectItem(int index) {
    albumsItemList[index].isCheck = !albumsItemList[index].isCheck;
  }

  changeSelectSyloItem(int index) {
    userSylosList[index].isCheck = !userSylosList[index].isCheck;
  }

  addTag(String tagName) {
    tagList.add(TagModel(name: tagName));
    state.setState(() {});
  }

  getListOfSelectedAlbum() {
    List<GetAlbum> selectedAlbums =
        albumsItemList.where((item) => item.isCheck == true).toList();
    return selectedAlbums;
  }

  bool albumSelected() {
    List<GetAlbum> selectedAlbums = getListOfSelectedAlbum();
    if (selectedAlbums != null && selectedAlbums.length > 0) {
      for (int i = 0; i < selectedAlbums.length; i++) {
        albumsItemListSelected.add(selectedAlbums[i].albumId);
      }
      return true;
    } else {
      return false;
    }
  }

  createMediaSubAlbumText(
      String title, String textMessage, String albumIdList) async {
    /*List<int> albumIds = List();
    if (albumIdList!=null) {
      albumIds = albumIdList;
    } else {
      albumIds = getAlbumIdList(getListOfSelectedAlbum());
    }*/

    String tagString = getTagString(tagListNew);
    MediaSubAlbumItem1 mediaSubAlbumItem = MediaSubAlbumItem1(
        title: title,
        tag: tagString,
        mediaType: "TEXT",
        albumList: albumIdList,
        textMsg: textMessage);
    /*bool isSuccess =
        await interceptorApi.callCreateMediaSubAlbum(mediaSubAlbumItem);*/
    bool isSuccess =
        await interceptorApi.callCreateMediaSubAlbumNew(mediaSubAlbumItem);
    if (isSuccess) {
      String text_message;
      if (state.widget.from == "MyDraftsPageState") {
        deleteDraftItem(state.widget.myDraft.id);
      }
      if (isQuickPost) {
        text_message = "Your Note has been saved successfully";
      } else {
        text_message =
            "Your Note has been saved to ${appState.userSylo.syloName}'s Sylo";
      }
      var result = await Navigator.push(
          state.context,
          NavigatePageRoute(
              state.context,
              SuccessMessagePage(
                headerName: "Write a Note",
                message: text_message,
              )));
    }
  }

  saveAsADraft(String message, String onlyMessage) async {
    String tagString = getTagString(tagListNew);
    int draft = await saveAsDraft(
      MyDraft(
          title: state.titleController.text,
          tag: tagString,
          mediaType: App.MediaTypeMap["text"],
          description: message,
          onlyMessage: onlyMessage),
    );
    if (draft > 0) {
      commonToast("successfully saved as Draft");
      goToHome(state.context, null);
    }
  }

  deleteDraftItem(int id) async {
    int isDelete = await databaseHelper.deleteDraftWithMedia(id, "TEXT");
    print(isDelete.toString());
    if (isDelete != null) {}
  }
}
