import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/common/play_view_side_video.dart';
import 'package:testsylo/model/qcast_dashboard_item.dart';

import '../../../../../../app.dart';
import 'subscriptions_detail_page_view_model.dart';

class SubscriptionsDetailPage extends StatefulWidget {
  DiscoverQcastItem discoverQcastItem;
  bool isAllowUserView;
  SubscriptionsDetailPage({this.discoverQcastItem, this.isAllowUserView=false});
  @override
  SubscriptionsDetailPageState createState() => SubscriptionsDetailPageState();
}




class SubscriptionsDetailPageState extends State<SubscriptionsDetailPage> {
  SubscriptionsDetailPageViewModel model;

  get topBanner => Row(
        children: <Widget>[
          ClipOval(
            child: Container(
              child: ClipOval(
                child: Container(
                  child: Image.network(
                    model.coverPhoto1??"",
                    fit: BoxFit.cover,

                  ),
                  width: 120,
                  height: 120,
                ),
              ),
              padding: EdgeInsets.all(3),
              color: colorOvalBorder,
            ),
          ),
          SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                AutoSizeText(
                  model.createQcastItem.title??"",
                  style: getTextStyle(
                    size: 14,
                    color: Colors.black,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    if(widget.isAllowUserView) {
                      var result = await goToSubscription(
                          context, widget.discoverQcastItem);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    child: Text(
                      widget.discoverQcastItem.name,
                      style: getTextStyle(
                          color: colorDark,
                          size: 14,
                          fontWeight: FontWeight.w400),
                    ),
                    padding: EdgeInsets.only(left: 3, top: 7, bottom: 2),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      child: Text(
                        model.createQcastItem.category??"",
                        style: getTextStyle(
                            color: colorSubTextPera,
                            size: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Image.asset(
                      App.ic_play_outline,
                      fit: BoxFit.contain,
                      width: 14.0,
                      height: 14.0,
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 3),
                      child: Text(
                        "${model.createQcastItem.numberOfVideo.toString()??"0"} Videos",
                        style: getTextStyle(
                            color: colorSubTextPera,
                            size: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 6,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: DownloadIndicatorWidget(
                            model: model,
                            status:
                                model.createQcastItem.downloadedByUser != null &&
                                        model.createQcastItem.downloadedByUser
                                    ? 2
                                    : 0),
                        height: 30,
//                  width: 107,
                      ),
                    ),
                    SizedBox(width: 8.0,),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 30.0,
                        child: RaisedButton(
                          onPressed: () {
                            print("Press on Share button");
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(
                                color: colorSectionHead,
                                width: 1.5,
                                )),
                          padding: EdgeInsets.all(0.0),
                          child: Ink(
                            decoration: BoxDecoration(
                                color: colorWhite,
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Container(
                              /*constraints:
                                  BoxConstraints(maxWidth: 107.0, minHeight: 30.0),*/
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.share,color: Colors.grey,size: 20.0,),
                                  SizedBox(width:5.0),
                                  Text(
                                    "Share",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      );

  get videosPreview => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(top: 2),
              child: Text(
                "Videos Preview",
                style: getTextStyle(
                    color: Colors.black, size: 20, fontWeight: FontWeight.w800),
              )),
          SizedBox(
            height: 12,
          ),
          Container(
            padding: EdgeInsets.only(left: 2),
            child: Row(
              children: <Widget>[
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              PlayViewSideVideoPage(
                            isFile: false,
                                          url: "https://technocometsolutions.com/Y2Y_Web/public/uploads/chat/product/videos/5889215561622184024.mp4",
                            cameraState: CameraState.R,
                            playIndicator: true,
                            title: "Preview",
                          ),
                        );
                      },

                      child: ClipOval(
                        child: Container(
                          color: colorOvalBorder,
                          width: 75,
                          height: 75,
                          child: Image.network(model.coverPhoto1,fit: BoxFit.cover,),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      AutoSizeText(
                        model.createQcastItem.title??"",
                        style: getTextStyle(
                          size: 16,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      /*Container(
                        child: Text(
                          model.createQcastItem.s,
                          style: getTextStyle(
                              color: colorSubTextPera,
                              size: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        padding: EdgeInsets.only(top: 3),
                      )*/
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      );

  get exampleQuestions => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          model.createQcastItem.sampleQuestion?.length!=0 ? SizedBox(
            height: 32,
          ):SizedBox(height: 2,),
          model.createQcastItem.sampleQuestion?.length!=0 ? Container(
              padding: EdgeInsets.only(top: 2),
              child: Text(
                "Example Questions",
                style: getTextStyle(
                    color: Colors.black, size: 20, fontWeight: FontWeight.w800),
              )):Container(),
          SizedBox(
            height: 12,
          ),
          ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: model.createQcastItem.sampleQuestion!=null?model.createQcastItem.sampleQuestion?.length??0:0,
            shrinkWrap: true,
            itemBuilder: (c, i) {
              String question = model.createQcastItem.sampleQuestion[i];
              return Container(
                padding: EdgeInsets.only(left: 5, bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${i + 1}.",
                      style: getTextStyle(
                          color: Colors.black,
                          size: 18,
                          fontWeight: FontWeight.w800),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: AutoSizeText(
                        question,
                        style: getTextStyle(
                          size: 16,
                          color: Colors.black,
                        ),
                      ),
                    )),
//                  ),
                  ],
//              ),
                ),
              );
            },
          ),
        ],
      );
  get descroiptions => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          model.createQcastItem.description == "" ? Container() : Container(
              padding: EdgeInsets.only(top: 2),
              child: Text(
                "Description",
                textAlign: TextAlign.start,
                style: getTextStyle(
                    color: Colors.black, size: 20, fontWeight: FontWeight.w800),
              )),
          SizedBox(
            height: 12,
          ),
          Container(
            child: Text(
              model.createQcastItem.description ?? "",
              textAlign: TextAlign.start,
              style: getTextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  size: 18),
            ),
            padding: EdgeInsets.only(top: 8,),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = SubscriptionsDetailPageViewModel(this));

    return Scaffold(
        backgroundColor: getColorBg(),
        appBar: AppBar(
          title: Text(
            "Qcasts",
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
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 20, left: 16, right: 16),
            child: Column(
              children: <Widget>[
                topBanner,
                SizedBox(
                  height: 32,
                ),
                videosPreview,
                exampleQuestions,
                SizedBox(
                  height: 20,
                ),
                descroiptions,
              ],
            ),
          ),
        ));
  }

  int totalDur = 0, currDur = 0;

  Future<Function> functionGetProgress(t, p) async {
    print("total Second -> " + t.toString());
    print("current Second -> " + p.toString());
    currDur = p;
    totalDur = t;
    if (totalDur > 0) {
      double progressMod = currDur / totalDur;
      //seekBloc.addProgress(progressMod);
    } else {
      //seekBloc.addProgress(0.0);
    }

    return null;
  }

}

class DownloadIndicatorWidget extends StatefulWidget {
  int status = 0;
  double progress = 0;
  SubscriptionsDetailPageViewModel model;
  DownloadIndicatorWidget({this.model, this.status = 0});
  @override
  _DownloadIndicatorWidgetState createState() =>
      _DownloadIndicatorWidgetState();
}

class _DownloadIndicatorWidgetState extends State<DownloadIndicatorWidget> {
  @override
  Widget build(BuildContext context) {
    switch (widget.status) {
      case 1:
        {
          return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                  /*height: 30,
                  width: 107,*/
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: colorSectionHead,
                        width: 1.5,
                      )),
                  child: Stack(
                    children: <Widget>[
                      AnimatedContainer(
                        color: colorSectionHead,
                        width: widget.progress,
                        duration: Duration(milliseconds: 100),
                        curve: Curves.fastOutSlowIn,
                      ),
                      Center(
                          child: Text("Downloading...",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14))),
                    ],
                  )));
        }
        break;

      case 2:
        {
          return RaisedButton(
            onPressed: () {
              print("Press on downloaded button");
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            padding: EdgeInsets.all(0.0),
            child: Ink(
              decoration: BoxDecoration(
                  color: colorDark, borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                /*constraints: BoxConstraints(maxWidth: 107.0, minHeight: 30.0),*/
                alignment: Alignment.center,
                child: Text(
                  "Downloaded",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 14),
                ),
              ),
            ),
          );
        }
        break;

      default:
        {
          return RaisedButton(
            onPressed: () async {
              setState(() {
                widget.status = 1;
              });
//              Timer(Duration(seconds: 2), () {
//                setState(() {
//                  widget.status = 2;
//                });
//              });
              Timer.periodic(Duration(milliseconds: 50), (Timer t) {
                setState(() {
                  if (widget.progress > 120) {
                    widget.progress = 0;
                    t.cancel();
                  } else {
                    widget.progress += 7;
                  }
                });
              });
              bool result = await widget.model.callDownload();
              if(result){
                widget.status = 2;
              }else {
                widget.status = 0;
              }
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            padding: EdgeInsets.all(0.0),
            child: Ink(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff9F00C5),
                      Color(0xff9405BD),
                      Color(0xff7913A7),
                      Color(0xff651E96),
                      Color(0xff522887)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "Download",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 14),
                ),
              ),
            ),
          );
        }
        break;
    }
  }
}
