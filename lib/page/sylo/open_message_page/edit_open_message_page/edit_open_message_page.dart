import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:testsylo/bloc_item/seek_bloc.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/common/play_video.dart';
import 'package:testsylo/common/play_view_side_video.dart';
import 'package:testsylo/model/draft_model.dart';
import 'package:testsylo/model/record_file_item.dart';
import 'package:testsylo/page/sylo/open_message_page/edit_open_message_page/edit_open_message_page_view_model.dart';
import 'package:testsylo/page/sylo/open_message_page/edit_open_message_page/success_message_page/success_message_page.dart';
import 'package:testsylo/util/navigate_effect.dart';

import '../../../../app.dart';

class EditOpenMessagePage extends StatefulWidget {
  List<RecordFileItem> listRecordWithThumb = List();
  String from = "";
  bool visi = false;
  MyDraft myDraft;

  EditOpenMessagePage(this.listRecordWithThumb,{this.from,this.myDraft});

  @override
  EditOpenMessagePageState createState() => EditOpenMessagePageState();
}

class EditOpenMessagePageState extends State<EditOpenMessagePage> {
  EditOpenMessagePageViewModel model;
  TextEditingController messageController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    model = EditOpenMessagePageViewModel(this);
    if(widget.from=="edit"){
      messageController.text = widget.myDraft.title;
    }
//    messageController.text = appState.addSyloItem?.openingMsg;
  }

  get pickProfileVideo => Container(
        margin: EdgeInsets.only(top: 12),
        child: InkWell(
          onTap: () async {
            try {} catch (e) {}
          },
          child: Stack(
            fit: StackFit.loose,
            alignment: Alignment.center,
            children: <Widget>[
              ClipOval(
                child: Container(
                  color: colorOvalBorder,
                  width: 112,
                  height: 112,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Image.file(widget.listRecordWithThumb[0].thumbPath),
                  )
                ),
              ),
              IgnorePointer(
                child: StreamBuilder(
                    stream: seekBloc.controller,
                    builder: (context, snapshot) {
                      if(snapshot.data!=null){
                        print("seekBloc -> "+snapshot.data.toString());
                        return commonDurationIndicator(snapshot.data, 110, 2.5);
                      }
                      else{
                        return Container();
                      }

                    }
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.play_arrow,
                  size: 48.0,
                  color: colorBlack,
                ),
                padding: EdgeInsets.all(0),
                onPressed: () async {

                  showDialog(
                    context: context,
                    builder: (BuildContext context) => PlayViewSideVideoPage(
                      isFile: true,
                      url: widget.listRecordWithThumb[0].file.path,
                      cameraState: CameraState.R,
                      playIndicator: false,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );

  get editVideoButtons => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      FlatButton.icon(
          onPressed: () {
            widget.myDraft = new MyDraft();
            widget.myDraft.title = messageController.text;
            Navigator.pop(context,widget.myDraft);
          },
          icon: Icon(
            Icons.mode_edit,
            size: 14,
          ),
          label: Text(
            "Edit Video",
            style: getTextStyle(
                color: Colors.black, fontWeight: FontWeight.w600, size: 15),
          ),
          color: colorOvalBorder,
          disabledColor: colorOvalBorder,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          )),
    ],
  );

  get openingMessageText => Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 22, left: 16, right: 16),
            alignment: Alignment.centerLeft,
            child: Text(
              "Enter Description",
              style: getTextStyle(
                  color: Colors.black, size: 20, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
              padding: EdgeInsets.only(top: 14, left: 16, right: 16),
              alignment: Alignment.centerLeft,
              child: TextField(
                controller: messageController,
                maxLines: null,
                minLines: 3,
                keyboardType: TextInputType.multiline,
                style: getTextStyle(
                    color: Colors.black, size: 15, fontWeight: FontWeight.w400),
                decoration: InputDecoration.collapsed(
                  hintText: "Write a greeting to accompany your video",
                  hintStyle:
                      TextStyle(fontSize: 15.0, color: Color(0x00ffC3C3C3)),
                ),
              )

//            Text(
//              App.lorem + App.lorem + App.lorem,
//              style: getTextStyle(
//                  color: Colors.black, size: 15, fontWeight: FontWeight.w400),
//              textAlign: TextAlign.left,
//            ),
              ),
        ],
      );

  /*get bottomButtons => Container(
      height: MediaQuery.of(context).size.height/2,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 20, left: 16, right: 16),
              child: commonButton(() async {
                model.addSyloPost(
                    messageController.text.trim(),
                    widget.listRecordWithThumb[model.editIndex].file);
//              var result = await Navigator.push(
//                  context, NavigatePageRoute(context, SuccessMessagePage()));
              }, "Post to Sylo"),
            ),
            Container(
              padding: EdgeInsets.only(top: 12, left: 16, right: 16),
              child: RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                padding: EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: colorSubTextPera, width: 1.1)),
                  child: Container(
                    constraints: BoxConstraints(minHeight: 50.0),
                    alignment: Alignment.center,
                    child: Text(
                      "Cancel",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: colorSubTextPera,
                          fontWeight: FontWeight.w800,
                          fontSize: 18),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
  );*/
  get bottomButtons => Container(
    padding: EdgeInsets.only(bottom: 20.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 20, left: 16, right: 16),
          child: commonButton(() async {
            model.addSyloPost(
                messageController.text.trim(),
                widget.listRecordWithThumb[model.editIndex].file);
//              var result = await Navigator.push(
//                  context, NavigatePageRoute(context, SuccessMessagePage()));
          }, "Post to Sylo"),
        ),
        Container(
          padding: EdgeInsets.only(top: 12, left: 16, right: 16),
          child: RaisedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            padding: EdgeInsets.all(0.0),
            child: Ink(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: colorSubTextPera, width: 1.1)),
              child: Container(
                constraints: BoxConstraints(minHeight: 50.0),
                alignment: Alignment.center,
                child: Text(
                  "Cancel",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: colorSubTextPera,
                      fontWeight: FontWeight.w800,
                      fontSize: 18),
                ),
              ),
            ),
          ),
        )
      ],
    ),
  );
  @override
  Widget build(BuildContext context){
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = EditOpenMessagePageViewModel(this));

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: getColorBg(),
      appBar: AppBar(
        title: Text(
          "Opening Message",
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
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: [
            pickProfileVideo,
            editVideoButtons,
            openingMessageText,
            bottomButtons,

          ],
        ),
      ),
    );
  }

  int totalDur = 0, currDur = 0;

  Future<Function> functionGetProgress(t, p) async {
    print("total Second -> " + t.toString());
    print("current Second -> " + p.toString());
    currDur = p;
    totalDur = t;
    if(totalDur>0){
      double progressMod = currDur / totalDur;
      //seekBloc.addProgress(progressMod);
    }
    else{
      //seekBloc.addProgress(0.0);
    }

    return null;
  }

  SeekBloc seekBloc = SeekBloc();
}
