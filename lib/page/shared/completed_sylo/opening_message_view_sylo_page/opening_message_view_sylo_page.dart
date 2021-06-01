import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/common/play_view_side_video.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/util/navigate_effect.dart';

import '../../../../app.dart';
import 'opening_message_detail_shared_page/opening_message_detail_shared_page.dart';
import 'opening_message_view_sylo_page_view_model.dart';

class OpeningMessageViewSyloPage extends StatefulWidget {
  SharedSyloItem sharedSyloItem;
  OpeningMessageViewSyloPage({this.sharedSyloItem});
  @override
  OpeningMessageViewSyloPageState createState() => OpeningMessageViewSyloPageState();
}

class OpeningMessageViewSyloPageState extends State<OpeningMessageViewSyloPage> {
  OpeningMessageViewSyloPageViewModel model;
  bool playIcon = true;

  get videoThumbView => Container(
//    padding: EdgeInsets.only(left: 16, right: 16),
    child: InkWell(
//      onTap: () async {
//        var result = await Navigator.push(
//            context, NavigatePageRoute(context, OpeningMessageDetailSharedPage(sharedSyloItem: widget.sharedSyloItem)));
//      },
      child: ClipOval(
        child: Container(
          height: MediaQuery.of(context).size.width-32,
          width: MediaQuery.of(context).size.width-32,
          child: ClipOval(
            child: ImageFromNetworkView(
              path: widget.sharedSyloItem?.syloPic??"",
              boxFit: BoxFit.cover,
            ),
          ),
          padding: EdgeInsets.all(3),
          color: colorOvalBorder,
        ),
      ),
    ),
  );

  get playButton => Container(
    margin: EdgeInsets.only(top: 12, bottom: 16),
    child: ClipOval(
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff9F00C5),
                Color(0xff9405BD),
                Color(0xff7913A7),
                Color(0xff651E96),
                Color(0xff522887),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )
        ),
        child: InkWell(
          onTap: () {
            setState(() {
              playIcon = !playIcon;
            });
            showDialog(
              context: context,
              builder: (BuildContext context) => PlayViewSideVideoPage(
                isFile: false,
                url:  (model.getSyloItem?.openingVideoUrl)??"",
              ),
            );
          },
          child:Icon(
            Icons.play_arrow,
            size: 28,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );

  get textDetailView => Container(
    padding: EdgeInsets.only(left: 16, right: 16),
    child: AutoSizeText(
      model.getSyloItem?.openingMsg??"",
      style: getTextStyle(
          size: 14,
          color: Colors.black,
          fontWeight: FontWeight.w400),
      textAlign: TextAlign.left,
    ),
  );

  get albumsView => Container(
    margin: EdgeInsets.only(right: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        InkWell(
          onTap: () async {
            var result = await Navigator.push(
                context, NavigatePageRoute(context,
                OpeningMessageDetailSharedPage(
                    sharedSyloItem: widget.sharedSyloItem)));
          },
          child: Container(
            child: Text(
              "Albums",
              style: getTextStyle(
                  color: colorSectionHead,
                  size: 16,
                  fontWeight: FontWeight.w500),
            ),
            padding: EdgeInsets.all(4),
          ),
        ),
        Icon(
          Icons.keyboard_arrow_right,
          size: 24,
          color: colorSectionHead,
        )
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = OpeningMessageViewSyloPageViewModel(this));

    return Scaffold(
      backgroundColor: getColorBg(),
      appBar: AppBar(
        title: Text(
          "Opening Message",
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
        actions: <Widget>[],
      ),
      body: SafeArea(
        child: Container(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Column(
                children: <Widget>[
                  videoThumbView,
                  albumsView,
                  playButton,
                  textDetailView,
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
