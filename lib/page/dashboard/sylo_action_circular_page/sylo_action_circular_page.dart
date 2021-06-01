import 'dart:ui';

import 'package:circle_list/circle_list.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/page/dashboard/sylo_action_circular_page/sylo_action_circular_page_view_model.dart';
import 'package:testsylo/util/navigate_effect.dart';

import '../../../app.dart';
import 'my_drafts_page/my_drafts_page.dart';

class SyloActionCircularPage extends StatefulWidget {
  @override
  SyloActionCircularPageState createState() => SyloActionCircularPageState();
}

class SyloActionCircularPageState extends State<SyloActionCircularPage> {
  SyloActionCircularPageViewModel model;
  MediaPostTapState mediaPostTapState = MediaPostTapState.None;

  get borderCircle => ClipOval(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
            border: Border.all(color: Colors.white),
          ),
          child: Container(
            color: Colors.transparent,
//            height: MediaQuery.of(context).size.width - 80,
//            width: MediaQuery.of(context).size.width - 80,
          ),
        ),
      );

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
                        path: appState.userItem.profilePic != null
                            ? appState.userItem.profilePic
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
      child: InkWell(
        child: Material(
          color: Color(0xcc979797),
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Ink(
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: Colors.white, width: 0.9)),
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 4, right: 4, top: 6, bottom: 4),
              child: Text(
                "My Drafts",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 11),
              ),
            ),
          ),
        ),
        onTap: () async {
          var result = await Navigator.push(
              context, NavigatePageRoute(context, MyDraftsPage()));
        },
      ));

  get topCircularView => Container(
          child: InkWell(

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
              child: InkWell(
                child: CircleList(
                  origin: Offset(0, 0),
                  outerRadius: 185,
                  children: <Widget>[
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
                      isGradient: mediaPostTapState == MediaPostTapState.T,
                    ),
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
                        color: getTapWhiteIconColor(
                            mediaPostTapState == MediaPostTapState.V, null),
                      ),
                      isGradient: mediaPostTapState == MediaPostTapState.V,
                    ),
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
                      isGradient: mediaPostTapState == MediaPostTapState.S,
                    ),
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
                      isGradient: mediaPostTapState == MediaPostTapState.P,
                    ),
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
                      isGradient: mediaPostTapState == MediaPostTapState.M,
                    ),
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
            ),
          ],
        ),
      ));

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = SyloActionCircularPageViewModel(this));

    return Scaffold(
      backgroundColor: Color(0xcc606060),
      body: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 4.0,
          sigmaY: 4.0,
        ),
        child: SafeArea(
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
                child: Column(
              children: <Widget>[
                /* Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Image.asset(
                            App.ic_back_white,
                            fit: BoxFit.contain,
                            width: 16,
                            height: 16,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),*/
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      topCircularView,
                    ],
                  ),
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}
