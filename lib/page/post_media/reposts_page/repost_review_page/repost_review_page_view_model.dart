import 'package:flutter/material.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/albums_item.dart';
import 'package:testsylo/model/api_request.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/model/draft_model.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/page/post_media/reposts_page/repost_review_page/repost_review_page.dart';
import 'package:testsylo/page/sylo/open_message_page/edit_open_message_page/success_message_page/success_message_page.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';
import 'package:testsylo/util/navigate_effect.dart';

import '../../../../app.dart';

class RepostReviewPageViewModel {
  RepostReviewPageState state;
  InterceptorApi interceptorApi;
  List<TagModel> tagList = List<TagModel>();
  List<TagModel> tagListNew = List<TagModel>();
  List<GetAlbum> albumsItemList;
  List<int> albumsItemListSelected=List();
  List<GetUserSylos> userSylosList;
  String title="";
  String thumnamil="";

  RepostReviewPageViewModel(this.state)  {
    interceptorApi = InterceptorApi(context: state.context);

    if (isQuickPost) {
      userSylosList = initializeSyloItems(appState.getUserSylosList);
    } else {
      albumsItemList = appState.albumList;
      initializeAlbumItems();
    }
    if(state.widget.type=="YouTube")  {
      callYoutubeMediaLink(state.widget.link);
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

  createMediaSubAlbumRepost(String title, String description, String albumIdList) async {
    /*List<int> albumIds = List();
    if (albumIdList!=null) {
      albumIds = albumIdList;
    } else {
      albumIds = getAlbumIdList(getListOfSelectedAlbum());
    }*/
    String tagString = getTagString(tagListNew);
    MediaSubAlbumItem1 mediaSubAlbumItem = MediaSubAlbumItem1(title: title, description: description, directURL: state.widget.link, tag: tagString, mediaType:"REPOST", albumList: albumIdList);
    //bool isSuccess = await interceptorApi.callCreateMediaSubAlbum(mediaSubAlbumItem);
    bool isSuccess = await interceptorApi.callCreateMediaSubAlbumNew(mediaSubAlbumItem);
    if (isSuccess) {
      if(state.widget.from == "MyDraftsPageState"){
        deleteDraftItem(state.widget.myDraft.id);
      }
      String text_message;
      if (isQuickPost) {
        text_message = "Your Repost has been saved successfully";
      } else {
        if(appState.userSylo.syloName!=null) {
          text_message =
          "Your Repost has been saved to ${appState.userSylo.syloName}'s Sylo";
        }
        else{
          text_message = "Your Repost has been saved successfully";
        }
      }
      var result = await Navigator.push(
          state.context,
          NavigatePageRoute(
              state.context,
              SuccessMessagePage(
                headerName: "Repost",
                message: text_message,
              )));
    }
  }


  callYoutubeMediaLink(String url) async {

    Map isSuccess = await interceptorApi.callYoutubeEmbedLink(url);
    state.setState(() {
        title=isSuccess['title'];
        thumnamil=isSuccess['thumbnail_url'];
    });

  }

  saveAsAudioDraft() async {
    String tagString = getTagString(tagListNew);
    int draft = await saveAsDraft(
        MyDraft(title:state.titleController.text, tag: tagString, directURL: state.widget.link,
            description: state.messageController.text, mediaType: App.MediaTypeMap["repost"],postType: state.widget.type)
    );
    if(draft>0) {
      commonToast("successfully saved as Draft");
      goToHome(state.context, null);
    }
  }
  deleteDraftItem(int id) async {
    int isDelete = await  databaseHelper.deleteDraftWithMedia(id,"repost");
    print(isDelete.toString());
    if(isDelete!=null){

    }
  }
}
