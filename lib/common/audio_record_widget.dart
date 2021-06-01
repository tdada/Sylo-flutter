
import 'dart:async';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
/*import 'package:medcorder_audio/medcorder_audio.dart';*/

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:testsylo/common/audio_recorder.dart';
import 'package:testsylo/page/post_media/post_photo/record_voice_tag_page/record_voice_tag_page_view_model.dart';
import 'package:testsylo/page/post_media/post_sound_bite/record/record_sound_page_view_model.dart';

import '../app.dart';


class AudioRecordWidget extends StatefulWidget {

  RecordSoundPageViewModel recordSoundPageViewModel;
  RecordVoiceTagPageViewModel recordVoiceTagPageViewModel;
  AudioRecordWidget({this.recordSoundPageViewModel, this.recordVoiceTagPageViewModel});

  @override
  State<StatefulWidget> createState() {

    return _AudioWidgetState();
  }
}

class _AudioWidgetState extends State<AudioRecordWidget> {

  //MedcorderAudio audioModule = new MedcorderAudio();
  bool canRecord = false;
  double recordPower = 0.0;
  double recordPosition = 0.0;
  bool isRecord = false;
  bool isPlay = false;
  double playPosition = 0.0;
  int _recordDuration = 0;
  Timer _timer;
  String file = "";
  String min = "";
  String max = "";

  @override
  initState() {
    super.initState();
    requestPermission();
    isRecord = false;


      /*audioModule.setCallBack((dynamic data) {
      _onEvent(data);
    });*/

    _initSettings();
  }

  Future _initSettings() async {
    canRecord = true;
    //String result = await audioModule.checkMicrophonePermissions();
    //print("result -> "+result);
/*final String result = await audioModule.checkMicrophonePermissions();
    if (result == 'OK') {
      await audioModule.setAudioSettings();
      setState(() {
        canRecord = true;
      });
    }*/

    return;
  }
  Recording _recording;

  FlutterAudioRecorder _recorder;


  Widget _buildText() {
    if (isRecord || isPlay) {
      return _buildTimer();
    }

    return Text("00:00");
  }

  Widget _buildTimer() {
    final String minutes = _formatNumber(_recordDuration ~/ 60);
    final String seconds = _formatNumber(_recordDuration % 60);

    return Text(
      '$minutes : $seconds',
      style: TextStyle(color: Colors.red),
    );
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0' + numberStr;
    }

    return numberStr;
  }

  Future _prepare() async {
    //var hasPermission = await FlutterAudioRecorder.hasPermissions;
    var hasPermission = await Record.hasPermission();
      if(hasPermission) {
        _init();
        /*await _init();
        var result = await _recorder.current();
        setState(() {
          _recording = result;
        });
        await _startRecording();*/

      }
  }

  requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
      Permission.photos,
      Permission.storage,
      Permission.mediaLibrary,
      Permission.unknown

    ].request();
    print(statuses);
  }
  bool _checkForStop = false;
  Timer _t;
  Future _startRecording() async {
    await _recorder.start();

    var current = await _recorder.current();
    setState(() {
      _recording = current;
      isRecord = true;
    });

    if(widget.recordSoundPageViewModel!=null){
      widget.recordSoundPageViewModel.startPlay();


    }
    if(widget.recordVoiceTagPageViewModel != null){
      widget.recordVoiceTagPageViewModel.startPlay();
    }
      print("power"+recordPower.toString());
    _t = Timer.periodic(Duration(milliseconds: 10), (Timer t) async {
      var current = await _recorder.current();
      if(mounted)
        setState(() {
          _recording = current;
          _t = t;
        });
    });
  }
  Future _stopRecording() async {
    var result = await _recorder.stop();

    recordPosition = _t.tick.toDouble();
    _t.cancel();
    setState(() {
      _recording = result;
      _checkForStop = false;
    });

    file = _recording.path;
    recordPosition = _timer.tick.toDouble();

    if(widget.recordSoundPageViewModel!=null){
       widget.recordSoundPageViewModel.onStopRecord(file+"", recordPosition);
    }
    if(widget.recordVoiceTagPageViewModel!=null){
       widget.recordVoiceTagPageViewModel.onStopRecord(file+"", recordPosition);
    }



    setState(() {
      isRecord = false;
    });

  }




  void onError(PlatformException e) {
    print(e.toString());
    isRecord = false;
  }






  Future _init() async {
    String customPath = '/';
    Directory appDocDirectory;
    if (Platform.isIOS) {
      appDocDirectory = await getApplicationDocumentsDirectory();
    } else {
      print("android");
      appDocDirectory = await getApplicationDocumentsDirectory();
      print(appDocDirectory.path);
    }
    // can add extension like ".mp4" ".wav" ".m4a" ".aac"
    customPath = appDocDirectory.path +
        customPath +
        DateTime.now().millisecondsSinceEpoch.toString()+".mp4";

    // .wav <---> AudioFormat.WAV
    // .mp4 .m4a .aac <---> AudioFormat.AAC
    // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.

      await Record.start(
      path: customPath, // required
      encoder: AudioEncoder.AAC, // by default
      bitRate: 128000, // by default
      samplingRate: 22050, // by default
    );
    DateTime time = new DateTime.now();
    setState(() {
      file = customPath;
    });
    setState(() {
      _recordDuration = 0;
      isRecord = true;
    });
    _startTimer();
    if(widget.recordSoundPageViewModel!=null){
      widget.recordSoundPageViewModel.startPlay();
      //widget.recordSoundPageViewModel.getVoulme(max, min);

    }
    if(widget.recordVoiceTagPageViewModel != null){
      widget.recordVoiceTagPageViewModel.startPlay();
    }



       }


  void _startTimer() {
    const tick = const Duration(seconds: 1);

    _timer?.cancel();

    _timer = Timer.periodic(tick, (Timer t) {
      setState(() => _recordDuration++);
    });

  }

  Future<void> _start(String path) async {
    try {
      if (await Record.hasPermission()) {
        await Record.start(path: path);

        bool isRecording = await Record.isRecording();
        setState(() {
            isRecord=true;
        });


      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _stop() async {
    await Record.stop();
    recordPosition = _timer.tick.toDouble();

    _timer.cancel();
    setState(() {
      _checkForStop = false;
    });


    setState(() => isRecord = false);

    if(widget.recordSoundPageViewModel!=null){
      widget.recordSoundPageViewModel.onStopRecord(file+"", recordPosition);
    }
    if(widget.recordVoiceTagPageViewModel!=null){
      widget.recordVoiceTagPageViewModel.onStopRecord(file+"", recordPosition);
    }
  }

  Future _startStopPlay() async {
    if (isPlay) {
      //await audioModule.stopPlay();
    } else {

    }
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: canRecord
            ? new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new InkWell(
              child: new Container(
                width: 60,
                height: 60,
                child: Image.asset(
                  !isRecord ? App.ic_play : App.ic_pause,
                ),
              ),
              onTap: () async {
                if (isRecord) {
                  //_stopRecord();
                  setState(() {
                    _checkForStop = true;
                  });
                  //await _stopRecording();
                  _stop();
                } else {
                  //_startRecord();
                  _prepare();

                  //await _startRecording();
                }
              },
            ),

            SizedBox(height: 8,),
            Container(child: _buildText())
            /*RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "• ",
                style: getTextStyle(
                  color: Color(0x00ffFFA694),
                  size: 16,
                  fontWeight: FontWeight.w500,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: _buildText(),
                      style: getTextStyle(
                          color: Colors.black,
                          size: 15,
                          fontWeight:
                          FontWeight.w500)),
                ],
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),*/
          ],
        )
            : new Text(
          'Microphone Access Disabled.\nYou can enable access in Settings',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

}
