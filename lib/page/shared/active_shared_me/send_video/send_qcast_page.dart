import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:circle_list/circle_list.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/common/play_video.dart';
import 'package:testsylo/model/record_file_item.dart';
import 'package:testsylo/page/qcast/qcat_tab/my_channel_page/review_qcast_page/review_qcast_page_view_model.dart';

import '../../../../app.dart';
import 'send_qcast_page_view_model.dart';

class SendQcastPage extends StatefulWidget {
  List<RecordFileItem> listRecordWithThumb = List();

  SendQcastPage(this.listRecordWithThumb);

  @override
  SendQcastPageState createState() => SendQcastPageState();
}

class SendQcastPageState extends State<SendQcastPage> {
  SendQcastPageViewModel model;
  bool thumbnailDefault = false;
  var formKey = GlobalKey<FormState>();
  TextEditingController nameController = new TextEditingController();

  get borderCircle => ClipOval(
    child: Container(
      padding: EdgeInsets.all(1),
      color: colorOvalBorder2,
      child: ClipOval(
        child: Container(
          color: Colors.white,
//          height: MediaQuery.of(context).size.width - 80,
//          width: MediaQuery.of(context).size.width - 80,
        ),
      ),
    ),
  );

  Widget get circularList {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned.fill(
                  child: Container(
                    margin: EdgeInsets.all(40),
                    child: borderCircle,
                  )
              ),
              CircleList(
                origin: Offset(0, 0),
                outerRadius: 185,
                children: List.generate(widget.listRecordWithThumb.length, (index) {
                  RecordFileItem item = widget.listRecordWithThumb[index];
                  return InkWell(
                    onTap: () {
                      setState(() {
                        model.editIndex = -1;
                      });

                      Future.delayed(
                          const Duration(milliseconds: 400), () {
                        setState(() {
                          model.editIndex = index;
                        });
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ClipOval(
                          child: Container(
                            child: ClipOval(
                              child: Image.file(
                                item.thumbPath,
                                fit: BoxFit.cover,
                                width: 54,
                                height: 54,
                              ),
                            ),
                            padding: EdgeInsets.all(4),
                            color: index == model.editIndex
                                ? colorOvalBorder2
                                : colorOvalBorder,
                          ),
                        ),

                      ],
                    ),
                  );
                }),
                centerWidget: Stack(
                  children: <Widget>[
                    ClipOval(
                      child: Container(
                        child: InkWell(
                          child: ClipOval(
                            child: Container(
                              width: 125,
                              height: 125,
                              child: model.editIndex==-1 ? Container(child: CircularProgressIndicator(), width: 24, height: 24, alignment: Alignment.center,) : PlayVideoPage(
                                url: widget
                                    .listRecordWithThumb[model.editIndex].file.path,
                                isFile: true,
                              ),
                            ),
                          ),
                        ),
                        padding: EdgeInsets.all(3),
                        color: colorOvalBorder,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  get thumbCircularList => Container(
    height: 200,
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            CircleList(

              children:
                  List.generate(widget.listRecordWithThumb.length, (index) {
                RecordFileItem item = widget.listRecordWithThumb[index];
                return InkWell(
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ClipOval(
                        child: Container(
                          child: ClipOval(
                            child: Image.file(
                              item.thumbPath,
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                            ),
                          ),
                          padding: EdgeInsets.all(3),
                          color: colorOvalBorder,
                        ),
                      ),
                    ],
                  ),
                );
              }),

            /*  centerWidget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ClipOval(
                    child: Container(
                      width: 100,
                      height: 100,
                      child: InkWell(
                        child: ClipOval(
                          child: PlayVideoPage(
                            url: widget
                                .listRecordWithThumb[model.editIndex].file.path,
                            isFile: true,
                          ),
                        ),
                        onLongPress: () {},
                      ),
                      padding: EdgeInsets.all(3),
                      color: colorOvalBorder,
                    ),
                  ),
                ],
              ),*/
            ),
          ],
        ),
      );

  get titleField => Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 16, left: 8),
            alignment: Alignment.centerLeft,
            child: commontextFieldLabel("Add Title", size: 14),
          ),
          Container(
            padding: EdgeInsets.only(left: 8),
            child: commonTextField(
                nameController, TextInputType.text, "Enter Title"),
          ),
        ],
      );

  get exampleQuestionField => Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 16, left: 8),
            alignment: Alignment.centerLeft,
            child: commontextFieldLabel("Write 3 example questions", size: 14),
          ),
          Container(
            padding: EdgeInsets.only(left: 8),
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: model.reviewQuestionsList.length,
              shrinkWrap: true,
              itemBuilder: (c, i) {
                int n = i + 1;
                return Container(
                  padding: EdgeInsets.only(top: 6),
                  child: AutoSizeText(
                    n.toString() + ". " + model.reviewQuestionsList[i],
                    style: getTextStyle(
                        size: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w300),
                    textAlign: TextAlign.start,
                  ),
                );
              },
            ),
          ),
        ],
      );

  get editAddButtons => Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              height: 25,
              child: FlatButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.mode_edit,
                    size: 14,
                  ),
                  label: Text(
                    "Edit Video",
                    style: getTextStyle(
                        size: 13,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                  color: colorOvalBorder,
                  disabledColor: colorOvalBorder,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  )),
            ),

          ],
        ),
      );

  get savePublishButton => Container(
    padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
    child: Container(child: commonButton(() {
      if(widget.listRecordWithThumb.length==0) {
        commonMessage(context,"Please add at least one video.");
        return;
      }
      model.askQcastQuestion();
    },
        "Send"), height: 50,),
  );

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = SendQcastPageViewModel(this));

    return Scaffold(
      backgroundColor: getColorBg(),
      appBar: AppBar(
        title: Text(

          appState.sharedSyloItem.displayName ?? appState.sharedSyloItem.syloName!=null?"Record Qcast/ "+appState.sharedSyloItem.displayName ?? appState.sharedSyloItem.syloName:"Record Qcast",
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
      bottomNavigationBar: savePublishButton,
      body: SafeArea(
        child: CupertinoScrollbar(
            child: Container(

          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              circularList,
              Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[


                      editAddButtons,

                      titleField,


                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),


            ],
          ),
        )),
      ),
    );
  }

  Widget imageButtonWidget(
      VoidCallback onPressed, String buttontext, bool defaultImage,
      [File imagePath, String image = ""]) {
    return Row(
      children: <Widget>[
        ClipOval(
          child: Container(
            child: ClipOval(
              child: Stack(
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    height: 75,
                    width: 75,
                  ),
                  defaultImage
                      ? Image.asset(
                          App.ic_placeholder,
                          fit: BoxFit.cover,
                          width: 75,
                          height: 75,
                        )
                      : imagePath != null
                          ? Container(
                              width: 75,
                              height: 75,
                              child: fileWidget(imagePath, 125.0, 125.0))
                          : Container(
                              color: Colors.white,
                              height: 75,
                              width: 75,
                            )
                ],
              ),
            ),
            padding: EdgeInsets.all(3),
            color: colorOvalBorder,
          ),
        ),
        SizedBox(
          width: 12,
        ),
        InkWell(
          onTap: onPressed,
          child: ClipRRect(
              child: Container(
                  width: 145,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: colorDark,
                      ),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Center(
                      child: Text(
                    buttontext,
                    style: TextStyle(
                        color: colorDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  )))),
        ),
      ],
    );
  }

  void commonAlert(BuildContext context, VoidCallback onPressSelectVideo,
      VoidCallback onPressUpload, VoidCallback onPressRandom) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Generate Thumbnail",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 20),
                Container(
                  height: 25,
                  child: FlatButton(
                      onPressed: () {
                        onPressSelectVideo.call();
                        Navigator.of(context).pop(true);
                      },
                      child: Text("Select from video"),
                      color: colorOvalBorder,
                      disabledColor: colorOvalBorder,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      )),
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  height: 25,
                  child: FlatButton(
                      onPressed: () {
                        onPressUpload.call();
                        Navigator.of(context).pop(true);
                      },
                      child: Text("Upload"),
                      color: colorOvalBorder,
                      disabledColor: colorOvalBorder,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      )),
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  height: 25,
                  child: FlatButton(
                      onPressed: () {
                        onPressRandom.call();
                        Navigator.of(context).pop(true);
                      },
                      child: Text("Random "),
                      color: colorOvalBorder,
                      disabledColor: colorOvalBorder,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      )),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
