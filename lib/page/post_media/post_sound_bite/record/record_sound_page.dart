import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testsylo/common/audio_record_widget.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/common/waves.dart';
import 'package:testsylo/common/waves_new.dart';
import 'package:testsylo/page/post_media/post_sound_bite/record/record_sound_page_view_model.dart';
import 'package:testsylo/page/post_media/post_sound_bite/sound_bite_trim_page/sound_bite_trim_page.dart';
import 'package:testsylo/page/post_media/post_sound_bite/upload_sound_from_sylo_page/upload_sound_from_sylo_page_view_model.dart';
import 'package:testsylo/util/navigate_effect.dart';
import 'package:testsylo/util/util.dart';

import '../../../../app.dart';

class RecordSoundPage extends StatefulWidget {
  String from = "";

  RecordSoundPage(this.from);

  @override
  RecordSoundPageState createState() => RecordSoundPageState();
}

class RecordSoundPageState extends State<RecordSoundPage> {
  RecordSoundPageViewModel model;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = RecordSoundPageViewModel(this));
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
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
          onTap: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        model.isWave ?
                        WavesView() :
                        Container(),
                        Image.asset(
                          App.ic_mic_record,
                          width: 75,
                          height: 75,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 225,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(
                        child: !model.isPermit ? Container() : AudioRecordWidget(
                          recordSoundPageViewModel: model,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  String _getTitle() {
    String _title = "Record Soundbite";
    if(widget.from != "ActiveSharedMeSyloPageState"){
      _title = _title + getSyloPostTitlesufix(appState.userSylo);
    }
    if(widget.from == "ActiveSharedMeSyloPageState"){
      _title = _title + "/ "+appState.sharedSyloItem.displayName ?? appState.sharedSyloItem.syloName;
    }
    return _title;
  }
}
