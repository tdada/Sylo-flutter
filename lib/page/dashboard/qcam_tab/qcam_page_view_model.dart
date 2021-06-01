import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:testsylo/bloc_item/forward_timer_bloc.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/api_request.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/model/record_file_with_ratio_item.dart';
import 'package:testsylo/page/dashboard/qcam_tab/qcam_page.dart';
import 'package:testsylo/page/post_media/post_photo/review_photo_post_page/review_photo_post_page.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';
import 'package:testsylo/util/navigate_effect.dart';
import 'package:testsylo/util/util.dart';
import '../../../app.dart';


class QcamPageViewModel {
  QcamPageState state;
  CameraController controller;
  List<CameraDescription> cameras;
  bool isPauseRecord = true;
  String videoSavePath = '';
  AnimationController textAnimOpacity;
  List<RecordFileWithRatioItem> listRecording = List();
  CameraState cameraState = CameraState.R;
    List<String> promptQuestionList = List();
  InterceptorApi interceptorApi;
  void Function(String value) onPath;
  QcamPageViewModel(QcamPageState state) {
    interceptorApi = InterceptorApi(context: state.context);
    this.state = state;
    textAnimOpacity = AnimationController(
        vsync: state, duration: Duration(milliseconds: 800));
    initCam();
  }

  initCam() async {
    if (videoSavePath.isNotEmpty) {
      commonMessage(
          state.context, "Can not change camera once recording initiate.");
      return;
    }

    if (cameras == null) {
      cameras = await availableCameras();
      cameras.forEach((f) {
        print(f.name);
        print(f.lensDirection);
      });
    }

    cameras = cameras.reversed.toList();

    CameraDescription description = cameras[0];

    if (controller != null) {
      controller.dispose();
    }
    controller = CameraController(description, ResolutionPreset.high);
    controller.initialize().then((_) {
      state.setState(() {});
    });

    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }
  /*initCam() async {

    if (videoSavePath.isNotEmpty) {
      commonMessage(
          state.context, "Can not change camera once recording initiate.");
      return;
    }



    if (controller != null) {

    }

    bloc.cameras.listen((data) {
      bloc.controllCamera = CameraController(
        data[0],
        ResolutionPreset.high,
      );
      bloc.cameraOn.sink.add(0);
      bloc.controllCamera.initialize().then((_) {
        bloc.selectCamera.sink.add(true);
        bloc.changeCamera();

        state.setState(() {});

      });
    });

    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }*/

  goToNextPage(bool isStop, {bool isRecursive, bool isFromRecursive}) async {
    // on 30 sec, on right tap, on pause
    if(isFromRecursive??false){

    }
    else{
      if (videoSavePath.isEmpty) {
        commonMessage(state.context,
            "By recording your question you can able to move to next recording");
        return false;
      }
      await controller.pauseVideoRecording();
      print("goToNextPage -> ");
      print(videoSavePath);

      videoIndex++;
      if(state.currentPage < promptQuestionList.length-1) {
        state.currentPage++;
        state.pageController.animateToPage(state.currentPage,
            duration: Duration(milliseconds: 800),
            curve: Curves.ease);
      }
      if (state.timer != null) {
        state.timer.cancel();
      }
      videoSavePath = "";
      isPauseRecord = true;
    }
    if(isRecursive??false){
      startIn = 5;
      state.setState(() {
      });
      callRecursiveNew();
      return;
    }
    //startIn = -1;
    state.start = -1;
    var path=await controller.stopVideoRecording();
    videoSavePath = await path.path;
    RecordFileWithRatioItem recordFileWithRatioItem = RecordFileWithRatioItem(File(videoSavePath), controller.value.aspectRatio);
    listRecording.add(recordFileWithRatioItem);
    print("VideoSavePath"+videoSavePath);
    if (!isStop) {
      playPauseVideo(true); // take new
    } else {
      state.setState(() {});
    }

    /*await showDialog(
      context: state.context,
      builder: (_) => PlayVideoPage(
        url: "" + videoSavePath,
        isFile: true,
      ),
    );*/

    return true;
  }

