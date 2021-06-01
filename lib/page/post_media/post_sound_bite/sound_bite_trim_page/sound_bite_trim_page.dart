import 'dart:io';
import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

import 'package:path_provider/path_provider.dart';
import 'package:testsylo/animation/audiocutter.dart';
import 'package:testsylo/animation/const/size_const.dart';
import 'package:testsylo/common/audio_play_widget.dart';
import 'package:testsylo/common/audio_trim.dart';
import 'package:testsylo/common/audio_wave.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/common/waves.dart';
import 'package:testsylo/common/waves_new.dart';
import 'package:testsylo/common/waves_sounds.dart';
import 'package:testsylo/common/waves_view_annograph_sound.dart';
import 'package:testsylo/model/draft_model.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/page/post_media/post_photo/record_voice_tag_page/record_voice_tag_page.dart';
import 'package:testsylo/page/post_media/post_photo/record_voice_tag_page/review_voice_tag_page/review_voice_tag_page.dart';
import 'package:testsylo/page/post_media/post_sound_bite/edit_sound_bite_post_page/edit_sound_bite_post_page.dart';
import 'package:testsylo/page/post_media/post_sound_bite/sound_bite_trim_page/sound_bite_trim_page_view_model.dart';
import 'package:testsylo/page/shared/active_shared_me/send_audio/send_record_sound_page.dart';
import 'package:testsylo/util/navigate_effect.dart';
import 'package:testsylo/util/util.dart';

import '../../../../app.dart';

class SoundBiteTrimPage extends StatefulWidget {
  File path;
  double totalRecordDur = 0;
  String from = "";
  bool trim = false;
  List<PostPhotoModel> listImages = List();
  MyDraft m = new MyDraft();
  SoundBiteTrimPage(this.path, this.totalRecordDur,
      {this.from, this.listImages});

  @override
  SoundBiteTrimPageState createState() => SoundBiteTrimPageState();
}

