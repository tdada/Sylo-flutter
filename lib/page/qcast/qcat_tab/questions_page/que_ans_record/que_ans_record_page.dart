import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera/camera.dart';
//import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:testsylo/bloc_item/seek_bloc.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/common/play_video.dart';
import 'package:testsylo/common/play_video_auto.dart';
import 'package:testsylo/common/play_video_auto_mute.dart';
import 'package:testsylo/model/question_item.dart';
import 'package:testsylo/page/qcast/qcat_tab/discover_page/record_qcast_list/record_qcast_list_page.dart';
import 'package:testsylo/page/qcast/qcat_tab/questions_page/que_ans_record/que_ans_record_page_view_model.dart';
import 'package:testsylo/util/navigate_effect.dart';
import 'package:vibration/vibration.dart';

import '../../../../../app.dart';

class QueAnsRecordPage extends StatefulWidget {
  String from;
  List<QuestionItem> listQuestions = List();

  QueAnsRecordPage(this.from, this.listQuestions);

  @override
  QueAnsRecordPageState createState() => QueAnsRecordPageState();
}

class QueAnsRecordPageState extends State<QueAnsRecordPage>
    with TickerProviderStateMixin {
  QueAnsRecordPageViewModel model;

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = QueAnsRecordPageViewModel(this));
    double w = MediaQuery.of(context).size.width;

    return NativeDeviceOrientationReader(
        useSensor: true,
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Stack(

                children: <Widget>[
                  Container(alignment:Alignment.center,child:getCamViewByStateNew(w)),
                  Column(
                    children: <Widget>[
                      Expanded(
                        child: /*model.bloc.cameras == null
                            ? Container()
                            : */Container(

                                child: Stack(
                                  children: <Widget>[
                                    //getCamViewByState(w),

                                    Container(
                                      child: FadeTransition(
                                        opacity: model.textAnimOpacity,
                                        child: Text(
                                          model.startLabel,
                                          style: getTextStyle(
                                              fontWeight: FontWeight.bold,
                                              size: 112,
                                              color: Color(0x00ffF1EEF5)),
                                        ),
                                      ),
                                      padding: EdgeInsets.only(top: 32),
                                    ),
                                    /*Positioned(
                              bottom: 8,
                              child: InkWell(
                                child: Image.asset(
                                  model.cameraState == CameraState.R
                                      ? App.ic_sq
                                      : App.ic_round_record,
                                  width: 32,
                                  height: 32,
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
                        padding: EdgeInsets.only(bottom: 35),
                        height: 180,
                        child: Stack(
                          /*alignment: Alignment.center,*/
                          children: <Widget>[
                            Positioned(
                              bottom: 2,
                              left: 8,
                              right: 8,
                              child: Container(
                                //color: Colors.blue,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          /*  model.videoIndex==0 ? Container(width: 29 ,) :InkWell(child: RotatedBox(child: Container(child: Image.asset(App.ic_right, width: 24, height: 24,), padding: EdgeInsets.all(5),), quarterTurns: 90,), onTap: (){

                                        },),*/
                                          Container(
                                            width: 29,
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 24,
                                                right: 24,
                                                top: 4,
                                                bottom: 4),
                                            /*decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(25)),*/
                                            child: AutoSizeText(
                                              model.getVideoIndexLabel(),
                                              minFontSize: 10,
                                              maxFontSize: 16,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: getTextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w800,
                                                  size: 18),
                                            ),
                                          ),
                                          (model.videoSavePath.isEmpty ||
                                                  model.videoIndex ==
                                                      widget.listQuestions
                                                              .length -
                                                          1)
                                              ? Container(
                                                  width: 29,
                                                )
                                              : InkWell(
                                                  child: Container(
                                                    child: Image.asset(
                                                      App.ic_right,
                                                      width: 24,
                                                      height: 24,
                                                    ),
                                                    padding: EdgeInsets.all(5),
                                                  ),
                                                  onTap: () {
                                                    model.loadNewQue();
                                                  },
                                                )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        model.textAnimOpacity.forward();
                                        await Future.delayed(
                                            Duration(milliseconds: 1000));
                                        model.startLabel = "";
                                        model.playPauseVideo();

                                        // model.controller.startVideoRecording(filePath);
                                      },
                                      child: Container(
                                        width: 64,
                                        height: 64,
                                        child: Image.asset(
                                          model.videoSavePath.isEmpty
                                              ? App.ic_play
                                              : App.ic_pause,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 8),
                                      child: Container(
                                        child: StreamBuilder<String>(
                                            stream: model
                                                .forwardTimerBloc.controller,
                                            builder: (context, snapshot) {
                                              return RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                  text: "• ",
                                                  style: getTextStyle(
                                                    color: Color(0x00ffFFA694),
                                                    size: 22,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text: snapshot.data ==
                                                                null
                                                            ? "00:00"
                                                            : snapshot.data,
                                                        style: getTextStyle(
                                                            color: Colors.white,
                                                            size: 22,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                  ],
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              );
                                            }),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            (model.listRecording.length > 0 ||
                                    model.videoSavePath.isNotEmpty)
                                ? Container()
                                : Positioned(
                                    bottom: 8,
                                    right: 8,
                                    child: InkWell(
                                      onTap: () async {
                                        //model.initCam();
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
                          ],
                        ),
                      )
                    ],
                  ),
                  InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(8),
                          child: Image.asset(
                            App.ic_back_white,
                            fit: BoxFit.contain,
                            width: 16,
                            height: 16,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      /*if(model.bloc.controllCamera!=null)
                        {
                          model.bloc.controllCamera.dispose();
                        }*/
                      Navigator.pop(context);
                    },
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.only(top: 12),
                    child: Text(
                      "Record Qcast Interview",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
    //model.bloc.dispose();
    if (model.forwardTimer != null) {
      model.forwardTimer.cancel();
    }
    model.controller.dispose();
    model.textAnimOpacity.dispose();
  }

  int totalDur = 0, currDur = 0;

  Future<Function> functionGetProgress(t, p) async {
    print("total Second -> " + t.toString());
    //print("current Second -> " + p.toString());
    currDur = p;
    totalDur = t;
    if (totalDur > 0) {
      print("total Second1 -> " + t.toString());
      model.isAudio = false;

      //model.bloc.controllCamera.pauseVideoRecording();
      double progressMod = currDur / totalDur;
      seekBloc.addProgress(progressMod);
      print("Audio True1" + model.isAudio.toString());
    } else {
      seekBloc.addProgress(0.0);
    }
    if (totalDur == currDur) {
      model.isAudio = true;
      print("Audio True" + model.isAudio.toString());
      //model.bloc.controllCamera.resumeVideoRecording();
    }

    return null;
  }

  SeekBloc seekBloc = SeekBloc();

  getCamViewByState(w) {
    if (model.cameraState == CameraState.R) {
      return ClipRRect(
        child: Container(
          color: colorOvalBorder,
          width: w - 19,
          height: w - 19,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              AspectRatio(
                child: ClipOval(
                  //child: CameraPreview(model.bloc.controllCamera),
                  child: Container(),
                ),
                aspectRatio: 1.0,
              ),
              //CameraPreview(model.controller),
            ],
          ),
        ),
        borderRadius: BorderRadius.circular(w),
      );
    } else {
      return AspectRatio(
        //child: CameraPreview(model.bloc.controllCamera),
        child: Container(),
        aspectRatio: 1.0,
      );
    }
  }

  String str_cam = "full default";

  getCamViewByStateNew(w) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    print("devicePixelRatio -> " +
        MediaQuery.of(context).devicePixelRatio.toString()+ deviceRatio.toString());
    if (model.cameras == null) {
      return Container();
    }
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
            child: /*StreamBuilder<bool>(
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data) {
                    if (str_cam == "small default") {
                      return OverflowBox(
                        child: AspectRatio(aspectRatio:model.controller.value.aspectRatio,child: CameraPreview(model.controller)),
                      );
                    } else if (str_cam == "full default") {

                      return */OverflowBox(
                        child: Stack(
                          children: <Widget>[
                            CameraPreview(model.controller),
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
                                            backgroundBlendMode:
                                                BlendMode.dstOut,
                                          ), // This one will handle background + difference out
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            height: getWHByDeviceRatio(
                                                MediaQuery.of(context)
                                                    .devicePixelRatio,
                                                w),
                                            width: getWHByDeviceRatio(
                                                MediaQuery.of(context)
                                                    .devicePixelRatio,
                                                w),
                                            child: ClipOval(
                                              child: Container(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : Container(),
                            model.isRefresh
                                ? Container()
                                : Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(bottom: w-48),
                                      child: Stack(
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        Container(
                                          child: ClipOval(
                                            child: Container(
                                              color: colorOvalBorder,
                                              width: 112,
                                              height: 112,
                                              child: model.videoIndex == -1
                                                  ? ImageFromNetworkView(
                                                      path: widget
                                                          .listQuestions[0]
                                                          .que_thumb,
                                                      boxFit: BoxFit.cover,
                                                    )
                                                  : Container(
                                                      child:
                                                          PlayVideoAutoMutePage(
                                                        isFile: false,
                                                        url: widget
                                                            .listQuestions[model
                                                                .videoIndex]
                                                            .que_link,
                                                        callback: functionGetProgress,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        ),
                                        IgnorePointer(
                                          child: StreamBuilder(
                                              stream: seekBloc.controller,
                                              builder: (context, snapshot) {
                                                if (snapshot.data != null) {
                                                  //print("seekBloc -> " + snapshot.data.toString());
                                                  return commonDurationIndicator(
                                                      snapshot.data,
                                                      110,
                                                      2.5);
                                                } else {
                                                  return Container(
                                                    height: 0,
                                                  );
                                                }
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      )
                    /*} else {
                      return Container(

                      );
                    }
                  } else {
                    return Container();
                  }
                } else {
                  return Container();
                }
              }*/),


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


}
