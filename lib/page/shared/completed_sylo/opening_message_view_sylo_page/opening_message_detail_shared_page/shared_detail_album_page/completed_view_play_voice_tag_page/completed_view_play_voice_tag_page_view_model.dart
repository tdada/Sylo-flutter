import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:testsylo/bloc_item/audio_timer_bloc.dart';
import 'package:testsylo/common/audio_wave.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';

import '../../../../../../../app.dart';
import 'completed_view_play_voice_tag_page.dart';


class CompletedViewPlayVoiceTagPageViewModel {
  CompletedViewPlayVoiceTagPageState state;
  InterceptorApi interceptorApi;
  SubAlbumData subAlbumData = SubAlbumData();
  int totalDuration=0;
  List<String> tagList = List();
  List<PostPhotoModel> listImages = List();
  String audioLink = "";
  AudioTimerBloc audioTimerBloc;
  List<AudioWaveBar> audioWaveBar=List();
  CompletedViewPlayVoiceTagPageViewModel(this.state){
    interceptorApi = InterceptorApi(context: state.context);
    audioTimerBloc = AudioTimerBloc();
    if (state.widget.from == "SyloAlbumDetailPageState" || state.widget.from == "SharedDetailAlbumPageState") {
      getSubAlbumData();
    } else {
      initImageModel();
    }
  }

  initImageModel() {
    subAlbumData = SubAlbumData(
        title: "Your 1st Birthday",
        postedDate:
        App.getDateByFormat(DateTime.now(), App.formatMMMDDYY).toString(),
        coverPhoto: "https://picsum.photos/seed/picsum/300/200",
        mediaUrls: [
          "https://picsum.photos/seed/picsum/300/200",
          "https://picsum.photos/id/1/200/300",
          "https://picsum.photos/id/1001/200/300",
          "https://picsum.photos/id/1005/200/300",
          "https://picsum.photos/id/1011/200/300",
          "https://picsum.photos/id/102/200/300"
        ]);
    tagList.add("birthday");
    tagList.add("party");
    tagList.add("holiday");
    listImages.add(PostPhotoModel(isCircle: true, link: "https://i.picsum.photos/id/721/300/300.jpg"));
    audioLink = "https://firebasestorage.googleapis.com/v0/b/tranform-9a6c6.appspot.com/o/alarm_sound%2FMelody%20Of%20My%20Dreams.mp3?alt=media&token=bda8fa01-c963-49ee-8005-b7266930e482";
  }

  getSubAlbumData() async {
    if (state.widget.albumMediaData.subAlbumId != null) {
      subAlbumData = await interceptorApi.callGetSubAlbumData(
          state.widget.albumMediaData.subAlbumId.toString());
      if (subAlbumData == null) {
        subAlbumData = SubAlbumData();
      }
      if (subAlbumData.tag != null && subAlbumData.tag != "") {
        tagList = subAlbumData.tag.split(',');
      }
      if (subAlbumData.mediaUrls!=null) {
        List<dynamic> imageIdsList = subAlbumData.mediaUrls.where((element) => element[1]=="@").toList();
        imageIdsList.forEach((element) {
          var arr = element.split('@');
          String mediaUrl = arr[1];
          if(arr[0] == "0") {
            listImages.add(PostPhotoModel(isCircle: false, link: mediaUrl));
          } else {
            listImages.add(PostPhotoModel(isCircle: true, link: mediaUrl));
          }
        });
        List<dynamic> audioIdsList = subAlbumData.mediaUrls.where((element) => element[1]!="@").toList();
        if(audioIdsList!=null&&audioIdsList.length>0) {
          audioLink = audioIdsList[0]??"";
        }
        print(audioLink);
      }

      loadaudio();

      if(listImages!=null) {
        if (listImages.length == 1) {
          for (int i = 0; i < 65; i++) {
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

      state.setState(() {});
    }
  }

  callBackFromAudion(d){
    print("callBackFromAudion1 ->"+d.toString());
    audioTimerBloc.addTime(d);

  }

  loadaudio() async {
    AudioPlayer audioplayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
    await audioplayer.setUrl(audioLink,isLocal: false);
    int a;
    Timer(Duration(milliseconds: 1500), () async {
      print("from --> "+state.widget.from.toString());
      a = await audioplayer.getDuration();
      print("from --> "+a.toString());
//      a= (a/1000).round();

      state.setState(() {
        double milli=a/22;
        double dss=(milli * 1000) % 1000;
        //int num1 = milli.round();
        totalDuration = milli.toInt().round();
        print("DURATION1: "+totalDuration.toString());

      });


    });
  }

  callDeleteSubAlbum() async {
    Navigator.pop(state.context);
    if(subAlbumData.subAlbumId!=null){
      bool isDelete = await interceptorApi.callDeleteSubAlbum(subAlbumData.subAlbumId);
      if (isDelete != null && isDelete==true) {
        commonToast("Deleted successfully");
        Navigator.pop(state.context, true);
      }
    }
  }

}
