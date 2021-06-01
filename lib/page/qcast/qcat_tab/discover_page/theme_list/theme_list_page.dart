import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:testsylo/model/slider_item.dart';
import 'package:testsylo/page/qcast/qcat_tab/discover_page/theme_list/theme_detail_list_page.dart';
import 'package:testsylo/util/navigate_effect.dart';

import '../../../../../app.dart';
import 'theme_list_page_view_model.dart';

class ThemeListPage extends StatefulWidget {
  @override
  ThemeListPageState createState() => ThemeListPageState();
}

class ThemeListPageState extends State<ThemeListPage> {
  ThemeListPageViewModel model;
  bool needToChangeState;

  @override
  void initState() {
    super.initState();
    needToChangeState = false;
  }

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = ThemeListPageViewModel(this));

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, needToChangeState);
        return false;
      },
      child: Scaffold(
        backgroundColor: getColorBg(),
        appBar: AppBar(
          title: Text(
            "Themes",
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
                  itemCount: themeModelList.length,
                  shrinkWrap: true,
                  itemBuilder: (c, i) {
                    return Container(
                      padding: EdgeInsets.only(left: 5, bottom: 16),
                      child: InkWell(
                        onTap: () async {
                          var result = await Navigator.push(
                              c, NavigatePageRoute(
                                  c, ThemeDetailListPage(themeModel: themeModelList[i])));
                          if(result==true) {
                            needToChangeState = true;
                            setState(() {
                            });
                          }
                        },
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 12,
                            ),
                            Container(
                              width: 60,
                              height: 70,
                              child: Stack(
                                children: <Widget>[
                                  Image.asset(
                                    App.ic_temp,
                                    fit: BoxFit.contain,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                  Positioned(
                                    bottom: 14,
                                    child: Image.asset(
                                      themeModelList[i].icon,
                                      fit: BoxFit.contain,
                                      width: 32,
                                      height: 32,
                                    ),
                                  ),
                                ],
                                alignment: Alignment.center,
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Container(
                                    child: Text(
                                      themeModelList[i].title,
                                      style: getTextStyle(
                                          color: Colors.black,
                                          size: 15,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    padding: EdgeInsets.only(top: 3),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  AutoSizeText(
                                    themeModelList[i].description,
                                    maxLines: 3,
                                    style: getTextStyle(
                                      size: 13,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
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
