import 'package:auto_size_text/auto_size_text.dart';
import 'package:circle_list/circle_list.dart';
import 'package:flutter/material.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/page/shared/active_own/shared_view_letter_page/shared_view_letter_page.dart';
import 'package:testsylo/page/shared/active_own/shared_view_qcast_page/shared_view_qcast_page.dart';
import 'package:testsylo/util/navigate_effect.dart';

import '../../../../../../app.dart';
import 'completed_sylo_letter_page/completed_sylo_letter_page.dart';
import 'completed_sylo_repost_page/completed_sylo_repost_page.dart';
import 'completed_sylo_song_page/completed_sylo_song_page.dart';
import 'completed_sylo_view_photo_page/completed_sylo_view_photo_page.dart';
import 'completed_view_play_audio_page/completed_view_play_audio_page.dart';
import 'completed_view_play_voice_tag_page/completed_view_play_voice_tag_page.dart';
import 'completed_view_video_page/completed_view_video_page.dart';
import 'shared_detail_album_page_view_model.dart';

class SharedDetailAlbumPage extends StatefulWidget {
  GetAlbum getAlbum;
  SharedDetailAlbumPage({this.getAlbum});
  @override
  SharedDetailAlbumPageState createState() => SharedDetailAlbumPageState();
}

class SharedDetailAlbumPageState extends State<SharedDetailAlbumPage> {
  SharedDetailAlbumPageViewModel model;
  bool syloAlbumDisplayView = false;

  @override
  void initState() {
    super.initState();
    appState.albumMediaDataList = null;
    model = SharedDetailAlbumPageViewModel(this);
  }

