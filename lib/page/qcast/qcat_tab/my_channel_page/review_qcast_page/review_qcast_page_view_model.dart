import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:testsylo/app.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/api_request.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/model/image_item.dart';
import 'package:testsylo/model/record_file_item.dart';
import 'package:testsylo/page/qcast/qcat_tab/my_channel_page/review_qcast_page/review_qcast_page.dart';
import 'package:testsylo/page/sylo/choose_sylo_view_all_page/choose_sylo_view_all_page.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';
import 'package:testsylo/util/navigate_effect.dart';
import 'package:testsylo/util/util.dart';
import '../my_channel_page.dart';
import 'package:path/path.dart';

class ReviewQcastPageViewModel {
  ReviewQcastPageState state;
  ImageItem thumbnailImage = ImageItem("");
  List<String> reviewQuestionsList = List();
  File thumbnailFile;
  Uint8List thumbnailByte;
  int editIndex = 0;
  int previewVideoIndex;
  List<GetUserSylos> userSylosList;
  InterceptorApi interceptorApi;

  ReviewQcastPageViewModel(this.state) {
    interceptorApi = InterceptorApi(context: state.context);
    userSylosList = initializeSyloItems(appState.getUserSylosList);
  }

  removePrompt(int index) {
    state.setState(() {
      reviewQuestionsList.removeAt(index);
    });
  }

  saveByteFile(unit8List) async {
    Directory appDocDirectory;
    appDocDirectory = await getTemporaryDirectory();
    String path = appDocDirectory.path +
        "/" +
        DateTime.now().millisecondsSinceEpoch.toString() +
        ".jpg";
    await writeToFile(unit8List, path);
    thumbnailFile = File(path);
  }

  validatereviewForm(String status) async {
    if (state.formKey.currentState.validate()) {
      if (thumbnailImage.path == null && thumbnailByte == null) {
        commonAlert(state.context, "Please, Generate thumbnail");
        return;
      }
      if (state.themeModel == null) {
        commonAlert(state.context, "Please, Select category");
        return;
      }
      if (previewVideoIndex == null) {
        commonAlert(state.context, "Please, Add Preview Video");
        return;
      }
      /*if (reviewQuestionsList.length <= 0) {
        commonAlert(state.context, "Please, Add the Questions");
        return;
      }*/
      List<GetUserSylos> list = getListOfSelectedSylo(userSylosList);
      if (list==null || list.length == 0) {
        commonAlert(state.context, "Please Select Sylos.");
        return;
      }
      List<GetUserSylos> selectedSyloList = List();
      userSylosList.forEach((element) {
        if(element.isCheck) {
          selectedSyloList.add(element);
        }
      });
      await callAddQcast(status);
    }
  }

  Future<List<String>> uploadQcastVideo(String mediaName) async {
    List<RecordFileItem> picked_images = state.widget.listRecordWithThumb;
    print(
        "RecordListFile" + state.widget.listRecordWithThumb.length.toString());
    List<String> uploadedImages = List();
    if (picked_images.length > 0) {
      int sizeOfMediaList = picked_images.length;
      for (int i = 0; i < sizeOfMediaList; i++) {
        //await interceptorApi.uploadGetMediaID(picked_images[i].file);
        String mediaUploaded = await interceptorApi.callUploadGetMediaID(
            picked_images[i].file,
            loaderLabel:
                "Uploading ${mediaName ?? ""} ${i + 1} / $sizeOfMediaList");
        print("Uploaded Media" + mediaUploaded);
        if (mediaUploaded != null) {
          uploadedImages.add(mediaUploaded);
        }
      }
    }
    return uploadedImages;
  }

  Future<String> uploadGeneratedThumbnail(File file) async {
    String uploadedThumbnail = await interceptorApi.callUploadGetMediaID(file,
        loaderLabel: "Uploading thumbnail", sync: true);
    //await interceptorApi.uploadGetMediaID(file);
    if (uploadedThumbnail != null) {
      return uploadedThumbnail;
    }
  }

  callAddQcast(String status) async {
    List<String> listOfVideo = await uploadQcastVideo("Video");
    if (listOfVideo != null) {
      String coverPhoto = await uploadGeneratedThumbnail(await getVideoThumbFile());
      if (coverPhoto != null) {
        String title = state.nameController.text;
        String category = state.themeModel.title;
        CreateQcastItem1 createQcastItem = CreateQcastItem1(
          title: title,
          category: category,
          previewVideoId: listOfVideo[previewVideoIndex],
          coverPhoto: coverPhoto,
          listOfVideo: listOfVideo.join(", "),
          status: status,
          description: state.descController.text.toString(),
          userId: appState.userItem.userId.toString(),
          sampleQuestion: reviewQuestionsList.join(", "),
          profileName: appState.myChannelProfileItem.profileName,
        );


        bool qcastCreated = await interceptorApi.callAddQcast(createQcastItem);
        print("adasdasdasd" + qcastCreated.toString());
        if (qcastCreated) {
          commonToast("Your qcast is being upload Succefully");
          goToSpecificTabOfHome(state.context, 0, 1);
        }
        else{
          goToSpecificTabOfHome(state.context, 0, 1);
        }
      }
    }
  }

  Future<File> getVideoThumbFile() async {
    if (thumbnailImage.path != null) {
      return thumbnailImage.path;
    } else {
      await saveByteFile(thumbnailByte);
      return thumbnailFile;
    }
  }

  changeSelectSyloItem(int index) {
    userSylosList[index].isCheck = !userSylosList[index].isCheck;
  }
}
