import 'package:auto_size_text/auto_size_text.dart';
import 'package:circle_list/circle_list.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/page/sylo/view_sylo_page/sylo_album_page/sylo_album_page_view.dart';

import '../../../../app.dart';

class SyloAlbumPage extends StatefulWidget {
  String from;
  GetUserSylos userSylo;
  Function(int index, GetUserSylos sylo,{String from, GetAlbum getAlbum, bool isAlbumGrid}) callBack;
  bool isAlbumGrid;
  SyloAlbumPage({this.from, this.userSylo, this.callBack, this.isAlbumGrid=false});

  @override
  SyloAlbumPageState createState() => SyloAlbumPageState();
}

class SyloAlbumPageState extends State<SyloAlbumPage> {
  SyloAlbumPageViewModel model;
  bool syloAlbumDisplayView;
  MediaPostTapState mediaPostTapState = MediaPostTapState.None;

  @override
  void initState() {
    super.initState();
    syloAlbumDisplayView = widget.isAlbumGrid;
  }

  get syloAlbumsGridView => Stack(
    alignment: Alignment.center,
    children: <Widget>[
      Container(
        margin: EdgeInsets.only(top:16),
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: appState.albumList?.length??0,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, childAspectRatio: 0.85),
              shrinkWrap: true,
              itemBuilder: (c, i) {
                GetAlbum getAlbum = appState.albumList[i];
                return GestureDetector(
                  child: Container(
                    padding: EdgeInsets.only(left: 5, top: 5),
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            ClipOval(
                              child: Container(
                                child: ClipOval(
                                  child:getAlbumThumbIcon(getAlbum.mediaType,getAlbum.coverPhoto,cHeight: 82,cWidth: 82),
                                ),
                                padding: EdgeInsets.all(3),
                                color: colorOvalBorder,
                              ),
                            ),
                            Positioned(
                              child: ClipOval(
                                child: Container(
                                  child: Text(getAlbum.mediaCount!=null?getAlbum.mediaCount.toString():"0", style: getTextStyle(color: Colors.black, size: 9, fontWeight: FontWeight.w800, ), overflow: TextOverflow.ellipsis, maxLines: 1,),
                                  color: colorOvalBorder,
                                  alignment: Alignment.center,
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                              right: 1,
                              top: 1,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Container(
                          child: Text(
                            getAlbum.albumName,
                            style: getTextStyle(
                                color: colorDark,
                                size: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          padding: EdgeInsets.only(top: 3),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    goToAlbumDetailPage(context, getAlbum, runtimeType.toString(), widget.userSylo, widget.callBack);
                    //widget.callBack(8, widget.userSylo, from: runtimeType.toString(), getAlbum: getAlbum, isAlbumGrid:true);
                  },
                );
              },
            ),
          ),
      model.isLoader ?
      Center(child: getCircularIndicatorWithBackSheet())
          : SizedBox(height: 0, width: 0),
    ],
  );

  get borderCircle => ClipOval(
    child: Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        border: Border.all(color: colorOvalBorder),
      ),
      child: Container(
        color: Colors.transparent,
//        height: MediaQuery.of(context).size.width - 80,
//        width: MediaQuery.of(context).size.width - 80,
      ),
    ),
  );

  get syloAlbumsCircularView => Stack(
    alignment: Alignment.center,
    children: <Widget>[
      Container(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned.fill(
                    child: Container(
                      margin: EdgeInsets.all(40),
                      child: borderCircle,
                    )
                ),
                Center(
                  child: CircleList(
                    origin: Offset(0, 0),
                    outerRadius: 185,
                    children: List.generate((appState.albumList?.length??0)>9?9:appState.albumList?.length??0, (index) {
                      GetAlbum getAlbum = appState.albumList[index];
                      return Stack(
                        children: <Widget>[
                          InkWell (
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ClipOval(
                                  child: Container(
                                    child: ClipOval(
                                      child: getAlbumThumbIcon(getAlbum.mediaType,getAlbum.coverPhoto,audioImagePadding: 13),
                                    ),
                                    padding: EdgeInsets.all(3),
                                    color: colorOvalBorder,
                                  ),
                                ),
                                Container(
                                  child: AutoSizeText(
                                    getAlbum.albumName,
                                    style: getTextStyle(
                                        color: Colors.black,
                                        size: 13,
                                        fontWeight: FontWeight.w500),
                                    maxFontSize: 10,
                                    minFontSize: 6,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  padding: EdgeInsets.only(top: 3),
                                  width: 50,
                                  alignment: Alignment.center,
                                )
                              ],
                            ),
                            onTap: () {
                              goToAlbumDetailPage(context, getAlbum, runtimeType.toString(), widget.userSylo, widget.callBack);
                            print("check sylo::");
                            print(widget.userSylo.syloId);

                            print("check album");
                            print(getAlbum.albumName);
                             // widget.callBack(8, widget.userSylo, from: runtimeType.toString(), getAlbum: getAlbum);
                            },
                          ),
                          Positioned(
                            child: ClipOval(
                              child: Container(
                                child: Text(getAlbum.mediaCount!=null?getAlbum.mediaCount.toString():"0", style: getTextStyle(color: Colors.black, size: 9, fontWeight: FontWeight.w800, ), overflow: TextOverflow.ellipsis, maxLines: 1,),
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
                      );
                    }),
                    centerWidget: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ClipOval(
                          child: Container(
                            child: ClipOval(
                              child: Container(
                                height:85,
                                width: 85,
                                child: ImageFromNetworkView(
                                  path:appState.userSylo.syloPic!=null?appState.userSylo.syloPic:"",
                                  boxFit: BoxFit.cover,
                                ),
                              ),
                            ),
                            padding: EdgeInsets.all(3),
                            color: colorOvalBorder,
                          ),
                        ),
                        Container(
                          child: Text(
                            appState.userSylo.syloName,
                            style: getTextStyle(
                                color: Colors.black,
                                size: 13,
                                fontWeight: FontWeight.w500),
                          ),
                          padding: EdgeInsets.only(top: 7),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      model.isLoader ?
      Center(child: getCircularIndicatorWithBackSheet())
          : SizedBox(height: 0, width: 0),
    ],
  );

  get addMoreActionButtonView => Container(
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 16, right: 8),
                  alignment: Alignment.centerLeft,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: Container(
                      child: Text(
                        "Add More",
                        style: getTextStyle(
                            size: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      commonActionAlbumIconButton(
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
                          fit: BoxFit.fill,
                          color: getTapWhiteIconColor(
                              mediaPostTapState == MediaPostTapState.V, null),
                        ),
                        isGradient:mediaPostTapState == MediaPostTapState.V,),
                      commonActionAlbumIconButton(
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
                          color: getTapWhiteIconColor(
                              mediaPostTapState == MediaPostTapState.S, null),
                        ),
                        isGradient:mediaPostTapState == MediaPostTapState.S,),
                      commonActionAlbumIconButton(
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
                          color: getTapWhiteIconColor(
                              mediaPostTapState == MediaPostTapState.P, null),
                        ),
                        isGradient:mediaPostTapState == MediaPostTapState.P,),
                      commonActionAlbumIconButton(
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
                          color: getTapWhiteIconColor(
                              mediaPostTapState == MediaPostTapState.M, null),
                        ),
                        isGradient:mediaPostTapState == MediaPostTapState.M,),
                      commonActionAlbumIconButton(
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
                          color: getTapWhiteIconColor(
                              mediaPostTapState == MediaPostTapState.R, null),
                        ),
                        isGradient:mediaPostTapState == MediaPostTapState.R,),
                      commonActionAlbumIconButton(
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
                          color: getTapWhiteIconColor(
                              mediaPostTapState == MediaPostTapState.T, null),
                        ),
                        isGradient:mediaPostTapState == MediaPostTapState.T,),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  get viewAllHeaderButton => Container(

      child: Row(
        children: <Widget>[
          InkWell(
            child: commonGradButtonWithIcon(
                App.ic_eye, syloAlbumDisplayView ? "Circular" : "Grid"),
            onTap: () {
              setState(() {
                syloAlbumDisplayView = !syloAlbumDisplayView;
              });
            },
          ),
          SizedBox(width: 16,)
        ],
      ));

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = SyloAlbumPageViewModel(this));

    return WillPopScope(
      onWillPop: () {
        widget.callBack(6, widget.userSylo);
        return;
      },
      child: Scaffold(
        backgroundColor: getColorBg(),
        appBar: AppBar(
          title: Text(
            "Albums",
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
              widget.callBack(6, widget.userSylo);
            //Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.white,
          actions: <Widget>[
            viewAllHeaderButton,
          ],
        ),
        body: SafeArea(
          child: Container(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                Column(
                  children: <Widget>[
                    syloAlbumDisplayView
                        ? syloAlbumsGridView
                        : syloAlbumsCircularView,
                    addMoreActionButtonView
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
