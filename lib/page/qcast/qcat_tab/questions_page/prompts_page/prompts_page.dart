import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:testsylo/app.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/prompt_item.dart';
import 'package:testsylo/page/qcast/qcat_tab/questions_page/prompts_page/prompts_page_view_model.dart';
import 'package:testsylo/util/navigate_effect.dart';

import 'create_prompts_page/create_prompts_page.dart';

class PromptsPage extends StatefulWidget {
  String from = "";
  List<PromptItem> promptsItem = List();


  PromptsPage(this.from);

  @override
  PromptsPageState createState() => PromptsPageState();
}

class PromptsPageState extends State<PromptsPage> {
  PromptsPageViewModel model;

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
                    child: Container(
                      padding: EdgeInsets.all(4),
                      child: Image.asset(
                        App.ic_q,
                        width: 18,
                        height: 18,
                      ),
                    )),
              ))
            ],
          ),
        ],
      );

  get selectBanner => ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: model.listPrompt?.length??0,
        shrinkWrap: true,
        itemBuilder: (c, i) {
          PromptItem item = model.listPrompt[i];
          return Container(
              padding: EdgeInsets.only(bottom: 16),
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      setState(() {
                        item.isExpand = !item.isExpand;
                      });
                    },
                    child: Row(
                      children: <Widget>[
                        (item.isExpand)
                            ? Icon(
                                Icons.keyboard_arrow_up,
                                color: colorSubTextPera,
                                size: 24,
                              )
                            : Icon(
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
                          child: item.isCheck
                              ? commonButtonWithFilledSingleColorCorner(() {
                                  setState(() {
                                    item.isCheck = !item.isCheck;
                                    widget.promptsItem.remove(item);

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
                                  colorDark)
                              : RaisedButton(
                                  onPressed: () {
                                    setState(() {
                                      item.isCheck = !item.isCheck;

                                      widget.promptsItem.add(item);

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
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    child: Container(
                                      constraints: BoxConstraints(
                                          maxWidth: 300.0, minHeight: 50.0),
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
                  ),
                  Visibility(
                      visible: item.isExpand,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(28, 5, 4, 0),
                        child: Column(
                          children: <Widget>[
                            ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: item.prompts?.length??0,
                              shrinkWrap: true,
                              itemBuilder: (c, i) {
                                String que = item.prompts[i];
                                return AutoSizeText(
                                  App.dot + " " + que,
                                  style: getTextStyle(
                                      size: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300),
                                  textAlign: TextAlign.start,
                                );
                              },
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            /*Container(
                              height: 30,
                              width: 140,
                              child: RaisedButton(
                                onPressed: () {
                                  goToAddQue(context);
                                },
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                padding: EdgeInsets.all(0.0),
                                child: Ink(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(
                                          color: colorDark, width: 1.1)),
                                  child: Container(
                                    constraints:
                                        BoxConstraints(minHeight: 50.0),
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.add,
                                          color: colorDark,
                                          size: 12,
                                        ),
                                        Text(
                                          "Add question",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: colorDark,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )*/
                          ],
                        ),
                      ))
                ],
              ));
        },
      );

  get onLoadPromptPress => () async {
        List<PromptItem> list = List();
        model.listPrompt.forEach((element) {
          if (element.isCheck) {
            list.add(element);
          }
        });
        /*if(list.length==0){
          commonMessage(context, "By selecting prompts you can able to load prompt.");
          return;
        }*/
        if(list.length==0){
          return commonMessage(context, "Please select prompts, without prompts you can not load them.");
        }

        if(widget.from=="QcamPageState"){
          Navigator.pop(context, list);
        }
        else{
          bool isMyChannel = await model.getMyChannel();
          if(isMyChannel) {
            goToRecordQCastPage(context, runtimeType.toString(), list);
          } else {
            commonMessage(context, "Please, First create your Channel, without channel you can not create Qcast.");
          }
        }

      };

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = PromptsPageViewModel(this));

    return Scaffold(
      backgroundColor: getColorBg(),
      bottomNavigationBar: Container(
        height: 220,
        child: Column(
          children: <Widget>[
            Container(
              child: commonButtonWithCorner(() async {
                var result = await Navigator.push(
                    context,
                    NavigatePageRoute(context, CreatePromptsPage()));
                if(result!=null && result==true){
                  model.initializeLists();
                  setState(() {
                  });
                }

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
                    widget.promptsItem.length > 1 ? "Load Prompts" : "Load Prompt",
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              textBanner,
              SizedBox(
                height: 14,
              ),
              selectBanner,
              commonEndView(),
            ],
          ),
        ),
      ),
    );
  }
}
