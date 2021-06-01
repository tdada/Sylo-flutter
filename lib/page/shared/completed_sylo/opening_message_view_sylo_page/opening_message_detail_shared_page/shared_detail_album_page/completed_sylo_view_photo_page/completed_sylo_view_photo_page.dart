import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/common/zoomable_widget.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/page/shared/completed_sylo/opening_message_view_sylo_page/opening_message_detail_shared_page/shared_detail_album_page/completed_view_play_voice_tag_page/completed_view_play_voice_tag_page.dart';
import 'package:testsylo/util/navigate_effect.dart';

import '../../../../../../../app.dart';
import 'completed_sylo_view_photo_page_view_model.dart';

class CompletedSyloViewPhotoPage extends StatefulWidget {
  String from;
  AlbumMediaData albumMediaData;

  CompletedSyloViewPhotoPage({this.from, this.albumMediaData});

  @override
  CompletedSyloViewPhotoPageState createState() =>
      CompletedSyloViewPhotoPageState();
}

class CompletedSyloViewPhotoPageState
    extends State<CompletedSyloViewPhotoPage> {
  CompletedSyloViewPhotoPageViewModel model;

  get topTextView => Container(
        padding: EdgeInsets.only(bottom: 8),
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
//          App.getDateByFormat(DateTime.now(), App.formatMMMDDYY),
              style: getTextStyle(
                color: Colors.black,
                size: 13,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            tagDisplayView,
          ],
        ),
      );

  get tagDisplayView => Container(
      alignment: Alignment.center,
//      padding: EdgeInsets.only(left: 40),
      height: 30,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemCount: model.tagList.length,
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

  get imageListView => Container(
        padding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
        alignment: Alignment.center,
        child: GridView.builder(
          physics: ScrollPhysics(),
          itemCount: model.subAlbumData?.mediaUrls?.length ?? 0,
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 1.0),
          shrinkWrap: true,
          itemBuilder: (c, i) {
            var arr = model.subAlbumData.mediaUrls[i].split('@');
            String mediaUrl = arr[1];
            Widget w;
            if (arr[0] == "0") {
              w = Container(
                  margin: EdgeInsets.only(left: 12, right: 12),
                  padding:
                      EdgeInsets.only(top: 2, bottom: 2, left: 2, right: 2),
                  color: colorOvalBorder,
                  child: ImageFromNetworkView(
                    path: mediaUrl != null ? mediaUrl : "",
                    boxFit: BoxFit.cover,
                  ));
            } else {
              w = Container(
                padding: EdgeInsets.all(4),
                child: ClipOval(
                  child: Container(
                    padding: EdgeInsets.all(2),
                    color: colorOvalBorder,
                    child: ClipOval(
                      child: Container(
                        child: ImageFromNetworkView(
                          path: mediaUrl != null ? mediaUrl : "",
                          boxFit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }

            return Container(
              margin: EdgeInsets.all(4),
              child: InkWell(
                onTap: () async {
                  if (widget.from != null &&
                      (widget.from == "SyloAlbumDetailPageState" ||
                          widget.from == "SharedDetailAlbumPageState")) {
                    zoomFileImageDialogueContainWidth(
                      context,
                      ZoomableWidget(
                        child: w,
                      ),
                      height: arr[0] != "0"
                          ? MediaQuery.of(context).size.width - 26
                          : null,
                    );
                  } else {
                    var result = await Navigator.push(
                        context,
                        NavigatePageRoute(
                            context, CompletedViewPlayVoiceTagPage()));
                  }
                },
                child: w,
              ),
            );
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = CompletedSyloViewPhotoPageViewModel(this));

    return Scaffold(
      backgroundColor: getColorBg(),
      appBar: AppBar(
        title: Text(
          "View Photo",
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
                      ),
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
//              model.callDeleteSubAlbum();
                  },
                )
              : SizedBox(),
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
                  imageListView,
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
