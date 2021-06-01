import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/page/shared/shared_page_view_model.dart';
import 'package:testsylo/page/sylo/add_sylo_page/add_sylo_page.dart';
import 'package:testsylo/util/navigate_effect.dart';

import '../../app.dart';
import 'active_own/active_sylo_shared_own.dart';
import 'active_shared_me/active_shared_me_sylo_page.dart';
import 'completed_sylo/opening_message_view_sylo_page/opening_message_view_sylo_page.dart';

class SharedPage extends StatefulWidget {
  @override
  SharedPageState createState() => SharedPageState();
}

class SharedPageState extends State<SharedPage> {
  SharedPageViewModel model;

  get ownSyloView => Container(
    color: Colors.white,
        height: 155,
        padding: EdgeInsets.only(
          top: t,
        ),
        child: Container(

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  "Sylos you own",
                  style: getTextStyle(
                      size: 15,
                      fontWeight: FontWeight.w800,
                      color: Colors.black),
                ),
                padding: EdgeInsets.only(left: l),
              ),
              SizedBox(
                height: 12,
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemCount: model.activeSylos?.length ?? 0,
                  /*  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, childAspectRatio: 0.5),
               */
                  shrinkWrap: true,
                  itemBuilder: (c, i) {
                    SharedSyloItem activeSylo = model.activeSylos[i];
                    return Container(
                      padding: EdgeInsets.only(left: 24),
                      child: Stack(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              InkWell(
                                onTap: () async {
                                  var result = await Navigator.push(
                                      context,
                                      NavigatePageRoute(
                                          context, ActiveSyloSharedOwnPage(activeSylo: activeSylo)));
                                },
                                child: ClipOval(
                                  child: Container(
                                    child: Stack(
                                      children: <Widget>[
                                        ClipOval(
                                          child: Container(
                                              color: Colors.white,
                                              height: 75,
                                              width: 75,

                                              child: ImageFromNetworkView(
                                                path: activeSylo.syloPic ?? "",
                                                boxFit: BoxFit.cover,
                                              )),
                                        ),
                                      ],
                                    ),
                                    color: colorOvalBorder,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Container(
                                width: 75,
                                child: AutoSizeText(
                                  activeSylo.displayName ?? activeSylo.syloName,
                                  style: getTextStyle(
                                      color: activeSylo.active ? Colors.black : Colors.red,
                                      size: 14,
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                padding: EdgeInsets.only(top: 3),
                              ),
                            ],
                          ),
                          activeSylo.questionCount != "0"
                              ? Positioned(
                                  child: ClipOval(
                                    child: Container(
                                      child: AutoSizeText(
                                        activeSylo.questionCount ?? "0",
                                        style: getTextStyle(
                                          color: colorSectionHead,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        minFontSize: 6,
                                        maxFontSize: 12,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      color: colorOvalBorder,
                                      alignment: Alignment.center,
                                      width: 20,
                                      height: 20,
                                      padding: EdgeInsets.only(top: 3),
                                    ),
                                  ),
                                  right: 1,
                                  top: 1,
                                )
                              : Container(
                                  height: 0,
                                  width: 0,
                                )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );

  get sharedSyloView => Container(

        height: 175,
        padding: EdgeInsets.only(
          top: 8,
        ),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  "Sylos shared with you",
                  style: getTextStyle(
                      size: 15,
                      fontWeight: FontWeight.w800,
                      color: Colors.black),
                ),
                padding: EdgeInsets.only(left: l),
              ),
              SizedBox(
                height: 12,
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemCount: model.sharedSylos?.length ?? 0,
                  /*  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, childAspectRatio: 0.5),
               */
                  shrinkWrap: true,
                  itemBuilder: (c, i) {
                    SharedSyloItem sharedSylo = model.sharedSylos[i];
                    return Container(
                      padding: EdgeInsets.only(left: 24, right: 16),
                      child: Stack(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              InkWell(
                                onTap: () async {
                                  var result = await Navigator.push(
                                      context,
                                      NavigatePageRoute(
                                          context, ActiveSharedMeSyloPage(sharedSyloItem: sharedSylo)));
                                },
                                child: ClipOval(
                                  child: Container(
                                    child: Stack(
                                      children: <Widget>[
                                        ClipOval(
                                          child: Container(
                                            color: Colors.white,
                                            height: 75,
                                            width: 75,
                                            child: ImageFromNetworkView(
                                              path: sharedSylo.syloPic ?? "",
                                              boxFit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    color: colorOvalBorder,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Container(
                                child: AutoSizeText(
                                  sharedSylo.displayName ?? sharedSylo.syloName,
                                  style: getTextStyle(
                                      color: sharedSylo.active ? Colors.black : Colors.red,
                                      size: 14,
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                padding: EdgeInsets.only(top: 3),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.east_outlined,
                                      color: sharedSylo.active ? Colors.black : Colors.red,
                                      size: 20,
                                    ),
                                    SizedBox(width: 5,),
                                    AutoSizeText(
                                      sharedSylo.syloMakerName,
                                      style: getTextStyle(
                                          color: sharedSylo.active ? Colors.black : Colors.red,
                                          size: 12,
                                          fontWeight: FontWeight.w400),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                  ],
                                ),
                                padding: EdgeInsets.only(top: 3),
                              ),
                            ],
                          ),
                          Positioned(
                            child: ClipOval(
                              child: Container(
                                //child: AutoSizeText("3",  style: getTextStyle(color: colorSectionHead,  fontWeight: FontWeight.w500, ), minFontSize: 6, maxFontSize: 12, overflow: TextOverflow.ellipsis, maxLines: 1,),
                                color: colorOvalBorder,
                                alignment: Alignment.center,
                                //width: 20,
                                //height: 20,
                                padding: EdgeInsets.only(top: 3),
                              ),
                            ),
                            right: 1,
                            top: 1,
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );

  get completeSyloView => Container(
    color: Colors.white,
        height: 155,
        padding: EdgeInsets.only(
          top: 8,
        ),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 12,
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemCount: model.completedSylos?.length ?? 0,
                  /*  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, childAspectRatio: 0.5),
               */
                  shrinkWrap: true,
                  itemBuilder: (c, i) {
                    SharedSyloItem completedSylo = model.completedSylos[i];
                    return Container(
                      padding: EdgeInsets.only(left: 24, right: 16),
                      child: Stack(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              InkWell(
                                onTap: () async {
                                  var result = await Navigator.push(
                                      context,
                                      NavigatePageRoute(context,
                                          OpeningMessageViewSyloPage(sharedSyloItem: completedSylo)));
                                },
                                child: ClipOval(
                                  child: Container(
                                    child: Stack(
                                      children: <Widget>[
                                        ClipOval(
                                          child: Container(
                                            color: Colors.white,
                                            height: 75,
                                            width: 75,
                                            child: ImageFromNetworkView(
                                              path: completedSylo.syloPic ?? "",
                                              boxFit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    color: colorOvalBorder,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Container(
                                width: 75,
                                child: AutoSizeText(
                                  completedSylo.displayName ?? completedSylo.syloName,
                                  style: getTextStyle(
                                      color: completedSylo.active ? Colors.black : Colors.red,
                                      size: 14,
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                padding: EdgeInsets.only(top: 3),
                              ),
                            ],
                          ),
                          Positioned(
                            child: ClipOval(
                              child: Container(
                                //child: AutoSizeText("3",  style: getTextStyle(color: colorSectionHead,  fontWeight: FontWeight.w500, ), minFontSize: 6, maxFontSize: 12, overflow: TextOverflow.ellipsis, maxLines: 1,),
                                color: colorOvalBorder,
                                alignment: Alignment.center,
                                //width: 20,
                                //height: 20,
                                padding: EdgeInsets.only(top: 3),
                              ),
                            ),
                            right: 1,
                            top: 1,
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );

  double l = 16, r = 16, t = 16;

  @override
  void initState() {
    super.initState();
    appState.userSylo = null;
  }

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = SharedPageViewModel(this));

    return Scaffold(
      backgroundColor: colorWhite,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Opacity(
              child: Container(

                child: Image.asset(
                  App.img_home_bg,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                padding: EdgeInsets.only(bottom: 64),
              ),
              opacity: 0.3,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                customAppBar(),
                Expanded(
                    child: Container(
                  child: Stack(
                    children: <Widget>[
                      ListView(
                        physics: BouncingScrollPhysics(),
                        children: <Widget>[
                          Container(

                            child: Text(

                              "Connected Sylos",
                              style: getTextStyle(
                                  color: Colors.black,
                                  size: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                            margin: EdgeInsets.only(top: t, left: l, right: r),
                          ),
                          Container(
                            height: 1,
                            color: Color(0x00ff4A4A4A),
                            margin: EdgeInsets.only(left: l, top: 5, right: r),
                          ),
                          ownSyloView,
                          sharedSyloView,
                          Container(

                            child: Text(
                              "Delivered Sylos",
                              style: getTextStyle(
                                  color: Colors.black,
                                  size: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                            margin: EdgeInsets.only(top: t, left: l, right: r),
                          ),
                          Container(
                            height: 1,
                            color: Color(0x00ff4A4A4A),
                            margin: EdgeInsets.only(left: l, top: 5, right: r),
                          ),
                          completeSyloView,
                          commonEndView(),
                        ],
                      ),
                      model.isLoader ?
                      getCircularIndicatorWithBackSheet(align: Alignment.center)
                          : SizedBox(height: 0, width: 0),

                    ],
                  ),
                )),
              ],
            ),
            commonEndView(),
          ],
        ),
      ),
    );
  }

  Widget customAppBar() {
    return Container(
      height: AppBar().preferredSize.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Text(
              "Shared",
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
        ],
      ),
    );
  }
}
