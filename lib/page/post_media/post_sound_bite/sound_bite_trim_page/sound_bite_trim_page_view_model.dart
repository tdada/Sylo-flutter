import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:testsylo/app.dart';
import 'package:testsylo/bloc_item/audio_timer_bloc.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/draft_model.dart';
import 'package:testsylo/page/post_media/post_sound_bite/sound_bite_trim_page/sound_bite_trim_page.dart';
import 'package:video_trimmer/video_trimmer.dart';

class SoundBiteTrimPageViewModel {
  SoundBiteTrimPageState state;
  int totalDur = 0;
  int totalDuraaa = 0;
  bool isWave = false;
  bool isPlaying = false;



  SoundBiteTrimPageViewModel(this.state, double totalRecordDur){

    double aa=totalRecordDur/100;
    double dss=(aa * 1000) % 1000;
    if(totalRecordDur<11){
      print("=>10.0 "+state.widget.path.toString());
      if(state.widget.totalRecordDur%1==0){ // isInteger true
        totalDur = (state.widget.totalRecordDur * 1000).toInt() ;
        totalDuraaa=dss.toInt();
        print("=>2"+totalDur.toString());
      }
      else{
        totalDur = (state.widget.totalRecordDur * 1000).ceilToDouble().ceil() + 1000;
        totalDuraaa=dss.toInt();
        print("=>1"+totalDur.toString());
      }
//      loadFile();
    }
    else{
      if(state.widget.totalRecordDur%1==0){ // isInteger true
        totalDur = (state.widget.totalRecordDur * 1000).toInt() ;
        totalDuraaa=dss.toInt();
        print("=>12"+totalDur.toString());
      }
      else{
        totalDur = (state.widget.totalRecordDur * 1000).ceilToDouble().ceil() + 1000;
        totalDuraaa=dss.toInt();
        print("=>11"+totalDur.toString());
      }
    }

    isWave = false;
  }
  bool isInteger(num value) => (value % 1) == 0;
  loadFile() async {

    if(state.widget.from == "libraryPickAudio")
      loadaudio(state.widget.path);
    else{
      await trimmer.loadVideo(videoFile: state.widget.path);
      if(state.widget.totalRecordDur%1==0){ // isInteger true
        totalDur = (state.widget.totalRecordDur * 1000).toInt() ;
      }
      else{
        totalDur = (state.widget.totalRecordDur * 1000).ceilToDouble().ceil() + 1000;
      }
      state.setState(() {
        isLoad = false;
      });
    }

  }
  loadaudio(File path) async {
    AudioPlayer audioplayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
    await audioplayer.setUrl(path.path,isLocal: true);
    int a;
    Timer(Duration(milliseconds: 1500), () async {

      a = await audioplayer.getDuration();
//      a= (a/1000).round();
      print("DURATION: "+a.toString());
      state.setState(() {
        totalDur = a;
        isLoad = false;
      });


    });
  }


  double startValue = 0.0;
  double endValue = 0.0;
  Trimmer trimmer = Trimmer();
  bool isLoad = false;
  AudioTimerBloc audioTimerBloc = AudioTimerBloc();

  callBackFromAudion(d){
    print("callBackFromAudion12 ->");
    audioTimerBloc.addTime(d);
  }

  String min = "";
  String max = "";

  getVoulme(String getmin,String getmax){

    var getMax=int.parse(getmax.substring(0,2));

    if(getMax<=80)
    {
      max="3";
      min="3";
    }
    else if(getMax<=70)
    {
      max="2";
      min="2";

    }
    else if(getMax<=60)
    {
      max="1";
      min="1";

    }



  }

  getAudioDurIn2Digit(double sec){

    print("getAudioDurIn2Digit -> "+sec.toString());
    String t = "";

    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    Duration duration = Duration(seconds: sec.ceil());
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    t =  twoDigits(duration.inHours) + ":" + twoDigitMinutes +":"+ twoDigitSeconds;

    return t;

  }

  bool isTrim = false;

  saveAsADraft() async {
    int draft = await saveAsDraft(
        MyDraft(mediaType: App.MediaTypeMap["audio"],directURL: state.widget.path.path)
    );
    if(draft>0) {
      commonToast("successfully saved as Draft");
      goToHome(state.context, null);
    }
  }
}