class SoundBiteTrimPageState extends State<SoundBiteTrimPage>
    with SingleTickerProviderStateMixin {
  SoundBiteTrimPageViewModel model;

  Animation<double> animation;
  int totalduration = 0;
  AnimationController controller;
  Tween<double> _rotationTween = Tween(begin: -math.pi, end: math.pi);
  List<AudioWaveBar> audioWaveBar=List();

  @override
  void initState() {
    super.initState();


    if(widget.listImages!=null) {
      if (widget.listImages.length == 1) {
        for (int i = 0; i < 70; i++) {
          int randomNumber = random.nextInt(90) + 10;
          audioWaveBar.add(AudioWaveBar(
              height: randomNumber.toDouble(), color: colorOvalBorder2));
        }
      }
      else {
        for (int i = 0; i < 28; i++) {
          int randomNumber = random.nextInt(40) + 10;
          audioWaveBar.add(AudioWaveBar(
              height: randomNumber.toDouble(), color: colorOvalBorder2));
        }

      }
    }

  }


  get topIconView =>
      Container(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            getTopImageView(),
            widget.path == null
                ? Container()
                : AudioPlayWidget(
              url: widget.path.path,
              icon_size: 54,
              isLocal: true,
              callback: model.callBackFromAudion,
                onPause: () {
                print("on call Pause");
                model.isWave = false;
                setState(() {});
              },
              onPlay: (AudioPlayer ap) async {
                _audioPlayer = ap;
                Duration startDuration = Duration(milliseconds: model.startValue.round().toInt());
                Duration endDuration = Duration(seconds: ((model.endValue)/1000).round().toInt());
                _audioPlayer.seek(startDuration);
                model.isWave = true;

                setState(() {
                  _audioPlayer.onAudioPositionChanged.listen((event) {
                    print("Current Position: ${event.inSeconds} End Position: ${endDuration.inSeconds}");
                    if(event.inSeconds==endDuration.inSeconds){
                      _audioPlayer.stop();
                      model.isWave = false;
                    }
                  });
                });
              },
            ),
            /* Icon(
                      Icons.play_circle_filled,
                      color: Color(0x59707070),
                      size: 54,
                    ),*/
          ],
        ),
      );

  getTopImageView() {
    if (widget.listImages == null) {
      return ClipOval(
        child: Container(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ClipOval(
                  child: Container(
                    color: Colors.white,
                    height: MediaQuery
                        .of(context)
                        .size
                        .width - 32,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width - 32,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        model.isWave ? WavesViewSound() : Container(),
                        Row(
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
                      ],
                    ),
                  )),
            ],
          ),
          padding: EdgeInsets.all(3),
          color: colorOvalBorder,
        ),
      );
    }
    else {
      return Container(
        height: MediaQuery
            .of(context)
            .size
            .width - 32,
        width: MediaQuery
            .of(context)
            .size
            .width - 32,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: widget.listImages.length == 1 ? 0 : 10),
          child: GridView.builder(
            physics: widget.listImages.length == 1
                ? NeverScrollableScrollPhysics()
                : ScrollPhysics(),
            itemCount: widget.listImages.length,
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.listImages.length == 1 ? 1 : 2,
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
                          widget.listImages[i].isCircle && model.isWave == true
                              ? /*GifImage(
                            controller: gifController,
                            image: AssetImage(App.ic_big_wave),
                            width: double.infinity,
                            height: double.infinity,
                          )*/
                          WavesViewAnnographSound()
                              : SizedBox(),
                          Container(
                            margin: EdgeInsets.all(15),
                            child: widget.listImages[i].isCircle ? ClipOval(
                              child: Container(
                                child: ClipOval(
                                  child: Container(
                                    child : ImageFromPhotoPostModel(widget.listImages[i], boxFit: BoxFit.cover),
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                                padding: EdgeInsets.all(3),
                                color: colorOvalBorder,
                              ),


                            ) : Stack(
                              children: [
                                Container(
                                    padding: EdgeInsets.only(left: 4, right: 4),
                                    child: Container(
                                      color: colorOvalBorder,
                                      padding: EdgeInsets.all(2),
                                      child: Container(
                                        child : ImageFromPhotoPostModel(widget.listImages[i], boxFit: BoxFit.cover),
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    )),
                                model.isWave==true?
                                Container(
                                  margin: EdgeInsets.only(left: 10,right: 10),
                                  alignment: Alignment.bottomCenter,
                                  child: AudioWave(
                                      height: 42,
                                      width: MediaQuery.of(context).size.width,
                                      spacing: 7,
                                      animation: true,
                                      beatRate: Duration(milliseconds: model.totalDuraaa),
                                      bars: audioWaveBar
                                  ),
                                ):Container(color: Colors.black,),
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

  get trimButton =>
      Container(
          margin: EdgeInsets.only(
            top: 24,
            bottom: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                child: Material(
//          color: Color(0xcc979797),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Ink(
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                            color: model.isTrim
                                ? colorSectionHead
                                : Color(0x00ffC3C3C3),
                            width: 2)),
                    child: Container(
                      alignment: Alignment.center,
                      padding:
                      EdgeInsets.only(left: 32, right: 32, top: 6, bottom: 6),
                      child: Text(
                        "Trim Audio",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: model.isTrim
                                ? colorSectionHead
                                : Color(0x00ffC3C3C3),
                            fontWeight: FontWeight.w900,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ),
                onTap: () async {

                  print("Start: ${model.startValue} End: ${model.endValue}");
                  print("File Old Path: ${widget.path.path}");
                  double startp = (model.startValue/1000).round().toDouble();
                  double endp = (model.endValue/1000).round().toDouble();
                  print(startp.toString()+"  "+endp.toString());
                  var pathh = await AudioCutter.cutAudio(widget.path.path, double.parse(startp.toString()), double.parse(endp.toString()));
                  if (model.isTrim) {
                    setState(()  {
                      widget.path = File(pathh);
                      model.isTrim = false;
                      if (_audioPlayer != null){
                        _audioPlayer.stop();
                      }
                    });
                      if (widget.from == 'RecordVoiceTagPageState') {
                        var result = await Navigator.push(
                            context,
                            NavigatePageRoute(context,
                                ReviewVoiceTagPage(pickedImages: widget.listImages,
                                    voiceTagFile: widget.path,from:"edit",myDraft: widget.m)));
                        if(result!=null){
                          widget.m = result;
                          print(widget.m.title);
                        }
                      }
                      else if (widget.from == 'ActiveSharedMeSyloPageState') {
                        var result = await Navigator.push(
                            context,
                            NavigatePageRoute(
                                context, SendRecordSoundPage(widget.path,from:"edit",myDraft: widget.m)));
                        if(result!=null){
                          widget.m = result;
                          print(widget.m.title);
                        }
                      }
                      else {
                        var result = await Navigator.push(
                            context,
                            NavigatePageRoute(
                                context, EditSoundBitePostPage(path:widget.path,from:"edit",myDraft: widget.m,)));

                        if(result!=null){
                          widget.m = result;
                          print(widget.m.title);
                        }
                      }



                  }
                  /*var result = await Navigator.push(
                  context, NavigatePageRoute(context, MyDraftsPage()));*/
                },
              ),
            ],
          ));

  get btnView =>
      Container(
        child: commonButton(
              () async {
                if (_audioPlayer != null){
                  _audioPlayer.stop();
                }
            if (widget.from == 'RecordVoiceTagPageState') {
              var result = await Navigator.push(
                  context,
                  NavigatePageRoute(context,
                      ReviewVoiceTagPage(pickedImages: widget.listImages,
                        voiceTagFile: widget.path,from:"edit",myDraft: widget.m)));
              if(result!=null){
                widget.m = result;
                print(widget.m.title);
              }
            }
            else if (widget.from == 'ActiveSharedMeSyloPageState') {
              var result = await Navigator.push(
                  context,
                  NavigatePageRoute(
                      context, SendRecordSoundPage(widget.path,from:"edit",myDraft: widget.m)));
              if(result!=null){
                widget.m = result;
                print(widget.m.title);
              }
            }
            else {
              var result = await Navigator.push(
                  context,
                  NavigatePageRoute(
                      context, EditSoundBitePostPage(path:widget.path,from:"edit",myDraft: widget.m,)));

              if(result!=null){
                widget.m = result;
                print(widget.m.title);
              }
            }
          },
          "Done",
          red: 22,
        ),
        padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
      );

  get seekView =>
      Container(
        child: Column(
          children: <Widget>[
            model.isLoad
                ? Container(
              height: 50,
            )
                : TrimEditor(
              viewerHeight: 50.0,
              viewerWidth: MediaQuery
                  .of(context)
                  .size
                  .width,
              durationTextStyle: TextStyle(color: Colors.black),
              borderPaintColor: colorSectionHead,
              circlePaintColor: colorSectionHead,
              videoDuration: (model.totalDur),
              onChangeStart: (value) {
                model.startValue = value;
                print("Start: ${model.startValue} End: ${model.endValue}");
                if (!model.isTrim) {
                  print("setState");
                  setState(() {

                    print("Start: ${model.startValue} End: ${model.endValue}");
                    model.isTrim = true;
                  });
                }
              },
              onChangeEnd: (value) {
                if (model.endValue > 0 && !model.isTrim) {
                  print("setState");
                  setState(() {

                    print("Start: ${model.startValue} End: ${model.endValue}");
                    model.isTrim = true;
                  });
                }
                model.endValue = value;
//                print("Start: ${model.startValue} End: ${model.endValue}");
              },
              onChangePlaybackState: (value) {
                setState(() {
                  model.isPlaying = value;
                });
              },
            ),
            /*StreamBuilder<double>(
                stream: model.audioTimerBloc.controller,
                builder: (context, snapshot) {
                  print(snapshot?.data??" -> audioTimerBloc Null");
                  return Column(
                    children: <Widget>[

                      Container(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: Row(

                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[

                            Text(model.getAudioDurIn2Digit(snapshot.data == null ? 0.0 : (snapshot.data * widget.totalRecordDur))),
                            Text(model.getAudioDurIn2Digit(widget.totalRecordDur)),


                          ],

                        ),
                      ),

                      Container(
                        height: 75,
                        child: Slider(
                          onChanged: (v) {
                            //final Position = v * _duration.inMilliseconds;
                            //_audioPlayer.seek(Duration(milliseconds: Position.round()));
                          },
                          value: snapshot.data == null ? 0.0 : snapshot.data,
                        ),
                      ),
                    ],
                  );
                }),*/
          ],
        ),
      );



  @override
  Widget build(BuildContext context) {
    model ?? (model = SoundBiteTrimPageViewModel(this,widget.totalRecordDur));
    return WillPopScope(
      onWillPop: () async {
          await commonCupertinoDialogPage(
              context,
              commonDraftWarningCenterWidget(),
              positiveAction: () async {
                model.saveAsADraft();
                Navigator.pop(context);
              },
              negativeAction: () {
                Navigator.pop(context);
                Navigator.pop(context);
              }
          );
        return false;
      },
      child: Scaffold(
        backgroundColor: getColorBg(),
        appBar: AppBar(
          title: Text(
            _getTitle(),
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
            onTap: () async {
              await commonCupertinoDialogPage(
                  context,
                  commonDraftWarningCenterWidget(),
              positiveAction: () async {
              model.saveAsADraft();
              Navigator.pop(context);
              },
              negativeAction: () {
              Navigator.pop(context);
              Navigator.pop(context);
              }
              );
            },
          ),
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
            child: ListView(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              children: <Widget>[
                topIconView,
                seekView,
                trimButton,
                btnView,
              ],
            )),
      ),
    );
  }

  AudioPlayer _audioPlayer;

  @override
  void dispose() {
    if (_audioPlayer != null){
    _audioPlayer.stop();
    }
    super.dispose ();
  }

  String _getTitle() {
    String _title = "Record Soundbite";
    if(widget.from == 'RecordVoiceTagPageState') {
      _title = "Record Annograph";
    }
    if(widget.from == "ActiveSharedMeFSyloPageState"){
      _title = _title + "/ "+appState.sharedSyloItem.displayName ?? appState.sharedSyloItem.syloName;
    }
    if(widget.from != "ActiveSharedMeSyloPageState"){
      _title = _title + getSyloPostTitlesufix(appState.userSylo);
    }
    return _title;
  }
}
