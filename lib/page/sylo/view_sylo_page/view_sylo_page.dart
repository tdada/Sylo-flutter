import 'package:auto_size_text/auto_size_text.dart';
import 'package:circle_list/circle_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/common/loader_page.dart';
import 'package:testsylo/model/api_request.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/page/common/create_album_page.dart';
import 'package:testsylo/page/sylo/add_sylo_page/add_sylo_page.dart';
import 'package:testsylo/page/sylo/view_sylo_page/sylo_album_page/sylo_album_page.dart';
import 'package:testsylo/page/sylo/view_sylo_page/view_sylo_page_view_model.dart';
import 'package:testsylo/util/navigate_effect.dart';

import '../../../app.dart';
import 'sylo_album_page/sylo_album_detail_page/sylo_album_detail_page.dart';

class ViewSyloPage extends StatefulWidget {
  GetUserSylos userSylo;
  Function(int index, GetUserSylos sylo, {String from, GetAlbum getAlbum})
      callBack;
  ViewSyloPage({this.userSylo, this.callBack});

  @override
  ViewSyloPageState createState() => ViewSyloPageState();
}

class ViewSyloPageState extends State<ViewSyloPage> {
  ViewSyloPageViewModel model;
  MediaPostTapState mediaPostTapState = MediaPostTapState.None;

  @override
  void initState() {
    super.initState();
    model = ViewSyloPageViewModel(this);
    appState.albumList = List();
    model.getAllAlbumsForTheSylo(widget.userSylo.syloId.toString());
  }

  get borderCircle => ClipOval(
        child: Container(
          padding: EdgeInsets.all(2),
          color: colorOvalBorder,
          child: ClipOval(
            child: Container(
              color: Colors.white,
//              height: MediaQuery.of(context).size.width - 80,
//              width: MediaQuery.of(context).size.width - 80,
            ),
          ),
        ),
      );

