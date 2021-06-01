import 'package:circle_list/circle_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/page/common/create_album_page.dart';
import 'package:testsylo/page/post_media/post_sound_bite/record/record_sound_page.dart';
import 'package:testsylo/page/sylo/add_sylo_page/add_sylo_page.dart';
import 'package:testsylo/page/sylo/view_sylo_page/sylo_album_page/sylo_album_page.dart';
import 'package:testsylo/page/sylo/view_sylo_page/view_sylo_page_view_model.dart';
import 'package:testsylo/util/navigate_effect.dart';

import '../../../app.dart';
import 'active_shared_me_sylo_page_view_model.dart';
import 'send_text/send_letter_post_page.dart';

class ActiveSharedMeSyloPage extends StatefulWidget {
  SharedSyloItem sharedSyloItem;
  ActiveSharedMeSyloPage({this.sharedSyloItem});
  @override
  ActiveSharedMeSyloPageState createState() => ActiveSharedMeSyloPageState();
}

class ActiveSharedMeSyloPageState extends State<ActiveSharedMeSyloPage> {
  ActriveSharedMeSyloPageViewModel model;
  MediaPostTapState mediaPostTapState = MediaPostTapState.None;

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
          child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned.fill(
              child: Container(
                margin: EdgeInsets.all(40),
                child: borderCircle,
              )
          ),
          CircleList(
            origin: Offset(0, 0),
            outerRadius: 185,
            children: <Widget>[
              commonActionAlbumIconButton(
                  () async {},
                  Image.asset(
                    App.ic_edit_album,
                    color: Colors.white,
                  ),
                  isBadge: true,
                  countNumber: model.syloMediaCountItem.text??0,
                  viewColor: colorDisable),
              commonActionAlbumIconButton(
                  () async {},
                  Image.asset(
                    App.ic_video,
                    color: Colors.white,
                  ),
                  viewColor: colorDisable,
                  isBadge: true,
                  countNumber: model.syloMediaCountItem.video??0
              ),
              commonActionAlbumIconButton(
                () async {},
                Image.asset(
                  App.ic_mic,
                  color: Colors.white,
                ),
                viewColor: colorDisable,
                isBadge: true,
                countNumber: model.syloMediaCountItem.audio??0
              ),
              commonActionAlbumIconButton(
                  () async {},
                  Image.asset(
                    App.ic_images_album,
                    color: Colors.white,
                  ),
                  viewColor: colorDisable,
                  isBadge: true,
                  countNumber: model.syloMediaCountItem.photo??0
              ),
              commonActionAlbumIconButton(
                () async {},
                Image.asset(
                  App.ic_music_album,
                  color: Colors.white,
                ),
                viewColor: colorDisable,
                isBadge: true,
                countNumber: model.syloMediaCountItem.songs??0
              ),
              commonActionAlbumIconButton(
                () async {},
                Image.asset(
                  App.ic_refresh_album,
                  color: Colors.white,
                ),
                  viewColor: colorDisable,
                  isBadge: true,
                  countNumber: model.syloMediaCountItem.vtag??0
              ),
            ],
            rotateMode: RotateMode.stopRotate,
            initialAngle: -78,
            centerWidget: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                pickProfile,
              ],
            ),
          ),
        ],
      ));

  get pickProfile => Stack(
        children: <Widget>[
          Container(
            width: 135,
            height: 135,
            child: ClipOval(
                child: Container(
                  color: colorOvalBorder,
                  padding: EdgeInsets.all(2),
                  child: ClipOval(
                    child: ImageFromNetworkView(
                      path: widget.sharedSyloItem.syloPic ?? "",
                      boxFit: BoxFit.cover,
                    ),
                  ),
                )),
          ),
        ],
      );

  get viewAllButton => Container(
          child: Row(
        children: <Widget>[
          InkWell(
            child: commonGradButtonWithIcon(App.ic_eye, "View"),
            onTap: () {},
          ),
          SizedBox(
            width: 12,
          )
        ],
      ));

  get topLabelView => Container(
        alignment: Alignment.center,
        child: Text(
            "Only Answers and Timeposts your provider gives you permission to view will be accessible here prior to you receiving your completed Sylo.", textAlign: TextAlign.center,),
      );

  get gradientButtonsView => Container(

    padding: EdgeInsets.only(top: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[

        commonGradientIconButton(
              () async {

                goToRecordQCastPage(context, runtimeType.toString(), null);

              },
          Image.asset(
            App.ic_q,
            color: Colors.white,
          ),
          viewColor: colorDisable,
          isGradient: true
        ),

        SizedBox(width: 16,),

        commonGradientIconButton(
                () async {

                  var result = await Navigator.push(
                      context, NavigatePageRoute(context, RecordSoundPage(runtimeType.toString())));

                },
            Image.asset(
              App.ic_mic,
              color: Colors.white,
            ),
            viewColor: colorDisable,
            isGradient: true
        ),

        SizedBox(width: 16,),

        commonGradientIconButton(
                () async {


                  var result = await Navigator.push(
                      context, NavigatePageRoute(context, SendLatterPage()));

                },
            Image.asset(
              App.ic_edit_album,
              color: Colors.white,
            ),
            viewColor: colorDisable,
            isGradient: true
        )


      ],

    ),

  );

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = ActriveSharedMeSyloPageViewModel(this));
    return Scaffold(
      backgroundColor: getColorBg(),
      appBar: AppBar(
        title: Text(
          appState.sharedSyloItem.displayName ?? appState.sharedSyloItem.syloName,
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
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          viewAllButton,
        ],
      ),
      body: SafeArea(
        child: Container(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(height: 16,),
                  topLabelView,
                  SizedBox(height: 8,),
                  topCircularView,
                  Text("Ask your Sylo Provider a Question", textAlign: TextAlign.center, style: getTextStyle(size: 20, fontWeight: FontWeight.w800),),
                  gradientButtonsView,
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
