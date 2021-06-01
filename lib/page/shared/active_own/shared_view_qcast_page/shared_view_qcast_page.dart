import 'package:flutter/material.dart';
import 'package:testsylo/bloc_item/seek_bloc.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/common/play_view_side_video.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/page/shared/active_own/shared_view_qcast_page/shared_view_qcast_page_view_model.dart';

import '../../../../app.dart';

class SharedViewQcastPage extends StatefulWidget {
  String from;
  AlbumMediaData albumMediaData;
  SyloQuestionItem syloQuestionItem;
  SharedViewQcastPage({this.from, this.albumMediaData, this.syloQuestionItem});
  @override
  SharedViewQcastPageState createState() => SharedViewQcastPageState();
}

class SharedViewQcastPageState extends State<SharedViewQcastPage> {
  SharedViewQcastPageViewModel model;
  bool playIcon = true;

  get topTextView => Container(
        padding: EdgeInsets.only(bottom: 24),
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
            widget.from == "ActiveSyloSharedOwnPageState"
                ? SizedBox()
                : tagDisplayView,
          ],
        ),
      );

  bool isStart = false;
  get videoThumbView => Container(
          child: Container(
        height: MediaQuery.of(context).size.width - 16,
        width: MediaQuery.of(context).size.width - 16,
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: model.listImages.length == 1 ? 0 : 10),
        child: GridView.builder(
          physics: model.listImages.length == 1
              ? NeverScrollableScrollPhysics()
              : ScrollPhysics(),
          itemCount: model.listImages.length,
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: model.listImages.length == 1 ? 1 : 2,
              childAspectRatio: 1.0),
          shrinkWrap: true,
          itemBuilder: (c, i) {
            var arr = model.subAlbumData.mediaUrls[i].split('@');
//            String mediaUrl = arr[1];
            return Container(
              margin: EdgeInsets.only(
                  top: arr[0] == "1" ? 0 : 10,
                  bottom: arr[0] == "1" ? 0 : 10,
                  left: 10,
                  right: 10),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        top: arr[0] == "1" ? 0 : 15,
                        bottom: arr[0] == "1" ? 0 : 15,
                        left: arr[0] == "1" ? 30 : 15,
                        right: arr[0] == "1" ? 30 : 15,
                      ),
                      child: arr[0] == "1"
                          ? Container(
                              child: Container(
                                child: ImageFromNetworkView(
                                  path: model.listImages[i].image ?? "",
                                  boxFit: BoxFit.cover,
                                ),
                                width: double.infinity,
                                height: double.infinity,
                              ),
                              padding: EdgeInsets.all(3),
                              color: colorOvalBorder,
                            )
                          : ClipOval(
                              child: Container(
                                child: ClipOval(
                                  child: Container(
                                    child: ImageFromNetworkView(
                                      path: model.listImages[i].image ?? "",
                                      boxFit: BoxFit.cover,
                                    ),
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                                padding: EdgeInsets.all(3),
                                color: colorOvalBorder,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                ],
              ),
            );
          },
        ),
      ));

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
                      url: getMediaUrl(model.subAlbumData.mediaUrls[0]),
                      cameraState: getVideoShape(model.subAlbumData.mediaUrls[0]),
                      playIndicator: true,
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

  get addToQcastButton => (widget.from != "SyloAlbumDetailPageState" &&
          widget.from != "SharedDetailAlbumPageState")
      ? Container(
          margin: EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 16),
          height: 45,
          child: AbsorbPointer(
            absorbing: model.disableAddQcast ?? true,
            child: commonButtonWithCorner(() {
              model.callAddToQcastQueastios();
            },
                "Add to Qcast Questions",
                Container(
                /*  child: Image.asset(
                    App.ic_q,
                    width: 22,
                    height: 22,
                    color: model.disableAddQcast ? colorDisable : colorDark,
                  ),*/
                ),
                font_size: 16,
                color: model.disableAddQcast ? colorDisable : colorDark),
          ),
        )
      : SizedBox();

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = SharedViewQcastPageViewModel(this));

    return Scaffold(
      backgroundColor: getColorBg(),
      appBar: AppBar(
        title: Text(
          (widget.from == "SyloAlbumDetailPageState" ||
                  widget.from == "SharedDetailAlbumPageState")
              ? "View Video"
              : "View Qcast",
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
                  onTap: () {
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
                  videoThumbView,
                  addToQcastButton,
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  getMediaUrl(String link) {
    String mediaUrl = "";
    var arr = link.split('@');
    if (arr.length > 1) {
      mediaUrl = arr[1];
    } else {
      mediaUrl = arr[0];
    }
    return mediaUrl;
  }

  getVideoShape(String link) {
    CameraState cameraState = CameraState.R;
    var arr = link.split('@');
    if (arr[0] == "1") {
      cameraState = CameraState.S;
    }
    return cameraState;
  }
}
