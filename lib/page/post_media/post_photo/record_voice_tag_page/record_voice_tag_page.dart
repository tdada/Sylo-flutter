import 'dart:io';

import 'package:flutter/material.dart';

import 'package:testsylo/common/audio_record_widget.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/common/waves_view_annograph.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/page/post_media/post_photo/record_voice_tag_page/record_voice_tag_page_view_model.dart';
import 'package:testsylo/util/util.dart';

import '../../../../app.dart';

class RecordVoiceTagPage extends StatefulWidget {
  List<PostPhotoModel> listImages = List();
  RecordVoiceTagPage({this.listImages});
  @override
  RecordVoiceTagPageState createState() => RecordVoiceTagPageState();
}

class RecordVoiceTagPageState extends State<RecordVoiceTagPage> with SingleTickerProviderStateMixin {
  RecordVoiceTagPageViewModel model;
  //GifController gifController;
  AudioRecordWidget _audioRecordWidget;

  @override
  void initState() {
    super.initState();
    //gifController = GifController(vsync: this);
    model = RecordVoiceTagPageViewModel(this);
  }
  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = RecordVoiceTagPageViewModel(this));
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: getColorBg(),
      appBar: AppBar(
        title: Text(
          "Record Annograph" + getSyloPostTitlesufix(appState.userSylo),
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
                    height: MediaQuery.of(context).size.width - 32,
                    width: MediaQuery.of(context).size.width - 32,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: widget.listImages.length == 1 ?  0 :10),
                    child: GridView.builder(
                      physics: widget.listImages.length == 1 ? NeverScrollableScrollPhysics() : ScrollPhysics(),
                      itemCount: widget.listImages.length,
                      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: widget.listImages.length==1?1:2, childAspectRatio: 1.0),
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
                                    widget.listImages[i].isCircle && model.isWave?WavesViewAnnograph():SizedBox(),
                                    Container(
                                      margin: EdgeInsets.all(15),
                                      child: widget.listImages[i].isCircle?ClipOval(
                                        child:
                                        Container(
                                          child: ClipOval(
                                            child: Container(
                                              child : ImageFromPhotoPostModel(widget.listImages[i], boxFit: BoxFit.cover),
                                              width: double.infinity,
                                              height: double.infinity,
                                              )
                                          ),
                                          padding: EdgeInsets.all(3),
                                          color: colorOvalBorder,
                                        ),
                                      ):Container(
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
                ),
                Container(
                  height: 225,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(
//                        child: Text("asdf"),

                        child: AudioRecordWidget(
                            recordVoiceTagPageViewModel: model,
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
}
