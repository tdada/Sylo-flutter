import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:testsylo/bloc_item/seek_bloc.dart';
//import 'package:testsylo/common/audio_trim.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/model/draft_model.dart';
import 'package:testsylo/model/question_item.dart';
import 'package:testsylo/model/record_file_with_ratio_item.dart';
import 'package:testsylo/page/qcast/qcat_tab/questions_page/qcasts_page/qcasts_video_record_page/qcasts_video_record_page.dart';
import 'package:testsylo/page/sylo/open_message_page/edit_open_message_page/edit_open_message_page.dart';
import 'package:testsylo/util/navigate_effect.dart';
import 'package:testsylo/util/util.dart';
import 'package:video_player/video_player.dart';
//import 'package:video_trimmer/trim_editor.dart';
import 'package:video_trimmer/video_trimmer.dart';
//import 'package:video_trimmer/video_viewer.dart';
import '../../../../../app.dart';
import '../../../../../app.dart';
import '../../../../../app.dart';
import '../../../../../common/common_widget.dart';
import '../../../../../common/play_video.dart';
import 'que_ans_record_edit_page_view_model.dart';

class QueAnsRecordEditPage extends StatefulWidget {
  List<RecordFileWithRatioItem> listRecording = List();
  List<QuestionItem> listQuestion = List();
  String from;
  CameraState cameraState = CameraState.R;
  MyDraft m = new MyDraft();
  bool isEdit = false;

  QueAnsRecordEditPage(
      this.listRecording, this.from, this.listQuestion, this.cameraState);

  @override
  QueAnsRecordEditPageState createState() => QueAnsRecordEditPageState();
}

