import 'dart:io';

import 'package:flutter/material.dart';
import 'package:testsylo/common/play_video_new.dart';
import 'package:testsylo/common/play_view_side_video.dart';
import 'package:testsylo/model/prompt_item.dart';
import 'package:testsylo/model/record_file_item.dart';
import 'package:testsylo/model/record_file_with_ratio_item.dart';
import 'package:testsylo/page/qcast/qcat_tab/discover_page/record_qcast_list/record_qcast_list_page_view_model.dart';
import 'package:testsylo/page/qcast/qcat_tab/my_channel_page/review_qcast_page/review_qcast_page.dart';
import 'package:testsylo/page/qcast/qcat_tab/my_channel_page/review_qcast_prompt_page/review_qcast_prompt_page.dart';
import 'package:testsylo/page/shared/active_shared_me/send_video/send_qcast_page.dart';
import 'package:testsylo/page/sylo/open_message_page/edit_open_message_page/edit_open_message_page.dart';
import 'package:testsylo/util/navigate_effect.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

import '../../../../../app.dart';
import '../../../../../app.dart';
import '../../../../../app.dart';
import '../../../../../common/common_widget.dart';
import '../../../../../common/play_video.dart';

class RecordQcastListPage extends StatefulWidget {
  List<RecordFileWithRatioItem> listRecording = List();
  String from = "";
  List<PromptItem> listPrompt = List();
  CameraState cameraState;


  RecordQcastListPage(
      this.listRecording, this.from, this.listPrompt, this.cameraState);

  @override
  RecordQcastListPageState createState() => RecordQcastListPageState();
}

class RecordQcastListPageState extends State<RecordQcastListPage> with WidgetsBindingObserver {
  RecordQcastListPageViewModel model;
  Subscription _subscription;
  int editIndex = -1;

