import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
/*import 'package:camera_camera/page/bloc/bloc_camera.dart';*/
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:testsylo/bloc_item/forward_timer_bloc.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/model/record_file_with_ratio_item.dart';
import 'package:testsylo/page/qcast/qcat_tab/discover_page/record_qcast/record_qcast_page.dart';
import 'package:testsylo/util/util.dart';

import '../../../../../app.dart';
import '../../../../../common/common_widget.dart';
import '../../../../../common/play_video.dart';

class RecordQcastPageViewModel {
  RecordQcastPageState state;
  CameraController controller;
  List<CameraDescription> cameras;
  bool isPauseRecord = true;
  String videoSavePath = '';
  File thumbnailFile;
  Uint8List thumbnailByte;
  AnimationController textAnimOpacity;
  List<RecordFileWithRatioItem> listRecording = List();
  List<RecordFileWithRatioItem> listRecording1 = List();
  CameraState cameraState = CameraState.R;
  List<String> promptQuestionList;
  RecordQcastPageViewModel(RecordQcastPageState state) {
    this.state = state;

    promptQuestionList =
        getPromptsQuestionListFromPromptsList(state.widget.listPrompt);
    textAnimOpacity = AnimationController(
        vsync: state, duration: Duration(milliseconds: 800));
    initCam();
  }
 // var bloc = BlocCamera();

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
    /* if (cameras == null) {
      cameras = await availableCameras();
      cameras.forEach((f) {
        print(f.name);
        print(f.lensDirection);
      });
    }

    cameras = cameras.reversed.toList();

    CameraDescription description = cameras[0];*/

    /*if (bloc.controllCamera != null) {
      //controller.dispose();
    }*/
    /*controller = CameraController(description, ResolutionPreset.high);
    controller.initialize().then((_) {
      state.setState(() {});
    });*/

    /*bloc.getCameras();
    bloc.cameras.listen((data) {
      bloc.controllCamera = CameraController(
        data[1],
        ResolutionPreset.high,
      );
      bloc.cameraOn.sink.add(0);
      bloc.controllCamera.initialize().then((_) {
        bloc.selectCamera.sink.add(true);
        //if (widget.initialCamera == CameraSide.front) bloc.changeCamera();
        bloc.changeCamera();
        state.setState(() {});
      });
    });*/
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  goToNextPage(bool isStop, {bool isRecursive, bool isFromRecursive,bool isprompt}) async {
    // on 30 sec, on right tap, on pause
    if (isFromRecursive ?? false) {
    } else {
      if (videoSavePath.isEmpty) {
        commonMessage(state.context,
            "By recording your question you can able to move to next recording");
        return false;
      }
      //await bloc.controllCamera.pauseVideoRecording();
      print("goToNextPage -> ");
      print(videoSavePath);


      videoIndex++;
      var ii = listRecording1.length - 1;
      if (state.currentPage < promptQuestionList.length - 1) {
        state.currentPage++;
        state.pageController.animateToPage(state.currentPage,
            duration: Duration(milliseconds: 800), curve: Curves.ease);
      }
      if (state.timer != null) {
        state.timer.cancel();
      }

      videoSavePath = "";
      isPauseRecord = true;
    }
    //startIn = -1;
    if (isRecursive ?? false) {
      startIn = 5;
      state.setState(() {});
      callRecursiveNew();
      return;
    }


    if (!isStop) {
      playPauseVideo(true);
      //getVideoThumbFile(videoIndex);

      // take new
    } else {
      state.setState(() {});
    }


    state.start = -1;
    var path=await controller.stopVideoRecording();
    videoSavePath=await path.path;
    RecordFileWithRatioItem recordFileWithRatioItem = RecordFileWithRatioItem(
        File(videoSavePath), controller.value.aspectRatio);
    listRecording.add(recordFileWithRatioItem);
    listRecording1.add(recordFileWithRatioItem);


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
          appDocDirectory = await getTemporaryDirectory();
        }
        if (Platform.isAndroid) {
          await checkPermission();
          appDocDirectory = getDirPath();
          if (!appDocDirectory.existsSync()) {
            appDocDirectory.createSync();
          }
        }
        else{
          await checkPermission();
          appDocDirectory = await getTemporaryDirectory();
          if (!appDocDirectory.existsSync()) {
            appDocDirectory.createSync();
          }
        }
        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        videoSavePath = appDocDirectory.path +
            "/" +
            DateTime.now().millisecondsSinceEpoch.toString() +
            ".mp4";
        controller.addListener(() {
          print("addListener" + " Video:" + videoSavePath);
        });

