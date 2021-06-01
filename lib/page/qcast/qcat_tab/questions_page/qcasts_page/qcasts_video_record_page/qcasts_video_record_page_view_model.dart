
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/albums_item.dart';
import 'package:testsylo/model/api_request.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/model/draft_model.dart';
import 'package:testsylo/model/image_item.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/model/question_item.dart';
import 'package:testsylo/page/qcast/qcat_tab/questions_page/qcasts_page/qcasts_video_record_page/qcasts_video_record_page.dart';
import 'package:testsylo/page/sylo/open_message_page/edit_open_message_page/success_message_page/success_message_page.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';
import 'package:testsylo/util/navigate_effect.dart';
import 'package:testsylo/util/util.dart';

import '../../../../../../app.dart';

class QcastsVideoRecordPageViewModel {
  QcastsVideoRecordPageState state;
  ImageItem profileImage = ImageItem("");
  InterceptorApi interceptorApi;
  List<GetAlbum> albumsItemList;
  List<int> albumsItemListSelected=List();
  List<GetUserSylos> userSylosList;
  List<TagModel> tagList = List<TagModel>();
  List<TagModel> tagListNew = List<TagModel>();

  QcastsVideoRecordPageViewModel(this.state){
    interceptorApi = InterceptorApi(context: state.context);
    if (isQuickPost) {
      userSylosList = initializeSyloItems(appState.getUserSylosList);

    } else {
      albumsItemList = appState.albumList;
      initializeAlbumItems();
      userSylosList = initializeSyloItems(appState.getUserSylosList);
    }
    print("UserSylo"+userSylosList.length.toString());
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

  getQuestionThumbIfQueListNotNull()  async {
    if (state.widget.listQuestion != null) {
      for (int i = 0; i < state.widget.listQuestion.length; i++) {
        QuestionItem item = state.widget.listQuestion[i];
        if(state.widget.from == "MyDraftsPageState"){
          return item.que_thumb;
        }
        if (item.start_time <= state.currDur &&
            item.end_time > state.currDur) {
          return item.que_thumb;
        }
      }
      return "";
      /*List<QuestionItem> items = state.widget.listQuestion
          .where((i) => i.isBetTime(startValue))
          .toList();
      items.forEach((element) {
        print("que_link -> "+element.que_link);
      });*/
    }
    else{
      return "";
    }
  }

  Future<List<String>> uploadMediaPhotoPost(String mediaName) async {
    List<File> picked_images = List();
    List<String> uploadedImages = List();
    if(state.widget.listRecordWithThumb[0].link==null) {
      if(state.widget.listRecordWithThumb[0].file.path.contains(",")) {
        var split=state.widget.listRecordWithThumb[0].file.path.split(",");
        await state.widget.listRecordWithThumb[0].file.copy(split[0]);
        state.widget.listRecordWithThumb[0].file=File(split[0].toString());
        picked_images.add(state.widget.listRecordWithThumb[0].file);
      }
      else{
        picked_images.add(state.widget.listRecordWithThumb[0].file);
      }
      if (picked_images.length > 0) {
//        return await interceptorApi.uploadVideoWithCoverPic(picked_images[0], loaderLabel: "Uploading ${mediaName??""}");
        String mediaUploaded = await interceptorApi.callUploadGetMediaID(picked_images[0]);
        /*String mediaUploaded = await interceptorApi.uploadGetMediaID(
            picked_images[0], loaderLabel: "Uploading ${mediaName ?? ""}");*/
        if (mediaUploaded != null) {
          if (state.widget.cameraState == CameraState.R) {
            uploadedImages.add("0@" + mediaUploaded);
          } else {
            uploadedImages.add("1@" + mediaUploaded);
          }
        }
      }
    } else{
      String mediaUploaded = state.widget.listRecordWithThumb[0].link.split("/").last;
      if (state.widget.cameraState == CameraState.R) {
        uploadedImages.add("0@" + mediaUploaded);
      } else {
        uploadedImages.add("1@" + mediaUploaded);
      }
    }
    return uploadedImages;
  }

  Future<String> uploadGeneratedThumbnail(File file) async {
    String uploadedThumbnail = await interceptorApi.callUploadGetMediaID(file);
    /*String uploadedThumbnail = await interceptorApi.uploadGetMediaID(file,
        loaderLabel: "Uploading thumbnail");*/
    print("UploadintTHim"+uploadedThumbnail);
    if (uploadedThumbnail != null) {
      return uploadedThumbnail;
    }
    return null;
  }

  Future<File> copy (
      String newPath
      )
  {

  }

  createMediaSubAlbumPhoto(String title, String listUploadedImages, cover_photo,  String albumIdList) async {
    /*List<int> albumIds = List();
    if (albumIdList!=null) {
      albumIds = albumIdList;
    } else {
      albumIds = getAlbumIdList(getListOfSelectedAlbum());
    }*/
    String tagString = getTagString(tagListNew);
    MediaSubAlbumItem1 mediaSubAlbumItem = MediaSubAlbumItem1(title: title, tag: tagString, mediaType:"VIDEO", albumList:albumIdList, rawMediaList:listUploadedImages, cover_photo: cover_photo);
    //bool isSuccess = await interceptorApi.callCreateMediaSubAlbum(mediaSubAlbumItem);
    bool isSuccess = await interceptorApi.callCreateMediaSubAlbumNew(mediaSubAlbumItem);
    if (isSuccess) {
      String text_message;
      if (isQuickPost) {
        text_message = "Your Video has been saved successfully";
      } else {
        if(state.widget.from=="QcamPageState") {

          text_message = "Your Video has been saved successfully";
        }
        else{
          if(appState.userSylo.syloName !=null) {
            text_message = "Your Video has been saved to ${appState.userSylo
                .syloName}'s Sylo";
          }
          else{
            text_message = "Your Video has been saved successfully";
          }
        }

      }
      var result = await Navigator.push(
          state.context,
          NavigatePageRoute(
              state.context,
              SuccessMessagePage(
                headerName: "Video Post",
                message: text_message,
              )));
    }

  }

