import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/slider_item.dart';
import 'package:testsylo/page/log_in/login_page.dart';
import 'package:testsylo/page/qcast/qcat_tab/qcast_tab_page.dart';
import 'package:testsylo/util/navigate_effect.dart';

import '../../app.dart';
import 'intro_page_view_model.dart';

class IntroPage extends StatefulWidget {
  @override
  IntroPageState createState() => IntroPageState();
}

class IntroPageState extends State<IntroPage> {
  IntroPageViewModel model;
  int viewPagerIndex = 0;
  SwiperController swiperController = new SwiperController();

  @override
  void initState() {
    super.initState();
    model ?? (model = IntroPageViewModel(this));
  }

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    return WillPopScope(
      onWillPop: () async{

        if(viewPagerIndex==0){
          return true;
        }
        else{
          swiperController.move(viewPagerIndex-1);
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: getColorBg(),
        appBar: AppBar(
          title: Text(
            "Welcome",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w900, fontSize: 17),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.white,
          leading: viewPagerIndex==0 ? null : InkWell(
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

            onTap: (){

              swiperController.move(viewPagerIndex-1);

            },


          ),
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.fromLTRB(15, 8, 15, 0),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Expanded(
                      child: Swiper(
                        autoplayDisableOnInteraction: true,
                        autoplay: false,
                        loop: false,
                        controller: swiperController,
                        index: viewPagerIndex,
                        physics: BouncingScrollPhysics(),
                        itemCount: listSlide.length,
                        itemBuilder: (context, index) {
                          SliderItem item = listSlide[index];
                          return Column(
                            children: <Widget>[
                              Text(
                                item.title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 22),
                              ),
                              Container(
                                height: 70,
                                margin: EdgeInsets.only(top: 15),
                                child: AutoSizeText(
                                  item.description,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: colorDark,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14),
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: ClipRRect(
                                    child: Image.asset(
                                      item.imageUrl,
                                      fit: BoxFit.fill                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   ,
                                      alignment: Alignment.topLeft,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 16),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              )
                            ],
                          );
                        },
                        pagination: new SwiperPagination(
                            margin: EdgeInsets.only(top: 16),
                            builder: new DotSwiperPaginationBuilder(
                                color: colorBg1, activeColor: colorSectionHead)),
                        onIndexChanged: (index) {
                          setState(() {
                            viewPagerIndex = index;
                          });
                        },
                      ),

                    ),
                    SizedBox(height: 30,),
                  ],
                ),
                viewPagerIndex==2 ? Positioned(
                  bottom: 12,
                  left: 46,
                  right: 46,
                  child: Container(child: commonButton(goToNext, "Get Started"), height: 50,),
                ) : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<Function> goToNext() async {
    var result = await Navigator.push(
        context, NavigatePageRoute(context,
        LogInPage(from: runtimeType.toString())
    ));
  }
}
