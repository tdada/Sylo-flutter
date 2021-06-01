import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/qcast_dashboard_item.dart';
import 'package:testsylo/model/slider_item.dart';
import 'package:testsylo/util/navigate_effect.dart';

import '../../../../app.dart';
import '../qcast_tab_page.dart';
import 'discover_page_view_model.dart';
import 'most_popular_list/most_pop_list_page.dart';
import 'subscriptions_list/subscriptions_list_page.dart';
import 'theme_list/theme_list_page.dart';
import 'package:testsylo/page/qcast/qcat_tab/discover_page/theme_list/theme_detail_list_page.dart';

class DiscoverPage extends StatefulWidget {
  @override
  DiscoverPageState createState() => DiscoverPageState();
}

class DiscoverPageState extends State<DiscoverPage> {
  DiscoverPageViewModel model;

  get pagerView => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 16, top: 24, bottom: 8),
            child: Text(
              "Featured: Qcasts by Authors ",
              style: getTextStyle(
                  size: 21, fontWeight: FontWeight.w800, color: Colors.black),
            ),
          ),
          featuredPages,
        ],
      );

  get mostPopularView => Container(
    height: 215,
    padding: EdgeInsets.only(top: 16, right: 4),
    child: ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          bottomLeft: Radius.circular(5)),
      child: Container(
        padding: EdgeInsets.only(top: 10, left: 4, bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 16, right: 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "Most Popular",
                        style: getTextStyle(
                            size: 18, fontWeight: FontWeight.w800, color: Colors.black),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        InkWell(
                          onTap: () async {
                            var result = await Navigator.push(
                                context, NavigatePageRoute(context, MostPopularListPage(listMostPopularQcasts: model.listMostPopularQcasts)));
                            if(result==true) {
                              model.getQcastDashboard();
                            }
                            },
                          child: Container(
                            child: Text(
                              "View All",
                              style: getTextStyle(
                                  color: colorSectionHead,
                                  size: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                            padding: EdgeInsets.only(),
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_right, size: 16, color: colorSectionHead, )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8,),
            Expanded(
              child: GridView.builder(

                physics: NeverScrollableScrollPhysics(),
                itemCount: model.listMostPopularQcasts.length>3?3:model.listMostPopularQcasts.length,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, childAspectRatio: 0.5),
                shrinkWrap: true,
                itemBuilder: (c, i) {
                  DiscoverQcastItem mostPopularQcast = model.listMostPopularQcasts[i];
                  return Container(
                    padding: EdgeInsets.only(left: 5, top: 5),
                    child:  Column(
                      children: <Widget>[
                        InkWell(
                          child: ClipOval(
                            child: Container(
                              child: ClipOval(
                                child: Container(
                                 child: ImageFromNetworkView(
                                   path: mostPopularQcast.coverPhoto,
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
                            var result = await goToDescriptionPage(context, mostPopularQcast, isAllowUserView: true);
                            model.getQcastDashboard();
                          },
                        ),
                        SizedBox(height: 5,),
                        InkWell(
                            child: AutoSizeText(mostPopularQcast.description, maxLines: 3, minFontSize: 11, textAlign: TextAlign.center, style: getTextStyle(size: 11, color: Colors.black,), overflow: TextOverflow.ellipsis,),
                            onTap: () async {
                              var result = await goToDescriptionPage(context, mostPopularQcast, isAllowUserView: true);
                              model.getQcastDashboard();
                            },
                        ),
                        SizedBox(height: 3,),
                        InkWell(
                          child: Container(
                            child: AutoSizeText(mostPopularQcast.name,
                              maxLines: 1,
                              minFontSize: 12,
                              textAlign: TextAlign.center,
                              style: getTextStyle(size: 14, color: colorDark, fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,),
                            padding: EdgeInsets.only(top: 3),
                          ),
                          onTap: () async {
                            var result = await goToSubscription(context,mostPopularQcast);
                            if(result == true) {
                              model.getQcastDashboard();
                            }
                          },
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
    ),
  );

  get subScriptionView => Container(
    height: 215,
    padding: EdgeInsets.only(top: 16, right: 4),
    child: ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          bottomLeft: Radius.circular(5)),
      child: Container(
        padding: EdgeInsets.only(top: 10, left: 4, bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 16, right: 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "Subscriptions",
                        style: getTextStyle(
                            size: 18, fontWeight: FontWeight.w800, color: Colors.black),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        InkWell(
                          onTap: () async {
                            var result = await Navigator.push(
                                context, NavigatePageRoute(context, SubscriptionsListPage(listMySubscriptions: model.listMySubscriptions)));
                            if(result == true) {
                              model.getQcastDashboard();
                            }
                          },
                          child: Container(
                            child: Text(
                              "View All",
                              style: getTextStyle(
                                  color: colorSectionHead,
                                  size: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                            padding: EdgeInsets.only(),
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_right, size: 16, color: colorSectionHead, )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8,),
            Expanded(
              child: GridView.builder(

                physics: NeverScrollableScrollPhysics(),
                itemCount: model.listMySubscriptions.length>3?3:model.listMySubscriptions.length,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, childAspectRatio: 0.5),
                shrinkWrap: true,
                itemBuilder: (c, i) {
                  DiscoverQcastItem mySubscription = model.listMySubscriptions[i];
                  return Container(
                    padding: EdgeInsets.only(left: 5, top: 5),
                    child:  Column(
                      children: <Widget>[
                        InkWell(
                          child: ClipOval(
                            child: Container(
                              child: ClipOval(
                                child: Container(
                                  child: ImageFromNetworkView(
                                    path: mySubscription.coverPhoto,
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
                              var result = await goToSubscription(context,mySubscription);
                              if(result == true) {
                                model.getQcastDashboard();
                              }
                          },
                        ),
                        SizedBox(height: 5,),
                        InkWell(
                            child: AutoSizeText(mySubscription.description, maxLines: 3, minFontSize: 11, textAlign: TextAlign.center, style: getTextStyle(size: 11, color: Colors.black,), overflow: TextOverflow.ellipsis,),
                            onTap: () {
//                              goToDescriptionPage(context);
                            },
                        ),
                        SizedBox(height: 3,),
                        InkWell(
                          child: Container(
                            child: AutoSizeText(mySubscription.name,
                              maxLines: 1,
                              minFontSize: 12,
                              textAlign: TextAlign.center,
                              style: getTextStyle(size: 14, color: colorDark, fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,),

                            padding: EdgeInsets.only(top: 3),
                          ),
                          onTap: () async {
                            var result = await goToSubscription(context,mySubscription);
                            if(result == true) {
                              model.getQcastDashboard();
                            }
                          },
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
    ),
  );

  get themeView => Container(
    height: 215,
    padding: EdgeInsets.only(top: 16, right: 4),
    child: ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          bottomLeft: Radius.circular(5)),
      child: Container(
        padding: EdgeInsets.only(top: 10, left: 4, bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 16, right: 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "Themes",
                        style: getTextStyle(
                            size: 18, fontWeight: FontWeight.w800, color: Colors.black),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        InkWell(
                          onTap: () async {
                            var result = await Navigator.push(
                                context, NavigatePageRoute(context, ThemeListPage()));
                            if(result==true){
                              model.getQcastDashboard();
                            }
                          },
                          child: Container(
                            child: Text(
                              "View All",
                              style: getTextStyle(
                                  color: colorSectionHead,
                                  size: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                            padding: EdgeInsets.only(),
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_right, size: 16, color: colorSectionHead, )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8,),
            Expanded(
              child: ListView.builder(

//                physics: ,
                scrollDirection: Axis.horizontal,
                itemCount: themeModelList.length,
//                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
//                    crossAxisCount: 5, childAspectRatio: 0.5),
                shrinkWrap: true,
                itemBuilder: (c, i) {

                  return Container(
                    padding: EdgeInsets.only(left: 5, top: 5),
                    child:  Column(
                      children: <Widget>[
                        InkWell(
                          onTap: () async {
                            var result = await Navigator.push(
                                c, NavigatePageRoute(
                                c, ThemeDetailListPage(themeModel: themeModelList[i])));
                            if(result == true) {
                              model.getQcastDashboard();
                            }
                          },
                          child: Container(
                            width: 60,
                            height: 70,
                            child: Stack(
                              children: <Widget>[
                                Image.asset(
                                  App.ic_temp,
                                  fit: BoxFit.contain,width: double.infinity,
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
                        ),
                        SizedBox(height: 3,),
                        Container(
                          width: 65,
                          child: Text(
                            themeModelList[i].title,
                            style: getTextStyle(color: Colors.black, size: 14, fontWeight: FontWeight.w400),
                            overflow: TextOverflow.ellipsis,
                            //maxLines: 2,
                            textAlign: TextAlign.center,
                            //minFontSize: 12,
                          ),
                          padding: EdgeInsets.only(top: 3),
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
    ),
  );

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = DiscoverPageViewModel(this));

    return Scaffold(
      backgroundColor: getColorBg(),
      body: SafeArea(
        child: CupertinoScrollbar(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              pagerView,
               mostPopularView,
              subScriptionView,
              themeView,
              commonEndView(),
            ],
          ),
        ),
      ),
    );
  }

  int currentIndex = 0;
  PageController pageController =
      PageController(initialPage: 0, viewportFraction: 0.9);

  Widget get featuredPages {
    pageController = PageController(initialPage: 0, viewportFraction: 0.9);
    return Container(
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          PageView.builder(
            scrollDirection: Axis.horizontal,
            controller: pageController,
            physics: BouncingScrollPhysics(),
            itemCount: model.listFeaturedQcasts.length,
            itemBuilder: (context, index) {

              DiscoverQcastItem  featuredQcastItem = model.listFeaturedQcasts[index];
              return Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Container(
                    child: Column(

                      children: <Widget>[
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              alignment: Alignment.center,
                              color: Colors.grey,
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: InkWell(
                                      child: Container(
                                        child: Container(
                                          width: double.infinity,
                                            child:
                                          ImageFromNetworkView(
                                            path: featuredQcastItem.coverPhoto ?? "",
                                            boxFit: BoxFit.cover,
                                          )
                                        ),

                                      ),
                                      onTap: () async {
                                        /*  zoomFileImageDialogue(
                                              context,
                                              Image.file(
                                                file,
                                                fit: BoxFit.contain,
                                              ));*/
                                        var result = await goToDescriptionPage(context, featuredQcastItem, isAllowUserView: true);
                                        model.getQcastDashboard();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.only(top: 3),
                          child: Container(
                              child: RichText(

                                text: TextSpan(
                                  text: featuredQcastItem.description,
                                  style: getTextStyle(color: Colors.black, size: 14, fontWeight: FontWeight.w500,),

//                                  children: <TextSpan>[
//                                    TextSpan(
//                                        text: 'Get Your Life Back',
//                                        recognizer: TapGestureRecognizer()
//                                          ..onTap = () {
//
//
//                                          },
//                                        style: getTextStyle(
//                                            color: Colors.black,
//                                            size: 15,
//                                            fontWeight: FontWeight.w900)),
//                                  ],
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              )),
                        ),

                        Container(
                          child: InkWell(
                            child: Text(
                              featuredQcastItem.name,
                              style: getTextStyle(color: colorDark, size: 14, fontWeight: FontWeight.w500),
                            ),
                            onTap: () async {
                              var result = await goToSubscription(context, featuredQcastItem);
                              if(result == true) {
                                model.getQcastDashboard();
                              }
                            },
                          ),
                          padding: EdgeInsets.only(top: 3),
                        )
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                    padding: EdgeInsets.only(right: 12),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
