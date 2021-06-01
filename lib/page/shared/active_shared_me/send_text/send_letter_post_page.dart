import 'package:flutter/material.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/page/common/create_album_page.dart';
import 'package:testsylo/page/post_media/post_text/edit_letter_post_page_view_model.dart';
import 'package:testsylo/page/sylo/choose_sylo_view_all_page/choose_sylo_view_all_page.dart';
import 'package:testsylo/page/sylo/open_message_page/edit_open_message_page/success_message_page/success_message_page.dart';
import 'package:testsylo/util/navigate_effect.dart';

import '../../../../app.dart';
import 'send_letter_post_page_view_model.dart';

class SendLatterPage extends StatefulWidget {
  @override
  SendLetterPageState createState() => SendLetterPageState();
}

class SendLetterPageState extends State<SendLatterPage> {
  SendLetterPostPageViewModel model;
  var formKey = GlobalKey<FormState>();
  var messageFormKey = GlobalKey<FormState>();
  TextEditingController titleController = new TextEditingController();
  TextEditingController dateController = new TextEditingController(
      text: App.getDateByFormat(DateTime.now(), App.formatDateWithTime));
  TextEditingController messageController = new TextEditingController();
  TextEditingController messageFormController = new TextEditingController();
  bool _selectionMode = false;
  bool _letterPostView = false;

  @override
  void initState() {
    super.initState();
    model = SendLetterPostPageViewModel(this);
    /*model.initializeItems();
    model.initializeTagItems();*/
  }

  get dateView => Container(
        margin: EdgeInsets.only(top: 16, bottom: 16),
        child: Center(
            child: Text(
          App.getDateByFormat(DateTime.now(), App.formatDdMMMYY),
          style: getTextStyle(
            color: colorDark,
            size: 13,
          ),
        )),
      );

  get saveButton => Container(
        height: 50,
        child: commonButton(
          () async {
            if (!_letterPostView) {
              setState(() {
                if (!isQuickPost) {
                  messageController.text = messageFormController.text;
                }
                _letterPostView = true;
              });
            } else if (isQuickPost) {
              goToChooseSyloPage(context, "Letter");
            } else {
              model.askLetterQuestion();
              /*var result = await Navigator.push(
                  context,
                  NavigatePageRoute(
                      context,
                      SuccessMessagePage(
                        headerName: "Letter Post",
                        message: "Your Letter has been saved to Harper's Sylo",
                      )));*/
            }
          },
          _letterPostView ? "Send" : "Continue",
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
                  padding: EdgeInsets.only(top: 16),
                  child: commontextFieldLabel("Date & Time", size: 14),
                ),
                Container(
                  child: commonTextField(dateController, TextInputType.text, "",
                      enabled: false),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 16),
                  child: commontextFieldLabel("Add Title", size: 14),
                ),
                Container(
                  child: commonTextField(
                      titleController, TextInputType.text, "Enter Note title"),
                ),
                Container(
                  padding: EdgeInsets.only(top: 16, bottom: 8),
                  alignment: Alignment.centerLeft,
                  child: commontextFieldLabel("Edit Notes", size: 14),
                ),
                Container(
                  child: TextField(
                    controller: messageController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration.collapsed(
                      hintText: "Writing a greeting to accompany your video",
                      hintStyle:
                          TextStyle(fontSize: 15.0, color: Color(0x00ffC3C3C3)),
                    ),
                  ),
                )
              ],
            )),
      );

//  get messageSaveButton => Container(
//    child: commonButton(() {
////      goToChooseSyloPage(context, widget.post_type);
//      _letterPostView = true;
//    }, "Continue"),
//  );

  get messageFormView => Container(
        padding: EdgeInsets.only(top: 8, left: 16, right: 16),
        child: Form(
            key: messageFormKey,
            child: TextField(
              controller: messageFormController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration.collapsed(
                hintText: "Writing a greeting to accompany your video",
                hintStyle:
                    TextStyle(fontSize: 15.0, color: Color(0x00ffC3C3C3)),
              ),
            )),
      );

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = SendLetterPostPageViewModel(this));

    return WillPopScope(
      onWillPop: () async {
        if (_letterPostView) {
          setState(() {
            _letterPostView = false;
          });
        } else {
          Navigator.pop(context);
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: getColorBg(),
        appBar: AppBar(
          title: Text(
            !_letterPostView
                ? "Write Notes/ " +appState.sharedSyloItem.displayName ?? appState.sharedSyloItem.syloName
                : "Write Note/ " + appState.sharedSyloItem.displayName ?? appState.sharedSyloItem.syloName,
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
              if (_letterPostView) {
                setState(() {
                  _letterPostView = false;
                });
              } else {
                Navigator.pop(context);
              }
            },
          ),
          backgroundColor: Colors.white,
        ),
        floatingActionButton: Container(
          color: Colors.transparent,
          height: 60,
          alignment: Alignment.center,
          child: saveButton,
          padding: EdgeInsets.only(left: 32),
        ),
        body: SafeArea(
          child: Container(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                _letterPostView
                    ? Column(
                        children: <Widget>[
                          formView,
                        ],
                      )
                    : Column(
                        children: <Widget>[
                          messageFormView,
                        ],
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
