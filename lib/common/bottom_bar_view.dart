import 'dart:math' as math;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testsylo/app.dart';
import 'package:testsylo/model/model.dart';

import '../main.dart';

class BottomBarView extends StatefulWidget {
  final Function(int index) changeIndex;
  final Function addClick;
  final List<TabIconData> tabIconsList;

  //final BasePageState state;
  const BottomBarView(
      {Key key, this.tabIconsList, this.changeIndex, this.addClick})
      : super(key: key);

  @override
  _BottomBarViewState createState() => _BottomBarViewState();
}

class _BottomBarViewState extends State<BottomBarView>
    with TickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 1000),
    );
    animationController.forward();
    widget.tabIconsList.forEach((tab) {
      tab.isSelected = false;
    });
    isHome=true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        AnimatedBuilder(
          animation: animationController,
          builder: (BuildContext context, Widget child) {
            return new Transform(
              transform: new Matrix4.translationValues(0.0, 0.0, 0.0),
              child: new PhysicalShape(
                color: Colors.white,
                elevation: 16.0,
                clipper: TabClipper(
                    radius: Tween(
                          begin: 0.0,
                          end: 0.0,
                        )
                            .animate(CurvedAnimation(
                                parent: animationController,
                                curve: Curves.fastOutSlowIn))
                            .value *
                        18.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 62,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10, right: 4, bottom: 5,),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TabIcons(
                                  tabIconData: widget.tabIconsList[0],
                                  removeAllSelect: () {
                                    setRemoveAllSelection(
                                        widget.tabIconsList[0]);
                                    widget.changeIndex(0);
                                  },badge:true,count:0),
                            ),
                            Expanded(
                              child: TabIcons(
                                  tabIconData: widget.tabIconsList[1],
                                  removeAllSelect: () {
                                    setRemoveAllSelection(
                                        widget.tabIconsList[1]);
                                    widget.changeIndex(1);
                                  },badge:true,count:0),
                            ),
                            SizedBox(
                              width: Tween(begin: 0.0, end: 1.0)
                                      .animate(CurvedAnimation(
                                          parent: animationController,
                                          curve: Curves.fastOutSlowIn))
                                      .value *
                                  64.0,
                            ),
                            Expanded(
                              child: TabIcons(
                                  tabIconData: widget.tabIconsList[2],
                                  removeAllSelect: () {
                                    setRemoveAllSelection(
                                        widget.tabIconsList[2]);
                                    widget.changeIndex(2);
                                  },badge:false,count:0),
                            ),
                            Expanded(
                              child: TabIcons(
                                  tabIconData: widget.tabIconsList[3],
                                  removeAllSelect: () {
                                    setRemoveAllSelection(
                                        widget.tabIconsList[3]);
                                    widget.changeIndex(3);
                                  },badge:false,count:appState.notificationNumber ?? 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    /*SizedBox(
                      height: MediaQuery.of(context).padding.bottom,
                    )*/
                  ],
                ),
              ),
            );
          },
        ),
        SizedBox(
          width: 42 * 2.0,
          height: 42 + 62.0,
          child: Container(
            alignment: Alignment.topCenter,
            color: Colors.transparent,
            child: SizedBox(
              width: 42 * 2.0,
              height: 42 * 2.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: new ScaleTransition(
                  alignment: Alignment.center,
                  scale: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                      parent: animationController,
                      curve: Curves.fastOutSlowIn)),
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorOvalBorder,
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      // alignment: Alignment.center,s
                      decoration: BoxDecoration(
                        color: colorSectionHead,
                        gradient: LinearGradient(
                          colors: !isHome
                              ? [Colors.white, Colors.white]
                              : [
                                  Color(0xff9F00C5),
                                  Color(0xff9405BD),
                                  Color(0xff7913A7),
                                  Color(0xff651E96),
                                  Color(0xff522887)
                                ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        shape: BoxShape.circle,
                        /*boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: colorSectionHead,
                              offset: Offset(8.0, 16.0),
                              blurRadius: 16.0),
                        ],*/
                      ),
                      margin: EdgeInsets.all(5),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: Colors.white.withOpacity(0.1),
                          highlightColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          onTap: () {
                            setState(() {
                              widget.tabIconsList.forEach((tab) {
                                tab.isSelected = false;
                              });
                            });
                            isHome = true;
                            widget.addClick();
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Image.asset(
                                App.img_sylo_icon,
                                width: 22,
                                height: 22,
                                color: isHome ? Colors.white : colorDark,
                              ),
                              AutoSizeText(
                                "Sylos",
                                style: getTextStyle(
                                    color: isHome ? Colors.white : colorDark,
                                    size: 16,
                                    fontWeight: FontWeight.w700),
                                maxFontSize: 12,
                                minFontSize: 8,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool isHome = true;

  void setRemoveAllSelection(TabIconData tabIconData) {
    if (!mounted) return;
    isHome = true;
    setState(() {
      widget.tabIconsList.forEach((tab) {
        tab.isSelected = false;

        if (tabIconData.index == tab.index) {
          tab.isSelected = true;
        }
      });
    });
  }
}

class TabIcons extends StatefulWidget {
  final TabIconData tabIconData;
  final Function removeAllSelect;
  bool badge=false;
  int count=0;

   TabIcons({Key key, this.tabIconData, this.removeAllSelect,this.badge,this.count})
      : super(key: key);

  @override
  _TabIconsState createState() => _TabIconsState();
}

class _TabIconsState extends State<TabIcons> with TickerProviderStateMixin {
  @override
  void initState() {
    widget.tabIconData.animationController = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 100),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (!mounted) return;
          widget.removeAllSelect();
          widget.tabIconData.animationController.reverse();
        }
      });
    super.initState();
  }

  void setAnimation() {
    widget.tabIconData.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Center(
        child: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: () {
            if (!widget.tabIconData.isSelected) {
              setAnimation();
            }
          },
          child: IgnorePointer(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                new ScaleTransition(
                  alignment: Alignment.center,
                  scale: Tween(begin: 0.88, end: 1.0).animate(CurvedAnimation(
                      parent: widget.tabIconData.animationController,
                      curve: Interval(0.1, 1.0, curve: Curves.fastOutSlowIn))),
                  child: Stack(

                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Image.asset(
                            widget.tabIconData.isSelected
                                ? widget.tabIconData.selctedImagePath
                                : widget.tabIconData.imagePath,
                            width: 36,
                            height: 26,
                          ),
                          AutoSizeText(
                            widget.tabIconData.label,
                            style: getTextStyle(
                                color: widget.tabIconData.isSelected
                                    ? colorSectionHead
                                    : colorDark,
                                size: 18,
                                fontWeight: FontWeight.w500),
                            maxFontSize: 15,
                            minFontSize: 8,
                          )
                        ],
                      ),
                      widget.badge ? Container():Positioned(
                        child:
                        widget.count!=null && widget.count==0 ? Container():
                        ClipOval(
                          child: Container(
                            color: colorlightPurple,
                            padding: EdgeInsets.all(1),
                            child: ClipOval(
                              child: Container(
                                child: AutoSizeText(
                                  widget.count.toString(),
                                  style: getTextStyle(
                                    color: colorgradient,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  minFontSize: 6,
                                  maxFontSize: 11,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                color: colorlightPurple,
                                alignment: Alignment.center,
                                width: 18,
                                height: 18,
                                padding: EdgeInsets.only(top: 3),
                              ),
                            ),
                          ),
                        ),
                        top: 1,
                        right: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TabClipper extends CustomClipper<Path> {
  final double radius;

  TabClipper({this.radius = 38.0});

  @override
  Path getClip(Size size) {
    final path = Path();

    final v = radius * 2;
    path.lineTo(0, 0);
    path.arcTo(Rect.fromLTWH(0, 0, radius, radius), degreeToRadians(180),
        degreeToRadians(90), false);
    path.arcTo(
        Rect.fromLTWH(
            ((size.width / 2) - v / 2) - radius + v * 0.04, 0, radius, radius),
        degreeToRadians(270),
        degreeToRadians(70),
        false);

    path.arcTo(Rect.fromLTWH((size.width / 2) - v / 2, -v / 2, v, v),
        degreeToRadians(160), degreeToRadians(-140), false);

    path.arcTo(
        Rect.fromLTWH((size.width - ((size.width / 2) - v / 2)) - v * 0.04, 0,
            radius, radius),
        degreeToRadians(200),
        degreeToRadians(70),
        false);
    path.arcTo(Rect.fromLTWH(size.width - radius, 0, radius, radius),
        degreeToRadians(270), degreeToRadians(90), false);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(TabClipper oldClipper) => true;

  double degreeToRadians(double degree) {
    var redian = (math.pi / 180) * degree;
    return redian;
  }
}
