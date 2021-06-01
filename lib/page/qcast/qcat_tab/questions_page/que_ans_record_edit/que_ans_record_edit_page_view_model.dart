import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/draft_model.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/model/question_item.dart';
import 'package:testsylo/model/record_file_item.dart';
import 'package:testsylo/page/qcast/qcat_tab/discover_page/record_qcast_list/record_qcast_list_page.dart';
import 'package:testsylo/page/qcast/qcat_tab/questions_page/qcasts_page/qcasts_video_record_page/qcasts_video_record_page.dart';
import 'package:testsylo/page/sylo/open_message_page/edit_open_message_page/edit_open_message_page.dart';
import 'package:testsylo/util/navigate_effect.dart';
import 'package:testsylo/util/util.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:video_trimmer/video_trimmer.dart';
import '../../../../../app.dart';
import 'que_ans_record_edit_page.dart';

class QueAnsRecordEditPageViewModel {
  QueAnsRecordEditPageState state;
  List<RecordFileItem> listRecordWithThumb = List();
  List<File> listFrames = List();
  bool isLoad = true;
  Trimmer trimmer = Trimmer();
  File pathhhh;
  double startValue = 0.0;
  double endValue = 0.0;
  bool isPlaying = false;
  bool progressVisibility = false;

  QueAnsRecordEditPageViewModel(QueAnsRecordEditPageState state) {
    this.state = state;
    if (Platform.isAndroid) {
      compressVideo();
    }
    else {
      compressVideo();
    }
  }

    compressVideo() async {

      for (int i = 0; i < state.widget.listRecording.length; i++) {
        File file = state.widget.listRecording[i].file;

        MediaInfo mediaInfo = await VideoCompress.compressVideo(
          file.path,
          quality: VideoQuality.DefaultQuality,
          //quality: VideoQuality.DefaultQuality,
          deleteOrigin: true, // It's false by default
        );
        print("FilePath1"+file.path);
        state.widget.listRecording[i].file = mediaInfo.file;
        //listFrames = await recordFileItem.getAllThumb;
      }
      await getAllThumb();
    }
      getAllThumb() async {

        listRecordWithThumb = List();
        for (int i = 0; i < state.widget.listRecording.length; i++) {
          File file = state.widget.listRecording[i].file;
          int fileSizeInBytes = file.lengthSync();



          RecordFileItem recordFileItem = RecordFileItem(file, state.widget.listRecording[i].aspectRatio);
          pathhhh = await recordFileItem.videoThumb;
          recordFileItem.thumbPath = await pathhhh;
          listRecordWithThumb.add(recordFileItem);
          await trimmer.loadVideo(videoFile: file);
          //listFrames = await recordFileItem.getAllThumb;
        }
        Future.delayed(Duration(milliseconds: 300)).then((onValue) {
          state.setState(() {
            isLoad = false;
          });
        });
      }

  getAllThumb1() async {

    for (int i = 0; i < state.widget.listRecording.length; i++) {
      File file = state.widget.listRecording[i].file;
      int fileSizeInBytes = file.lengthSync();
      double fileSizeInKB = fileSizeInBytes / 1024; // KB
      double fileSizeInMB = fileSizeInKB / 1024; // MB


      RecordFileItem recordFileItem = RecordFileItem(file, state.widget.listRecording[i].aspectRatio);
      recordFileItem.file=file;

      if (Platform.isAndroid) {
        recordFileItem.thumbPath = await pathhhh;
      }
      else{
        //recordFileItem.thumbPath = await recordFileItem.videoThumb1;
        //recordFileItem.thumbPath=await _file;
        recordFileItem.thumbPath = await pathhhh;
        //recordFileItem.thumbPath = await pathhhh;

      }

      listRecordWithThumb[0]=recordFileItem;
      await trimmer.loadVideo(videoFile: file);

      //listFrames = await recordFileItem.getAllThumb;
    }
    /*Future.delayed(Duration(milliseconds: 300)).then((onValue) {
      state.setState(()  {
        isLoad = false;
      });
    });*/

    isLoad = false;
    if(!isLoad)
    {
      if (isPlaying) {
        bool playbackState = await trimmer.videPlaybackControl(
          startValue: startValue,
          endValue: endValue,
        );
        state.setState(() {
          isPlaying = playbackState;
        });
      }
      if (state.widget.from == "SinglePromptsPageState") {
        var result = await Navigator.push(
            state.context,
            NavigatePageRoute(
                state.context,
                EditOpenMessagePage(
                  listRecordWithThumb,
                  from: "edit",
                  myDraft: state.widget.m,
                )));
        if (result != null) {
          state.widget.isEdit = true;
          state.widget.m = result;
          print(state.widget.m.title);
        }
      } else if (state.widget.from == "OpenMessagePageState") {
        var result = await Navigator.push(
            state.context,
            NavigatePageRoute(
                state.context,
                EditOpenMessagePage(
                  listRecordWithThumb,
                  from: "edit",
                  myDraft: state.widget.m,
                )));
        if (result != null) {
          state.widget.isEdit = true;
          state.widget.m = result;
          print(state.widget.m.title);
        }
      } else {

        if(state.widget.from=="QcamPageState") {
          var result = await Navigator.push(
              state.context,
              NavigatePageRoute(
                  state.context,
                  QcastsVideoRecordPage(
                    listRecordWithThumb,
                    state.widget.listQuestion,
                    state.widget.cameraState,
                    from: "QcamPageState",
                    myDraft: state.widget.m,
                  )));
          if (result != null) {
            state.widget.isEdit = true;
            state.widget.m = result;
            print(state.widget.m.title);
          }
        }
        else{
          var result = await Navigator.push(
              state.context,
              NavigatePageRoute(
                  state.context,
                  QcastsVideoRecordPage(
                    listRecordWithThumb,
                    state.widget.listQuestion,
                    state.widget.cameraState,
                    from: "edit",
                    myDraft: state.widget.m,
                  )));
          if (result != null) {
            state.widget.isEdit = true;
            state.widget.m = result;
            print(state.widget.m.title);
          }
        }
      }
    }

  }