  get onPressed => () {
    if(!model.isLoad) {
      if (widget.from == "ActiveSharedMeSyloPageState") {
        Navigator.push(
            context,
            NavigatePageRoute(
                context, SendQcastPage(model.listRecordWithThumb)));
      }
    /*else if (widget.from=="PromptsPageState"){
        Navigator.push(
            context,
            NavigatePageRoute(
                context,
                ReviewQcastPromptPage(
                    model.listRecordWithThumb, widget.listPrompt)));
     *//* Navigator.push(
          context, NavigatePageRoute(context, ReviewQcastPromptPage(model.listRecordWithThumb, widget.listPrompt)));*//*
    }*/
        /*else if (widget.listPrompt != null) {

      }*/
      else {
        Navigator.push(
            context,
            NavigatePageRoute(
                context, ReviewQcastPage(model.listRecordWithThumb)));
      }
    }
      };


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

  }
  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);

  }


  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = RecordQcastListPageViewModel(this));
    double w = MediaQuery.of(context).size.width - 48;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          widget.from=="QcamPageState"?"Edit Qcast":"Edit Video",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: <Widget>[
          /*Container(
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
          onTap: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 5, right: 5, top: 4),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      /* ClipOval(
                        child: Container(
                          color: editIndex == -1 ? Colors.black : colorOvalBorder,
                          width: w-19,
                          height: w-19,
                          //padding: EdgeInsets.all(5),
                          child: editIndex == -1
                              ? Container()
                              : ClipOval(
                                  child: PlayVideoPage(
                                    url: model.listRecordWithThumb[editIndex].file.path,
                                    isFile: true,
                                  ),
                                ),
                        ),
                      ),*/

                      /* ClipRRect(
                        child: Container(
                          color:
                              editIndex == -1 ? Colors.black : colorOvalBorder,
                          width: w - 19,
                          height: w - 19,
                          //padding: EdgeInsets.all(5),
                          child: editIndex == -1
                              ? Container()
                              : PlayVideoPage(
                                  url: model
                                      .listRecordWithThumb[editIndex].file.path,
                                  isFile: true,
                                ),
                        ),
                        borderRadius: BorderRadius.circular(
                            widget.cameraState == CameraState.R ? w - 19 : 0),
                      ),*/
                      /* Container(
                        width: w,
                        height: widget.cameraState == CameraState.R ? w : w * (1+model.listRecordWithThumb[0].aspectRatio) ,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              widget.cameraState == CameraState.R ? w  : 0),
                          child: OverflowBox(
                            alignment: Alignment.center,
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: editIndex == -1
                                  ? Container()
                                  :  Container(
                                width: w,
                                height: w /
                                    model
                                        .listRecordWithThumb[editIndex].aspectRatio,
                                child: PlayVideoPage(
                                  url: model
                                      .listRecordWithThumb[editIndex].file.path,
                                  isFile: true,
                                ), // this is my CameraPreview
                              ),
                            ),
                          ),
                        ),
                      )*/

                      Container(
                        width: w,
                        height: w,
                        /*height: model.listRecordWithThumb.length == 0
                            ? w
                            : (widget.cameraState == CameraState.R
                                ? w
                                : w *
                                    (1 +
                                        model.listRecordWithThumb[0]
                                            .aspectRatio -
                                        0.1)),*/
                        child: ClipOval(
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: model.isLoad
                                ? Container()
                                : editIndex == -1
                                      ? Container()
                                      : Container(
                                        width: w,
                                        height: w,
                                        child: PlayViewSideVideoPage(
                                          url: model
                                              .listRecordWithThumb[
                                                  editIndex]
                                              .file
                                              .path,
                                          isFile: true,
                                        ),
                                      ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: model.listRecordWithThumb.length,
                    shrinkWrap: true,
                    itemBuilder: (c, i) {
                      RecordFileItem item = model.listRecordWithThumb[i];
                      // Use the controller to loop the video.

                      return Container(
                        padding: EdgeInsets.only(left: 12),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              editIndex = -1;
                            });

                            Future.delayed(const Duration(milliseconds: 400),
                                () {
                              setState(() {
                                editIndex = i;
                              });
                            });
                          },
                          child: ClipOval(
                            child: Container(
                              width: 54,
                              height: 54,
                              child: ClipOval(
                                child: item.thumbPath != null
                                    ? Image.file(
                                        item.thumbPath,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(App.ic_placeholder),
                              ),
                              padding: EdgeInsets.all(4),
                              color: i == editIndex
                                  ? colorOvalBorder2
                                  : colorOvalBorder,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  height: 54,
                  margin: EdgeInsets.only(top: 40),
                ),
                editIndex == -1
                    ? Container(
                        height: 65,
                      )
                    : Container(
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.only(top: 16),
                        child: FlatButton(
                          child: Text(
                            "Delete Question",
                            style: getTextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                size: 16),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                // return object of type Dialog
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
                                  title: new Text(
                                    "Alert",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  content: new Text("Confirm delete? ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500)),
                                  actions: <Widget>[
                                    // usually buttons at the bottom of the dialog
                                    new FlatButton(
                                      child: new Text(
                                        "No",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),

                                    new FlatButton(
                                      child: new Text(
                                        "Yes",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                      onPressed: () {
                                        print("ListLength1"+model.listRecordWithThumb.length.toString());
                                        Navigator.of(context).pop();
                                        setState(() {
                                          if(model.listRecordWithThumb.length==1) {
                                              commonToast("You can not delete last Question");
                                          }
                                          else{
                                            model.listRecordWithThumb
                                                .removeAt(editIndex);
                                            editIndex = -1;

                                          }
                                        });
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17.0),
                              side:
                                  BorderSide(color: Colors.white, width: 1.5)),
                        ),
                      ),
                Container(
                  child: commonButton(
                      onPressed,
                      widget.from == "ActiveSharedMeSyloPageState"
                          ? "Done"
                          : "Save"),
                  padding: EdgeInsets.only(left: 16, right: 16, top: 24),
                )
              ],
              physics: BouncingScrollPhysics(),
            ),
            appLoader(model.isLoad),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {


    }
    else if(state == AppLifecycleState.paused)
    {

    }
    else if(state == AppLifecycleState.inactive)
    {

    }
    else if(state == AppLifecycleState.detached)
    {

    }
  }

}
