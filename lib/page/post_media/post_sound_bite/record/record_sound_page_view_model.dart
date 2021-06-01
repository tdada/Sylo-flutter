import 'dart:async';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/page/post_media/post_sound_bite/record/record_sound_page.dart';
import 'package:testsylo/page/post_media/post_sound_bite/upload_sound_from_sylo_page/upload_sound_from_sylo_page.dart';

import '../../../../bloc_item/forward_timer_bloc.dart';

class RecordSoundPageViewModel {
  RecordSoundPageState state;
  bool isPermit = true;
  RecordSoundPageViewModel(this.state){
    checkPermission();
  }

  onStopRecord(String filePath, double totalRecordDur) async {
    //Directory appDocDir = await getTemporaryDirectory();
    //String appDocPath = appDocDir.path + '/' + filePath + '.mp3';
    //print('onStopRecord -> ' + appDocPath);
    Navigator.pop(state.context);
    if(state.widget.from=="ActiveSharedMeSyloPageState"){
      goToTrimAudio(state.context, File(filePath), totalRecordDur, from: state.widget.from);
    }
    else{
      goToTrimAudio(state.context, File(filePath), totalRecordDur);

    }

  }
  bool isWave = false;
  String min = "";
  String max = "";
  startPlay(){
    state.setState(() {

      isWave = true;

    });
  }
  /*getVoulme(String getmin,String getmax){

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




  }*/

  Future<void> checkPermission() async {
    PermissionStatus status = await Permission.microphone.status;
    if(!status.isGranted){
      await Future.delayed(Duration(milliseconds: 150));
      state.setState((){
        isPermit = false;
      });
      await Permission.microphone.request();
      state.setState((){
        isPermit = true;
      });
    }
  }

}