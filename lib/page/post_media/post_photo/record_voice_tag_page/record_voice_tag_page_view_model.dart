import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/page/post_media/post_photo/record_voice_tag_page/record_voice_tag_page.dart';
import 'package:testsylo/util/navigate_effect.dart';

import 'review_voice_tag_page/review_voice_tag_page.dart';

class RecordVoiceTagPageViewModel {
  RecordVoiceTagPageState state;
  RecordVoiceTagPageViewModel(this.state);

  onStopRecord(String filePath, double totalRecordDur) async {
    //Directory appDocDir = await getTemporaryDirectory();
    //String appDocPath = appDocDir.path + '/' + filePath + '.mp3';
    //print('onStopRecord -> ' + appDocPath);
    //Navigator.pop(state.context);
    //state.gifController.value = 0;
    isWave = false;
    goToTrimAudio(state.context, File(filePath), totalRecordDur,from: state.runtimeType.toString(), imageList: state.widget.listImages);
//    var result = await Navigator.push(
//        state.context, NavigatePageRoute(state.context, ReviewVoiceTagPage(pickedImages: state.listImages,)));
  }
  bool isWave = false;
  String min = "";
  String max = "";
  getVoulme(String getmin,String getmax){
    /*state.setState(() {*/

    max=getmax;
    min=getmin;

    /*});*/
  }
  startPlay(){
    state.setState(() {
      //state.gifController.repeat(min:0,max:200,period:Duration(milliseconds: 10000));
      isWave = true;

    });
  }
}