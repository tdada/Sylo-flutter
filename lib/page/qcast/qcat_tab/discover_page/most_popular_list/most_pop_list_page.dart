import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/qcast_dashboard_item.dart';
import 'package:testsylo/model/slider_item.dart';

import '../../../../../app.dart';
import 'most_pop_list_page_view_model.dart';


class MostPopularListPage extends StatefulWidget {
  List<DiscoverQcastItem> listMostPopularQcasts;
  MostPopularListPage({this.listMostPopularQcasts});
  @override
  MostPopularListPageState createState() => MostPopularListPageState();
}

class MostPopularListPageState extends State<MostPopularListPage> {
  MostPopularListPageViewModel model;
  bool needToChangeState;

  @override
  void initState() {
    super.initState();
    needToChangeState = false;
  }

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = MostPopularListPageViewModel(this));

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, needToChangeState);
        return false;
      },
      child: Scaffold(
        backgroundColor: getColorBg(),
        appBar: AppBar(
          title: Text(
            "Most Popular",
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
          )

          ,
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: widget.listMostPopularQcasts?.length??0,
                  shrinkWrap: true,
                  itemBuilder: (c, i) {
                    DiscoverQcastItem mostPopularQcastItem = widget.listMostPopularQcasts[i];
                    return InkWell(
                      onTap: () async {
                        await goToDescriptionPage(context, mostPopularQcastItem);
                        needToChangeState = true;
                        setState(() {
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 5, bottom: 16, right: 5),
                        child: Row(
                            children: <Widget>[
                              SizedBox(width: 12,),
                              ClipOval(
                                child: Container(
                                  child: ClipOval(
                                    child: Container(
                                      child: ImageFromNetworkView(
                                        path: mostPopularQcastItem.coverPhoto,
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

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(height: 3,),
                                    AutoSizeText(mostPopularQcastItem.description, maxLines: 3, style: getTextStyle(size: 13, color: Colors.black,), overflow: TextOverflow.ellipsis,),
                                    SizedBox(height: 3,),
                                    InkWell(
                                      child: Container(
                                        child: AutoSizeText(mostPopularQcastItem.name,
                                          maxLines: 1,
                                          minFontSize: 12,
                                          textAlign: TextAlign.center,
                                          style: getTextStyle(size: 14, color: colorDark, fontWeight: FontWeight.w500),
                                          overflow: TextOverflow.ellipsis,),
                                        padding: EdgeInsets.only(top: 3),
                                      ),
                                      onTap: () async {
                                        var result = await goToSubscription(context,mostPopularQcastItem);
                                        if (result == true) {
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
