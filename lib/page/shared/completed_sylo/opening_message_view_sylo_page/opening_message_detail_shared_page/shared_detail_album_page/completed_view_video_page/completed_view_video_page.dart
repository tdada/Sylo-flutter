import 'package:flutter/material.dart';
import 'package:testsylo/bloc_item/seek_bloc.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/common/play_view_side_video.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/page/shared/active_own/shared_view_qcast_page/shared_view_qcast_page_view_model.dart';

import '../../../../../../../app.dart';
import 'completed_view_video_page_view_model.dart';

class CompletedViewVideoPage extends StatefulWidget {
  String from;
  AlbumMediaData albumMediaData;
  CompletedViewVideoPage({this.from, this.albumMediaData});
  @override
  CompletedViewVideoPageState createState() => CompletedViewVideoPageState();
}

class CompletedViewVideoPageState extends State<CompletedViewVideoPage> {
  CompletedViewVideoPageViewModel model;
  bool playIcon = true;

  get topTextView => Container(
        child: Column(
          children: <Widget>[
            Text(
              model.subAlbumData.title ?? "",
              style: getTextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                size: 18,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              model.subAlbumData.postedDate ?? "",
              style: getTextStyle(
                color: Colors.black,
                size: 13,
              ),
            ),
          ],
        ),
      );

  bool isStart = false;
  get videoThumbView => Container(
        padding: EdgeInsets.only(top: 16),
        height: MediaQuery.of(context).size.width + 32,
        width: MediaQuery.of(context).size.width + 32,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            ClipOval(
              child: Container(
                height: MediaQuery.of(context).size.width - 32,
                width: MediaQuery.of(context).size.width - 32,
                child: ClipOval(
                    child:Image.network(model.subAlbumData.coverPhoto ?? "",fit: BoxFit.cover,)
                  /*ImageFromNetworkView(
                    path: model.subAlbumData.coverPhoto ?? "",
                    boxFit: BoxFit.cover,
                  ),*/
                ),
                padding: EdgeInsets.all(3),
                color: colorOvalBorder,
              ),
            ),
            Container(
              alignment: Alignment.bottomRight,
              margin: EdgeInsets.only(right: 32),
              child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  ClipOval(
                    child: Container(
                        color: colorOvalBorder,
                        width: 112,
                        height: 112,
                        child: Image.network(model.subAlbumData.qcastCoverPhoto ?? "",fit: BoxFit.cover,)),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  get playButton => Container(
        margin: EdgeInsets.only(top: 24),
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
            )),
            child: InkWell(
              onTap: () {
                /* setState(() {
              isStart = true;
              playIcon = !playIcon;
            });*/
                showDialog(
                  context: context,
                  builder: (BuildContext context) => PlayViewSideVideoPage(
                    isFile: false,
                    url: model.subAlbumData.mediaUrls[0] ?? "",
                    queLink: model.queLink,
                    strtTimingList: model.strtTimingList,
                    thumbImageLink: model.subAlbumData.qcastCoverPhoto,
                  ),
                );
              },
              child: Icon(
                playIcon ? Icons.play_arrow : Icons.pause,
                size: 28,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );

  get tagDisplayView => Container(
      alignment: Alignment.center,
      height: 30,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemCount: model.tagList.length ?? 0,
        shrinkWrap: true,
        itemBuilder: (c, i) {
          return Container(
            padding: EdgeInsets.only(left: 4, right: 4),
            height: 30,
            child: FlatButton(
                onPressed: () {},
                child: Text(model.tagList[i] ?? ""),
                color: colorOvalBorder,
                disabledColor: colorOvalBorder,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                )),
          );
        },
      ));

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = CompletedViewVideoPageViewModel(this));

    return Scaffold(
      backgroundColor: getColorBg(),
      appBar: AppBar(
        title: Text(
          "View Qcast Interview",
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
          widget.from == "SyloAlbumDetailPageState"
              ? InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 12, left: 12),
                        child: Image.asset(
                          App.ic_delete_drafts,
                          height: 20,
                        ),
                      )
                    ],
                  ),
                  onTap: () async {
                    commonCupertinoDialogPage(
                        context,
                        Column(
                          children: <Widget>[
                            SizedBox(
                              height: 12,
                            ),
                            new Image.asset(
                              App.ic_alert_new,
                              height: 24,
                              width: 24,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "Are you sure you want to delete \nthis Posted media?",
                              textAlign: TextAlign.center,
                              style: getTextStyle(
                                  size: 18,
                                  height: 1.5,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 34,
                            ),
                          ],
                        ), positiveAction: () {
                      model.callDeleteSubAlbum();
                    });
                  },
                )
              : SizedBox()
        ],
      ),
      body: SafeArea(
        child: Container(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Column(
                children: <Widget>[
                  topTextView,
                  tagDisplayView,
                  videoThumbView,
                  playButton
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
