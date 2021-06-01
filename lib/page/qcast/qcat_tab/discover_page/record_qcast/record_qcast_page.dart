import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:testsylo/bloc_item/seek_bloc.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/common/zoomable_widget.dart';
import 'package:testsylo/model/prompt_item.dart';
import 'package:testsylo/page/dashboard/dashboard_page.dart';
import 'package:testsylo/page/dashboard/qcam_tab/qcam_page.dart';
import 'package:testsylo/page/qcast/qcat_tab/discover_page/record_qcast/record_qcast_page_view_model.dart';
import 'package:testsylo/page/qcast/qcat_tab/questions_page/questions_page.dart';
import 'package:vibration/vibration.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as Format;

import '../../../../../app.dart';
import '../../../../../util/navigate_effect.dart';

class RecordQcastPage extends StatefulWidget {
  String from;
  List<PromptItem> listPrompt = List();
  void Function() callback;

  RecordQcastPage(this.from, this.listPrompt, this.callback);

  @override
  RecordQcastPageState createState() => RecordQcastPageState();
}

class RecordQcastPageState extends State<RecordQcastPage>
    with TickerProviderStateMixin {
  RecordQcastPageViewModel model;
  int currentPage;
  PageController pageController;

  void _changeCamera() async {
    await model.onCameraSwitch();
  }

  @override
  void initState() {
    super.initState();
    currentPage = 0;
    pageController = PageController(initialPage: currentPage, keepPage: false);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
    //model.bloc.dispose();
    if (timer != null) {
      timer.cancel();
    }
    if (model.forwardTimer != null) {
      model.forwardTimer.cancel();
    }
    model.controller.dispose();
    model.textAnimOpacity.dispose();
  }

  bool isShowBottomView = false;

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    print("widget.from -> " + widget.from.toString());

    model ?? (model = RecordQcastPageViewModel(this));
    double w = MediaQuery.of(context).size.width;

    return NativeDeviceOrientationReader(
        useSensor: true,
        builder: (context) {
          NativeDeviceOrientation orientation =
              NativeDeviceOrientationReader.orientation(context);
          return Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Stack(
                children: <Widget>[
                  str_cam == "full default"
                      ? getCamViewByStateNew(w)
                      : Container(),
                  Column(
                    children: <Widget>[
                      /*model.bloc.cameras == null
                          ? Expanded(
                              child: Container(),
                            )
                          :*/ Expanded(
                              child: Container(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    str_cam == "full default"
                                        ? Container()
                                        : getCamViewByStateNew(w),
                                    model.videoSavePath.isNotEmpty ||
                                            widget.from ==
                                                "MyChannelPageState" ||
                                            widget.from ==
                                                "ActiveSharedMeSyloPageState" ||
                                            widget.from == "PromptsPageState" ||
                                            widget.from ==
                                                "OpenMessagePageState"
                                        ? Container()
                                        : Positioned(
                                      bottom: 8,
                                            child: Container(

                                            child: InkWell(
                                            child: Image.asset(
                                              model.cameraState ==
                                                      CameraState.R
                                                  ? App.ic_sq
                                                  : App.ic_round_record,
                                              width: 42,
                                              height: 42,
                                            ),
                                            onTap: () {
                                              setState(() {
                                                if (model.cameraState ==
                                                    CameraState.R) {
                                                  model.cameraState =
                                                      CameraState.S;
                                                } else {
                                                  model.cameraState =
                                                      CameraState.R;
                                                }
                                              });
                                            },
                                                ),
                                          ),
                                        )
                                  ],
                                ),
                              ),
                            ),
                      /*Row(children: [
                        for(int i=0;i<5;i++)
                          Text("ABCDE",
                              style: TextStyle(
                                  color: Colors
                                      .green))

                      ],),*/
                      widget.from == "MyChannelPageState" ||
                              widget.from == "ActiveSharedMeSyloPageState"
                          ? Container(
                              padding: EdgeInsets.only(left: 20, top: 50),
                              width: 500,
                              height: 120,
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: model.listRecording.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text(
                                            "${index + 1}",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : Container(),
                      Container(
                        height: 140,
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Positioned(
                              bottom: 8,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Stack(
                                  children: <Widget>[
                                    !model.isRecNextQue()
                                        ? Container(
                                            width: 29,
                                            height: 4,
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 80.0, top: 4),
                                                child: InkWell(
                                                  onTap: () {
                                                    print(":::::::"+widget.from.toString());
                                                    //model.goToNextPage(false);
                                                    if(widget.from=="PromptsPageState") {
                                                      print(":::::::"+model.promptQuestionList.length.toString()+":::::::"+currentPage.toString());
                                                      if (model.promptQuestionList.length ==
                                                          currentPage+1) {
                                                        commonToast(
                                                            "You have finished all prompts");
                                                      }
                                                      else {
                                                        model.goToNextPage1(
                                                            false,
                                                            );
                                                      }
                                                    }
                                                    else{
                                                      if (model.listRecording.length > 10) {
                                                        //model.bloc.controllCamera.resumeVideoRecording();
                                                        commonToast(
                                                            "You can not add more than 12 Questions");
                                                        pauseTimer();
                                                        setState(() {
                                                          model.isPauseRecord =
                                                          true;
                                                        });
                                                      } else {



                                                        if (model.videoSavePath
                                                            .isEmpty) {
                                                          commonMessage(context,
                                                              "By recording your question you can able to move to next recording");
                                                          return;
                                                        }
                                                        //start = -1;

                                                          model.goToNextPage(false,
                                                              isRecursive: true);


                                                      }
                                                    }

                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        left: 10,
                                                        right: 10,
                                                        top: 10,
                                                        bottom: 10),
                                                    decoration: BoxDecoration(
                                                        color: colorDisable,
                                                        border: Border.all(
                                                            color:
                                                                colorDisable),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Row(
                                                      children: <Widget>[
                                                        /*Text(
                                                          "Next Question",
                                                          style: getTextStyle(
                                                              color: Colors.white,
                                                              fontWeight:
                                                                  FontWeight.w800,
                                                              size: 14),
                                                        ),
                                                        SizedBox(
                                                          width: 8,
                                                        ),*/
                                                        Container(
                                                          child: Image.asset(
                                                            App.ic_right,
                                                            color:
                                                                colorOvalBorder2,
                                                          ),
                                                          width: 24,
                                                          height: 24,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            /*widget.from == "MyChannelPageState" ||
                                                widget.from == "ActiveSharedMeSyloPageState"?
                                            Container(
                                              width: 100,
                                              height: 20,
                                              padding: EdgeInsets.only(
                                                  left: 30, bottom: 6),
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    "Qcast",
                                                    style: getTextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        size: 14),
                                                  ),
                                                ],
                                              ),
                                            ):Container(),*/
                                            InkWell(
                                              onTap: () async {
                                                if (model.startIn == -1) {
                                                  setState(() {
                                                    model.textAnimOpacity
                                                        .forward();
                                                    model.startIn = 5;
                                                  });
                                                  model.callRecursive();
                                                } else {
                                                  model.playPauseVideo(false);
                                                }

                                                // model.controller.startVideoRecording(filePath);
                                              },
                                              child: Container(
                                                width: 56,
                                                height: 56,
                                                child: Image.asset(
                                                  model.isPauseRecord
                                                      ? App.ic_play
                                                      : App.ic_pause,
                                                ),
                                              ),
                                            ),
                                            Container(
                                                margin: EdgeInsets.only(top: 8),
                                                child: !model.is30SecTimer()
                                                    ? StreamBuilder<String>(
                                                        stream: model
                                                            .forwardTimerBloc
                                                            .controller,
                                                        builder: (context,
                                                            snapshot) {
                                                          return RichText(
                                                            textAlign: TextAlign
                                                                .center,
                                                            text: TextSpan(
                                                              text: "• ",
                                                              style:
                                                                  getTextStyle(
                                                                color: Color(
                                                                    0x00ffFFA694),
                                                                size: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                              children: <
                                                                  TextSpan>[
                                                                TextSpan(
                                                                    text: snapshot.data ==
                                                                            null
                                                                        ? "00:00"
                                                                        : snapshot
                                                                            .data,
                                                                    style: getTextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        size:
                                                                            24,
                                                                        fontWeight:
                                                                            FontWeight.w500)),
                                                              ],
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                          );
                                                        })
                                                    : StreamBuilder<String>(
                                                        stream: model
                                                            .forwardTimerBloc
                                                            .controller,
                                                        builder: (context,
                                                            snapshot) {
                                                          return RichText(
                                                            textAlign: TextAlign
                                                                .center,
                                                            text: TextSpan(
                                                              text: "• ",
                                                              style:
                                                                  getTextStyle(
                                                                color: Color(
                                                                    0x00ffFFA694),
                                                                size: 24,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                              children: <
                                                                  TextSpan>[
                                                                TextSpan(
                                                                    text: snapshot.data ==
                                                                            null
                                                                        ? "00:30"
                                                                        : snapshot
                                                                            .data,
                                                                    style: getTextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        size:
                                                                            24,
                                                                        fontWeight:
                                                                            FontWeight.w500)),
                                                              ],
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                          );
                                                        })),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            (model.listRecording.length > 0 ||
                                    model.videoSavePath.isNotEmpty)
                                ? Container()
                                : Positioned(
                                    bottom: 45,
                                    right: 8,
                                    child: InkWell(
                                      onTap: () {
                                        //model.initCam();
                                        _changeCamera();
                                      },
                                      child: Container(
                                        child: Image.asset(
                                          App.ic_change_cam,
                                        ),
                                        width: 36,
                                        height: 22,
                                        margin: EdgeInsets.only(top: 8),
                                      ),
                                    ),
                                  ),
                            model.startIn > 0
                                ? AbsorbPointer(
                                    child: Container(
                                      alignment: Alignment.center,
                                      color: Colors.transparent,
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      )
                    ],
                  ),
                  widget.listPrompt == null
                      ? Container()
                      : Container(
                          alignment: Alignment.topCenter,
                          margin: EdgeInsets.only(top: 60),
                          height: 60,
                          child: PageView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            onPageChanged: (index) {
                              setState(() {
                                currentPage = index;
                              });
                            },
                            controller: pageController,
                            itemCount: model.promptQuestionList?.length ?? 0,
                            itemBuilder: (c, i) {
                              String item = model.promptQuestionList[i];
                              return Container(
                                child: Center(
                                    child: Text(
                                  item,
                                  style: getTextStyle(
                                      color: Colors.white, size: 18),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                )),
                                padding: EdgeInsets.only(left: 16),
                              );
                            },
                          ),
                        ),
                  widget.callback != null
                      ? Container()
                      : InkWell(
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 8, right: 8, top: 12, bottom: 8),
                            child: Image.asset(
                              App.ic_back_white,
                              fit: BoxFit.contain,
                              width: 16,
                              height: 16,
                            ),
                          ),
                          onTap: () {
                           /* if(widget.from.toString()=="MyChannelPageState")
                            {
                              goToHome(context,widget.from);
                              //QcamPage(runtimeType.toString(), List(), null);

                            }
                            else{*/
                            Navigator.pop(context);
                            /*}*/
                          },
                        ),
                  widget.callback == null
                      ? Container()
                      : Positioned(
                          bottom: 74,
                          left: 8,
                          child: InkWell(
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 8, right: 8, top: 12, bottom: 8),
                              child: RotatedBox(
                                quarterTurns: !isShowBottomView ? 135 : 45,
                                child: Image.asset(
                                  App.ic_back_white,
                                  fit: BoxFit.contain,
                                  width: 16,
                                  height: 16,
                                ),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                isShowBottomView = !isShowBottomView;
                              });
                              widget.callback.call();
                            },
                          ),
                        ),
                  /*Positioned(
                    right: 0,
                    top: 8,
                    child: Container(
                      margin: EdgeInsets.only(right: 16),
                      child: InkWell(
                        onTap: () async {
                          if (widget.from == "DashBoardPageState") {
                            var result = await Navigator.push(
                                context,
                                NavigatePageRoute(context,
                                    QuestionsPage(runtimeType.toString())));
                            if (result != null) {
                              setState(() {
                                widget.listPrompt = result;
                              });
                            }
                          } else {
                            goToRecordQCamPage(
                                context, runtimeType.toString(), null);
                          }
                        },
                        child: Image.asset(
                          App.ic_q_white,
                        ),
                      ),
                      width: 32,
                      height: 32,
                    ),
                  ),*/

                  Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.only(top: 12),
                    child: Text(
                      model.getVideoIndexLabel(),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 15),
                    ),
                  ),

                  /*Positioned(
                    right: 16,
                    top: 16,
                    child: InkWell(
                      onTap: (){

                        if(str_cam=="full default"){
                          str_cam = "small default";
                        }

                        else if(str_cam=="small default"){
                          str_cam = "full default";
                        }

                        setState(() {

                        });

                      },
                      child: Container(
                        alignment: Alignment.topRight,
                        width: 75,
                        height: 45,
                        color: Colors.green,
                        child: Center(
                          child: Text(
                            str_cam,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                  ),*/
                ],
              ),
            ),
          );
        });
  }

  // Time machine

  Timer timer;
  int start = -1;
  bool _vibrationActive = false;

  void startTimer(int timerDuration) {
    if (timer != null) {
      timer.cancel();
      cancelVibrate();
    }
    setState(() {
      start = timerDuration;
    });
    const oneSec = const Duration(seconds: 1);
    print('test');

    timer = new Timer.periodic(
      oneSec,
      callbackRevTimer,
    );
  }

  void callbackRevTimer(Timer timer) {
    if (start < 1) {
      timer.cancel();
      vibrate();
      model.goToNextPage(false,isRecursive: true);
    } else {
      start = start - 1;
    }

    String t = model.getCurrentDuration();
    model.forwardTimerBloc.addTime(t);
    double progressMod = getCamRecordSeekProgress();

    seekBloc.addProgress(progressMod);
  }

  void cancelVibrate() {
    _vibrationActive = false;
    //Vibration.cancel();
  }

  void vibrate() async {
    HapticFeedback.vibrate();
    return;
    _vibrationActive = true;
    if (await Vibration.hasVibrator()) {
      while (_vibrationActive) {
        Vibration.vibrate(duration: 1000);
        await Future.delayed(Duration(seconds: 2));
      }
    }
  }

  void pauseTimer() {
    if (timer != null) timer.cancel();
  }

  void unPauseTimer() => {
        startTimer(start),
      };

  getCamRecordSeekProgress() {
    if (start > 0) {
      double progressMod = start / 30;
      return 1 - progressMod;
    } else {
      return 0.0;
    }
  }

  SeekBloc seekBloc = SeekBloc();

  getCamViewByState(w) {
    if (model.cameraState == CameraState.R) {
      return Stack(
        children: <Widget>[
          ClipRRect(
            child: Container(
              color: colorOvalBorder,
              width: w - 19,
              height: w - 19,
              //padding: EdgeInsets.all(5),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  AspectRatio(
                    child: ClipOval(
                      //child: CameraPreview(/*model.bloc.controllCamera*/),
                      child: Container(),
                    ),
                    aspectRatio: 1.0,
                  ),
                  //CameraPreview(model.controller),
                ],
              ),
            ),
            borderRadius: BorderRadius.circular(w),
          ),
          StreamBuilder<double>(
              stream: seekBloc.controller,
              builder: (context, snapshot) {
                return commonRecordCamDurationIndicator(
                    snapshot.data == null ? 0.0 : snapshot.data, w, 3.0);
              }),
        ],
      );
    } else {
      return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          AspectRatio(
            child: /*CameraPreview(model.bloc.controllCamera)*/Container(),
            aspectRatio: 1.0,
          ),
        ],
      );
    }
  }

  String str_cam = "full default";

  getCamViewByStateNew(w) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    print("devicePixelRatio -> " +
        MediaQuery.of(context).devicePixelRatio.toString());
    /*if (model.bloc.cameras == null) {
      return Container();
    }*/
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(

            child: /*Builder(
                builder: (context) {*/

                      /* previewRatio = model.bloc
                          .controllCamera.value.aspectRatio;
                      print("previewRatio" +
                          previewRatio.toString());*/

                      /*if (str_cam == "small default") {*/
                      /*  return AspectRatio(
                            aspectRatio: model.controller.value.aspectRatio,
                          child: OverflowBox(
                            child: CameraPreview(model.controller),
                          ),
                        );
                      } else if (str_cam == "full default") {

                        return */OverflowBox(
                          child: Container(margin:EdgeInsets.only(bottom: 80,top: 10),child: CameraPreview(model.controller)),
                        )
                     /* } else {
                        return Container();
                      }
                    })*/),

        model.cameraState == CameraState.R
            ? ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(isBlackBG() ? 1.0 : 0.5),
                  BlendMode.srcOut,
                ), // This one will create the magic
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        backgroundBlendMode: BlendMode.dstOut,
                      ), // This one will handle background + difference out
                    ),
                    ZoomableWidget(
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: getWHByDeviceRatio(
                              MediaQuery.of(context).devicePixelRatio, w),
                          width: getWHByDeviceRatio(
                              MediaQuery.of(context).devicePixelRatio, w),
                          //margin: EdgeInsets.only(top: 98),
                          child: ClipOval(
                            child: Container(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      //isScale: widget.from=="MyChannelPageState" ?  false : true,
                      isScale: false,
                    ),
                  ],
                ),
              )
            : Container(),
        IgnorePointer(
          child: Container(
            child: StreamBuilder<double>(
                stream: seekBloc.controller,
                builder: (context, snapshot) {
                  return Visibility(
                    child:WidgetsBinding.instance.window.physicalSize.width>1080?
                        commonRecordCamDurationIndicator(
                        snapshot.data == null ? 0.0 : snapshot.data,
                        w-80, 3.0):commonRecordCamDurationIndicator(
                        snapshot.data == null ? 0.0 : snapshot.data,
                        w-20, 3.0)
                  );
                }),
          ),
        ),
        Container(
          color: Colors.transparent,
          child: FadeTransition(
            opacity: model.textAnimOpacity,
            child: Text(
              model.startIn > 0 ? model.startIn.toString() : (model.startLabel),
              style: getTextStyle(
                  fontWeight: FontWeight.bold,
                  size: model.startIn > 0 ? 224 : 112,
                  color: Color(0x00ffF1EEF5)),
            ),
          ),
          padding: EdgeInsets.only(top: 32),
        ),
        /*model.cameraState==CameraState.R ? Container(
            padding: EdgeInsets.only(top: 76),
            child: ZoomableWidget(
              child: AspectRatio(
                aspectRatio: model.bloc
                    .controllCamera
                    .value
                    .aspectRatio,
                child: ClipPath(
                  clipper: new InvertedCircleClipper(),
                  child: new Container(
                    color: new Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                ),
              ),
            )
        ) : Container(),*/
      ],
    );
  }

  bool isBlackBG() {
    if (widget.from == "MyChannelPageState" ||
        widget.from == "ActiveSharedMeSyloPageState" ||
        widget.from == "PromptsPageState" ||
        widget.from == "OpenMessagePageState") {
      return true;
    }
    return false;
  }
}
