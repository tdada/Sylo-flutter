import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:circle_list/circle_list.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/common/play_video.dart';
import 'package:testsylo/model/prompt_item.dart';
import 'package:testsylo/model/record_file_item.dart';
import 'package:testsylo/page/qcast/qcat_tab/my_channel_page/review_qcast_page/review_qcast_page_view_model.dart';
import 'package:testsylo/page/sylo/open_message_page/edit_open_message_page/success_message_page/success_message_page.dart';
import 'package:testsylo/util/navigate_effect.dart';

import '../../../../../app.dart';
import 'review_qcast_prompt_page_view_model.dart';

class ReviewQcastPromptPage extends StatefulWidget {
  List<RecordFileItem> listRecordWithThumb = List();
  List<PromptItem> listPrompt = List();

  ReviewQcastPromptPage(this.listRecordWithThumb, this.listPrompt);

  @override
  ReviewQcastPromptPageState createState() => ReviewQcastPromptPageState();
}

class ReviewQcastPromptPageState extends State<ReviewQcastPromptPage> {
  ReviewQcastPromptPageViewModel model;
  bool thumbnailDefault = false;
  var formKey = GlobalKey<FormState>();

  TextEditingController messageController = TextEditingController(text: App.lorem);

  Widget get circularList {
    return Container(
      padding: EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ClipOval(
                child: Container(
                  child: InkWell(
                    child: ClipOval(
                      child: Container(
                        width: 125,
                        height: 125,
                        child: model.editIndex == -1
                            ? Container(
                                child: CircularProgressIndicator(),
                                width: 24,
                                height: 24,
                                alignment: Alignment.center,
                              )
                            : PlayVideoPage(
                                url: widget.listRecordWithThumb[model.editIndex]
                                    .file.path,
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
          )
        ],
      ),
    );
  }

  get editAddButtons => Padding(
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
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


  get onPressedSylo => () async {
//    model.addSyloPost(
//        messageController.text.trim(),
//        widget.listRecordWithThumb[model.editIndex].file);
    var result = await Navigator.push(
                  context, NavigatePageRoute(context, SuccessMessagePage()));
  };



  get onPressCancel => () {

    goToHome(context, null);

  };

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = ReviewQcastPromptPageViewModel(this));

    return Scaffold(
      backgroundColor: getColorBg(),
      appBar: AppBar(
        title: Text(
          "Review",
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
        child: CupertinoScrollbar(
            child: Container(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Container(
                alignment: Alignment.topCenter,
                height: 30,
                child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemCount: widget.listPrompt.length,
                  itemBuilder: (c, i) {
                    PromptItem item = widget.listPrompt[i];
                    return Container(
                      child: Center(
                          child: Text(
                        item.text,
                        style: getTextStyle(
                            color: Colors.black,
                            size: 14,
                            fontWeight: FontWeight.w800),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                      padding: EdgeInsets.only(left: 16),
                    );
                  },
                ),
              ),
              circularList,
              Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      editAddButtons,
                      Container(
                          padding: EdgeInsets.only(top: 16, bottom: 8),
                          alignment: Alignment.centerLeft,
                          child: Container(
                            height: 20,
                            child: Text(
                              "Edit Opening Message",
                              style:
                                  getTextStyle(color: Colors.black, size: 18),
                            ),
                          )),
                      Container(
                        child: TextField(
                          controller: messageController,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration.collapsed(
                            hintText: "Enter here",
                            hintStyle: TextStyle(
                                fontSize: 15.0, color: Color(0x00ffC3C3C3)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                child: commonButton(onPressedSylo, "Post to Sylo"),
                padding: EdgeInsets.only(top: 16, left: 16, right: 16),
              ),
              Container(
                child: commonButtonWithCorner(onPressCancel, "Cancel", null, color: colorDisable),
                padding: EdgeInsets.only(top: 16, left: 16, right: 16),
              ),
              SizedBox(
                height: 24,
              )
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
                      child: Text("Random"),
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