        controller.startVideoRecording();
        if (is30SecTimer()) {
          state.startTimer(30);
        } else {
          startForwardTimer();
        }
      } else {
        // Restart
        state.unPauseTimer();
        //controller.resumeVideoRecording();
        print("Ansert" + videoIndex.toString());
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
        if (state.widget.callback == null) {
            Navigator.pop(state.context);
        }
        if (state.widget.from == "PostVideoPageState") {
          goToTrimVideo(state.context, state.widget.from, listRecording, null,
              cameraState);


        } else if (state.widget.from == "OpenMessagePageState") {
          goToTrimVideo(state.context, state.widget.from, listRecording, null,
              cameraState);


        } else {
          goToRecordVideoListDeletePage(state.context, state.widget.from,
              listRecording, state.widget.listPrompt, cameraState);

        }

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

  getVideoIndexLabel() {
    if (state.widget.callback != null) {
      return "Qcam";
    } else if (state.widget.from == "PostVideoPageState" ||
        state.widget.from == "OpenMessagePageState") {
      if (state.widget.from == "OpenMessagePageState") {
        return "Record Video";
      }
      if (state.widget.from == "PromptsPageState") {
        return "Record Video";
      }
      return "Record Video" + getSyloPostTitlesufix(appState.userSylo);
    }else if(state.widget.from == "ActiveSharedMeSyloPageState")
      {
        if(appState.sharedSyloItem.syloName!=null)
          {
            return "Record Video/ " + appState.sharedSyloItem.syloName;

          }
        else{

            return "Record Video";
        }
      }
    else if(state.widget.from == "MyChannelPageState")
    {

        return "Record Qcast";

    }
    else {
      int i = videoIndex + 1;
      return "Record Video"; /*[" + i.toString() + "]"*/
    }
  }

  bool isStart5SecTimer() {
    if (state.widget.from == "PostVideoPageState" ||
        state.widget.from == "OpenMessagePageState") {
      return false;
    }
    return true;
  }

  bool isRecNextQue() {
    if (videoSavePath.isEmpty) {
      return false;
    }
    if (state.widget.from == "PostVideoPageState" ||
        state.widget.from == "OpenMessagePageState") {
      return false;
    }

    return true;
  }

  bool is30SecTimer() {
    print("state.widget.from1 -> " + state.widget.from);
    if (state.widget.from == "MyChannelPageState") {
      return true;
    } else if (state.widget.from == "ActiveSharedMeSyloPageState") {
      return true;
    } else if (state.widget.from == "PostVideoPageState" ||
        state.widget.from == "OpenMessagePageState") {
      return false;
    }
    return false;
  }

  bool isForwardTimer() {
    if (state.widget.from == "PostVideoPageState" ||
        state.widget.from == "OpenMessagePageState") {
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

  void callback(Timer timer) {
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
    t = twoDigitMinutes +
        ":" +
        twoDigitSeconds;

    forwardTimerBloc.addTime(t);
  }

  void cancelVibrate() {}

  void vibrate() async {
    HapticFeedback.vibrate();
  }

  void pauseForwardTimer() {
    if (forwardTimer != null) forwardTimer.cancel();
  }

  ForwardTimerBloc forwardTimerBloc =
      ForwardTimerBloc(); // for both reverse and forward

  getCurrentDuration() {
    if (state.start == -1) {
      return "00:30";
    }
    if (state.start > 9) {
      return "00:" + state.start.toString();
    } else {
      return "00:0" + state.start.toString();
    }
  }

  Future<File> getVideoThumbFile(int index) async {
    if (listRecording1[0]?.file != null) {
      //showLoader(state.context, label: "Generating Thumbnail");
      Uint8List byteArry =
          await generateThumbnailFromVideo(listRecording1[index].file);
      File thumbnailFile1 = await saveByteFile(byteArry);

      //hideLoader();
      state.setState(() {
        thumbnailFile = thumbnailFile1;
      });
      print("ThumbPath:" +
          thumbnailFile.path +
          " ABCd:" +
          listRecording1[index].file.path);
      return thumbnailFile;
    }
    return null;
  }

  saveByteFile(unit8List) async {
    Directory appDocDirectory;
    appDocDirectory = await getTemporaryDirectory();
    String path = appDocDirectory.path +
        "/" +
        DateTime.now().millisecondsSinceEpoch.toString() +
        ".jpg";
    await writeToFile(unit8List, path);
    return File(path);
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
