import 'package:auto_size_text/auto_size_text.dart';
import 'package:circle_list/circle_list.dart';
import 'package:flutter/material.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/page/sylo/view_sylo_page/sylo_album_page/sylo_album_detail_page/sylo_album_detail_page_view_model.dart';
import 'package:testsylo/util/navigate_effect.dart';

import '../../../app.dart';
import 'active_sylo_shared_own_page_view_model.dart';
import 'shared_view_letter_page/shared_view_letter_page.dart';
import 'shared_view_play_audio_page/shared_view_play_audio_page.dart';
import 'shared_view_qcast_page/shared_view_qcast_page.dart';

class ActiveSyloSharedOwnPage extends StatefulWidget {
  SharedSyloItem activeSylo;
  ActiveSyloSharedOwnPage({this.activeSylo});
  @override
  ActiveSyloSharedOwnPageState createState() => ActiveSyloSharedOwnPageState();
}

class ActiveSyloSharedOwnPageState extends State<ActiveSyloSharedOwnPage> {
  ActiveSyloSharedOwnPageViewModel model;
  bool syloAlbumDisplayView = false;
  bool isUpdateAlbumsForSylo = false;
  MediaPostTapState mediaPostTapState = MediaPostTapState.None;



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
        CircleList(
          origin: Offset(1, 1),
          outerRadius: 190,
          innerRadius: 65,
          children: List.generate(model.syloQuestionItem.length,
                  (index) {
              SyloQuestionItem syloQuestionItem = model.syloQuestionItem[index];
            return GestureDetector(
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                          ClipOval(
                            child: Container(
                              child: ClipOval(
                                child:
                                getThumbIconOfContentType(syloQuestionItem.mediaType, index)
                              ),
                              padding: EdgeInsets.all(3),
                              color: colorOvalBorder,
                            ),
                          ),
                      Container(
                        child: AutoSizeText(
                          syloQuestionItem.title,
                          style: getTextStyle(
                              color: Colors.black,
                              size: 13,
                              fontWeight: FontWeight.w500),
                          maxFontSize: 13,
                          minFontSize: 13,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        padding: EdgeInsets.only(top: 3),
                      )
                    ],
                  ),
                  Positioned(
                    child: ClipOval(
                      child: Container(
                        padding: EdgeInsets.only(left:6,right: 6,top: 6,bottom: 6),
                        child: Image.asset(getImageOfContentType(syloQuestionItem.mediaType)),
                        color: colorOvalBorder,
                        alignment: Alignment.center,
                        width: 24,
                        height: 24,
                      ),
                    ),
                    right: 0,
                    top: 0,
                  )
                ],
              ),
              onTap: () {
                clickOnItem(syloQuestionItem.mediaType, syloQuestionItem:syloQuestionItem);
              },
            );
          }),
          centerWidget:
              ClipOval(
                child: Container(
                  child: ClipOval(
                    child: Container(
                      height: 120,
                      width: 120,
                      child: ImageFromNetworkView(
                        path: widget.activeSylo.syloPic != null
                            ? widget.activeSylo.syloPic
                            : "",
                        boxFit: BoxFit.cover,
                      ),
                    ),
                  ),
                  padding: EdgeInsets.all(3),
                  color: colorOvalBorder,
                ),
              ),
        ),
      ],
    ),
  );

  get syloAlbumsGridView => Container(
    child: GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: albumItemList.length,
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, childAspectRatio: 0.95),
      shrinkWrap: true,
      itemBuilder: (c, i) {
        return GestureDetector(
          child: Container(
            padding: EdgeInsets.only(left: 5, top: 5),
            child:
                Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        ClipOval(
                          child: Container(
                            child: ClipOval(
                              child: getThumbIconOfContentType(albumItemList[i].content_type,i),
                            ),
                            padding: EdgeInsets.all(3),
                            color: colorOvalBorder,
                          ),
                        ),
                        Positioned(
                          child: ClipOval(
                            child: Container(
                              padding: EdgeInsets.only(left:6,right: 6,top: 6,bottom: 6),
                              child: Image.asset(getImageOfContentType(albumItemList[i].content_type)),
                              color: colorOvalBorder,
                              alignment: Alignment.center,
                              width: 24,
                              height: 24,
                            ),
                          ),
                          right: 0,
                          top: 0,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Container(
                      child: Text(
                        albumItemList[i].name,
                        style: getTextStyle(
                            color: colorDark,
                            size: 13,
                            fontWeight: FontWeight.w500),
                      ),
                      padding: EdgeInsets.only(top: 3),
                    )
                  ],
                ),

          ),
          onTap: () {},
        );
      },
    ),
  );

  get addMoreActionButtonView => Container(
    padding: EdgeInsets.only(
      top: 16,
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
      child: Container(
        padding: EdgeInsets.only(top: 4, bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 16, right: 8),
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: Container(

                  child: Text(
                    "Reply to "+ widget.activeSylo.syloName +"'s Sylo",
                    style: getTextStyle(
                        size: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.black),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  commonActionAlbumIconButton(
                        () async {
                      setState(() {
                        mediaPostTapState = MediaPostTapState.V;
                      });

                      await Future.delayed(Duration(milliseconds: startDur));
                      await model.updateAlbumsForSylo();
                      goToVideoPostPage(context);

                      await Future.delayed(Duration(milliseconds: endDur));

                      setState(() {
                        mediaPostTapState = MediaPostTapState.None;
                      });


                    },
                    Image.asset(
                      App.ic_video,
                      fit: BoxFit.fill,
                      color: getTapWhiteIconColor(
                          mediaPostTapState == MediaPostTapState.V, null),
                    ),
                    isGradient:mediaPostTapState == MediaPostTapState.V,),
                  commonActionAlbumIconButton(
                        () async {
                      setState(() {
                        mediaPostTapState = MediaPostTapState.S;
                      });

                      await Future.delayed(Duration(milliseconds: startDur));

                      await model.updateAlbumsForSylo();
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
                    isGradient:mediaPostTapState == MediaPostTapState.S,),
                  commonActionAlbumIconButton(
                        () async {
                      setState(() {
                        mediaPostTapState = MediaPostTapState.P;
                      });

                      await Future.delayed(Duration(milliseconds: startDur));

                      await model.updateAlbumsForSylo();
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
                    isGradient:mediaPostTapState == MediaPostTapState.P,),
                  commonActionAlbumIconButton(
                        () async {
                      setState(() {
                        mediaPostTapState = MediaPostTapState.M;
                      });

                      await Future.delayed(Duration(milliseconds: startDur));

                      await model.updateAlbumsForSylo();
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
                    isGradient:mediaPostTapState == MediaPostTapState.M,),
                  commonActionAlbumIconButton(
                        () async {
                      setState(() {
                        mediaPostTapState = MediaPostTapState.R;
                      });

                      await Future.delayed(Duration(milliseconds: startDur));

                      await model.updateAlbumsForSylo();
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
                    isGradient:mediaPostTapState == MediaPostTapState.R,),
                  commonActionAlbumIconButton(
                        () async {
                      setState(() {
                        mediaPostTapState = MediaPostTapState.T;
                      });

                      await Future.delayed(Duration(milliseconds: startDur));

                      await model.updateAlbumsForSylo();
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
                    isGradient:mediaPostTapState == MediaPostTapState.T,),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = ActiveSyloSharedOwnPageViewModel(this));
    print("runtimeType123 -> " + widget.activeSylo.displayName.toString());

    return Scaffold(
      backgroundColor: getColorBg(),
      appBar: AppBar(
        title: Text(widget.activeSylo.syloName + "'s Inbox",
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

        ],
      ),


      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              syloAlbumDisplayView
                  ? syloAlbumsGridView
                  : syloAlbumsCircularView,
              addMoreActionButtonView

            ],
          ),
        ),
      ),
    );
  }

  String getImageOfContentType(String mediaType) {
    switch(mediaType) {
      case "QCAST":
      case "VIDEO": {
        return App.ic_video;
      }
      break;
      case "PHOTO": {
        return App.ic_images_album;
      }
      break;
      case "SONGS": {
        return App.ic_music_album;
      }
      break;
      case "AUDIO": {
        return App.ic_mic;
      }
      break;
      case "TEXT": {
        return App.ic_edit_album;
      }
      break;
      default : {
        return App.ic_refresh_album;
      }
      break;
    }
  }

  Widget getThumbIconOfContentType(String mediaType, int index) {
    switch (mediaType) {
      case "AUDIO":
        {
          return Container(
            color: Colors.white,
            height: 80,
            width: 80,
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
            height: 80,
            width: 80,
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
            height: 80,
            width: 80,
            child: ImageFromNetworkView(
              path: model.syloQuestionItem[index].coverPhoto != null
                  ? model.syloQuestionItem[index].coverPhoto
                  : "",
              boxFit: BoxFit.cover,
            ),
          );
        }
        break;
    }
  }

  clickOnItem(String mediaType,{syloQuestionItem}) async{
    switch(mediaType) {
      case "QCAST":
      case "VIDEO": {
        var result = await Navigator.push(
            context, NavigatePageRoute(context,
            SharedViewQcastPage(from: runtimeType.toString(), syloQuestionItem: syloQuestionItem)
        ));
        if(result!=null && result==true){
          model.getSyloQuestion();
        }
      }
      break;
      case "image": {

      }
      break;
      case "SONGS": {

      }
      break;
      case "AUDIO": {
        var result = await Navigator.push(
            context, NavigatePageRoute(context,
            SharedViewPlayAudioPage(from: runtimeType.toString(),syloQuestionItem: syloQuestionItem)
        ));
      }
      break;
      case "TEXT": {
        print("From ->" + runtimeType.toString());
        var result = await Navigator.push(
            context, NavigatePageRoute(context,
            SharedViewLetterPage(from: runtimeType.toString(),syloQuestionItem: syloQuestionItem)
        ));
      }
      break;
      default : {

      }
      break;
    }
  }
}
