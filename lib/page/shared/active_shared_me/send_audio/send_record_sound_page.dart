import 'dart:io';
import 'package:flutter/material.dart';
import 'package:testsylo/common/audio_play_widget.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/draft_model.dart';
import 'package:testsylo/page/common/create_album_page.dart';
import 'package:testsylo/page/sylo/choose_sylo_view_all_page/choose_sylo_view_all_page.dart';
import 'package:testsylo/page/sylo/open_message_page/edit_open_message_page/success_message_page/success_message_page.dart';
import 'package:testsylo/util/navigate_effect.dart';
import '../../../../app.dart';
import 'send_record_sound_page_view_model.dart';

class SendRecordSoundPage extends StatefulWidget {
  File path;
  String from = "";
  MyDraft myDraft;
  SendRecordSoundPage(this.path,{this.from,this.myDraft});

  @override
  SendRecordSoundPageState createState() => SendRecordSoundPageState();
}

class SendRecordSoundPageState extends State<SendRecordSoundPage> {
  SendRecordSoundPageViewModel model;
  var formKey = GlobalKey<FormState>();
  TextEditingController titleController = new TextEditingController();
  bool _selectionMode = false;

  @override
  void initState() {
    super.initState();
    model = SendRecordSoundPageViewModel(this);
    model.initializeItems();
    model.initializeTagItems();
    if(widget.from=="edit"){
      print("title: ${widget.myDraft.title} tag: ${widget.myDraft.tag}");
      titleController.text = widget.myDraft.title;
      model.tagList = getTagFromString(widget.myDraft.tag);
    }
  }

  get audioTopView => Center(
//    padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Stack(
          children: <Widget>[
            ClipOval(
              child: Container(
                height: MediaQuery.of(context).size.width-32,
                width: MediaQuery.of(context).size.width-32,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    ClipOval(
                        child: Container(
                      color: Colors.white,
                      height: MediaQuery.of(context).size.width-32,
                      width: MediaQuery.of(context).size.width-32,
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
                    widget.path == null
                        ? Container()
                        : AudioPlayWidget(
                            url: widget.path.path,
                            icon_size: 54.0,
                            isLocal: true,
                          ),
                  ],
                ),
                padding: EdgeInsets.all(3),
                color: colorOvalBorder,
              ),
            ),
            Positioned(
                right: 32,
                top: 32,
                child: ClipOval(
                    child: Container(
                  color: colorOvalBorder,
                  padding: EdgeInsets.all(6),
                  child: Icon(
                    Icons.close,
                    color: colorDark,
                    size: 20,
                  ),
                ))),
          ],
        ),
      );

  get editSoundBiteButtons => Container(
        margin: EdgeInsets.only(top: 8, bottom: 8),
        height: 25,
        child: FlatButton.icon(
            onPressed: () {
              MyDraft m = MyDraft();
              m.title = titleController.text;
              m.tag = getTagString(model.tagList);
              Navigator.pop(context,m);
            },
            icon: Icon(
              Icons.mode_edit,
              size: 16,
              color: Colors.white,
            ),
            label: Container(
              padding: EdgeInsets.only(top: 2),
              child: Text(
                "Edit Soundbite",
                style: getTextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600, size: 13),
              ),
            ),
            color: colorDark,
            disabledColor: colorDark,
            padding: EdgeInsets.only(left: 4, right: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7.0),
            )),
      );





  get saveButton => Container(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
        height: 70,
        child: commonButton(
          (){
            model.askAudioQuestion();
          },
          "Send",
        ),
      );

  get formView => Container(
        padding: EdgeInsets.only(top: 8, left: 16, right: 16),
        child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: commontextFieldLabel("Add title", size: 14),
                ),
                Container(
                  child: commonTextField(titleController, TextInputType.text,
                      "Enter Soundbite title"),
                ),

              ],
            )),
      );

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = SendRecordSoundPageViewModel(this));

    return Scaffold(
      backgroundColor: getColorBg(),
      appBar: AppBar(
        title: Text(
          appState.sharedSyloItem.displayName ?? appState.sharedSyloItem.syloName!=null? "Record Soundbite/ "+appState.sharedSyloItem.displayName ?? appState.sharedSyloItem.syloName:"Record Soundbite",
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
      bottomNavigationBar:  saveButton,
      body: SafeArea(
        child: Container(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Column(
                children: <Widget>[
                  audioTopView,
                  editSoundBiteButtons,
                  formView,
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