  goToNextPage1(bool isStop, {bool isRecursive, bool isFromRecursive,bool isprompt}) async {
    // on 30 sec, on right tap, on pause
    if (isFromRecursive ?? false) {} else {
      /*if (videoSavePath.isEmpty) {
        commonMessage(state.context,
            "By recording your question you can able to move to next recording");
        return false;
      }
      //await bloc.controllCamera.pauseVideoRecording();
      print("goToNextPage -> ");
      print(videoSavePath);


      videoIndex++;
      var ii = listRecording1.length - 1;*/
      if (state.currentPage < promptQuestionList.length - 1) {
        state.currentPage++;
        state.pageController.animateToPage(state.currentPage,
            duration: Duration(milliseconds: 800), curve: Curves.ease);
      }
      if (state.timer != null) {
        state.timer.cancel();
      }


      /*await showDialog(
      context: state.context,
      builder: (_) => PlayVideoPage(
        url: "" + videoSavePath,
        isFile: true,
      ),
    );*/

      return true;
    }
  }



  int startIn = -1;
  String startLabel = "";

  callRecursive() async {
    if (!isStart5SecTimer()) {
      startIn = 0;
      //startLabel = "Start";
      startLabel = "";
      //await Future.delayed(Duration(milliseconds: 700));
      startLabel = "";
      playPauseVideo(false);
      return;
    }
    Future.delayed(Duration(seconds: 1)).then((onValue) {
      startIn--;
      if (startIn == 0) {
        playPauseVideo(false);
      } else {
        state.setState(() {});
        callRecursive();
      }
    });
  }

  callRecursiveNew() async {
    Future.delayed(Duration(seconds: 1)).then((onValue) {
      startIn--;
      if (startIn == 0) {
        //playPauseVideo(false);
        goToNextPage(false, isFromRecursive: true);
      } else {
        state.setState(() {});
        callRecursiveNew();
      }
    });
  }


  playPauseVideo(bool isStartNew) async {
    if (isPauseRecord) {
      if (videoSavePath.isEmpty) {
        // start

        Directory appDocDirectory;
        if (Platform.isIOS) {
          appDocDirectory = await getTemporaryDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }
        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        videoSavePath = appDocDirectory.path +
            "/" +
            DateTime.now().millisecondsSinceEpoch.toString() +
            ".mp4";



        controller.addListener(() { });

        //bloc.controllCamera.startVideoRecording(videoSavePath);
        controller.startVideoRecording();
        if (is30SecTimer()) {
          state.startTimer(30);
        }
        else{

          startForwardTimer();
        }
      } else {
        // Restart
        state.unPauseTimer();
        controller.resumeVideoRecording();
      }

      state.setState(() {
        isPauseRecord = false;
      });
    } else {
      // Pause
      state.setState(() {
        state.pauseTimer();
        isPauseRecord = true;
      });

      bool isNxt = await goToNextPage(true);
      if (isNxt) {
        if(state.widget.callback==null){
          Navigator.pop(state.context);
        }
        if(isCreateQcast){
          state.seekBloc.addProgress(0.0);
          goToRecordVideoListDeletePage(
              state.context, state.widget.from, listRecording, null, cameraState);
        }
        else if(currentView=="video"){
          goToTrimVideo(state.context, "QcamPageState", listRecording, null, cameraState);
          forwardStart = 0;
          forwardTimer.cancel();
          state.setState(() { });
        }
        else if (state.widget.from == "PostVideoPageState") {
          await goToTrimVideo(state.context, state.widget.from, listRecording, null, cameraState);
        } else if (state.widget.from == "OpenMessagePageState"){
          await goToTrimVideo(state.context, state.widget.from, listRecording, null, cameraState);
        }else {
          forwardStart = 0;
          forwardTimer.cancel();
          await goToRecordVideoListDeletePage(
              state.context, state.widget.from, listRecording, state.widget.listPrompt, cameraState);
        }
        listRecording = List();
        isStart = false;
        videoIndex = 0;
        /*var result = await Navigator.push(
                                            context,
                                            NavigatePageRoute(
                                                context,
                                                RecordQcastListPage(
                                                    model.listRecording)));*/
      }
    }
  }

