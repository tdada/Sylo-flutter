import 'package:flutter/material.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/prompt_item.dart';
import 'package:testsylo/page/sylo/open_message_page/open_message_page_view_model.dart';
import 'package:testsylo/util/navigate_effect.dart';

import '../../../app.dart';
import 'edit_open_message_page/edit_open_message_page.dart';
import 'prompts_page/single_prompts_page.dart';

class OpenMessagePage extends StatefulWidget {
  @override
  OpenMessagePageState createState() => OpenMessagePageState();
}

class OpenMessagePageState extends State<OpenMessagePage> {
  OpenMessagePageViewModel model;
//  TextEditingController messageController = new TextEditingController();

  get pickVideo => Container(
        child: ClipOval(
          child: Container(
            padding: EdgeInsets.all(2),
            color: colorLightRound,
            child: ClipOval(
                child: Stack(
              children: <Widget>[
                Container(
                  width: 100,
                  height: 100,
                  child: Container(
                    margin: EdgeInsets.all(30),
                    child: Image.asset(
                      App.ic_video,
                    ),
                  ),
                ),
              ],
            )),
          ),
        ),
      );

  get topText => Container(
        padding: EdgeInsets.only(top: 20, left: 16, right: 16),
        alignment: Alignment.center,
        child: Text(
          "Record your Opening Message",
          style: getTextStyle(
              color: Colors.black, size: 20, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
      );

  get intructionText => Container(
        padding: EdgeInsets.only(top: 12, left: 16, right: 16),
        child: Text(
          App.openMessageSyloInstruction,
          textAlign: TextAlign.center,
          style: getTextStyle(color: Color(0x00ffC3C3C3), size: 15),
        ),
      );

  get messageInfoBannner => Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          pickVideo,
          topText,
          intructionText,
        ],
      );

  /*get inputTextField => Container(
        padding: EdgeInsets.only(top: 20, left: 16, right: 16),
        child: TextField(
          controller: messageController,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration.collapsed(
            hintText: "Writing a greeting to accompany your video",
            hintStyle: TextStyle(fontSize: 15.0, color: Color(0x00ffC3C3C3)),
          ),
        ),
      );*/

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = OpenMessagePageViewModel(this));
    return Scaffold(
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
      bottomNavigationBar: Container(
        height: 55,
        child: commonButton(() async {
//          appState.addSyloItem.openingMsg = messageController.text.trim();
          //var result = await Navigator.push(context, NavigatePageRoute(context, SinglePromptsPage(from: runtimeType.toString(),)));
          List<PromptItem> list = List();
          goToRecordQCastPage(context, runtimeType.toString(), list);
        }, "Record Video"),
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
        ),
        margin: EdgeInsets.only(bottom: 16),
      ),
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                messageInfoBannner,
//                inputTextField,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
