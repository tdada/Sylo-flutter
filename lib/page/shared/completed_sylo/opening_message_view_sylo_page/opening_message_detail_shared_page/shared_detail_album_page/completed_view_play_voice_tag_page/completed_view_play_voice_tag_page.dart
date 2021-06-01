import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:testsylo/common/audio_play_widget.dart';
import 'package:testsylo/common/audio_wave.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/common/play_view_side_audio_widget.dart';
import 'package:testsylo/common/waves.dart';
import 'package:testsylo/common/waves_view_annograph.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/model/model.dart';
import '../../../../../../../app.dart';
import 'completed_view_play_voice_tag_page_view_model.dart';

class CompletedViewPlayVoiceTagPage extends StatefulWidget {
  String from;
  AlbumMediaData albumMediaData;
  CompletedViewPlayVoiceTagPage({this.from, this.albumMediaData});
  @override
  CompletedViewPlayVoiceTagPageState createState() =>
      CompletedViewPlayVoiceTagPageState();
}

class CompletedViewPlayVoiceTagPageState
    extends State<CompletedViewPlayVoiceTagPage>
    with SingleTickerProviderStateMixin {
  CompletedViewPlayVoiceTagPageViewModel model;
  bool playIcon = true;
  bool isWave = false;
  int totalduration = 0;


  @override
  void initState() {
    super.initState();


  }

  get topTextView => Container(
        child: Column(
          children: <Widget>[
            Text(
              model.subAlbumData.title ?? "",
              style: getTextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                size: 18,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              model.subAlbumData.postedDate ?? "",
              style: getTextStyle(
                color: Colors.black,
                size: 13,
              ),
            ),
          ],
        ),
      );

  get tagDisplayView => Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 8),
      height: 30,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemCount: model.tagList.length,
        shrinkWrap: true,
        itemBuilder: (c, i) {
          return Container(
            padding: EdgeInsets.only(left: 4, right: 4),
            height: 30,
            child: FlatButton(
                onPressed: () {},
                child: Text(model.tagList[i]),
                color: colorOvalBorder,
                disabledColor: colorOvalBorder,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                )),
          );
        },
      ));

  getTopImageView() {
    if (model.listImages == null) {
      return ClipOval(
        child: Container(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ClipOval(
                  child: Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.width - 32,
                width: MediaQuery.of(context).size.width - 32,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      App.ic_mic_coloroval,
                      fit: BoxFit.contain,
                      width: 110,
                      height: 110,
                    ),
                  ],
                ),
              )),
            ],
          ),
          padding: EdgeInsets.all(3),
          color: colorOvalBorder,
        ),
      );
    } else {
      return Container(
        height: MediaQuery.of(context).size.width - 32,
        width: MediaQuery.of(context).size.width - 32,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: model.listImages.length == 1 ? 0 : 10),
          child: GridView.builder(
            physics: model.listImages.length == 1
                ? NeverScrollableScrollPhysics()
                : ScrollPhysics(),
            itemCount: model.listImages.length,
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: model.listImages.length == 1 ? 1 : 2,
                childAspectRatio: 1.0),
            shrinkWrap: true,
            itemBuilder: (c, i) {
              return Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          model.listImages[i].isCircle && isWave == true
                              ? /*GifImage(
                                  controller: gifController,
                                  image: AssetImage(App.ic_big_wave),
                                  width: double.infinity,
                                  height: double.infinity,
                                )*/
                          WavesViewAnnograph()
                              : SizedBox(),
                          Container(
                            margin: EdgeInsets.all(15),
                            child: model.listImages[i].isCircle
                                ? Stack(
                                  children: [
                                    ClipOval(
                                        child: Container(
                                          child: ClipOval(
                                            child: Container(
                                              width: double.infinity,
                                              height: double.infinity,
                                              child: ImageFromNetworkView(
                                                path: model.listImages[i].link,
                                                boxFit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          padding: EdgeInsets.all(3),
                                          color: colorOvalBorder,
                                        ),
                                      ),
                                    //isWave==true ? WavesView():SizedBox()
                                  ],
                                )
                                :
                                Stack(
                                  children: [
                                    Container(
                                        padding: EdgeInsets.only(left: 4, right: 4),
                                        child: Container(
                                          color: colorOvalBorder,
                                          padding: EdgeInsets.all(2),
                                          child: Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            child: Container(
                                              width: double.infinity,
                                              height: double.infinity,
                                              child: ImageFromNetworkView(
                                                path: model.listImages[i].link,
                                                boxFit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        )),
                                        isWave == true ?
                                        Container(

                                      margin: EdgeInsets.only(left: 10),
                                      alignment: Alignment.bottomCenter,
                                      child: AudioWave(
                                          height: 42,
                                          width: MediaQuery.of(context).size.width,
                                          spacing: 7,
                                          beatRate: Duration(milliseconds: model.totalDuration),
                                          bars: model.audioWaveBar
                                      ),
                                    ):SizedBox(),
                                  ],
                                ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print("runtimeType1 -> " + runtimeType.toString());
    model ?? (model = CompletedViewPlayVoiceTagPageViewModel(this));

    return Scaffold(
      backgroundColor: getColorBg(),
      appBar: AppBar(
        title: Text(
          "Listen to Annograph",
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
        actions: <Widget>[
          widget.from == "SyloAlbumDetailPageState"
              ? InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 12, right: 12),
                        child: Image.asset(
                          App.ic_delete_drafts,
                          height: 20,
                        ),
                      )
                    ],
                  ),
                  onTap: () {
                    commonCupertinoDialogPage(
                        context,
                        Column(
                          children: <Widget>[
                            SizedBox(
                              height: 12,
                            ),
                            new Image.asset(
                              App.ic_alert_new,
                              height: 24,
                              width: 24,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "Are you sure you want to delete \nthis Posted media?",
                              textAlign: TextAlign.center,
                              style: getTextStyle(
                                  size: 18,
                                  height: 1.5,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 34,
                            ),
                          ],
                        ), positiveAction: () {
                      model.callDeleteSubAlbum();
                    });
                  },
                )
              : SizedBox()
        ],
      ),
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            if (_audioPlayer != null) {
              _audioPlayer.stop();
            }
            return true;
          },
          child: Container(
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    topTextView,
                    tagDisplayView,

//                  Expanded(
//                    child: Container(
//                      child: PlayViewSideAudioWidget(
//                        url:model.audioLink,
//                        icon_size: 32.0,
//                        isLocal: false,
////                        playCall: callback,
//                        voiceTagLink: model.listImages??[PostPhotoModel(isCircle: true, link:"")]
////                        model.subAlbumData.mediaUrls,
//                      ),
//                    ),
//                  ),
                    getTopImageView(),
                    model.audioLink.isEmpty
                        ? Container()
                        : AudioPlayWidget(
                            url: model.audioLink,
                            icon_size: 54,
                            isLocal: true,
                            callback: model.callBackFromAudion,
                            onPlay: (AudioPlayer ap) async {
                              _audioPlayer = ap;
                              isWave = true;
                              setState(() {

                              });

                            },
                            onPause: () {
                              isWave = false;
                              setState(() {});
                            },
                          )
                    /*videoThumbView,
                        playButton*/
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  callback() {
    showDialog(
      context: context,
      builder: (BuildContext context) => PlayViewSideAudioWidget(
        url: model.audioLink,
        icon_size: 32.0,
        isLocal: false,
        voiceTagLink: model.subAlbumData.coverPhoto != null
            ? [
                PostPhotoModel(
                    isCircle: true, link: model.subAlbumData.coverPhoto)
              ]
            : [PostPhotoModel(isCircle: true, link: "")],
      ),
    );
  }



  AudioPlayer _audioPlayer;
  @override
  void dispose() {
    if (_audioPlayer != null) {
      _audioPlayer.stop();
    }
    super.dispose();
  }
}