  int videoIndex = 0;

  String currentView = "video"; // video, photo, qcam
  bool isStart = false;
  getVideoIndexLabel() {
    if(currentView=="video"){
      return "Record Video";
    }
    if(currentView=="photo"){
      return "Capture Photo";
    }
    if(state.widget.callback!=null){
      int i = videoIndex + 1;
      return "Qcam" /*[" + i.toString() + "]"*/;
    }
    else if (state.widget.from == "PostVideoPageState" || state.widget.from == "OpenMessagePageState") {
      return "Record Video";
    } else {
      int i = videoIndex + 1;
      return "Record Qcast" /*[" + i.toString() + "]"*/;
    }
  }

  bool isStart5SecTimer() {
    if(currentView=="video"||currentView=="photo"){
      return false;
    }
    if (state.widget.from == "PostVideoPageState" || state.widget.from == "OpenMessagePageState") {
      return false;
    }
    return true;
  }

  bool isRecNextQue() {
    if (videoSavePath.isEmpty) {
      return false;
    }
    if(isCreateQcast)return true;
    if(currentView=="video"||currentView=="photo"){
      return false;
    }
    if (state.widget.from == "PostVideoPageState" || state.widget.from == "OpenMessagePageState") {
      return false;
    }

    return true;
  }

  bool is30SecTimer(){
    print("state.widget.from1 -> "+state.widget.from);
    if(isCreateQcast)return true;
    if(state.widget.from=="MyChannelPageState"){
      return true;
    }
    else if(state.widget.from == "PostVideoPageState" || state.widget.from == "OpenMessagePageState"){
      return false;
    }
    return false;
  }

  bool isForwardTimer() {
    if (state.widget.from == "PostVideoPageState" || state.widget.from == "OpenMessagePageState") {
      return true;
    }
    return false;
  }

  Timer forwardTimer;
  int forwardStart = 0;

  void startForwardTimer() {

    if (forwardTimer != null) {
      forwardTimer.cancel();
      cancelVibrate();
    }

    const oneSec = const Duration(seconds: 1);

    print("startForwardTimer");
    forwardTimer = new Timer.periodic(
      oneSec,
      callback,

    );

  }

  void callback(Timer timer){
    print("callback");

    print("forwardTimer call");
    forwardStart = forwardStart + 1;
    String t = "";

    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    Duration duration = Duration(seconds: forwardStart);
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    t =  twoDigitMinutes +":"+ twoDigitSeconds;

    forwardTimerBloc.addTime(t);
  }

  void cancelVibrate() {

  }

  void vibrate() async {
    HapticFeedback.vibrate();

  }

  void pauseForwardTimer() {
    if (forwardTimer != null) forwardTimer.cancel();
  }

  ForwardTimerBloc forwardTimerBloc = ForwardTimerBloc(); // for both reverse and forward

  getCurrentDuration() {
    if (state.start == -1) {
      return "0"
          "0:30";
    }
    if (state.start > 9) {
      return "00:" + state.start.toString();
    } else {
      return "00:0" + state.start.toString();
    }
  }

