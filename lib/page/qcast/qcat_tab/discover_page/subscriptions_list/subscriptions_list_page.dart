import 'package:flutter/material.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/qcast_dashboard_item.dart';
import 'package:testsylo/page/qcast/qcat_tab/discover_page/subscriptions_list/detail_page/subscriptions_detail_page.dart';
import 'package:testsylo/page/qcast/qcat_tab/discover_page/subscriptions_list/subscriptions_list_page_view_model.dart';
import 'package:testsylo/util/navigate_effect.dart';

import '../../../../../app.dart';
import 'detail_page/qcasts_subscribe_page/qcasts_subscribe_page.dart';

class SubscriptionsListPage extends StatefulWidget {
  List<DiscoverQcastItem> listMySubscriptions;
  SubscriptionsListPage({this.listMySubscriptions});
  @override
  SubscriptionsListPageState createState() => SubscriptionsListPageState();
}

class SubscriptionsListPageState extends State<SubscriptionsListPage> {
  SubscriptionsListPageViewModel model;
  bool needToChangeState;

  @override
  void initState() {
    super.initState();
    needToChangeState = false;
  }

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = SubscriptionsListPageViewModel(this));

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, needToChangeState);
        return false;
      },
      child: Scaffold(
        backgroundColor: getColorBg(),
        appBar: AppBar(
          title: Text(
            "Subscriptions",
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
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: widget.listMySubscriptions?.length??0,
                  shrinkWrap: true,
                  itemBuilder: (c, i) {
                    DiscoverQcastItem  mySubscriptionItem = widget.listMySubscriptions[i];
                    return Container(
                      padding: EdgeInsets.only(left: 5, bottom: 16),
                      child:  InkWell(
                        onTap: () async {
                          var result = await goToSubscription(context, mySubscriptionItem);
                          if(result == true) {
                            needToChangeState = true;
                            setState(() {});
                          }
                          /*var result = await Navigator.push(
                              context, NavigatePageRoute(context, QcastsSubscribePage()));*/
                        },
                        child: Row(
                          children: <Widget>[
                            SizedBox(width: 12,),
                            ClipOval(
                              child: Container(
                                child: ClipOval(
                                  child: Container(
                                    child: ImageFromNetworkView(
                                      path : mySubscriptionItem.coverPhoto,
                                      boxFit: BoxFit.cover,
                                    ),
                                    width: 75,
                                    height: 75,
                                  ),
                                ),
                                padding: EdgeInsets.all(3),
                                color: colorOvalBorder,
                              ),
                            ),
                            SizedBox(width: 12,),
                            Expanded(
                              child: Text(
                                      mySubscriptionItem.name,
                                      style: getTextStyle(color: colorDark, size: 14, fontWeight: FontWeight.w400),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

          ),
        ),
      ),
    );
  }
}
