import 'package:flutter/material.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/albums_item.dart';
import 'package:testsylo/model/api_request.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/model/draft_model.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/page/post_media/post_photo/record_voice_tag_page/review_voice_tag_page/review_voice_tag_page.dart';
import 'package:testsylo/page/sylo/open_message_page/edit_open_message_page/success_message_page/success_message_page.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';
import 'package:testsylo/util/navigate_effect.dart';

import '../../../../../app.dart';

class ReviewVoiceTagPageViewModel {
  ReviewVoiceTagPageState state;
  InterceptorApi interceptorApi;
  List<GetAlbum> albumsItemList;
  List<int> albumsItemListSelected=List();
  List<GetUserSylos> userSylosList;
  List<TagModel> tagList = List<TagModel>();
  List<TagModel> tagListNew = List<TagModel>();

  List<PostPhotoModel> photoList = List();

  ReviewVoiceTagPageViewModel(this.state) {
    interceptorApi = InterceptorApi(context: state.context);
    if (isQuickPost) {
      userSylosList = initializeSyloItems(appState.getUserSylosList);
    } else {
      albumsItemList = appState.albumList;
      initializeAlbumItems();
    }
    photoList = state.widget.pickedImages;
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

  Future<List<String>> uploadMediaPhotoPost(String mediaName) async {
    List<PostPhotoModel> picked_images = photoList;
    List<String> uploadedImages = List();

    if(picked_images.length > 0) {
      int sizeOfMediaList = picked_images.length;
      for(int i = 0; i < sizeOfMediaList; i++) {
        String mediaUploaded;
        if(picked_images[i].link != null && picked_images[i].link.isNotEmpty){
          mediaUploaded = picked_images[i].link.split('/').last;
        } else {
          mediaUploaded = await interceptorApi.callUploadGetMediaID(
              picked_images[i].image,
              loaderLabel: "Uploading ${mediaName ?? ""} ${i +
                  1} / $sizeOfMediaList");
        }
        if(mediaUploaded != null) {
          if(picked_images[i].isCircle) {
            uploadedImages.add(
                "1@"+mediaUploaded
            );
          } else {
            uploadedImages.add(
                "0@"+mediaUploaded
            );
          }
        }
      }
    }
    if (state.widget.voiceTagFile!=null) {
      String mediaUploaded = await interceptorApi.callUploadGetMediaID(
          state.widget.voiceTagFile, loaderLabel: "Uploading Annograph");
      if (mediaUploaded != null) {
        uploadedImages.add(mediaUploaded);
      }
    }
    return uploadedImages;
  }

  createMediaSubAlbumPhoto(String title, List<String> listUploadedImages, {List<int> albumIdList}) async {
    List<int> albumIds = List();
    if (albumIdList!=null) {
      albumIds = albumIdList;
    } else {
      albumIds = getAlbumIdList(getListOfSelectedAlbum());
    }
    String tagString = getTagString(tagListNew);
    MediaSubAlbumItem mediaSubAlbumItem = MediaSubAlbumItem(title: title, tag: tagString, mediaType:"VTAG", albumList:albumIds, rawMediaList:listUploadedImages);
    MediaSubAlbumItem1 mediaSubAlbumItem1 = MediaSubAlbumItem1(title: title, tag: tagString, mediaType:"VTAG", albumList:albumsItemListSelected.join(","), rawMediaList:listUploadedImages.join(","));
    bool isSuccess = await interceptorApi.callCreateMediaSubAlbumNew(mediaSubAlbumItem1);
    if (isSuccess) {
      if(state.widget.from == "MyDraftsPageState"){
        deleteDraftItem(state.widget.myDraft.id);
      }
      String text_message;
      if (isQuickPost) {
        text_message = "Your Annograph has been saved successfully";
      } else {
        text_message = "Your Annograph has been saved to ${appState.userSylo.syloName}'s Sylo";
      }
        var result = await Navigator.push(
            state.context,
            NavigatePageRoute(
                state.context,
                SuccessMessagePage(
                  headerName: "Annograph Post",
                  message: text_message,
                )));
    }
  }

  saveAsADraft() async {
    String tagString = getTagString(tagListNew);
    List<String> mediaList = await savePhotoAsDraft(
        myDraft: MyDraft(title:state.titleController.text, tag: tagString,
            mediaType: App.MediaTypeMap["vtag"], directURL: state.widget.voiceTagFile.path),
        photoList: photoList
    );
    if(mediaList.length>0) {
      commonToast("successfully saved as Draft");
      goToHome(state.context, null);
    }
  }
  deleteDraftItem(int id) async {
    int isDelete = await  databaseHelper.deleteDraftWithMedia(id,"VTAG");
    print(isDelete.toString());
    if(isDelete!=null){

    }
  }

}