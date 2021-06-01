import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:testsylo/bloc_item/seek_bloc.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/common/invert_clip.dart';
import 'package:testsylo/common/play_video.dart';
import 'package:testsylo/common/zoomable_widget.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/model/prompt_item.dart';
import 'package:testsylo/page/dashboard/qcam_tab/qcam_page_view_model.dart';
import 'package:testsylo/page/qcast/qcat_tab/questions_page/questions_page.dart';
import 'package:testsylo/util/navigate_effect.dart';
import 'package:testsylo/util/util.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:vibration/vibration.dart';

import '../../../app.dart';

class QcamPage extends StatefulWidget {
  String from;
  List<PromptItem> listPrompt = List();
  void Function() callback;

  QcamPage(this.from, this.listPrompt, this.callback);

  @override
  QcamPageState createState() => QcamPageState();
}

class QcamPageState extends State<QcamPage> with TickerProviderStateMixin {
  QcamPageViewModel model;
  int currentPage;
  PageController pageController;

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
    if (timer != null) {
      timer.cancel();
    }
    if (model.forwardTimer != null) {
      model.forwardTimer.cancel();
      model.forwardTimerBloc.dispose();
    }
    model.controller.dispose();
    model.textAnimOpacity.dispose();
  }

  bool isShowBottomView = false;
  double leftAnim = 76;
  double rightAnim = 0;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = QcamPageViewModel(this));
    double w = MediaQuery.of(context).size.width;

    return NativeDeviceOrientationReader(
        useSensor: true,
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Stack(
                children: <Widget>[
                  str_cam == "full default"
                      ? Padding(padding: EdgeInsets.only(bottom: 120),child:getCamViewByStateNew(w))
                      : Container(),
                  Column(
                    children: <Widget>[
                      model.cameras == null
                          ? Expanded(child: Container())
                          : Expanded(
                              child: Container(
                                //padding: EdgeInsets.only(top: 76),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    //getCamViewByStateNew(w),

                                    /*Positioned(
                                  bottom: 8,
                                  child: InkWell(
                                    child: Image.asset(
                                      model.cameraState == CameraState.R
                                          ? App.ic_sq
                                          : App.ic_round_record,
                                      width: 42,
                                      height: 42,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        if (model.cameraState == CameraState.R) {
                                          model.cameraState = CameraState.S;
                                        } else {
                                          model.cameraState = CameraState.R;
                                        }
                                      });
                                    },
                                  ),
                                )*/
                                  ],
                                ),
                              ),
                            ),
                      Container(
                        height: 250,
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Positioned(
                              bottom: 10,
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    (model.currentView != "photo" &&
                                                model.isStart) ||
                                            model.isCreateQcast ||
                                            model.isBlack
                                        ? Container()
                                        : Container(
                                        alignment: Alignment.center,
                                        height: 70,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          physics: BouncingScrollPhysics(),
                                          itemCount:
                                              model.listTakedImages?.length ??
                                                  0,
                                          shrinkWrap: true,
                                          itemBuilder: (c, i) {
                                            PostPhotoModel postPhotoModel =
                                                model.listTakedImages[i];
                                            return InkWell(
                                              child: postPhotoModel.isCircle
                                                  ? ClipOval(
                                                      child: Container(
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          child: ClipOval(
                                                            child: Container(
                                                              color:
                                                                  colorOvalBorder,
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(2),
                                                              child: ClipOval(
                                                                child:
                                                                    Image.file(
                                                                  postPhotoModel
                                                                      .image,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  width: 60,
                                                                  height: 60,
                                                                ),
                                                              ),
                                                            ),
                                                          )),
                                                    )
                                                  : Container(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      child: Container(
                                                        color: colorOvalBorder,
                                                        padding:
                                                            EdgeInsets.all(2),
                                                        child: Image.file(
                                                          postPhotoModel.image,
                                                          fit: BoxFit.cover,
                                                          width: 50,
                                                          height: 60,
                                                        ),
                                                      )),
                                              onTap: () {
                                                zoomFileImageDialogueContainWidthOneImage(
                                                    context,
                                                    ZoomableWidget(
                                                      child: Image.file(
                                                        postPhotoModel.image,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ));
                                              },
                                            );
                                          },
                                        )),
                                    InkWell(
                                      child: Image.asset(
                                        model.cameraState == CameraState.R
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
                                    model.currentView == "qcam"
                                        ? Container()
                                        : AnimatedContainer(
                                            duration:
                                                Duration(milliseconds: 400),
                                            padding: EdgeInsets.only(
                                                left: leftAnim,
                                                right: rightAnim),
                                            child: Row(
                                              children: <Widget>[
                                                InkWell(
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        left: 16,
                                                        right: 16,
                                                        top: 6,
                                                        bottom: 6),
                                                    child: Text("Video",
                                                        style: getTextStyle(
                                                            color: model.currentView ==
                                                                    "video"
                                                                ? Color(
                                                                    0x00ff9F00C5)
                                                                : Colors.grey,
                                                            size: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                  ),
                                                  onTap: () {
                                                    if (model.isStart) {
                                                      return;
                                                    }
                                                    setState(() {
                                                      leftAnim = 76;
                                                      rightAnim = 0;
                                                      model.currentView =
                                                          "video";
                                                    });
                                                  },
                                                ),
                                                InkWell(
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        left: 16,
                                                        right: 16,
                                                        top: 6,
                                                        bottom: 6),
                                                    child: Text("Photo",
                                                        style: getTextStyle(
                                                            color: model.currentView ==
                                                                    "photo"
                                                                ? Color(
                                                                    0x00ff9F00C5)
                                                                : Colors.grey,
                                                            size: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                  ),
                                                  onTap: () {
                                                    if (model.isStart) {
                                                      return;
                                                    }
                                                    setState(() {
                                                      leftAnim = 0;
                                                      rightAnim = 76;
                                                      model.currentView =
                                                          "photo";
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                    /* SizedBox(
                                  height: 8,
                                ),*/
                                    /*model.isRecNextQue()
                                        ? Container(
                                      width: 29,
                                      height: 4,
                                    )
                                        : Container(

                                      color: Colors.white,
                                          child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.end,
                                            children: [

                                              Padding(
                                                padding: const EdgeInsets.only(
                                                     right: 80,top: 4),
                                                child: InkWell(

                                      onTap: () {
                                                //model.goToNextPage(false);
                                                if (model.videoSavePath.isEmpty) {
                                                  commonMessage(context,
                                                      "By recording your question you can able to move to next recording");
                                                  return;
                                                }
                                                //start = -1;
                                                //model.goToNextPage(false);
                                                seekBloc.addProgress(0.0);
                                                model.goToNextPage(
                                                    false, isRecursive: true);
                                      },
                                      */ /*child: Container(
                                                padding: EdgeInsets.only(
                                                    left: 24,
                                                    right: 24,
                                                    top: 4,
                                                    bottom: 4),
                                                decoration: BoxDecoration(
                                                    border:
                                                    Border.all(color: Colors.white),
                                                    borderRadius:
                                                    BorderRadius.circular(25)),
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(
                                                      "Record Next Question",
                                                      style: getTextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w800,
                                                          size: 14),
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Container(
                                                      child: Image.asset(
                                                        App.ic_right,
                                                      ),
                                                      width: 16,
                                                      height: 16,
                                                    ),
                                                  ],
                                                ),
                                      ),*/ /*
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
                                                    */ /*Text(
                                                                  "Next Question",
                                                                  style: getTextStyle(
                                                                      color: Colors.white,
                                                                      fontWeight:
                                                                          FontWeight.w800,
                                                                      size: 14),
                                                                ),
                                                                SizedBox(
                                                                  width: 8,
                                                                ),*/ /*
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
                                        ),*/
                                    /* SizedBox(
                                  height: 8,
                                ),*/
                                    InkWell(
                                      onTap: () async {
                                        model.isStart = true;
                                        if (model.currentView == "photo") {
                                          model.takePicture();
                                          return;
                                        }

                                        if (model.currentView == "qcam") {
                                          if (widget.listPrompt.length == 0) {
                                            commonToast(
                                                "Please Select Prompts");
                                          } else {
                                            if (model.startIn == -1) {
                                              setState(() {
                                                model.textAnimOpacity.forward();
                                                model.startIn = 5;
                                              });
                                              model.callRecursive();
                                            } else {
                                              model.playPauseVideo(false);
                                            }
                                          }
                                        } else {
                                          if (model.startIn == -1) {
                                            setState(() {
                                              model.textAnimOpacity.forward();
                                              model.startIn = 5;
                                            });
                                            model.callRecursive();
                                          } else {
                                            model.playPauseVideo(false);
                                          }
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
                                    model.currentView == "photo"
                                        ? Container(
                                            height: 35,
                                          )
                                        : Container(
                                            margin: EdgeInsets.only(top: 8),
                                            child: !model.is30SecTimer()
                                                ? StreamBuilder<String>(
                                                    stream: model
                                                        .forwardTimerBloc
                                                        .controller,
                                                    builder:
                                                        (context, snapshot) {
                                                      return RichText(
                                                        textAlign:
                                                            TextAlign.center,
                                                        text: TextSpan(
                                                          text: "• ",
                                                          style: getTextStyle(
                                                            color: Color(
                                                                0x00ffFFA694),
                                                            size: 24,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                                text: snapshot
                                                                            .data ==
                                                                        null
                                                                    ? "00:00"
                                                                    : snapshot
                                                                        .data,
                                                                style: getTextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    size: 24,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500)),
                                                          ],
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      );
                                                    })
                                                : StreamBuilder<String>(
                                                    stream: model
                                                        .forwardTimerBloc
                                                        .controller,
                                                    builder:
                                                        (context, snapshot) {
                                                      return RichText(
                                                        textAlign:
                                                            TextAlign.center,
                                                        text: TextSpan(
                                                          text: "• ",
                                                          style: getTextStyle(
                                                            color: Color(
                                                                0x00ffFFA694),
                                                            size: 24,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                                text: snapshot
                                                                            .data ==
                                                                        null
                                                                    ? "00:30"
                                                                    : snapshot
                                                                        .data,
                                                                style: getTextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    size: 24,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500)),
                                                          ],
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      );
                                                    })),
                                  ],
                                ),
                              ),
                            ),
                            if (!model.isRecNextQue())
                              Container(
                                width: 29,
                                height: 4,
                              )
                            else
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.only(top: 106, right: 85),
                                      child: InkWell(
                                        onTap: () {
                                          //model.goToNextPage(false);
                                          if (model.videoSavePath.isEmpty) {
                                            commonMessage(context,
                                                "By recording your question you can able to move to next recording");
                                            return;
                                          }
                                          //start = -1;
                                          //model.goToNextPage(false);

                                          seekBloc.addProgress(0.0);
                                          if (model.promptQuestionList.length ==
                                              currentPage + 1) {
                                            commonToast(
                                                "You have finished all prompts");
                                          } else {
                                            model.goToNextPage1(false);
                                          }
                                        },
                                        /*child: Container(
                                                padding: EdgeInsets.only(
                                                    left: 24,
                                                    right: 24,
                                                    top: 4,
                                                    bottom: 4),
                                                decoration: BoxDecoration(
                                                    border:
                                                    Border.all(color: Colors.white),
                                                    borderRadius:
                                                    BorderRadius.circular(25)),
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(
                                                      "Record Next Question",
                                                      style: getTextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w800,
                                                          size: 14),
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Container(
                                                      child: Image.asset(
                                                        App.ic_right,
                                                      ),
                                                      width: 16,
                                                      height: 16,
                                                    ),
                                                  ],
                                                ),
                                      ),*/
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                              top: 10,
                                              bottom: 10),
                                          decoration: BoxDecoration(
                                              color: colorDisable,
                                              border: Border.all(
                                                  color: colorDisable),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
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
                                                  color: colorOvalBorder2,
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
                              ),
                            (model.listRecording.length > 0 ||
                                    model.videoSavePath.isNotEmpty)
                                ? Container()
                                : Positioned(
                                    bottom: 28,
                                    right: 8,
                                    child: InkWell(
                                      onTap: () async {
                                        //model.c;
                                        await model.onCameraSwitch();
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
                                padding: EdgeInsets.only(left: 17),
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
                            Navigator.pop(context);
                          },
                        ),
                  widget.callback == null
                      ? Container()
                      : Positioned(
                          bottom: 68,
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
                  widget.listPrompt == null ||
                          model.videoSavePath.isNotEmpty ||
                          model.isStart
                      ? Container()
                      : Positioned(
                          right: 0,
                          top: 20,
                          child: Container(
                            margin: EdgeInsets.only(right: 16),
                            child: InkWell(
                              onTap: () async {
                                if (widget.from == "DashBoardPageState") {
                                  bool isMyChannel = await model.getMyChannel();
                                  if (isMyChannel) {
                                    model.isBlack = true;
                                    if (!model.isCreateQcast) {
                                      setState(() {
                                        model.isCreateQcast = true;

                                        model.currentView = "qcam";
                                        model.cameraState = CameraState.R;
                                      });
                                    } else {
                                      var result = await Navigator.push(
                                          context,
                                          NavigatePageRoute(
                                              context,
                                              QuestionsPage(
                                                  runtimeType.toString())));
                                      if (result != null) {
                                        setState(() {
                                          widget.listPrompt = result;
                                          model.isCreateQcast = false;
                                          model.promptQuestionList =
                                              getPromptsQuestionListFromPromptsList(
                                                  widget.listPrompt);
                                        });
                                        model.currentView = "qcam";
                                      }
                                    }
                                  } else {
                                    commonMessage(context,
                                        "Please, First create your Channel, without channel you can not create Qcast.");
                                  }
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                              child: Image.asset(
                                App.ic_q_white,
                              ),
                            ),
                            width: 32,
                            height: 32,
                          ),
                        ),
                  Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.only(top: 25),
                    child: Text(
                      model.getVideoIndexLabel(),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 15),
                    ),
                  ),
                  model.currentView == "photo"
                      ? Positioned(
                          right: 1,
                          bottom: 70,
                          child: InkWell(
                            child: model.capturePicPath.length >= 1
                                ? Container(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(top: 3),
                                          child: Text("Add",
                                              style: getTextStyle(
                                                  color: Colors.white,
                                                  size: 15,
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              right: 4,
                                              top: 6,
                                              bottom: 6,
                                              left: 2),
                                          child: Image.asset(
                                            App.ic_right,
                                          ),
                                          width: 16,
                                          height: 16,
                                        ),
                                      ],
                                    ),
                                  )
                                : SizedBox(height: 0, width: 0),
                            onTap: () async {
                              for (var i = 0;
                                  i < model.capturePicPath.length;
                                  i++) {
                                if (model.listTakedImages[i].isCircle) {
                                  File croppedFile =
                                      await ImageCropper.cropImage(
                                          sourcePath:
                                              model.capturePicPath[i].path,
                                          aspectRatioPresets: [
                                            CropAspectRatioPreset.square,
                                          ],
                                          cropStyle: CropStyle.circle,
                                          androidUiSettings: AndroidUiSettings(
                                            toolbarTitle: 'Edit Image',
                                            toolbarColor: colorDark,
                                            toolbarWidgetColor: Colors.white,
                                            initAspectRatio:
                                                CropAspectRatioPreset.square,
                                            lockAspectRatio: false,
                                          ),
                                          iosUiSettings: IOSUiSettings(
                                            title: "Edit Image",
                                            minimumAspectRatio: 1.0,
                                          ));
                                  /*.then((value) =>
                            model.capturePicPath[i] = value);*/
                                  model.listTakedImages[i].image = croppedFile;
                                  model.capturePicPath[i] = croppedFile;
                                } else {
                                  File croppedFile =
                                      await ImageCropper.cropImage(
                                          sourcePath:
                                              model.capturePicPath[i].path,
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
                                              initAspectRatio:
                                                  CropAspectRatioPreset
                                                      .original,
                                              lockAspectRatio: false),
                                          iosUiSettings: IOSUiSettings(
                                            title: "Edit Image",
                                            minimumAspectRatio: 1.0,
                                          ));
                                  /*.then((value) =>
                            model.capturePicPath[i] = value);*/
                                  model.listTakedImages[i].image = croppedFile;
                                  model.capturePicPath[i] = croppedFile;
                                }
                              }
                              await model.gotoPhotoReviewPageProcess();
                            },
                          ),
                        )
                      : Container()
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
      model.goToNextPage(false);
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

  void unPauseTimer() => startTimer(start);

  getCamRecordSeekProgress() {
    if (start > 0) {
      double progressMod = start / 30;
      return 1 - progressMod;
    } else {
      return 0.0;
    }
  }

  SeekBloc seekBloc = SeekBloc();

  String str_cam = "full default";

  /*getCamViewByStateNew(w) {
    print("devicePixelRatio -> " +
        MediaQuery.of(context).devicePixelRatio.toString());
    if (model.bloc.cameras == null) {
      return Container();
    }
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          child: StreamBuilder<bool>(
              stream: model.bloc.selectCamera.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data) {
                     */ /*previewRatio = model.bloc
                          .controllCamera.value.aspectRatio;
                      print("previewRatio" +
                          previewRatio.toString());*/ /*
                    print("aspectRatio" +
                        model.bloc.controllCamera.value.aspectRatio
                            .toString());
                    if (str_cam == "small default") {
                      return AspectRatio(
                        aspectRatio:
                        model.bloc.controllCamera.value.aspectRatio,
                        child: OverflowBox(
                          child: CameraPreview(model.bloc.controllCamera),
                        ),
                      );
                    } else if (str_cam == "full default") {
                      return SwipeDetector(
                        onSwipeLeft: () {
                          print("onSwipeLeft");
                          if (model.currentView == "qcam" || model.isStart) {
                            return;
                          }
                          if (model.currentView == "video" && leftAnim > 0) {
                            setState(() {
                              leftAnim = 0;
                              rightAnim = 76;
                              model.currentView = "photo";
                            });
                          }
                        },
                        onSwipeRight: () {
                          print("onSwipeRight");
                          if (model.currentView == "qcam" || model.isStart) {
                            return;
                          }
                          if (model.currentView == "photo" && leftAnim == 0) {
                            setState(() {
                              leftAnim = 76;
                              rightAnim = 0;
                              model.currentView = "video";
                            });
                          }
                        },
                        child: AspectRatio(
                          aspectRatio:
                          model.bloc.controllCamera.value.aspectRatio,
                          child: OverflowBox(
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                CameraPreview(model.bloc.controllCamera),

                                model.cameraState == CameraState.R
                                    ? ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(model.isBlack ? 1 : (model.isCreateQcast ? 1 :0.5)),
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
                                            height:  getWHByDeviceRatio(MediaQuery.of(context).devicePixelRatio, w),
                                            width:  getWHByDeviceRatio(MediaQuery.of(context).devicePixelRatio, w),
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
                                Container(
                                  child: FadeTransition(
                                    opacity: model.textAnimOpacity,
                                    child: Text(
                                      model.startIn > 0
                                          ? model.startIn.toString()
                                          : (model.startLabel),
                                      style: getTextStyle(
                                          size: model.startIn > 0 ? 112 : 56,
                                          color: Color(0x00ffF1EEF5)),
                                    ),
                                  ),
                                ),
                                IgnorePointer(
                                  child: Container(
                                    child: StreamBuilder<double>(
                                        stream: seekBloc.controller,
                                        builder: (context, snapshot) {
                                          return commonRecordCamDurationIndicator(
                                              snapshot.data == null ? 0.0 : snapshot.data,
                                              w / 1.05,
                                              3.0);
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  } else {
                    return Container();
                  }
                } else {
                  return Container();
                }
              }),
        ),



        model.cameraState==CameraState.R ? Container(
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
        ) : Container(),
      ],
    );
  }*/

  getCamViewByStateNew(w) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    print("devicePixelRatio -> " +
        MediaQuery.of(context).devicePixelRatio.toString()+ "dsfdsf:"+deviceRatio.toString());
    if (model.cameras == null) {
      return Container();
    }
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
            child:
                SwipeDetector(
                onSwipeLeft: () {
                  print("onSwipeLeft");
                  if (model.currentView == "qcam" || model.isStart) {
                    return;
                  }
                  if (model.currentView == "video" && leftAnim > 0) {
                    setState(() {
                      leftAnim = 0;
                      rightAnim = 76;
                      model.currentView = "photo";
                    });
                  }
                },
                onSwipeRight: () {
                  print("onSwipeRight");
                  if (model.currentView == "qcam" || model.isStart) {
                    return;
                  }
                  if (model.currentView == "photo" && leftAnim == 0) {
                    setState(() {
                      leftAnim = 76;
                      rightAnim = 0;
                      model.currentView = "video";
                    });
                  }
                },
                child: CameraPreview(model.controller))),
            model.cameraState == CameraState.R
            ? ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(1.0),
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
                    child: commonRecordCamDurationIndicator(
                        snapshot.data == null ? 0.0 : snapshot.data,
                        w / 1.05,
                        3.0),
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
                  size: model.startIn > 0 ? 112 : 56,
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (model.controller == null || !model.controller.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      model.controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      //onNewCameraSelected(model.controller.description);
    }
  }
}
