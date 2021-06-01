import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:circle_list/circle_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:testsylo/common/bottom_bar_view.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/model/slider_item.dart';
import 'package:testsylo/page/account/account_page/account_page.dart';
import 'package:testsylo/page/home/home_sylo_page.dart';
import 'package:testsylo/page/qcast/qcat_tab/discover_page/record_qcast/record_qcast_page.dart';
import 'package:testsylo/page/qcast/qcat_tab/qcast_tab_page.dart';
import 'package:testsylo/page/shared/shared_page.dart';
import 'package:testsylo/page/sylo/add_sylo_page/add_sylo_page.dart';
import 'package:testsylo/page/sylo/view_sylo_page/sylo_album_page/sylo_album_detail_page/sylo_album_detail_page.dart';
import 'package:testsylo/page/sylo/view_sylo_page/sylo_album_page/sylo_album_page.dart';
import 'package:testsylo/page/sylo/view_sylo_page/view_sylo_page.dart';
import 'package:testsylo/util/navigate_effect.dart';

import '../../app.dart';
import 'dashboard_page_view_model.dart';
import 'qcam_tab/qcam_page.dart';
import 'sylo_action_circular_page/sylo_action_circular_page.dart';

class DashBoardPage extends StatefulWidget {
  String from = "";
  int initIndex;
  int subInitIndex;
  DashBoardPage({this.from, this.initIndex, this.subInitIndex});
  @override
  DashBoardPageState createState() => DashBoardPageState();
}

class DashBoardPageState extends State<DashBoardPage> {
  DashBoardPageViewModel model;
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;
  GetUserSylos sylo = GetUserSylos();
  String callBackFrom = "";
  GetAlbum getAlbumForDetailPage = GetAlbum();
  bool isAlbumGridDefaultView = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    if (widget.from!=null && (widget.from=="signup" || widget.from=="signin")){
      commonToast("Welcome to Sylo");
    }
  }

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = DashBoardPageViewModel(this));

    return Scaffold(
      backgroundColor: getColorBg(),
      body: Platform.isAndroid?SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            getMenuByIndex,
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                !isShow ? Container() :BottomBarView(
                  tabIconsList: tabIconsList,
                  addClick: () async {

                    if (model.menuIndex == 5) {
                      return;
                    }
                    setState(() {
                      model.menuIndex = 5;
                      isShow = true;
                    });
                  },
                  changeIndex: (index) async {
                    await Future.delayed(Duration(milliseconds: 100));
                    setState(() {
                      model.menuIndex = index;
                    });

                    if(index==1){
                      await Future.delayed(Duration(milliseconds: 1500));
                      toggleBottomView();
                    }
                    else{
                      isShow = true;
                    }

                    if(model.menuIndex==5){
                      tabIconsList.forEach((tab) {
                        tab.isSelected=false;
                      });
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ):Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          getMenuByIndex,
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              !isShow ? Container() :BottomBarView(
                tabIconsList: tabIconsList,
                addClick: () async {

                  if (model.menuIndex == 5) {
                    return;
                  }
                  setState(() {
                    model.menuIndex = 5;
                    isShow = true;
                  });
                },
                changeIndex: (index) async {
                  await Future.delayed(Duration(milliseconds: 100));
                  setState(() {
                    model.menuIndex = index;
                  });

                  if(index==1){
                    await Future.delayed(Duration(milliseconds: 1500));
                    toggleBottomView();
                  }
                  else{
                    isShow = true;
                  }

                  if(model.menuIndex==5){
                    tabIconsList.forEach((tab) {
                      tab.isSelected=false;
                    });
                  }
                },

              ),
            ],
          )
        ],
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
    );
  }

  Widget get getMenuByIndex {
    print("menuIndex -> " + model.menuIndex.toString());
    String _from = widget.from;
    widget.from = "";
    if (model.menuIndex == 0) {
      return QcastTabPage(tabIndex: widget.subInitIndex??0,);
    } else if (model.menuIndex == 1) {
      return QcamPage(runtimeType.toString(), List(), toggleBottomView);
      //return RecordQcastPage(runtimeType.toString(), List(), toggleBottomView);
    } else if (model.menuIndex == 2) {
      return SharedPage();
    } else if (model.menuIndex == 3) {
      return AccountPage();
    }
    else if (model.menuIndex == 6) {
      return ViewSyloPage(userSylo: sylo, callBack:changeIndex);
    } else if (model.menuIndex == 7) {
      return SyloAlbumPage(from: callBackFrom, userSylo: sylo, callBack:changeIndex, isAlbumGrid: isAlbumGridDefaultView);
    } else if (model.menuIndex == 8){
      return SyloAlbumDetailPage(getAlbum: getAlbumForDetailPage, from: callBackFrom, userSylo: sylo, callBack: changeIndex, isAlbumGridstate: isAlbumGridDefaultView,);
    }
    else {
      return HomeSyloPage(from: _from, callBack:changeIndex,);
    }
  }

  bool isShow = true;
  toggleBottomView(){
    if(model.menuIndex==1) {
      setState(() {
        isShow = !isShow;
      });
    }
  }

  changeIndex(int index, GetUserSylos _sylo, {String from="", GetAlbum getAlbum, bool isAlbumGrid = false}) {

    if(index==6){
      sylo = _sylo;
    }
    if(index==7){
      callBackFrom = from;
      sylo = _sylo;
      isAlbumGridDefaultView = isAlbumGrid;
    }
    if(index==8){
      callBackFrom = from;
      sylo = _sylo;
      getAlbumForDetailPage = getAlbum;
      isAlbumGridDefaultView = isAlbumGrid;
    }
    setState(() {
      model.menuIndex = index;
    });
  }

}
