import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testsylo/page/qcast/qcat_tab/questions_page/questions_page_view_model.dart';

import '../../../../app.dart';
import 'prompts_page/prompts_page.dart';
import 'qcasts_page/qcasts_page.dart';

class QuestionsPage extends StatefulWidget {

  String from = "";


  QuestionsPage(this.from);

  @override
  QuestionsPageState createState() => QuestionsPageState();
}

class QuestionsPageState extends State<QuestionsPage> {
  QuestionsPageViewModel model;
  int subTabIndex = 0;
  Map<int, Widget> subTabChildren;
  PageController pageSubController;

  get subTabView => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            onTap: () {
              if (subTabIndex == 0) return;
              pageSubController.animateToPage(0,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            },
            child: ClipRRect(
                child: Container(
                    width: 145,
                    height: 35,
                    decoration: BoxDecoration(
                        color:
                            subTabIndex == 0 ? colorSectionHead : Colors.white,
                        border: Border.all(
                          color: colorSectionHead,
                        ),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Center(
                        child: Text(
                      "Prompts",
                      style: TextStyle(
                          color: subTabIndex == 0
                              ? Colors.white
                              : colorSectionHead,
                          fontSize: 18),
                    )))),
          ),
          InkWell(
            onTap: () {
              if (subTabIndex == 1) return;
              pageSubController.animateToPage(1,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            },
            child: ClipRRect(
                child: Container(
                    width: 145,
                    height: 35,
                    decoration: BoxDecoration(
                        color:
                            subTabIndex == 1 ? colorSectionHead : Colors.white,
                        border: Border.all(
                          color: colorSectionHead,
                        ),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Center(
                        child: Text(
                      "Qcasts",
                      style: TextStyle(
                          color: subTabIndex == 1
                              ? Colors.white
                              : colorSectionHead,
                          fontSize: 18),
                    )))),
          )
        ],
      );

  get pageSubView => Expanded(
        child: PageView(
          controller: pageSubController,
          onPageChanged: (t) {
            setState(() {
              subTabIndex = t;
            });
          },
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            PromptsPage(widget.from),
            QcastsPage(widget.from),
          ],
        ),
      );

  @override
  void initState() {
    super.initState();

    pageSubController = PageController();
    subTabChildren = <int, Widget>{
      0: Container(
        child: Text(
          "Prompts",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      ),
      1: Container(
        width: double.infinity,
        child: Text("Qcasts", style: TextStyle(fontWeight: FontWeight.w700)),
        padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = QuestionsPageViewModel(this));

    return Scaffold(
      backgroundColor: getColorBg(),
      appBar: widget.from == "QcamPageState" ?  AppBar(
        title: Text(
          "Questions",
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
      ) : null,
      body: SafeArea(
        child: CupertinoScrollbar(
          child: Stack(
//            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
//                mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    subTabView,
                    SizedBox(height: 14,),
                    pageSubView,
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
