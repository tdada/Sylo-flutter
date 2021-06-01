import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/model/qcast_dashboard_item.dart';
import 'package:testsylo/model/slider_item.dart';

import '../../../../../app.dart';
import 'theme_detail_list_page_view_model.dart';
import 'package:testsylo/common/common_route.dart';

class ThemeDetailListPage extends StatefulWidget {
  ThemeModel themeModel;
  ThemeDetailListPage({this.themeModel});
  @override
  ThemeDetailListPageState createState() => ThemeDetailListPageState();
}

class ThemeDetailListPageState extends State<ThemeDetailListPage> {
  ThemeDetailListPageViewModel model;
  bool needToChangeState;

  @override
  void initState() {
    super.initState();
    needToChangeState = false;
  }

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = ThemeDetailListPageViewModel(this));

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, needToChangeState);
        return false;
      },
      child: Scaffold(
        backgroundColor: getColorBg(),
        appBar: AppBar(
          title: Text(
            widget.themeModel?.title??"",
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
                  itemCount: model.listQcastByCatogory?.length??0,
                  shrinkWrap: true,
                  itemBuilder: (c, i) {
                    DiscoverQcastItem qcastsByCategory = model.listQcastByCatogory[i];
                    return Container(
                      padding: EdgeInsets.only(left: 5, bottom: 16, right: 5),
                      child: Row(
                        children: <Widget>[
                          SizedBox(width: 12,),
                          InkWell(
                            child: ClipOval(
                              child: Container(
                                child: ClipOval(
                                  child: Container(
                                    child: ImageFromNetworkView(
                                      path: qcastsByCategory.coverPhoto,
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
                            onTap: () async {
                              var result = await goToDescriptionPage(context, qcastsByCategory, isAllowUserView: true);
                              needToChangeState = true;
                              setState(() {
                              });
                            },
                          ),
                          SizedBox(width: 12,),
                          Expanded(

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 3,),
                                InkWell(
                                  onTap: () async {
                                    var result = await goToDescriptionPage(context, qcastsByCategory, isAllowUserView: true);
                                    needToChangeState = true;
                                    setState(() {
                                    });
                                  },
                                    child: AutoSizeText(qcastsByCategory.description, maxLines: 3, style: getTextStyle(size: 13, color: Colors.black,), overflow: TextOverflow.ellipsis,),
                                ),
                                SizedBox(height: 3,),
                                InkWell(
                                  child: Container(
                                    child: Text(
                                      qcastsByCategory.name,
                                      style: getTextStyle(color: colorDark, size: 13),
                                    ),
                                    padding: EdgeInsets.only(top: 3),
                                  ),
                                  onTap: () async {
                                    var result = await goToSubscription(context, qcastsByCategory);
                                    if(result==true) {
                                      needToChangeState = true;
                                      setState(() {
                                      });
                                    }
                                  },
                                )

                              ],
                            ),
                          ),
                        ],
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
