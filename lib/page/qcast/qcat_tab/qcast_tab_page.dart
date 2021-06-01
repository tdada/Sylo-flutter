import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:testsylo/model/slider_item.dart';
import 'package:testsylo/page/qcast/qcat_tab/questions_page/questions_page.dart';

import '../../../app.dart';
import 'discover_page/dsicover_page.dart';
import 'my_channel_page/my_channel_page.dart';
import 'qcast_tab_page_view_model.dart';

class QcastTabPage extends StatefulWidget {
  int tabIndex = 0;
  QcastTabPage({this.tabIndex});
  @override
  QcastTabPageState createState() => QcastTabPageState();
}

class QcastTabPageState extends State<QcastTabPage> {
  QcastTabPageViewModel model;
  int tabIndex;
  Map<int, Widget> children;
  PageController pageController;

  get tabView => Container(

    /* child: CupertinoSegmentedControl(
                      onValueChanged: (t) {
                        pageController.animateToPage(t,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease);
                      },
                      unselectedColor: Colors.white,

                      children: children,
                      groupValue: tabIndex,
                    ),*/

    child: Column(
      children: <Widget>[
        Container(
          height: 2,
          color: colorDark,
        ),
        Expanded(
          child: Row(


            children: <Widget>[



              Expanded(
                child: InkWell(
                  onTap: (){
                    if(tabIndex==0)return;
                    pageController.animateToPage(0,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease);
                  },
                  child: Container(
                    alignment: Alignment.center,


                    height: double.infinity,
                    color: tabIndex==0 ? colorDark : Colors.white,


                    child: Text("Browse", style: getTextStyle(color: tabIndex==0 ? Colors.white : colorDark, fontWeight: FontWeight.w900, size: 17),),
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                color: colorDark,
                width: 2,
              ),
              Expanded(
                child: InkWell(
                  onTap: (){

                    if(tabIndex==1)return;
                    pageController.animateToPage(1,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease);

                  },
                  child: Container(
                    height: double.infinity,
                    alignment: Alignment.center,

                    color: tabIndex==1 ? colorDark : Colors.white,


                    child: Text("My Channel", style: getTextStyle(color: tabIndex==1 ? Colors.white : colorDark, fontWeight: FontWeight.w900, size: 17),),

                  ),
                ),
              ),
              Container(
                height: double.infinity,
                color: colorDark,
                width: 2,
              ),
              Expanded(
                child: InkWell(
                  onTap: (){

                    if(tabIndex==2)return;
                    pageController.animateToPage(2,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease);

                  },
                  child: Container(

                    alignment: Alignment.center,
                    height: double.infinity,

                    color: tabIndex==2 ? colorDark : Colors.white,

                    child: Text("Questions", style: getTextStyle(color: tabIndex==2 ? Colors.white : colorDark, fontWeight: FontWeight.w900, size: 17),),

                  ),
                ),
              ),




            ],



          ),
        ),
        Container(
          height: 2,
          color: colorDark,
        ),
      ],
    ),

    height: 50,
  );

  get pageView => Expanded(
    child: PageView(
      controller: pageController,
      onPageChanged: (t) {
        setState(() {
          tabIndex = t;
        });
      },
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        DiscoverPage(),
        MyChannelPage(),
        QuestionsPage(runtimeType.toString()),
      ],
    ),
  );

  @override
  void initState() {
    super.initState();

    tabIndex = widget.tabIndex??0;
    pageController = PageController(initialPage: tabIndex);
    children = <int, Widget>{
      0: Container(
        child: Text(
          "Discover",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      ),
      1: Container(
        width: double.infinity,
        child:
            Text("My Channel", style: TextStyle(fontWeight: FontWeight.w700)),
        padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      ),
      2: Container(
        width: double.infinity,
        child: Text("Questions", style: TextStyle(fontWeight: FontWeight.w700)),
        padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      )
    };
  }

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = QcastTabPageViewModel(this));

    return Scaffold(
      backgroundColor: getColorBg(),
      appBar: AppBar(
        title: Text(
          "Qcast Dashboard",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w800, fontSize: 17),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: CupertinoScrollbar(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  tabView,
                  pageView,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
