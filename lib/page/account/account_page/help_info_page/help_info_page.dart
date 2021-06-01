import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:testsylo/model/help_info_item.dart';
import 'package:testsylo/page/account/account_page/help_info_page/help_info_page_view_model.dart';

import '../../../../app.dart';

class HelpInfoPage extends StatefulWidget {
  @override
  HelpInfoPageState createState() => HelpInfoPageState();
}

class HelpInfoPageState extends State<HelpInfoPage> {
  HelpInfoPageViewModel model;

  @override
  void initState() {
    super.initState();
    model = HelpInfoPageViewModel(this);
  }

  get topTextView => Container(
    padding: EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 8),
    child: AutoSizeText(App.helpInfoInstruction,
      style: getTextStyle(
          size: 14,
          color: Colors.black,
          fontWeight: FontWeight.w400),
      textAlign: TextAlign.center,
    ),
  );

  get questionsListView => Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: ListView.builder(
            itemCount: model?.helpInfoList?.length ?? 0,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {

              HelpInfoModel item = model?.helpInfoList[index];

              return Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        item.title,
                        style: getTextStyle(
                            size: 16,
                            color: colorDark,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    model.helpInfoList[index].queList != null
                        ? ListView.builder(
                            itemCount:
                                model?.helpInfoList[index].queList?.length ?? 0,
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (BuildContext context, int subindex) {
                              return Column(
                                children: <Widget>[
//                                  Text(model.helpInfoList[index].queList[subindex].question),
                                  Container(
                                    padding: EdgeInsets.only(top: 8, bottom: 8),
                                    child: InkWell(
                                      child: Row(
                                        children: <Widget>[
                                          model.helpInfoList[index]
                                                  .queList[subindex].isChecked
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
                                          Expanded(
                                            child: Text(
                                              model.helpInfoList[index]
                                                  .queList[subindex].question,
                                              style: getTextStyle(
                                                  size: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        setState(() {
                                          model.helpInfoList[index]
                                              .queList[subindex].isChecked =
                                          !model.helpInfoList[index]
                                              .queList[subindex].isChecked;
                                        });
                                      },
                                    ),
                                  ),
                                  Visibility(
                                    visible: model.helpInfoList[index]
                                        .queList[subindex].isChecked,
                                    child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(28, 5, 4, 0),
                                        child: AutoSizeText(
                                          model.helpInfoList[index]
                                              .queList[subindex].answer,
                                          style: getTextStyle(
                                              size: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300),
                                          textAlign: TextAlign.start,
                                        )),
                                  ),
                                ],
                              );
                            })
                        : Container(height: 0)
                  ],
                ),
              );
            }),
      );

  bool isSearch = false;
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = HelpInfoPageViewModel(this));

    return Scaffold(
      backgroundColor: getColorBg(),
      appBar: AppBar(
        title: Text(
          "Help & Info",
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

          Center(
            child: Text(
              "What Can We Help You With?",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
          ),

          Container(
            margin: EdgeInsets.only(left: 32, right: 32, top: 16),
            decoration: BoxDecoration(
                border: Border.all(color: colorOvalBorder),
              borderRadius: BorderRadius.circular(10)
             ),
            child: Row(
              children: <Widget>[
                SizedBox(width: 8,),

                Expanded(
                  child: TextField(
                    onChanged: (v){
                      if(isSearch && v.isEmpty){
                        setState(() {
                          textEditingController.text = "";
                          isSearch = false;
                          model.helpInfoList = model.faqResultList;
                        });
                      }


                    },
                    controller: textEditingController,
                    cursorColor: Colors.black,
                    style: TextStyle(color: Colors.black,fontSize: 12),
                    decoration: InputDecoration(
                      hintText: 'Type keywords to find answers',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Color(0x00ff878787),fontSize: 13),
                    ),
                  ),
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child: Text(isSearch ? 'Clear' :'Submit', style: TextStyle(color: Colors.white),),
                  color: colorDark,
                  onPressed: () {

                    if(isSearch){
                      setState(() {
                        textEditingController.text = "";
                        isSearch = false;
                        model.helpInfoList = model.faqResultList;
                      });
                    }
                    else if(textEditingController.text.isNotEmpty){
                      setState(() {
                        isSearch = true;
                      });
                      model.searchFaqData(textEditingController.text);
                    }
                  },
                ),
                SizedBox(width: 4,)
              ],
            ),
          ),

          topTextView,
          questionsListView,
        ],
      )),
    );
  }
}
