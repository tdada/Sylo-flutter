import 'package:flutter/material.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/albums_item.dart';
import 'package:testsylo/model/api_request.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/model/draft_model.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/page/post_media/post_song/song_post_review_page/song_post_review_page.dart';
import 'package:testsylo/page/sylo/open_message_page/edit_open_message_page/success_message_page/success_message_page.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';
import 'package:testsylo/util/navigate_effect.dart';

import '../../../../app.dart';

class SongPostReviewPageViewModel {
  SongPostReviewPageState state;
  InterceptorApi interceptorApi;
  List<TagModel> tagList = List<TagModel>();
  List<TagModel> tagListNew = List<TagModel>();
  List<GetAlbum> albumsItemList;
  List<int> albumsItemListSelected=List();
  List<GetUserSylos> userSylosList;

  SongPostReviewPageViewModel(this.state){
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
      if(element.isCheck){
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

  addTag(String tagName){
    tagList.add(TagModel(name: tagName));
    state.setState(() {
    });
  }

  getListOfSelectedAlbum(){
    List<GetAlbum> selectedAlbums = albumsItemList.where((item) => item.isCheck==true).toList();

    return selectedAlbums;
  }

  bool albumSelected(){
    List<GetAlbum> selectedAlbums = getListOfSelectedAlbum();
    if(selectedAlbums!=null&&selectedAlbums.length>0){
      for(int i=0;i<selectedAlbums.length;i++)
      {
        albumsItemListSelected.add(selectedAlbums[i].albumId);
      }
      return true;
    } else {
      return false;
    }
  }

  createMediaSubAlbumSong(String title, String description, {List<int> albumIdList}) async {
    List<int> albumIds = List();
    if (albumIdList!=null) {
      albumIds = albumIdList;
    } else {
      albumIds = getAlbumIdList(getListOfSelectedAlbum());
    }
    String tagString = getTagString(tagListNew);
    MediaSubAlbumItem mediaSubAlbumItem = MediaSubAlbumItem(title: title, description: description, directURL: state.widget.link, tag: tagString, mediaType:"SONGS", albumList:albumIds);
    MediaSubAlbumItem1 mediaSubAlbumItem1 = MediaSubAlbumItem1(title: title, description: description, directURL: state.widget.link, tag: tagString, mediaType:"SONGS", albumList:albumIds.join(", "));
    bool isSuccess = await interceptorApi.callCreateMediaSubAlbumNew(mediaSubAlbumItem1);
    if (isSuccess) {
      if(state.widget.from == "MyDraftsPageState"){
        deleteDraftItem(state.widget.myDraft.id);
      }
      String text_message;
      if (isQuickPost) {
        text_message = "Your Song has been saved successfully";
      } else {
        text_message = "Your Song has been saved to ${appState.userSylo.syloName}'s Sylo";
      }
      var result = await Navigator.push(
          state.context,
          NavigatePageRoute(
              state.context,
              SuccessMessagePage(
                headerName: "Song Post",
                message: text_message,
              )));
    }
  }

  saveAsADraft() async {
    String tagString = getTagString(tagListNew);
    int draft = await saveAsDraft(
        MyDraft(title:state.titleController.text, tag: tagString, directURL: state.widget.link,
            description: state.messageController.text, mediaType: App.MediaTypeMap["songs"],postType: state.widget.type)
    );
    if(draft>0) {
      commonToast("successfully saved as Draft");
      goToHome(state.context, null);
    }
  }
  deleteDraftItem(int id) async {
    int isDelete = await  databaseHelper.deleteDraftWithMedia(id,"SONGS");
    print(isDelete.toString());
    if(isDelete!=null){

    }
  }
}