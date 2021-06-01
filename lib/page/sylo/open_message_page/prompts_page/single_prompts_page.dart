import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/prompt_item.dart';
import 'package:testsylo/page/qcast/qcat_tab/questions_page/qcasts_page/qcasts_video_record_page/qcasts_video_record_page.dart';
import 'package:testsylo/page/qcast/qcat_tab/questions_page/que_ans_record/que_ans_record_page.dart';
import 'package:testsylo/page/sylo/open_message_page/edit_open_message_page/edit_open_message_page.dart';
import 'package:testsylo/page/sylo/open_message_page/prompts_page/single_prompts_page_view_model.dart';
import 'package:testsylo/util/navigate_effect.dart';

import '../../../../app.dart';

class SinglePromptsPage extends StatefulWidget {
  String from;
  SinglePromptsPage({this.from});

  @override
  SinglePromptsPageState createState() => SinglePromptsPageState();
}

class SinglePromptsPageState extends State<SinglePromptsPage> {
  SinglePromptsPageViewModel model;

  get textBanner => Column(
        children: <Widget>[
          AutoSizeText(
            App.promptsTopLabel,
            style: getTextStyle(
              size: 13,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "To return here simply click",
                style: getTextStyle(
                  size: 16,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                width: 5,
              ),
              Center(
                  child: new InkWell(
                onTap: () => print("Click on button"),
                child: new Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[400],
                          offset: Offset(0.0, 1.0),
                          blurRadius: 4.0,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      App.ic_q_prompts,
                      width: 24,
                      height: 24,
                    )),
              ))
            ],
          ),
        ],
      );

  get selectBanner => Container(
    padding: EdgeInsets.only(top: 8),
    child: ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: model.listPrompt.length,
      shrinkWrap: true,
      itemBuilder: (c, i) {
        PromptItem item = model.listPrompt[i];
        return Container(
            padding: EdgeInsets.only(bottom: 16),
            child:
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    (item.isCheck ) ?Icon(
                      Icons.keyboard_arrow_up,
                      color: colorSubTextPera,
                      size: 24,
                    ):Icon(
                      Icons.keyboard_arrow_down,
                      color: colorSubTextPera,
                      size: 24,
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        item.text,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Container(
                      height: 25,
                      width: 70,
                      child: item.isCheck?commonButtonWithFilledSingleColorCorner(
                              () {
                            setState(() {
                              item.isCheck = !item.isCheck;
                            });
                          },
                          Text(
                            "Selected",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 13),
                          ),
                          colorDark
                      ):RaisedButton(
                        onPressed: () {
                          setState(() {
                            item.isCheck = !item.isCheck;
                          });
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        padding: EdgeInsets.all(0.0),
                        child: Ink(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xff9F00C5),
                                  Color(0xff9405BD),
                                  Color(0xff7913A7),
                                  Color(0xff651E96),
                                  Color(0xff522887)
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Container(
                            constraints:
                            BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                            alignment: Alignment.center,
                            child: Text(
                              "Select",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13),
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
                Visibility(
                    visible:  item.isCheck,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(28, 5, 4, 0),
                      child: Column(
                        children: <Widget>[
                          ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: model.listPromptQuestions.length,
                            shrinkWrap: true,
                            itemBuilder: (c, i) {
                              return AutoSizeText(
                                App.dot+" "+model.listPromptQuestions[i],
                                style: getTextStyle(
                                    size: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300
                                ),
                                textAlign: TextAlign.start,
                              );
                            },
                          ),
                          SizedBox(height: 12,),
                          Container(
                            height: 30,
                            width: 140,
                            child: RaisedButton(
                              onPressed: () {
                                goToAddQue(context);
                              },
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                              padding: EdgeInsets.all(0.0),
                              child: Ink(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(color: colorDark, width: 1.1)

                                ),
                                child: Container(
                                  constraints: BoxConstraints(minHeight: 50.0),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.add,color: colorDark,size: 12,),
                                      Text(
                                        "Add question",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: colorDark,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 12
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),)
                        ],
                      ),
                    )
                )
              ],
            )
        );
      },
    ),
  );

  get onLoadPromptPress => (){
    //goToQueAnsPage(context, runtimeType.toString(), App.status_only_record_trim);
    List<PromptItem> list = List();
    model.listPrompt.forEach((element) {
      if (element.isCheck) {
        list.add(element);
      }
    });
   /* if(list.length==0){
      commonMessage(context, "By selecting prompts you can able to load prompt.");
      return;
    }*/
//    goToRecordQCastPage(context, runtimeType.toString(), list);
    if(widget.from == "OpenMessagePageState") {
      goToRecordQCastPage(context, widget.from, list);
    } else {
      goToRecordQCastPage(context, runtimeType.toString(), list);
    }
  };


  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = SinglePromptsPageViewModel(this));

    return Scaffold(
      backgroundColor: getColorBg(),
      appBar: AppBar(
        title: Text(
          "Prompts",
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
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                textBanner,
                selectBanner,
                Container(
                  child: commonButtonWithCorner(
                          () {

                        createNewPrompt(context);

                      },
                      "Create New Prompt",
                      Icon(
                        Icons.add,
                        size: 24,
                        color: colorDark,
                      )),
                  padding: EdgeInsets.only(top: 12),
                ),
                Container(
                  child: commonButtonWithFilledSingleColorCorner(
                      onLoadPromptPress,
                      Text(
                        "Load Prompt",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 18),
                      ),
                      colorDark),
                  padding: EdgeInsets.only(top: 12),
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}
