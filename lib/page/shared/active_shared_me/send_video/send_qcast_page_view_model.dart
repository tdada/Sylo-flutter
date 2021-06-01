import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/model/api_request.dart';
import 'package:testsylo/model/image_item.dart';
import 'package:testsylo/model/record_file_item.dart';
import 'package:testsylo/page/qcast/qcat_tab/my_channel_page/review_qcast_page/review_qcast_page.dart';
import 'package:testsylo/page/shared/active_shared_me/send_video/send_qcast_page.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';
import 'package:testsylo/util/util.dart';

import '../../../../app.dart';

class SendQcastPageViewModel {
  SendQcastPageState state;
  ImageItem thumbnailImage = ImageItem("");
  List<String> reviewQuestionsList = List();
  int editIndex = 0;
  InterceptorApi interceptorApi;
  SendQcastPageViewModel(this.state){
    reviewQuestionsList.add("What to do be a good husband?");
    reviewQuestionsList.add("What to do be a good husband?");

    interceptorApi = InterceptorApi(context: state.context);
  }

  askQcastQuestion() async {
    hideFocusKeyBoard(state.context);
    if (state.formKey.currentState.validate()) {
      String title = state.nameController.text.toString().trim();
      print("Sylo Id -> " + appState.sharedSyloItem.syloId.toString());

      String coverPhoto = "";
      File thumbnailFile = await getVideoThumbFile();
      if (thumbnailFile != null)
      {
        print("File path -> " + thumbnailFile.path.toString());
        coverPhoto = await uploadGeneratedThumbnail(thumbnailFile);
      }

      List<String> mediaIds = List();
      mediaIds = await uploadQcastVideo("Video");
      if (mediaIds.length > 0 && coverPhoto != null) {
        bool result = await interceptorApi.callAskSyloQuestions(
            AskSyloQuestionItem(
                syloID: appState.sharedSyloItem.syloId.toString(),
                title: title,
                mediaType: "QCAST",
                coverPhoto: coverPhoto,
                rawMediaIds: mediaIds,
                userId: appState.userItem.userId.toString()));
        if (result!=null && result==true) {
          Navigator.pop(state.context);
          Navigator.pop(state.context);
        }
      }

    }
  }

  Future<List<String>> uploadQcastVideo(String mediaName) async {
    List<RecordFileItem> picked_images = state.widget.listRecordWithThumb;
    List<String> uploadedImages = List();

    if (picked_images.length > 0) {
      int sizeOfMediaList = picked_images.length;

      for (int i = 0; i < sizeOfMediaList; i++) {
        String mediaUploaded = await interceptorApi.callUploadGetMediaID(
            picked_images[i].file,
            loaderLabel:
            "Uploading ${mediaName ?? ""} ${i + 1} / $sizeOfMediaList");
        if (mediaUploaded != null) {
          uploadedImages.add(mediaUploaded);
        }
      }
    }
    return uploadedImages;
  }

  Future<String> uploadGeneratedThumbnail(File file) async {
    String uploadedThumbnail = await interceptorApi.callUploadGetMediaID(file,
        loaderLabel: "Uploading thumbnail");
    if (uploadedThumbnail != null) {
      return uploadedThumbnail;
    }
    return null;
  }

  Future<File> getVideoThumbFile() async {
    if(state.widget.listRecordWithThumb[0]?.file!=null){
      showLoader(state.context, label: "Generating Thumbnail");
      Uint8List byteArry = await generateThumbnailFromVideo(state.widget.listRecordWithThumb[0].file);
      File file = await saveByteFile(byteArry);
      hideLoader();
      return file;
    }
    return null;
  }
}