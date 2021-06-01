import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/page/post_media/post_sound_bite/post_sound_bite_page_view_model.dart';
import 'package:testsylo/page/post_media/post_sound_bite/record/record_sound_page.dart';
import 'package:testsylo/util/navigate_effect.dart';
import 'package:testsylo/util/util.dart';
import '../../../app.dart';
import 'edit_sound_bite_post_page/edit_sound_bite_post_page.dart';
import 'upload_sound_from_sylo_page/upload_sound_from_sylo_page.dart';

class PostSoundBitePage extends StatefulWidget {
  @override
  PostSoundBitePageState createState() => PostSoundBitePageState();
}

  class PostSoundBitePageState extends State<PostSoundBitePage> {
    PostSoundBitePageViewModel model;
    SoundTapState soundTapState = SoundTapState.None;

    get pickSound =>
        InkWell(
          onTap: () async {
            setState(() {
              soundTapState = SoundTapState.R;
            });
            await Future.delayed(Duration(milliseconds: startDur));
            var result = await Navigator.push(
                context, NavigatePageRoute(
                context, RecordSoundPage(runtimeType.toString())));
            await Future.delayed(Duration(milliseconds: endDur));
            setState(() {
              soundTapState = SoundTapState.None;
            });
//      goToRecordQCastPage(context, runtimeType.toString(), null, null);
          },
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ClipOval(
                child: Container(
                  padding: EdgeInsets.all(2),
                  //color: colorLightRound,
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      App.ic_mic_record,
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
                                          "Record",
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
                  type: FileType.audio);
              if (result != null) {
                goToTrimAudio(context, result.files.single.path, 10.0,
                    from: "libraryPickAudio");
              }
            } catch (e) {}
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
//                color: colorLightRound,
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
            var audioLink = await Navigator.push(
                context, NavigatePageRoute(context, UploadSoundFromSyloPage()));
            if (audioLink != null) {
              var result1 = await Navigator.push(
                  context,
                  NavigatePageRoute(
                      context,
                      EditSoundBitePostPage(audioLink: audioLink, from: "",)));
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
//                color: colorLightRound,
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
      model ?? (model = PostSoundBitePageViewModel(this));
      return Scaffold(
        backgroundColor: getColorBg(),
        appBar: AppBar(
          title: Text(
            "Soundbite Post" + getSyloPostTitlesufix(appState.userSylo),
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
                        SizedBox(
                          height: 125,
                        ),
                        pickSound,
                        SizedBox(
                          height: 16,
                        ),
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