class QueAnsRecordEditPageState extends State<QueAnsRecordEditPage> with WidgetsBindingObserver {
  QueAnsRecordEditPageViewModel model;


  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  get onPressed => () async {
    print("OnPressedCall");
    if(!model.isLoad)
      {
    if (model.isPlaying) {
      bool playbackState = await model.trimmer.videPlaybackControl(
        startValue: model.startValue,
        endValue: model.endValue,
      );
      setState(() {
        model.isPlaying = playbackState;
      });
    }
    if (widget.from == "SinglePromptsPageState") {
      var result = await Navigator.push(
          context,
          NavigatePageRoute(
              context,
              EditOpenMessagePage(
                model.listRecordWithThumb,
                from: "edit",
                myDraft: widget.m,
              )));
      if (result != null) {
        widget.isEdit = true;
        widget.m = result;
        print(widget.m.title);
      }
    } else if (widget.from == "OpenMessagePageState") {
      var result = await Navigator.push(
          context,
          NavigatePageRoute(
              context,
              EditOpenMessagePage(
                model.listRecordWithThumb,
                from: "edit",
                myDraft: widget.m,
              )));
      if (result != null) {
        widget.isEdit = true;
        widget.m = result;
        print(widget.m.title);
      }
    } else {

       if(widget.from=="QcamPageState") {
         var result = await Navigator.push(
          context,
          NavigatePageRoute(
              context,
              QcastsVideoRecordPage(
                model.listRecordWithThumb,
                widget.listQuestion,
                widget.cameraState,
                from: "QcamPageState",
                myDraft: widget.m,
              )));
      if (result != null) {
        widget.isEdit = true;
        widget.m = result;
        print(widget.m.title);
      }
       }
       else{



         var result = await Navigator.push(
          context,
          NavigatePageRoute(
              context,
              QcastsVideoRecordPage(
                model.listRecordWithThumb,
                widget.listQuestion,
                widget.cameraState,
                from: "edit",
                myDraft: widget.m,
              )));
      if (result != null) {
        widget.isEdit = true;
        widget.m = result;
        print(widget.m.title);
      }
       }
    }
  }
      };



  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = QueAnsRecordEditPageViewModel(this));
    MediaQueryData queryData = MediaQuery.of(context);
    double w = queryData.size.width - 48;
    //model.getQuestionThumbIfQueListNotNull();
    //double r = queryData.devicePixelRatio;
    //print(r.toString());
    return WillPopScope(
      onWillPop: () async {
        if (model.listRecordWithThumb[0] != null) {
          await commonCupertinoDialogPage(
              context, commonDraftWarningCenterWidget(),
              positiveAction: () async {
            await model.saveAsDraft();
          }, negativeAction: () {
            Navigator.pop(context);
            Navigator.pop(context);
          });
        } else {
          Navigator.pop(context);
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(
            _getTitle(),
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          elevation: 0,
          actions: <Widget>[
            /* Container(
              margin: EdgeInsets.only(right: 16),
              child: Image.asset(
                App.ic_q_white,
              ),
              width: 32,
              height: 32,
            )*/
          ],
          leading: InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Image.asset(
                    App.ic_back_white,
                    fit: BoxFit.contain,
                    width: 16,
                    height: 16,
                  ),
                ),
              ],
            ),
            onTap: () async {
              if (model.listRecordWithThumb[0] != null) {
                await commonCupertinoDialogPage(
                    context, commonDraftWarningCenterWidget(),
                    positiveAction: () async {
                  await model.saveAsDraft();
                }, negativeAction: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                });
              } else {
                Navigator.pop(context);
              }
            },
          ),
          backgroundColor: Colors.black,
        ),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 5, right: 5, top: 4),
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Container(
                          width: w,
                          height: w,
                          /*width: w,
                          height: model.listRecordWithThumb.length == 0
                              ? w
                              : (widget.cameraState == CameraState.R
                                  ? w
                                  : w *
                                      (1 +
                                          model.listRecordWithThumb[0]
                                              .aspectRatio)),*/
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                widget.cameraState == CameraState.R ? w : 0),
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: model.isLoad
                                  ? Container()
                                  : Container(width:MediaQuery.of(context).size.width,child: VideoViewer()),
                            ),
                          ),
                        ),
                        /*  Container(
                          width: w,
                          height: w * (1+model.listRecordWithThumb[0].aspectRatio),
                          child: ClipPath(
                            clipper: new InvertedCircleClipper(),
                            child: new Container(
                              color: new Color.fromRGBO(0, 0, 0, 0.4),
                            ),
                          ),
                        ),*/
                        model.isLoad
                            ? Container()
                            : IconButton(
                                icon: model.isPlaying
                                    ? Icon(
                                        Icons.pause,
                                        size: 48.0,
                                        color: colorWhite,
                                      )
                                    : Icon(
                                        Icons.play_arrow,
                                        size: 48.0,
                                        color: colorWhite,
                                      ),
                                padding: EdgeInsets.all(0),
                                onPressed: () async {
                                  bool playbackState =
                                      await model.trimmer.videPlaybackControl(
                                    startValue: model.startValue,
                                    endValue: model.endValue,
                                  );
                                  setState(() {
                                    model.isPlaying = playbackState;
                                  });
                                },
                              ),
                        Positioned(
                          right: 16,
                          bottom: 16,
                          child: Container(
                            alignment: Alignment.topCenter,
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: <Widget>[
                                FutureBuilder(
                                    future: model
                                        .getQuestionThumbIfQueListNotNull(),
                                    builder: (context, snapshot) {
//                                  print("Question -> " + snapshot.data?.que_link?.toString()??"");
                                      return snapshot.data == null ||
                                              snapshot.data.que_link.isEmpty
                                          ? Container()
                                          : ClipOval(
                                              child: Container(
                                                  color: colorOvalBorder,
                                                  width: 90,
                                                  height: 90,
                                                  child:
//                                      model.isPlaying?PlayVideoAutoPage(
//                                        isFile: false,
//                                        url: snapshot.data.que_link,
//                                        callback: functionGetProgress,
//                                      ) :
                                                      ImageFromNetworkView(
                                                    path: snapshot
                                                            .data?.que_thumb ??
                                                        "",
                                                    boxFit: BoxFit.cover,
                                                  )),
                                            );
                                    }),
                                /*IgnorePointer(
                                  child: StreamBuilder(
                                      stream: seekBloc.controller,
                                      builder: (context, snapshot) {
                                        if (snapshot.data != null) {
                                          //print("seekBloc -> " + snapshot.data.toString());
                                          return commonDurationIndicator(
                                              snapshot.data, 110, 2.5);
                                        } else {
                                          return Container();
                                        }
                                      }),
                                ),*/
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: model.isLoad
                        ? Container()
                        : TrimEditor(
                            viewerHeight: 50.0,

                      viewerWidth: MediaQuery.of(context).size.width,
                            onChangeStart: (value) {
                              model.startValue = value;

                            },
                            onChangeEnd: (value) {
                              model.endValue = value;

                            },
                            onChangePlaybackState: (value) {

                            },
                          ),
                    //height: 75,
                    //height: 54,
                    /* decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0.0),
                        border:
                        Border.all(color: Colors.white, width: 2.0)),
                    margin: EdgeInsets.only(top: 40, left: 8, right: 8),*/
                  ),
                  model.isLoad
                      ? Container(
                          height: 60,
                        )
                      : Container(
                          alignment: Alignment.topCenter,
                          margin: EdgeInsets.only(top: 16),
                          child: FlatButton(
                            child: Text(
                              "   Trim Video   ",
                              style: getTextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  size: 16),
                            ),
                            onPressed: () async {
                              //await model.getAllThumb();
                              setState(() {
                                model.isLoad = true;
                              });

                              String path;
                              await model.trimmer.saveTrimmedVideo(
                                      startValue: model.startValue,
                                      endValue: model.endValue).
                                  then((value)
                                  {

                                      path = value;

                                  });


                              setState(() {
                                //model.listRecordWithThumb[0].file = File(path);
                                 widget.listRecording[0].file = File(path);
                              });

                              await model.getAllThumb1();
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(17.0),
                                side: BorderSide(
                                    color: Colors.white, width: 1.5)),
                          ),
                        ),
                  model.isLoad
                      ? Container(
                          height: 60,
                        )
                      : Container(height: 30),
                  /*Container(
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.only(top: 16),
                      child: FlatButton(
                        child: Text(
                          "Save to Gallery",
                          style: getTextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              size: 16),
                        ),
                        onPressed: () async {
                          //model.getAllThumb();
                          //setState(() {
                          //  model.isLoad = true;
                          //});
                          GallerySaver.saveVideo(model.listRecordWithThumb[0]
                              .file
                              .path).then((bool success) {
                            if (success) {
                              print('XXXXXX');
                              Fluttertoast.showToast(
                                  msg: "Video saved successfully",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Color(0xff9F00C5),
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                            } else {
                              print('YYYY');
                              Fluttertoast.showToast(
                                  msg: "Error occurred saving video",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Color(0xff9F00C5),
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                            }
                          });
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17.0),
                            side:
                            BorderSide(color: Colors.white, width: 1.5)),
                      ),
                    ),*/
                  Container(
                    child: commonButton(onPressed, "Done"),
                    padding: EdgeInsets.only(left: 16, right: 16, top: 24),
                  )
                ],
              ),
              appLoader(model.isLoad),
            ],
          ),
        ),
      ),
    );
  }



  Future<Function> functionGetProgress(t, p) async {
    //print("total Second -> " + t.toString());
    //print("current Second -> " + p.toString());
    currDur = p;
    totalDur = t;
    if (totalDur > 0) {
      double progressMod = currDur / totalDur;
      seekBloc.addProgress(progressMod);
    } else {
      seekBloc.addProgress(0.0);
    }
    return null;
  }

  int totalDur = 0, currDur = 0;
  SeekBloc seekBloc = SeekBloc();

  String _getTitle() {
    String _title = "Edit Video";
    if (widget.from == "PostVideoPageState") {
      _title = _title + getSyloPostTitlesufix(appState.userSylo);
    }
    return _title;
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {


    }
    else if(state == AppLifecycleState.paused)
      {
        //model.isPlaying=false;
      }
    else if(state == AppLifecycleState.inactive)
      {

      }
    else if(state == AppLifecycleState.detached)
    {

    }
  }
}
