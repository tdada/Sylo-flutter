import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:circle_list/circle_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:testsylo/animation/const/size_const.dart';
import 'package:testsylo/common/bottom_bar_view.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/model/slider_item.dart';
import 'package:testsylo/page/dashboard/sylo_action_circular_page/sylo_action_circular_page.dart';
import 'package:testsylo/page/sylo/add_sylo_page/add_sylo_page.dart';
import 'package:testsylo/page/sylo/view_sylo_page/view_sylo_page.dart';
import 'package:testsylo/util/navigate_effect.dart';
import 'package:testsylo/util/util.dart';


import '../../app.dart';
import 'home_sylo_page_view_model.dart';

class HomeSyloPage extends StatefulWidget {
  String from;
  AnimationController _controller;
  Function(int index, GetUserSylos sylo) callBack;

  HomeSyloPage({this.from, this.callBack});

  @override
  HomeSyloPageState createState() => HomeSyloPageState();
}

class HomeSyloPageState extends State<HomeSyloPage> with SingleTickerProviderStateMixin  {
  HomeSyloPageViewModel model;

  AnimationController controller;
  Animation heartbeatAnimation;
  PageController pageController;
  int currentPage;
  bool isVisible=false;

  get borderCircle => ClipOval(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
            border: Border.all(color: Colors.white),
          ),
          child: Container(
            color: Colors.transparent,
            //height: MediaQuery.of(context).size.width - 80,
            //width: MediaQuery.of(context).size.width - 80,
          ),
        ),
      );

  @override
  void initState() {
    super.initState();
    model = HomeSyloPageViewModel(this);
    appState.userSylo = null;
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    heartbeatAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(controller);
    controller.forward().whenComplete(() {
      controller.reverse();
    });
    currentPage = 0;
    pageController = PageController(initialPage: currentPage, keepPage: true);
  }

  Widget get gridList {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 1.35,
          padding: EdgeInsets.all(10),
          child: CupertinoScrollbar(
            child: ListView(
              children: [
                Column(
                  children: <Widget>[
                    GridView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: model?.gridgetUserSylosList?.length ?? 0,
                      gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, childAspectRatio: 0.72),
                      shrinkWrap: true,
                      itemBuilder: (c, i) {
                        GetUserSylos item = model.gridgetUserSylosList[i];
                        String postText =
                            item.albumCount > 1 ? " posts" : " post";
                        return Container(
                          padding: EdgeInsets.only(top: 5),
                          child: GestureDetector(
                            onTap: () {
                              onTapAt(model.gridgetUserSylosList[i]);
                            },
                            child: Column(
                              children: <Widget>[
                                ClipOval(
                                  child: Container(
                                    child: ClipOval(
                                      child: Container(
                                        height: 70,
                                        width: 70,
                                        child: ImageFromNetworkView(
                                          path: item.syloPic,
                                          boxFit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    padding: EdgeInsets.all(3),
                                    color: colorOvalBorder,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                AutoSizeText(
                                  getMultilineFixCharacter(item.displayName ?? item.syloName),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: getTextStyle(
                                      size: 11,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700),
//                            overflow: TextOverflow.ellipsis,
                                ),
                                Container(
                                  child: Text(
                                    item.syloAge,
                                    maxLines: 1,
                                    style: getTextStyle(
                                        color: Color(0x00ff707070),
                                        size: 11,
                                        fontWeight: FontWeight.w500),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  padding: EdgeInsets.only(top: 1),
                                ),
                                Container(
                                  child: Text(
                                    item.albumCount.toString() + postText,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: getTextStyle(
                                        color: Color(0x00ff707070),
                                        size: 11,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  padding: EdgeInsets.only(top: 1),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 75,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget get circularList {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            /*Positioned.fill(
                child: Container(
              margin: EdgeInsets.all(20),
              child: borderCircle,
            )),*/
            CircleList(
              origin: Offset(1, 1),
              //showInitialAnimation: true,
              //animationSetting: AnimationSetting(duration: Duration(seconds: 100), curve: Curves.ease),
              children: List.generate(model.getUserSylosList.length, (index) {

                //model.getUserSylosList=model.chunkgetUserSylosList[currentPage];
                GetUserSylos item = model.getUserSylosList[index];
                return GestureDetector(
                  onTap: () {
                    onTapAt(item);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ClipOval(
                        child: Container(
                          child: ClipOval(
                            child: Container(
                              height: 80,
                              width: 80,
                              child: ImageFromNetworkView(
                                path: item.syloPic,
                                boxFit: BoxFit.cover,
                              ),
                            ),
                          ),
                          //padding: EdgeInsets.all(3),
                          color: colorOvalBorder,
                        ),
                      ),
                      Container(
                        child:AutoSizeText(
                          getMultilineFixCharacter(item.displayName ?? item.syloName),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: getTextStyle(
                              size: 11,
                              color: Colors.black,
                              fontWeight: FontWeight.w700),
//                            overflow: TextOverflow.ellipsis,
                        ),

//                          width: 50,

                        alignment: Alignment.center,
                      )
                    ],
                  ),
                );
              }),
              centerWidget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ClipOval(
                    child: Container(
                      child: InkWell(
                        child: ClipOval(
                          child: Container(
                            height: 80,
                            width: 80,
                            child: ImageFromNetworkView(
                              path: appState.userItem.profilePic != null
                                  ? appState.userItem.profilePic
                                  : "",
                              boxFit: BoxFit.cover,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(PageRouteBuilder(
                              opaque: false, // set to false
                              pageBuilder: (_, __, ___) =>
                                  SyloActionCircularPage()));
                        },
                      ),
                      padding: EdgeInsets.all(3),
                      color: colorOvalBorder,
                    ),
                  ),
                  Container(
                    child: Text(
                      appState.userItem.username,
                      style: getTextStyle(
                          color: Colors.black,
                          size: 13,
                          fontWeight: FontWeight.w500),
                    ),
                    padding: EdgeInsets.only(top: 7),
                  )
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  onTapAt(GetUserSylos sylo) async {
    print("syloID --> " + sylo.syloId.toString());
    widget.callBack(6, sylo);
    /*var result = await Navigator.push(
        context, NavigatePageRoute(context, ViewSyloPage(userSylo:sylo)));*/
  }



  @override
  Widget build(BuildContext context) {
    print("runtimeType123 -> " + runtimeType.toString());
    model ?? (model = HomeSyloPageViewModel(this));

    return Scaffold(
      appBar: customAppBar(),
      backgroundColor: colorWhite,
      body: SafeArea(
        child: model.isGrid
            ? ListView(
                shrinkWrap: true,
                children: <Widget>[
                  gridList,
                  commonEndView(),
                ],
              )
            :
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Column(
                      children: [
                        Container(
                          height: 430,
                          child: PageView.builder(
                                      scrollDirection: Axis.horizontal,
                                      physics: NeverScrollableScrollPhysics(),
                                      controller: pageController,
                                      itemCount: model.chunkgetUserSylosList.length,
                                      onPageChanged: (index) {
                                      setState(() {
                                          currentPage = index;
                                          model.getUserSylosList=model.chunkgetUserSylosList[currentPage];
                                          if(currentPage>=1)
                                            {
                                              isVisible=true;
                                            }
                                          else{

                                              isVisible=false;
                                          }
                                      });
                                      },
                                      itemBuilder: (BuildContext context, int index) {
                                        return Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [

                                            circularList
                                          ],
                                        );

                                      }),
                          ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  if(currentPage <= model.chunkgetUserSylosList.length-1) {
                                    currentPage--;
                                    pageController.animateToPage(currentPage,
                                        duration: Duration(milliseconds: 800),
                                        curve: Curves.easeInOut);
                                  }
                                },
                                child: Visibility(
                                  visible: isVisible,
                                  child: Container(
                                    //margin: EdgeInsets.only(top: 20),
                                    child: Icon(
                                    Icons.chevron_left,
                                    color: Colors.purple,
                                    size: 60,
                                  ),

                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  if(currentPage < model.chunkgetUserSylosList.length-1) {
                                    currentPage++;
                                    pageController.animateToPage(currentPage,
                                        duration: Duration(milliseconds: 800),
                                        curve: Curves.easeIn);
                                  }
                                },
                                child:
                                model.chunkgetUserSylosList.length >= 1 && currentPage < model.chunkgetUserSylosList.length-1 ? Container(
                                  //margin: EdgeInsets.only(top: 20),
                                  child: Icon(
                                  Icons.chevron_right,
                                  color: Colors.purple,
                                  size: 60,
                                ),

                                ):Container(),
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )

        ,



      ),
    );
  }

  Widget customAppBar() {
    return AppBar(
        flexibleSpace: Platform.isAndroid?
        Container(
      color: colorWhite,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 16,
          ),
          InkWell(
            child: commonGradButtonWithIcon(
                App.ic_eye, model.isGrid ? "Circular" : "Grid"),
            onTap: () {
              setState(() {
                model.isGrid = !model.isGrid;
              });
            },
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Text(
              App.app_name,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 17),
            ),
          ),
          SizedBox(
            width: 16,
          ),
          InkWell(
            child: commonGradButtonWithIcon(App.ic_add, "Add Sylo"),
            onTap: () async {
              var result = await Navigator.push(
                  context, NavigatePageRoute(context, AddSyloPage()));
            },
          ),
          SizedBox(
            width: 16,
          ),
        ],
      ),
    ):Container(
          margin: EdgeInsets.only(top: 45),
      color: colorWhite,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 16,
          ),
          InkWell(
            child: commonGradButtonWithIcon(
                App.ic_eye, model.isGrid ? "Circular" : "Grid"),
            onTap: () {
              setState(() {
                model.isGrid = !model.isGrid;
              });
            },
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Text(
              App.app_name,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 17),
            ),
          ),
          SizedBox(
            width: 16,
          ),
          InkWell(
            child: commonGradButtonWithIcon(App.ic_add, "Add Sylo"),
            onTap: () async {
              var result = await Navigator.push(
                  context, NavigatePageRoute(context, AddSyloPage()));
            },
          ),
          SizedBox(
            width: 16,
          ),
        ],
      ),
    )
    );
  }




  int getLength() {
    if (model.getUserSylosList == null) {
      return 0;
    } else if (model.getUserSylosList.length >= 10) {
      return 10;
    } else {
      return model.getUserSylosList.length;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();

  }

}
