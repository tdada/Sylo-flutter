import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/api_response.dart';

import '../../../../../../../app.dart';
import 'completed_sylo_song_page_view_model.dart';

class CompletedSyloSongPage extends StatefulWidget {
  String from;
  AlbumMediaData albumMediaData;
  CompletedSyloSongPage({this.from, this.albumMediaData});

  @override
  CompletedSyloSongPageState createState() => CompletedSyloSongPageState();
}

class CompletedSyloSongPageState extends State<CompletedSyloSongPage> {
  CompletedSyloSongPageViewModel model;

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
        itemCount: model.tagList?.length ?? 0,
        shrinkWrap: true,
        itemBuilder: (c, i) {
          return Container(
            padding: EdgeInsets.only(left: 4, right: 4),
            height: 30,
            child: FlatButton(
                onPressed: () {},
                child: Text(model.tagList[i]),
                color: colorOvalBorder,
                disabledColor: colorOvalBorder,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                )),
          );
        },
      ));

  get detailTextView => Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 20),
        child: Container(
          padding: EdgeInsets.all(16),
          child: AutoSizeText(
            model.subAlbumData.description ?? "",
            style: getTextStyle(
                size: 14, color: Colors.black, fontWeight: FontWeight.w400),
            textAlign: TextAlign.left,
          ),
        ),
      );

  get thumbnailSongPlatformView => Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 16),
//    height: 162,
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: () {
                model.redirectonLink(model.subAlbumData.directUrl);
              },
              child: Container(
                child: ClipOval(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3,
                    height: MediaQuery.of(context).size.width / 3,
                    color: colorOvalBorder,
                    padding: EdgeInsets.all(2),
                    child: ClipOval(
                      child: Container(
                        child: ImageFromNetworkView(
                          path: model.subAlbumData.coverPhoto ?? "",
                          boxFit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, left: 2, bottom: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        height: 30,
                        width: 30,
                        child: ImageFromNetworkView(
                          path: model.subAlbumData.coverPhoto ?? "",
                          boxFit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      InkWell(
                        onTap: () {
                          model.redirectonLink(model.subAlbumData.directUrl);
                        },
                        child: AutoSizeText(
                          getAppNameFromLink(
                              model.subAlbumData.directUrl ?? ""),
                          style: getTextStyle(
                              color: Colors.black,
                              size: 18,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: 4,
                      bottom: 4,
                      left: MediaQuery.of(context).size.width / 3,
                      right: MediaQuery.of(context).size.width / 3,
                    ),
                    alignment: Alignment.center,
                    child: AutoSizeText(
                      model.subAlbumData.directUrl ?? "",
                      style: getTextStyle(
                          color: colorTextPara,
                          size: 14,
                          fontWeight: FontWeight.w500),
                      maxLines: 1,
                      minFontSize: 10,
                      maxFontSize: 14,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = CompletedSyloSongPageViewModel(this));

    return Scaffold(
      backgroundColor: getColorBg(),
      appBar: AppBar(
        title: Text(
          "Songs",
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
                  thumbnailSongPlatformView,
                  detailTextView,
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
