import 'dart:io';

import 'package:flutter/material.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/albums_item.dart';
import 'package:testsylo/model/api_request.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/model/draft_model.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/page/post_media/post_photo/review_photo_post_page/review_photo_post_page.dart';
import 'package:testsylo/page/sylo/open_message_page/edit_open_message_page/success_message_page/success_message_page.dart';
import 'package:testsylo/service/database/database_helper.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';
import 'package:testsylo/util/navigate_effect.dart';

import '../../../../app.dart';

class ReviewPhotoPostPageViewModel {
  ReviewPhotoPostPageState state;
  InterceptorApi interceptorApi;
  List<TagModel> tagList = List<TagModel>();
  List<TagModel> tagListNew = List<TagModel>();
  List<GetAlbum> albumsItemList;
  List<int> albumsItemListSelected=List();
  List<PostPhotoModel> photoList = List();
  List<GetUserSylos> userSylosList;

  ReviewPhotoPostPageViewModel(this.state){
    interceptorApi = InterceptorApi(context: state.context);
    makeImageItem();
    if (isQuickPost) {
      userSylosList = initializeSyloItems(appState.getUserSylosList);
    } else {
      albumsItemList = appState.albumList;
      initializeAlbumItems();
      userSylosList = initializeSyloItems(appState.getUserSylosList);
    }
    Future.delayed(Duration(microseconds: 200) , () {
      state.setState(() {});
    });
  }

  initializeAlbumItems() {
    albumsItemList.forEach((element) {
      if(element.isCheck){
        element.isCheck = false;
      }
    });
  }

  makeImageItem() {
    if(state.widget.pickedImages!=null){
      photoList = state.widget.pickedImages;
    }
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

  Future<List<String>> uploadMediaPhotoPost(String mediaName) async {
    List<PostPhotoModel> picked_images = photoList;
    List<String> uploadedImages = List();

    if(picked_images.length > 0) {

      int sizeOfMediaList = picked_images.length;

      for(int i = 0; i < sizeOfMediaList; i++) {
        String mediaUploaded = "";
        if(picked_images[i].link != null && picked_images[i].link.isNotEmpty){
          mediaUploaded = picked_images[i].link.split('/').last;
        } else {
          //await interceptorApi.uploadGetMediaID(picked_images[i].image);
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
    return uploadedImages;
  }

  createMediaSubAlbumPhoto(String title, List<String> listUploadedImages, {List<int> albumIdList}) async {
    MediaSubAlbumItem mediaSubAlbumItem;
    MediaSubAlbumItem1 mediaSubAlbumItem1;
    String tagString = getTagString(tagList);

      List<int> albumIds = List();
      if (albumIdList != null) {
        albumIds = albumIdList;
      } else {
        albumIds = getAlbumIdList(getListOfSelectedAlbum());
      }
      mediaSubAlbumItem = MediaSubAlbumItem(title: title,
          tag: tagString,
          mediaType: "PHOTO",
          albumList: albumIds,
          rawMediaList: listUploadedImages);
    mediaSubAlbumItem1 = MediaSubAlbumItem1(title: title,
        tag: tagString,
        mediaType: "PHOTO",
        albumList: albumsItemListSelected.join(", "),
        rawMediaList: listUploadedImages.join(", "));
    //await interceptorApi.createMediaSubAlbum(mediaSubAlbumItem);

    //bool isSuccess = await interceptorApi.callCreateMediaSubAlbum(mediaSubAlbumItem);
    bool isSuccess = await interceptorApi.callCreateMediaSubAlbumNew(mediaSubAlbumItem1);
    if (isSuccess) {
      String text_message;
      if (isQuickPost) {
        text_message = "Your Photo has been saved successfully";
      } else {
        text_message = "Your Photo has been saved to ${appState.userSylo
            .syloName}'s Sylo";
      }
      var result = await Navigator.push(
                  state.context,
                  NavigatePageRoute(
                      state.context,
                      SuccessMessagePage(
                        headerName: "Photo Post",
                        message: text_message,
                      )));
    }

  }

  createMediaSubAlbumPhotoNew(String title, String listUploadedImages, String albumIdList) async {
    MediaSubAlbumItem1 mediaSubAlbumItem;

    String tagString = getTagString(tagListNew);


    mediaSubAlbumItem = MediaSubAlbumItem1(title: title,
        tag: tagString,
        mediaType: "PHOTO",
        albumList: albumIdList,
        rawMediaList: listUploadedImages);
    //await interceptorApi.createMediaSubAlbum(mediaSubAlbumItem);

    bool isSuccess = await interceptorApi.callCreateMediaSubAlbumNew(mediaSubAlbumItem);
    if (isSuccess) {
      String text_message;
      if (isQuickPost) {
        text_message = "Your Photo has been saved successfully";
      } else {
        if(state.widget.from=="QcamPageState") {

          text_message = "Your Photo has been saved successfully";
        }
        else {
          if (appState.userSylo.syloName != null) {
            text_message = "Your Photo has been saved to ${appState.userSylo
                .syloName}'s Sylo";
          }
          else {
            text_message = "Your Photo has been saved successfully";
          }
        }


      }
      var result = await Navigator.push(
          state.context,
          NavigatePageRoute(
              state.context,
              SuccessMessagePage(
                headerName: "Photo Post",
                message: text_message,
              )));
    }

  }

  saveAsDraft() async {
    String tagString = getTagString(tagListNew);
      List<String> mediaList = await savePhotoAsDraft(
        myDraft: MyDraft(title:state.titleController.text, tag: tagString, mediaType: App.MediaTypeMap["photo"]),
        photoList: photoList
      );
      if(mediaList.length>0) {
          commonToast("successfully saved as Draft");
          goToHome(state.context, null);
      }
    }

  deleteDraftItem(int id) async {
    int isDelete = await  databaseHelper.deleteDraftWithMedia(id,"PHOTO");
    print(isDelete.toString());
    if(isDelete!=null){

    }
  }
}