  get topCircularView => Container(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              //borderCircle,
              Positioned.fill(
                  child: Container(
                margin: EdgeInsets.all(48),
                child: borderCircle,
              )),
              Center(
                child: CircleList(
                  origin: Offset(0, 0),

                  outerRadius: (MediaQuery.of(context).size.width) / 2,
                  children: <Widget>[
                    commonActionAlbumColorIconButton(
                      () async {
                        setState(() {
                          mediaPostTapState = MediaPostTapState.T;
                        });

                        await Future.delayed(Duration(milliseconds: startDur));

                        goToTextPostPage(context);

                        await Future.delayed(Duration(milliseconds: endDur));

                        setState(() {
                          mediaPostTapState = MediaPostTapState.None;
                        });
                      },
                      Image.asset(
                        App.ic_edit_album,
                        color: getTapWhiteIconColorTint(
                            mediaPostTapState == MediaPostTapState.T, colorgradient),
                      ),
                      isGradient: mediaPostTapState == MediaPostTapState.T,
                    ),
                    commonActionAlbumColorIconButton(
                      () async {
                        setState(() {
                          mediaPostTapState = MediaPostTapState.V;
                        });

                        await Future.delayed(Duration(milliseconds: startDur));

                        goToVideoPostPage(context);

                        await Future.delayed(Duration(milliseconds: endDur));

                        setState(() {
                          mediaPostTapState = MediaPostTapState.None;
                        });
                      },
                      Image.asset(
                        App.ic_video,
                        color: getTapWhiteIconColorTint(
                            mediaPostTapState == MediaPostTapState.V, null),
                      ),
                      isGradient: mediaPostTapState == MediaPostTapState.V,
                    ),
                    commonActionAlbumColorIconButton(
                      () async {
                        setState(() {
                          mediaPostTapState = MediaPostTapState.S;
                        });

                        await Future.delayed(Duration(milliseconds: startDur));

                        goToSoundBitePage(context);

                        await Future.delayed(Duration(milliseconds: endDur));

                        setState(() {
                          mediaPostTapState = MediaPostTapState.None;
                        });
                      },
                      Image.asset(
                        App.ic_mic,
                        color: getTapWhiteIconColorTint(
                            mediaPostTapState == MediaPostTapState.S, null),
                      ),
                      isGradient: mediaPostTapState == MediaPostTapState.S,
                    ),
                    commonActionAlbumColorIconButton(
                      () async {
                        setState(() {
                          mediaPostTapState = MediaPostTapState.P;
                        });

                        await Future.delayed(Duration(milliseconds: startDur));

                        goToPhotoPostPage(context);

                        await Future.delayed(Duration(milliseconds: endDur));

                        setState(() {
                          mediaPostTapState = MediaPostTapState.None;
                        });
                      },
                      Image.asset(
                        App.ic_images_album,
                        color: getTapWhiteIconColorTint(
                            mediaPostTapState == MediaPostTapState.P, null),
                      ),
                      isGradient: mediaPostTapState == MediaPostTapState.P,
                    ),
                    commonActionAlbumColorIconButton(
                      () async {
                        setState(() {
                          mediaPostTapState = MediaPostTapState.M;
                        });

                        await Future.delayed(Duration(milliseconds: startDur));

                        goToSongPostPage(context);

                        await Future.delayed(Duration(milliseconds: endDur));

                        setState(() {
                          mediaPostTapState = MediaPostTapState.None;
                        });
                      },
                      Image.asset(
                        App.ic_music_album,
                        color: getTapWhiteIconColorTint(
                            mediaPostTapState == MediaPostTapState.M, null),
                      ),
                      isGradient: mediaPostTapState == MediaPostTapState.M,
                    ),
                    commonActionAlbumColorIconButton(
                      () async {
                        setState(() {
                          mediaPostTapState = MediaPostTapState.R;
                        });

                        await Future.delayed(Duration(milliseconds: startDur));

                        goToRePostPage(context);

                        await Future.delayed(Duration(milliseconds: endDur));

                        setState(() {
                          mediaPostTapState = MediaPostTapState.None;
                        });
                      },
                      Image.asset(
                        App.ic_refresh_album,
                        color: getTapWhiteIconColorTint(
                            mediaPostTapState == MediaPostTapState.R, null),
                      ),
                      isGradient: mediaPostTapState == MediaPostTapState.R,
                    ),
                  ],
                  rotateMode: RotateMode.stopRotate,
                  initialAngle: -78,
                  centerWidget: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      pickProfile,
                      editVideoButtons,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ));

  get pickProfile => Stack(
        children: <Widget>[
          ClipOval(
            child: Container(
              padding: EdgeInsets.all(2),
              color: colorOvalBorder,
              child: ClipOval(
                //borderRadius: BorderRadius.circular(10),
                child: Container(
                    width: 125,
                    height: 125,
                    child: Container(
                      color: Colors.white,
                      child: ImageFromNetworkView(
                        path: widget.userSylo.syloPic != null
                            ? widget.userSylo.syloPic
                            : "",
                        boxFit: BoxFit.cover,
                      ),
                    )),
              ),
            ),
          ),
        ],
      );

  get editVideoButtons => Container(
      width: 65,
      margin: EdgeInsets.only(top: 8),
      child: Material(
        elevation: 0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Ink(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(color: colorSectionHead, width: 0.9)),
          child: InkWell(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 4, right: 4, top: 5, bottom: 3),
              child: Text(
                "Edit Sylo",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: colorSectionHead,
                    fontWeight: FontWeight.w500,
                    fontSize: 11),
              ),
            ),
            onTap: () async {
              var result = await Navigator.push(
                  context,
                  NavigatePageRoute(context,
                      AddSyloPage(userSylo: widget.userSylo, isEdit: true)));
              if (result != null) {
                AddSyloItem addSyloItem = result;
                widget.userSylo.syloPic = addSyloItem.syloPic;
                widget.userSylo.syloName = addSyloItem.recipientName;
                widget.userSylo.displayName = addSyloItem.displayName;
                appState.getUserSylosList = null;
                setState(() {});
              }
            },
          ),
        ),
      ));

  get albumsView => Container(
        height: 195,
        padding: EdgeInsets.only(
          top: 16,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
          child: Container(
            padding: EdgeInsets.only(top: 4, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 16, right: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text(
                            "Albums",
                            style: getTextStyle(
                                size: 18,
                                fontWeight: FontWeight.w800,
                                color: Colors.black),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            InkWell(
                              onTap: () async {
                                widget.callBack(7, widget.userSylo);
                                /*var result = await Navigator.push(
                                    context,
                                    NavigatePageRoute(
                                        context, SyloAlbumPage()));*/
                              },
                              child: Container(
                                child: Text(
                                  "View all",
                                  style: getTextStyle(
                                      color: colorSectionHead,
                                      size: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                padding: EdgeInsets.only(),
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_right,
                              size: 24,
                              color: colorSectionHead,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        itemCount: appState.albumList.length + 1,
                        /*  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, childAspectRatio: 0.5),
               */
                        shrinkWrap: true,
                        itemBuilder: (c, i) {
                          i = i - 1;
                          if (i == -1) {
                            return Container(
                              padding: EdgeInsets.only(left: 16),
                              child: Stack(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      ClipOval(
                                        child: Container(
                                          child: ClipOval(
                                            child: Container(
                                              color: Colors.white,
                                              width: 74,
                                              height: 74,
                                              child: InkWell(
                                                onTap: () async {
                                                  String result =
                                                      await showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        CreateAlbumPage(
                                                            syloId: widget
                                                                .userSylo.syloId
                                                                .toString()),
                                                  );
                                                  if (result != null) {
                                                    setState(() {});
                                                  }
                                                },
                                                child: Container(
                                                  child: Image.asset(
                                                    App.ic_create_album,
                                                    fit: BoxFit.contain,
                                                  ),
                                                  padding: EdgeInsets.only(
                                                      left: 3,
                                                      right: 3,
                                                      top: 8,
                                                      bottom: 8),
                                                ),
                                              ),
                                            ),
                                          ),
                                          padding: EdgeInsets.all(3),
                                          color: colorOvalBorder,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Container(
                                        child: Text(
                                          "Create Album",
                                          style: getTextStyle(
                                              color: Colors.black,
                                              size: 14,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        padding: EdgeInsets.only(top: 3),
                                      )
                                    ],
                                    mainAxisSize: MainAxisSize.min,
                                  ),
                                ],
                              ),
                            );
                          }
                          GetAlbum getAlbum = appState.albumList[i];
                          return Container(
                            width: 120,
                            padding: EdgeInsets.only(left: 16),
                            child: Column(
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    ClipOval(
                                      child: Container(
                                        child: ClipOval(
                                          child: Container(
                                            color: Colors.white,
                                            child: InkWell(
                                                onTap: () async {
                                                  /*var result = await Navigator.push(
                                                    context,
                                                    NavigatePageRoute(context,
                                                        SyloAlbumDetailPage(getAlbum: getAlbum,)));*/
                                                  /*goToAlbumDetailPage(
                                                      context, getAlbum,runtimeType.toString(), widget.userSylo, widget.callBack);*/
                                                  widget.callBack(
                                                      8, widget.userSylo,
                                                      from: runtimeType
                                                          .toString(),
                                                      getAlbum: getAlbum);
                                                },
                                                child: getAlbumThumbIcon(
                                                    getAlbum.mediaType,
                                                    getAlbum.coverPhoto,
                                                    cHeight: 74,
                                                    cWidth: 74)),
                                          ),
                                        ),
                                        padding: EdgeInsets.all(3),
                                        color: colorOvalBorder,
                                      ),
                                    ),
                                    Positioned(
                                      child: ClipOval(
                                        child: Container(
                                          child: Text(
                                            getAlbum.mediaCount != null
                                                ? getAlbum.mediaCount.toString()
                                                : "0",
                                            style: getTextStyle(
                                              color: Colors.black,
                                              size: 9,
                                              fontWeight: FontWeight.w800,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          color: colorOvalBorder,
                                          alignment: Alignment.center,
                                          width: 24,
                                          height: 24,
                                        ),
                                      ),
                                      right: 0,
                                      top: 0,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  width: 70,
                                  child: AutoSizeText(
                                    getAlbum.albumName,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: getTextStyle(
                                        color: Colors.black,
                                        size: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  padding: EdgeInsets.only(top: 3),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                      model.isLoader
                          ? Center(child: getCircularIndicatorWithBackSheet())
                          : SizedBox(height: 0, width: 0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  get viewAllButton => Container(
          child: Row(
        children: <Widget>[
          InkWell(
            child: commonGradButtonWithIcon(App.ic_eye, "View All"),
            onTap: () async {
              widget.callBack(7, widget.userSylo, from: "ViewAllButton");
              /*var result = await Navigator.push(
                  context,
                  NavigatePageRoute(
                      context, SyloAlbumPage(from: "ViewAllButton")));*/
            },
          ),
          SizedBox(
            width: 12,
          )
        ],
      ));

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = ViewSyloPageViewModel(this));
    return Scaffold(
      backgroundColor: getColorBg(),
      appBar: AppBar(
        title: Text(
          widget.userSylo.displayName ?? widget.userSylo.syloName,
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

            if(widget.callBack==null)
               {
                 Navigator.pop(context);
              }
            else {
              widget.callBack(5, null);
            }
//            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          viewAllButton,
        ],
      ),
      body: WillPopScope(
        onWillPop: () {
          widget.callBack(5, null);
          return;
        },
        child: SafeArea(
          child: Container(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                Column(
                  children: <Widget>[
                    topCircularView,
                    albumsView,
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