  List<PostPhotoModel> listTakedImages = List();
  String pictureSavePath = '';
  List<File> capturePicPath = List<File>();
  takePicture() async {
    try {
      Directory appDocDirectory;
      if (Platform.isIOS) {
        appDocDirectory = await getTemporaryDirectory();
      } else {
        appDocDirectory = await getExternalStorageDirectory();
      }
      // can add extension like ".mp4" ".wav" ".m4a" ".aac"
      pictureSavePath = appDocDirectory.path +
          "/" +
          DateTime.now().millisecondsSinceEpoch.toString() +
          ".png";

      var path=await controller.takePicture();
      pictureSavePath=await path.path;
      //print("Take a pic Path >> $path"+path.path);
      File _image = await FlutterExifRotation.rotateImage(path: pictureSavePath);
      capturePicPath.add(_image);
      listTakedImages.add(PostPhotoModel(image: _image, isCircle: cameraState == CameraState.R));
      state.setState(() {});
      if (capturePicPath.length >= 4) {
        for (var i = 0; i <
            capturePicPath.length; i++) {

          if(listTakedImages[i].isCircle)
          {
            File croppedFile=await ImageCropper.cropImage(
                sourcePath: capturePicPath[i].path,
                aspectRatioPresets: [
                  CropAspectRatioPreset.square,

                ],
                cropStyle: CropStyle.circle,
                androidUiSettings: AndroidUiSettings(
                  toolbarTitle: 'Edit Image',
                  toolbarColor: colorDark,
                  toolbarWidgetColor: Colors.white,
                  initAspectRatio: CropAspectRatioPreset
                      .square,
                  lockAspectRatio: false,

                ),
                iosUiSettings: IOSUiSettings(
                  title: "Edit Image",
                  minimumAspectRatio: 1.0,
                )
            );/*.then((value) =>
            capturePicPath[i] = value);*/
            listTakedImages[i].image=croppedFile;
            capturePicPath[i]=croppedFile;
          }
          else{
            File croppedFile=await ImageCropper.cropImage(
                sourcePath: capturePicPath[i].path,
                aspectRatioPresets: [
                  CropAspectRatioPreset.square,
                  CropAspectRatioPreset.ratio3x2,
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.ratio4x3,
                  CropAspectRatioPreset.ratio16x9
                ],
                cropStyle: CropStyle.rectangle,
                androidUiSettings: AndroidUiSettings(
                    toolbarTitle: 'Edit Image',
                    toolbarColor: colorDark,
                    toolbarWidgetColor: Colors.white,
                    initAspectRatio: CropAspectRatioPreset
                        .original,
                    lockAspectRatio: false),
                iosUiSettings: IOSUiSettings(
                  title: "Edit Image",
                  minimumAspectRatio: 1.0,
                )
            );/*.then((value) =>
            capturePicPath[i] = value);*/
            listTakedImages[i].image=croppedFile;
            capturePicPath[i]=croppedFile;
          }
        }
        await gotoPhotoReviewPageProcess();
      }
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
  }

  gotoPhotoReviewPageProcess() async {
    List<PostPhotoModel> photoList = List();
    photoList.addAll(listTakedImages);

    await Navigator.push(
        state.context,
        NavigatePageRoute(
            state.context, ReviewPhotoPostPage(pickedImages: photoList,from:"QcamPageState")));
    listTakedImages = List();
    capturePicPath = List();
    isStart = false;
  }

  bool isCreateQcast = false;
  bool isQcam = false;
  bool isBlack = false;

  Future<bool> getMyChannel() async {
    if (appState.myChannelProfileItem == null) {
      MyChannelProfileItem myChannelProfileItem = await interceptorApi.callGetMyChannelProfile(appState.userItem.userId.toString(), appState.userItem.userId.toString());
      if(myChannelProfileItem!=null) {
        appState.myChannelProfileItem =  myChannelProfileItem;
        state.setState(() {
        });
      }
    }
    return appState.myChannelProfileItem == null ? false : true;
  }

  onCameraSwitch() async {
    final CameraDescription cameraDescription =
    (controller.description == cameras[0]) ? cameras[1] : cameras[0];
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(cameraDescription, ResolutionPreset.max);
    controller.addListener(() {
      if (state.mounted) state.setState(() {});
      if (controller.value.hasError) {
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
    }

    if (state.mounted) {
      state.setState(() {});
    }
  }
}

