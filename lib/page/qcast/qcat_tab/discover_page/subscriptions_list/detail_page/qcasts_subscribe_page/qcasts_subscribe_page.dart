import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/qcast_dashboard_item.dart';
import 'package:testsylo/model/qcast_item.dart';
import 'package:testsylo/page/qcast/qcat_tab/discover_page/subscriptions_list/detail_page/qcasts_subscribe_page/qcasts_subscribe_page_view_model.dart';

import '../../../../../../../app.dart';

class QcastsSubscribePage extends StatefulWidget {
  DiscoverQcastItem discoverQcastItem;
  QcastsSubscribePage({this.discoverQcastItem});
  @override
  QcastsSubscribePageState createState() => QcastsSubscribePageState();
}

class QcastsSubscribePageState extends State<QcastsSubscribePage> {
  QcastsSubscribePageViewModel model;
  bool needToChangeState;
  get pickProfile => InkWell(
        onTap: () {},
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            ClipOval(
              child: Container(
                padding: EdgeInsets.all(2),
                color: colorOvalBorder,
                child: ClipOval(
                  //borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    children: <Widget>[
                      Container(
                          width: 125,
                          height: 125,
                          child:
                          ImageFromNetworkView(
                            path: model.myChannelProfileItem?.coverPhoto ?? "",
                            boxFit: BoxFit.cover,
                          )
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  get otherQcastsGrid => Container(
    padding: EdgeInsets.only(top: 8, left: 16, right: 16),
    child: Column(
      children: <Widget>[
        GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: model.listPublishQcastItem?.length,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              shrinkWrap: true,
              itemBuilder: (c, i) {
                QcastItem item = model.listPublishQcastItem[i];
                return Container(
                  padding: EdgeInsets.only(left: 5, top: 5),
                  child: Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          DiscoverQcastItem qcastItem = DiscoverQcastItem(
                              qcasId: item.qcastUserid,
                              name: item.name,
                              description: item.description,
                              coverPhoto: item.coverPhoto);
                          goToDescriptionPage(context, qcastItem);
                        },
                        child: ClipOval(
                          child: Container(
                            child: ClipOval(
                              child: Container(
                                child: ImageFromNetworkView(
                                  path: item.coverPhoto,
                                  boxFit: BoxFit.cover,
                                ),
                                width: 75,
                                height: 75,
                              )
                            ),
                            padding: EdgeInsets.all(3),
                            color: colorOvalBorder,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      AutoSizeText(
                        item.description,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: getTextStyle(
                          size: 14,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 3,
                      ),
                    ],
                  ),
                );
              },
            ),
      ],
    ),
  );

  @override
  void initState() {
    super.initState();
    needToChangeState = false;
  }

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = QcastsSubscribePageViewModel(this));

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, needToChangeState);
        return false;
      },
      child: Scaffold(
        backgroundColor: getColorBg(),
        appBar: AppBar(
          title: Text(
            "Qcasts",
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
              Navigator.pop(context, needToChangeState);
            },
          ),
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: CupertinoScrollbar(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                SizedBox(
                  height: 8,
                ),
                pickProfile,
                SizedBox(
                  height: 8,
                ),
                Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        model.myChannelProfileItem.profileName??"",
                        style: getTextStyle(
                            color: colorDark,
                            fontWeight: FontWeight.w800,
                            size: 22),
                      ),
                    ),
                    Container(
                      child: Text(
                        model.myChannelProfileItem.qcastMoto??"",
                        style: getTextStyle(
                            color: Color(0x00ffC3C3C3),
                            fontWeight: FontWeight.w800,
                            size: 18),
                      ),
                      padding: EdgeInsets.only(top: 8, left: 16, right: 16),
                    ),
                    Container(
                      child: Text(
                        model.myChannelProfileItem.description??"",
                        textAlign: TextAlign.center,
                        style: getTextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            size: 14),
                      ),
                      padding: EdgeInsets.only(top: 8, left: 16, right: 16),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                        width: 150,
                        height: 40,
                        child: getSubscribebutton()),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                        height: 100,
                        margin: EdgeInsets.only(
                            top: 12, bottom: 4, left: 16, right: 16),
                        child: coundIndicatorBanner(model.myChannelProfileItem.subscribers??0, model.myChannelProfileItem.qcastSerices??0, model.myChannelProfileItem.totalQuestions??0)),
                    otherQcastsGrid,
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getSubscribebutton() {
    if(model.isSubscribe==null) {
      return SizedBox();
    }
    if(model.isSubscribe == "No") {
       return commonButton(() {
          model.callSubscribe();
        }, "Subscribe", red: 15);
    } else if (model.isSubscribe == "Yes"){
         return commonButtonWithFilledSingleColorCorner(() {
           model.callUnsubscribe();
         },
             Text(
               "Unsubscribe",
               textAlign: TextAlign.center,
               style: TextStyle(
                   color: Colors.white,
                   fontWeight: FontWeight.w800,
                   fontSize: 18),
             ),
             colorDark,
             red: 15);
       }
    return SizedBox();
  }
}