  get viewHeaderButton => Container(

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

  get syloAlbumsCircularView => Container(
    alignment: Alignment.center,
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
            children: List.generate(model.getCircleListLength(),
                    (index) {
                  if(model.currentPage>1){
                    //index = index + (model.currentPage * 8);
                  }
                  AlbumMediaData albumMediaData =
                  model.albumMediaDataList[index];
                  return InkWell(
                    child: Stack(
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 3, right: 3),
                                  child: ClipOval(
                                    child: Container(
                                      child: ClipOval(
                                          child: getThumbIconOfContentType(albumMediaData.mediaType,index)),
                                      padding: EdgeInsets.all(3),
                                      color: colorOvalBorder,
                                    ),
                                  ),
                                ),
                                albumMediaData.mediaType=="QCAST" ? Positioned(
                                  child: ClipOval(
                                    child: Container(
                                      padding: EdgeInsets.all(2),
                                      child: ClipOval(
                                        child: Container(
                                          width: 24,
                                          height: 24,
                                          child: ImageFromNetworkView(
                                            path: albumMediaData.qcastCoverPhoto,
                                            boxFit:BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      color: colorOvalBorder,
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                  right: 0,
                                  bottom: 0,
                                ):SizedBox()
                              ],
                            ),
                            Container(
                              child: AutoSizeText(
                                albumMediaData.subAlbumName,
                                style: getTextStyle(
                                    color: Colors.black,
                                    size: 13,
                                    fontWeight: FontWeight.w500),
                                maxFontSize: 10,
                                minFontSize: 6,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              padding: EdgeInsets.only(top: 3),
                              width: 50,
                            ),
                          ],
                        ),
                        albumMediaData.mediaType != "QCAST" ? Positioned(
                          child: ClipOval(
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 6, right: 6, top: 6, bottom: 6),
                              child: Image.asset(getImageOfContentType(
                                  albumMediaData.mediaType)),
                              color: colorOvalBorder,
                              alignment: Alignment.center,
                              width: 24,
                              height: 24,
                            ),
                          ),
                          right: 0,
                          top: 1,
                        ):SizedBox()
                      ],
                    ),
                    onTap: () {
                      clickOnItem(albumMediaData);
                    },
                  );
                }),
            centerWidget: ClipOval(
              child: Container(
                child: ClipOval(
                    child: model.albumMediaDataList!=null && model.albumMediaDataList.length>0 ? getAlbumThumbIcon(model.albumMediaDataList?.last?.mediaType,
                        model.albumMediaDataList?.last?.coverPhoto,
                        cHeight: 120, cWidth: 120, textSize: 20) : Image.asset(App.ic_placeholder, height: 120, width: 120)),
                padding: EdgeInsets.all(3),
                color: colorOvalBorder,
              ),
            ),
          ),
        ),
        Positioned(child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(child: Icon(Icons.chevron_left, size: 16,), onTap: (){
              model.goToPrevPage();
            },),
            Text(model.getPageInfo()),
            InkWell(child: Icon(Icons.chevron_right, size: 16,), onTap: (){
              model.goToNextPage();
            },)
          ],
        ), right: 16, bottom: 8,)
      ],
    ),
  );

  get syloAlbumsGridView => Container(
    child: GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: model?.albumMediaDataList?.length ?? 0,
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, childAspectRatio: 0.95),
      shrinkWrap: true,
      itemBuilder: (c, i) {
        AlbumMediaData albumMediaData = model.albumMediaDataList[i];
        return GestureDetector(
          child: Container(
            padding: EdgeInsets.only(left: 5, top: 5),
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        ClipOval(
                          child: Container(
                            child: ClipOval(
                              child: getThumbIconOfContentType(
                                  albumMediaData.mediaType, i, cHeight: 80, cWidth: 80),
                            ),
                            padding: EdgeInsets.all(3),
                            color: colorOvalBorder,
                          ),
                        ),
                        albumMediaData.mediaType=="QCAST" ? Positioned(
                          child: ClipOval(
                            child: Container(
                              padding: EdgeInsets.all(2),
                              child: ClipOval(
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  child: ImageFromNetworkView(
                                    path: albumMediaData.qcastCoverPhoto,
                                    boxFit:BoxFit.cover,
                                  ),
                                ),
                              ),
                              color: colorOvalBorder,
                              alignment: Alignment.center,
                            ),
                          ),
                          right: 0,
                          bottom: 0,
                        ):SizedBox()
                      ],
                    ),
                    albumMediaData.mediaType != "QCAST" ? Positioned(
                      child: ClipOval(
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 6, right: 6, top: 6, bottom: 6),
                          child: Image.asset(getImageOfContentType(
                              albumMediaData.mediaType)),
                          color: colorOvalBorder,
                          alignment: Alignment.center,
                          width: 24,
                          height: 24,
                        ),
                      ),
                      right: 0,
                      top: 0,
                    ):SizedBox()
                  ],
                ),
                SizedBox(
                  height: 3,
                ),
                Container(
                  child: AutoSizeText(
                    albumMediaData.subAlbumName,
                    style: getTextStyle(
                        color: colorDark,
                        size: 14,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  padding: EdgeInsets.only(top: 3),
                )
              ],
            ),
          ),
          onTap: () {
            clickOnItem(albumMediaData);
          },
        );
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = SharedDetailAlbumPageViewModel(this));

    return Scaffold(
      backgroundColor: getColorBg(),
      appBar: AppBar(
        title: Text(
          syloAlbumDisplayView ?"View all":"John Elder",
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
          viewHeaderButton,
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
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getThumbIconOfContentType(String mediaType, int index, {double cHeight, double cWidth}) {
    switch (mediaType) {
      case "AUDIO":
        {
          return Container(
            color: Colors.white,
            height: cHeight??50,
            width: cWidth??50,
            padding: EdgeInsets.all(13),
            child: Image.asset(
              App.ic_mic,
            ),
          );
        }
        break;
      case "TEXT":
        {
          return Container(
            color: Colors.white,
            height: cHeight??50,
            width: cWidth??50,
            child: Center(
              child: Text(
                "Abc",
                style: getTextStyle(
                  color: colorSectionHead,
                  size: 15,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          );
        }
        break;
      default:
        {
          return Container(
            height: cHeight??50,
            width: cWidth??50,
            child: ImageFromNetworkView(
              path: model.albumMediaDataList[index].coverPhoto != null
                  ? model.albumMediaDataList[index].coverPhoto
                  : "",
              boxFit: BoxFit.cover,
            ),
          );
        }
        break;
    }
  }

  clickOnItem(AlbumMediaData albumMediaData) async{
    switch(albumMediaData.mediaType) {
      case "VIDEO": {
        var result = await Navigator.push(
            context, NavigatePageRoute(context,
            SharedViewQcastPage(from: runtimeType.toString(), albumMediaData: albumMediaData)
        ));
        if(result!=null && result==true) {
          appState.albumList = null;
          model.getAlbumMediaData(isReCall: true);
        }
      }
      break;
      case "PHOTO": {
        var result = await Navigator.push(
            context, NavigatePageRoute(context,
            CompletedSyloViewPhotoPage(from: runtimeType.toString(), albumMediaData: albumMediaData)
        ));
        if(result!=null && result==true) {
          appState.albumList = null;
          model.getAlbumMediaData(isReCall: true);
        }
      }
      break;
      case "SONGS": {
        var result = await Navigator.push(
            context, NavigatePageRoute(context,
            CompletedSyloSongPage(from: runtimeType.toString(), albumMediaData: albumMediaData)
        ));
        if(result!=null && result==true){
          appState.albumList = null;
          model.getAlbumMediaData(isReCall: true);
        }
      }
      break;
      case "REPOST": {
        var result = await Navigator.push(
            context, NavigatePageRoute(context,
            CompletedSyloRepostPage(from: runtimeType.toString(), albumMediaData: albumMediaData)
        ));
        if(result!=null && result==true){
          appState.albumList = null;
          model.getAlbumMediaData(isReCall: true);
        }
      }
      break;
      case "AUDIO": {
        var result = await Navigator.push(
            context, NavigatePageRoute(context,
            CompletedViewPlayAudioPage(from: runtimeType.toString(), albumMediaData: albumMediaData)
        ));
        if(result!=null && result==true) {
          appState.albumList = null;
          model.getAlbumMediaData(isReCall: true);
        }
      }
      break;
      case "TEXT": {
        var result = await Navigator.push(
            context, NavigatePageRoute(context,
            SharedViewLetterPage(from: runtimeType.toString(), albumMediaData: albumMediaData)
        ));
        if(result!=null && result==true) {
          appState.albumList = null;
          model.getAlbumMediaData(isReCall: true);
        }
      }
      break;
      case "VTAG": {
        var result = await Navigator.push(
            context, NavigatePageRoute(context,
            CompletedViewPlayVoiceTagPage(from: runtimeType.toString(), albumMediaData: albumMediaData)
//            CompletedViewPlayVoiceTagPage()
        ));
        if(result!=null && result==true){
          appState.albumList = null;
          model.getAlbumMediaData(isReCall: true);
        }

      }
      break;
      case "QCAST": {
        var result = await Navigator.push(
            context, NavigatePageRoute(context,
            CompletedViewVideoPage(from: runtimeType.toString(), albumMediaData: albumMediaData)
        ));
        if(result!=null && result==true){
          appState.albumList = null;
          model.getAlbumMediaData(isReCall: true);
        }
      }
      break;
      default : {

      }
      break;
    }
  }
  /*clickOnItem(String mediaType) async{
    switch(mediaType) {
      case "video": {
//        var result = await Navigator.push(
//            context, NavigatePageRoute(context,
//            SharedViewQcastPage()
//        ));
        var result = await Navigator.push(
            context, NavigatePageRoute(context,
            CompletedViewVideoPage()
        ));
      }
      break;
      case "image": {
        var result = await Navigator.push(
            context, NavigatePageRoute(context,
            CompletedSyloViewPhotoPage()
        ));
      }
      break;
      case "SONGS": {
        var result = await Navigator.push(
            context, NavigatePageRoute(context,
            CompletedSyloSongPage()
        ));
      }
      break;
      case "audio": {
        var result = await Navigator.push(
            context, NavigatePageRoute(context,
            CompletedViewPlayAudioPage()
        ));
      }
      break;
      case "text": {
        var result = await Navigator.push(
            context, NavigatePageRoute(context,
            CompletedSyloLetterPage()
        ));
      }
      break;
      default : {
        var result = await Navigator.push(
            context, NavigatePageRoute(context,
            CompletedSyloRepostPage()
        ));
      }
      break;
    }
  }*/
}