        getQuestionThumbIfQueListNotNull() async {
          if (state.widget.listQuestion != null) {
            for (int i = 0; i < state.widget.listQuestion.length; i++) {
              QuestionItem item = state.widget.listQuestion[i];
              Duration duration = videoPlayerController.value.position;
              if (item.start_time <= duration.inSeconds &&
                  item.end_time > duration.inSeconds) {
                return item;
              }
            }
            return null;
            /*List<QuestionItem> items = state.widget.listQuestion
          .where((i) => i.isBetTime(startValue))
          .toList();
      items.forEach((element) {
        print("que_link -> "+element.que_link);
      });*/
          }
          else {
            return null;
          }
        }

        saveAsDraft() async {
          Navigator.pop(state.context);
          PostPhotoModel postPhotoModel;
          if (listRecordWithThumb[0].link == null) {
            postPhotoModel =
                PostPhotoModel(image: listRecordWithThumb[0].file);
            if (state.widget.cameraState == CameraState.S) {
              postPhotoModel.isCircle = false;
            }
          } else {
            postPhotoModel =
                PostPhotoModel(link: listRecordWithThumb[0].link);
            if (state.widget.cameraState == CameraState.S) {
              postPhotoModel.isCircle = false;
            }
          }
          List<PostPhotoModel> photoList = [postPhotoModel];
          String mediaTypeName = isQuickPost &&
              appState.selectedDownloadedQcast != null ? "qcast" : "video";
          File thumbnailFile = await getVideoThumbFileFromRecordFileItem(
              state.context, listRecordWithThumb[0]);
          String strtDuration = mediaTypeName == "qcast"
              ? getTimeStringFromQcastQuestions(state.widget.listQuestion)
              : null;
          String coverPhoto;
          if (thumbnailFile != null) {
            print("File path -> " + thumbnailFile.path.toString());
            coverPhoto = thumbnailFile.path;
          }
          if (coverPhoto == null) {
            commonToast("Thumbnail doesn't generate to save");
            return;
          }
          String qcastQuestionList;
          if (mediaTypeName == "qcast") {
            List<String> queList = List();
            state.widget.listQuestion.forEach((element) {
              queList.add(element.que_link);
            });
            qcastQuestionList = queList.join(",");
          }
          List<String> mediaList = await savePhotoAsDraft(
              myDraft: MyDraft(
                coverPhoto: coverPhoto,
                mediaType: App.MediaTypeMap[mediaTypeName],
                qcastId: mediaTypeName == "qcast" ? appState
                    .selectedDownloadedQcast.qcastId : null,
                qcastCoverPhoto: mediaTypeName == "qcast" ? appState
                    .selectedDownloadedQcast.coverPhoto : null,
                qcastDuration: strtDuration,
                qcastQuestionList: qcastQuestionList,
              ),
              photoList: photoList
          );
          if (mediaList.length > 0) {
            commonToast("successfully saved as Draft");
            goToHome(state.context, null);
          }
        }

  Future<File> getVideoThumbFile() async {
    if(state.widget.listRecording?.length!=null){
      showLoader(state.context, label: "Generating Thumbnail");
      Uint8List byteArry = await generateThumbnailFromVideo(state.widget.listRecording[0].file);
      File file = await saveByteFile(byteArry);
      hideLoader();
      return file;
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

}
