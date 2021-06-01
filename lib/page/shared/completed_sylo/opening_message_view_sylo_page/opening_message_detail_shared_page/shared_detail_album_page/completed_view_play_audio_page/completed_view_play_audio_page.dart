import 'package:flutter/material.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/common/play_view_side_audio_widget.dart';
import 'package:testsylo/common/play_view_side_audio_widget_icon.dart';
import 'package:testsylo/model/api_response.dart';
import '../../../../../../../app.dart';
import 'completed_view_play_audio_page_view_model.dart';

class CompletedViewPlayAudioPage extends StatefulWidget {
  String from;
  AlbumMediaData albumMediaData;
  CompletedViewPlayAudioPage({this.from, this.albumMediaData});
  @override
  CompletedViewPlayAudioPageState createState() =>
      CompletedViewPlayAudioPageState();
}

class CompletedViewPlayAudioPageState
    extends State<CompletedViewPlayAudioPage> {
  CompletedViewPlayAudioPageViewModel model;
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

  get videoThumbView => Container(
//    padding: EdgeInsets.only(left: 16, right: 16),
        child: ClipOval(
          child: Container(
            height: MediaQuery.of(context).size.width - 32,
            width: MediaQuery.of(context).size.width - 32,
            child: ClipOval(
              child: ImageFromNetworkView(
                path: "https://i.picsum.photos/id/721/300/300.jpg",
              ),
            ),
            padding: EdgeInsets.all(3),
            color: colorOvalBorder,
          ),
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
              onTap: () {},
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

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = CompletedViewPlayAudioPageViewModel(this));

    return Scaffold(
      backgroundColor: getColorBg(),
      appBar: AppBar(
        title: Text(
          "Listen to Soundbite",
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
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  topTextView,
                  tagDisplayView,
                  model.subAlbumData.mediaUrls != null
                      ? Expanded(
                          child: Container(
                            padding: EdgeInsets.only(top: 24),
                            child: PlayViewSideAudioWidgetIcon(
                              url: model.subAlbumData.mediaUrls[0],
                              icon_size: 32.0,
                              isLocal: false,
                              playCall: callback,
                            ),
                          ),
                        )
                      : SizedBox(),
                  /*videoThumbView,
                      playButton*/
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  callback() {
    showDialog(
      context: context,
      builder: (BuildContext context) => PlayViewSideAudioWidget(
        url: model.subAlbumData.mediaUrls[0],
        icon_size: 32.0,
        isLocal: false,
      ),
    );
  }
}
