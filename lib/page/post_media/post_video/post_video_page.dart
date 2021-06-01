import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/record_file_item.dart';
import 'package:testsylo/model/record_file_with_ratio_item.dart';
import 'package:testsylo/page/post_media/post_photo/photo_sylo_page/sylo_library_page.dart';
import 'package:testsylo/page/post_media/post_video/post_video_page_view_model.dart';
import 'package:testsylo/page/qcast/qcat_tab/questions_page/qcasts_page/qcasts_video_record_page/qcasts_video_record_page.dart';
import 'package:testsylo/page/sign_up/profile/sign_up_profile_page_view_model.dart';
import 'package:testsylo/page/sign_up/profile/sign_up_verification_sent_page.dart';
import 'package:testsylo/util/navigate_effect.dart';
import 'package:testsylo/util/util.dart';
import '../../../app.dart';

class PostVideoPage extends StatefulWidget {
  @override
  PostVideoPageState createState() => PostVideoPageState();
}

  class PostVideoPageState extends State<PostVideoPage> {
    PostVideoPageViewModel model;
    SoundTapState soundTapState = SoundTapState.None;

    get onPressedContinue =>
            () async {
          var result = await Navigator.push(
              context, NavigatePageRoute(context,
              SignUpVerificationSentPage(null, runtimeType.toString())
          ));
        };

    get pickCam =>
        InkWell(
          onTap: () async {

            setState(() {
              soundTapState = SoundTapState.R;
            });
            await Future.delayed(Duration(milliseconds: startDur));
            //goToQueAnsPage(context, runtimeType.toString(), App.status_only_record_trim);
            goToRecordQCastPage(context, runtimeType.toString(), null);
            await Future.delayed(Duration(milliseconds: endDur));
            setState(() {
              soundTapState = SoundTapState.None;
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ClipOval(
                child: Container(
                  padding: EdgeInsets.all(2),
//            color: colorLightRound,
                  decoration: BoxDecoration(
                      gradient:
                      getTapBackColor(
                          soundTapState == SoundTapState.R, colorLightRound)),
                  child: ClipOval(
                    //borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: <Widget>[
                        Container(
                            width: 175,
                            height: 175,
                            child: Container(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      App.ic_cam,
                                      width: 60,
                                      height: 45,
                                      color: getTapWhiteIconColor(
                                          soundTapState == SoundTapState.R,
                                          null),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Center(
                                        child: Text(
                                          "Camera",
                                          textAlign: TextAlign.center,
                                          style: getTextStyle(
                                              size: 15,
                                              color: getTapWhiteLabelColor(
                                                  soundTapState ==
                                                      SoundTapState.R,
                                                  Colors.black),
                                              fontWeight: FontWeight.w800),
                                        ))
                                  ],
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

    get pickLib =>
        InkWell(
          onTap: () async {
            setState(() {
              soundTapState = SoundTapState.L;
            });
            await Future.delayed(Duration(milliseconds: startDur));
            try {
              FilePickerResult result = await FilePicker.platform.pickFiles(
                  type: FileType.video);
              if (result != null) {
                List<RecordFileWithRatioItem> listRecording = List();
                RecordFileWithRatioItem recordFileWithRatioItem = RecordFileWithRatioItem(
                    new File(result.files.single.path),
                    0.5); // from local sd card
                listRecording.add(recordFileWithRatioItem);
                goToTrimVideo(
                    context, runtimeType.toString(), listRecording, null,
                    CameraState.S);
              }
            } catch (e) {}
//      Put here navigator.
            await Future.delayed(Duration(milliseconds: endDur));
            setState(() {
              soundTapState = SoundTapState.None;
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ClipOval(
                child: Container(
                  padding: EdgeInsets.all(2),
//            color: colorLightRound,
                  decoration: BoxDecoration(
                      gradient:
                      getTapBackColor(
                          soundTapState == SoundTapState.L, colorLightRound)),
                  child: ClipOval(
                    //borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: <Widget>[
                        Container(
                            width: 140,
                            height: 140,
                            child: Container(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      App.ic_lib,
                                      width: 60,
                                      height: 45,
                                      color: getTapWhiteIconColor(
                                          soundTapState == SoundTapState.L,
                                          null),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Center(
                                        child: Text(
                                          "Library",
                                          textAlign: TextAlign.center,
                                          style: getTextStyle(
                                              size: 15,
                                              color: getTapWhiteLabelColor(
                                                  soundTapState ==
                                                      SoundTapState.L,
                                                  Colors.black),
                                              fontWeight: FontWeight.w800),
                                        ))
                                  ],
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

    get pickSylo =>
        InkWell(
          onTap: () async {
            setState(() {
              soundTapState = SoundTapState.S;
            });
            await Future.delayed(Duration(milliseconds: startDur));
            var resultt = await Navigator.push(
                context,
                NavigatePageRoute(
                    context, SyloLibraryPage("VIDEO")));
            if (resultt != null) {
              List<RecordFileItem> listRecordWithThumb = resultt;
              Navigator.push(
                  context,
                  NavigatePageRoute(
                      context, QcastsVideoRecordPage(
                      listRecordWithThumb, null, CameraState.S)));
            }
            await Future.delayed(Duration(milliseconds: endDur));
            setState(() {
              soundTapState = SoundTapState.None;
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ClipOval(
                child: Container(
                  padding: EdgeInsets.all(2),
//            color: colorLightRound,
                  decoration: BoxDecoration(
                      gradient:
                      getTapBackColor(
                          soundTapState == SoundTapState.S, colorLightRound)),
                  child: ClipOval(
                    //borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: <Widget>[
                        Container(
                            width: 140,
                            height: 140,
                            child: Container(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      App.ic_sylo_pick,
                                      width: 60,
                                      height: 45,
                                      color: getTapWhiteIconColor(
                                          soundTapState == SoundTapState.S,
                                          null),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Center(
                                        child: Text(
                                          App.app_name,
                                          textAlign: TextAlign.center,
                                          style: getTextStyle(
                                              size: 15,
                                              color: getTapWhiteLabelColor(
                                                  soundTapState ==
                                                      SoundTapState.S,
                                                  Colors.black),
                                              fontWeight: FontWeight.w800),
                                        ))
                                  ],
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

    @override
    Widget build(BuildContext context) {
      print("runtimeType -> " + runtimeType.toString());
      model ?? (model = PostVideoPageViewModel(this));
      return Scaffold(
        backgroundColor: getColorBg(),
        appBar: AppBar(
          title: Text(
            "Video Post" + getSyloPostTitlesufix(appState.userSylo),
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w800, fontSize: 17),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Image.asset(
                    App.ic_back,
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
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 125,),
                        pickCam,
                        SizedBox(height: 16,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            pickSylo,
                            pickLib,
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }