import 'package:flutter/material.dart';
import 'package:testsylo/common/audio_play_widget.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/common/play_view_side_audio_widget.dart';
import 'package:testsylo/common/play_view_side_audio_widget_icon.dart';
import 'package:testsylo/common/play_view_side_video.dart';
import 'package:testsylo/model/api_response.dart';

import '../../../../app.dart';
import 'shared_view_play_audio_page_view_model.dart';

class SharedViewPlayAudioPage extends StatefulWidget {
  String from;
  SyloQuestionItem syloQuestionItem;
  SharedViewPlayAudioPage({this.from, this.syloQuestionItem});
  @override
  SharedViewPlayAudioPageState createState() => SharedViewPlayAudioPageState();
}

class SharedViewPlayAudioPageState extends State<SharedViewPlayAudioPage> {
  SharedViewPlayAudioPageViewModel model;
  bool playIcon = true;

  get topTextView => Container(
        padding: EdgeInsets.only(bottom: 24),
        child: Column(
          children: <Widget>[
            Text(
              model.title,
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
              model.date,
//              App.getDateByFormat(DateTime.now(), App.formatMMMDDYY),
              style: getTextStyle(
                color: Colors.black,
                size: 13,
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = SharedViewPlayAudioPageViewModel(this));

    return Scaffold(
      backgroundColor: getColorBg(),
      appBar: AppBar(
        title: Text(
          "Listen to Soundbite",
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
        actions: <Widget>[],
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  topTextView,
                  Expanded(
                    child: Container(
                      child: PlayViewSideAudioWidgetIcon(
                        url:
                            model.audioUrl,
//                            "https://firebasestorage.googleapis.com/v0/b/tranform-9a6c6.appspot.com/o/alarm_sound%2FMelody%20Of%20My%20Dreams.mp3?alt=media&token=bda8fa01-c963-49ee-8005-b7266930e482",
                        icon_size: 32.0,
                        isLocal: false,
                        playCall: callback,
                      ),
                    ),
                  )
                  /*videoThumbView,
                      playButton*/
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  callback() {
    showDialog(
      context: context,
      builder: (BuildContext context) => PlayViewSideAudioWidget(
        url:
            model.audioUrl,
//            "https://firebasestorage.googleapis.com/v0/b/tranform-9a6c6.appspot.com/o/alarm_sound%2FMelody%20Of%20My%20Dreams.mp3?alt=media&token=bda8fa01-c963-49ee-8005-b7266930e482",
        icon_size: 32.0,
        isLocal: false,
      ),
    );
  }
}
