import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:testsylo/bloc_item/forward_timer_bloc.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/question_item.dart';
import 'package:testsylo/model/record_file_with_ratio_item.dart';
import 'package:testsylo/page/qcast/qcat_tab/questions_page/que_ans_record/que_ans_record_page.dart';
import 'package:testsylo/page/qcast/qcat_tab/questions_page/que_ans_record_edit/que_ans_record_edit_page.dart';
import 'package:testsylo/util/navigate_effect.dart';

import '../../../../../app.dart';

class QueAnsRecordPageViewModel {
  QueAnsRecordPageState state;
  CameraController controller;
  List<CameraDescription> cameras;
  String videoSavePath = '';
  bool isRefresh = false;
  bool isAudio = false;
  AnimationController textAnimOpacity;
  //String startLabel = "Start";
  String startLabel = "";
  List<RecordFileWithRatioItem> listRecording = List();
  //var bloc = CameraBloc();

  QueAnsRecordPageViewModel(QueAnsRecordPageState state) {
    this.state = state;
    textAnimOpacity = AnimationController(
        vsync: state, duration: Duration(milliseconds: 700));
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
    await controller.initialize();
    await controller.initialize().then((_) {
      state.setState(() {

      });
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

    *//* if (cameras == null) {
      cameras = await availableCameras();
      cameras.forEach((f) {
        print(f.name);
        print(f.lensDirection);
      });
    }

    cameras = cameras.reversed.toList();

    CameraDescription description = cameras[0];*//*

    *//*if (bloc.controllCamera != null) {
      //controller.dispose();
    }
    *//**//*controller = CameraController(description, ResolutionPreset.high);
    controller.initialize().then((_) {
      state.setState(() {});
    });*//**//*

    bloc.getCameras();
    bloc.cameras.listen((data) {
      if (isAudio) {
        bloc.controllCamera = CameraController(
            data[1], ResolutionPreset.ultraHigh,
            enableAudio: false);

      } else {
        bloc.controllCamera = CameraController(
            data[1], ResolutionPreset.ultraHigh,
            enableAudio: false);

      }
      bloc.cameraOn.sink.add(0);
      bloc.controllCamera.initialize().then((_) {
        bloc.selectCamera.sink.add(true);
        bloc.changeCamera();

        //if (widget.initialCamera == CameraSide.front) bloc.changeCamera();
        state.setState(() {
          //bloc.controllCamera.enableAudio = true;
        });
      });
    });*//*
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }*/

  goToNextPage() async {
    print("goToNextPage -> ");
    print(videoSavePath);
    var path=await controller.stopVideoRecording();
    videoSavePath=await path.path;
    RecordFileWithRatioItem item = RecordFileWithRatioItem(
        File(videoSavePath), controller.value.aspectRatio);
    listRecording.add(item);

    videoSavePath = "";


    setEndTimeInQuestionItem();

    Navigator.pop(state.context);
    goToTrimVideo(state.context, state.widget.from, listRecording,
        state.widget.listQuestions, cameraState);

    //var result = await Navigator.push(state.context, NavigatePageRoute(state.context, QueAnsRecordEditPage(listRecording, state.widget.from)));

    return true;
  }

  playPauseVideo() async {
    if (videoSavePath.isEmpty) {
      // start

      Directory appDocDirectory;
      if (Platform.isIOS) {
        appDocDirectory = await getTemporaryDirectory();
      } else {
        appDocDirectory = await getTemporaryDirectory();
      }
      // can add extension like ".mp4" ".wav" ".m4a" ".aac"
      videoSavePath = appDocDirectory.path +
          "/" +
          DateTime.now().millisecondsSinceEpoch.toString() +
          ".mp4";

      controller.addListener(() {
        print("addListener");
      });

      videoIndex = 0;

      controller.startVideoRecording();

      startForwardTimer();
      state.setState(() {});
    } else {
      // Restart
      controller.resumeVideoRecording();
      goToNextPage();
      forwardTimer.cancel();
    }
  }

  int videoIndex = -1;

  getVideoIndexLabel() {
    if (videoIndex == -1) return "Tap Below To Start Interview";
    int i = videoIndex + 1;
    return "Question " +
        i.toString() +
        "/" +
        state.widget.listQuestions.length.toString();
  }

  loadNewQue() async {
    state.seekBloc.addProgress(0.0);
    state.setState(() {
      isRefresh = true;
      isAudio = false;
    });
    await controller.pauseVideoRecording();
    await Future.delayed(Duration(milliseconds: 100));
    setEndTimeInQuestionItem();
    state.setState(() {
      isRefresh = false;
      videoIndex++;
    });
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

    var minutes = int.parse(twoDigitMinutes);
    var seconds = int.parse(twoDigitSeconds);

    t = twoDigitMinutes + ":" + twoDigitSeconds;


    if (minutes > 10) {
      commonToast("You can not add video more than 10 minutes");
      //controller.pauseVideoRecording();
      pauseForwardTimer();
    } else {
      forwardTimerBloc.addTime(t);
    }
  }

  void cancelVibrate() {}

  void vibrate() async {
    HapticFeedback.vibrate();
  }

  void pauseForwardTimer() {
    if (forwardTimer != null) forwardTimer.cancel();
  }

  ForwardTimerBloc forwardTimerBloc = ForwardTimerBloc();

  int start_time = 0;
  setEndTimeInQuestionItem() {
    QuestionItem item = state.widget.listQuestions[videoIndex];
    item.start_time = start_time;
    item.end_time = forwardStart;
    state.widget.listQuestions[videoIndex] = item;
    start_time = forwardStart;
    print("End Time:" + item.end_time.toString());
  }

  CameraState cameraState = CameraState.R;

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