  Future<File> getVideoThumbFile() async {
    if(state.widget.listRecordWithThumb[0]?.file!=null){
      showLoader(state.context, label: "Generating Thumbnail");
      Uint8List byteArry = await generateThumbnailFromVideo(state.widget.listRecordWithThumb[0].file);
      File file = await saveByteFile(byteArry);
      hideLoader();
      return file;
    } else if (state.widget.listRecordWithThumb[0]?.link!=null){
      return state.widget.listRecordWithThumb[0].thumbPath;
    }
    return null;
  }

  Future<File> saveByteFile(unit8List) async {
    Directory appDocDirectory;
    appDocDirectory = await getTemporaryDirectory();
    String path = appDocDirectory.path +
        "/" +
        DateTime.now().millisecondsSinceEpoch.toString() + ".jpg";
    await writeToFile(unit8List, path);
    return File(path);
  }

  getQuestionTimeString() {
    if(state.widget.listQuestion != null) {
      List<String> strtTimeList = List();
      state.widget.listQuestion.forEach((element) {
        strtTimeList.add(element.start_time.toString());
      });
      return strtTimeList.join(",");
    }
    return "";
  }

  createMediaSubAlbumQcast(String title, String listUploadedImages, cover_photo,  qcastId,String albumIdList) async {
    /*List<int> albumIds = List();
    if (albumIdList!=null) {
      albumIds = albumIdList;
    } else {
      albumIds = getAlbumIdList(getListOfSelectedAlbum());
    }*/
    String strtDuration;
    if(state.widget.from == "MyDraftsPageState"){
      strtDuration = state.widget.myDraft.qcastDuration;
    } else {
      strtDuration = getQuestionTimeString();
    }

    String tagString = getTagString(tagListNew);
    MediaSubAlbumItem1 mediaSubAlbumItem = MediaSubAlbumItem1(
        title: title,
        tag: tagString,
        mediaType:"QCAST",
        albumList:albumIdList,
        rawMediaList:listUploadedImages,
        cover_photo: cover_photo,
        qcastId: qcastId,
      qcastDuration: strtDuration);
    //bool isSuccess = await interceptorApi.callCreateMediaSubAlbum(mediaSubAlbumItem);
    bool isSuccess = await interceptorApi.callCreateMediaSubAlbumNew(mediaSubAlbumItem);
    if (isSuccess) {
      if(state.widget.from == "MyDraftsPageState"){
        deleteDraftItem(state.widget.myDraft.id);
      }
      String textMessage = "Your Qcast interview has been saved successfully";
      var result = await Navigator.push(
          state.context,
          NavigatePageRoute(
              state.context,
              SuccessMessagePage(
                headerName: " Qcast interview Post",
                message: textMessage,
              )));
    }

  }

  saveAsDraft() async {
    Navigator.pop(state.context);
    String tagString = getTagString(tagList);
    PostPhotoModel postPhotoModel;
    if(state.widget.listRecordWithThumb[0].link==null) {
      postPhotoModel = PostPhotoModel(image: state.widget.listRecordWithThumb[0].file);
      if (state.widget.cameraState == CameraState.S) {
        postPhotoModel.isCircle = false;
      }
    } else {
      postPhotoModel = PostPhotoModel(link: state.widget.listRecordWithThumb[0].link);
      if (state.widget.cameraState == CameraState.S) {
        postPhotoModel.isCircle = false;
      }
    }
    List<PostPhotoModel> photoList = [postPhotoModel];
    String mediaTypeName = isQuickPost && appState.selectedDownloadedQcast!=null ? "qcast": "video";
    File thumbnailFile = await getVideoThumbFile();
    String strtDuration = mediaTypeName=="qcast" ? getQuestionTimeString(): null;
    String coverPhoto;
    if (thumbnailFile != null)
    {
      print("File path -> " + thumbnailFile.path.toString());
      coverPhoto = thumbnailFile.path;
    }
    if(coverPhoto==null){
      commonToast("Thumbnail doesn't generate to save");
      return;
    }
    String qcastQuestionList;
    if(mediaTypeName=="qcast") {
      List<String> queList = List();
      state.widget.listQuestion.forEach((element) {
        queList.add(element.que_link);
      });
      qcastQuestionList = queList.join(",");
    }
    List<String> mediaList = await savePhotoAsDraft(
        myDraft: MyDraft(
            title:state.titleController.text,
            tag: tagString,
            coverPhoto: coverPhoto,
            mediaType: App.MediaTypeMap[mediaTypeName],
          qcastId: mediaTypeName=="qcast" ? appState.selectedDownloadedQcast.qcastId : null,
          qcastCoverPhoto: mediaTypeName=="qcast" ? appState.selectedDownloadedQcast.coverPhoto : null,
            qcastDuration: strtDuration,
          qcastQuestionList: qcastQuestionList,
        ),
        photoList: photoList
    );
    if(mediaList.length>0) {
      commonToast("successfully saved as Draft");
      goToHome(state.context, null);
    }
  }

  deleteDraftItem(int id) async {
    int isDelete = await  databaseHelper.deleteDraftWithMedia(id,"QCAST");
    print(isDelete.toString());
  }
}