import 'package:circle_list/circle_list.dart';
import 'package:flutter/material.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/common/play_video_auto.dart';
import 'package:testsylo/common/play_video_new.dart';
import 'package:testsylo/common/play_view_side_audio_widget.dart';
import 'package:testsylo/common/play_view_side_video.dart';
import 'package:testsylo/common/zoomable_widget.dart';
import 'package:testsylo/model/api_request.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/page/shared/active_own/shared_view_letter_page/shared_view_letter_page.dart';
import 'package:testsylo/page/shared/active_own/shared_view_qcast_page/shared_view_qcast_page.dart';
import 'package:testsylo/page/shared/completed_sylo/opening_message_view_sylo_page/opening_message_detail_shared_page/shared_detail_album_page/completed_sylo_repost_page/completed_sylo_repost_page.dart';
import 'package:testsylo/page/shared/completed_sylo/opening_message_view_sylo_page/opening_message_detail_shared_page/shared_detail_album_page/completed_sylo_song_page/completed_sylo_song_page.dart';
import 'package:testsylo/page/shared/completed_sylo/opening_message_view_sylo_page/opening_message_detail_shared_page/shared_detail_album_page/completed_sylo_view_photo_page/completed_sylo_view_photo_page.dart';
import 'package:testsylo/page/shared/completed_sylo/opening_message_view_sylo_page/opening_message_detail_shared_page/shared_detail_album_page/completed_view_play_audio_page/completed_view_play_audio_page.dart';
import 'package:testsylo/page/shared/completed_sylo/opening_message_view_sylo_page/opening_message_detail_shared_page/shared_detail_album_page/completed_view_play_voice_tag_page/completed_view_play_voice_tag_page.dart';
import 'package:testsylo/page/shared/completed_sylo/opening_message_view_sylo_page/opening_message_detail_shared_page/shared_detail_album_page/completed_view_video_page/completed_view_video_page.dart';
import 'package:testsylo/page/sylo/view_sylo_page/sylo_album_page/movecopyalbum/copymovealbumitems.dart';
import 'package:testsylo/page/sylo/view_sylo_page/sylo_album_page/sylo_album_detail_page/sylo_album_detail_page_view_model.dart';
import 'package:testsylo/util/navigate_effect.dart';
import '../../../../../app.dart';


class SyloAlbumDetailPage extends StatefulWidget {
  GetAlbum getAlbum;
  String from;
  GetUserSylos userSylo;
  bool isAlbumGridstate;
  SubAlbumData subAlbumData = SubAlbumData();
  Function(int index, GetUserSylos sylo, {String from, GetAlbum getAlbum, bool isAlbumGrid}) callBack;

  SyloAlbumDetailPage(
      {this.getAlbum, this.from, this.userSylo, this.callBack, this.isAlbumGridstate = false});

  @override
  SyloAlbumDetailPageState createState() => SyloAlbumDetailPageState();
}

  class SyloAlbumDetailPageState extends State<SyloAlbumDetailPage> with WidgetsBindingObserver {
    SyloAlbumDetailPageViewModel model;
    bool syloAlbumDisplayView = false;
    MediaPostTapState mediaPostTapState = MediaPostTapState.None;
    bool useChildInCenter = false;
    AlbumMediaData albumMediaData;
    int selectedIndex, prevSelectedIndex;
    TextEditingController albumNameController = new TextEditingController();

    //final controller = StoryController();

    @override
    void initState() {
      super.initState();
      WidgetsBinding.instance.addObserver(this);

      appState.albumMediaDataList = null;
      model = SyloAlbumDetailPageViewModel(this);
      model.newName = widget.getAlbum.albumName;
    }


    @override
    void dispose()
    {
      super.dispose();
      WidgetsBinding.instance.removeObserver(this);
    }

    get viewHeaderButton =>
        Container(
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
                SizedBox(
                  width: 16,
                )
              ],
            ));


    get borderCircle =>
        ClipOval(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              border: Border.all(color: colorOvalBorder),
            ),
            child: Container(
              color: Colors.transparent,
//            height: MediaQuery.of(context).size.width - 80,
//            width: MediaQuery.of(context).size.width - 80,
            ),
          ),
        );


    get syloAlbumsCircularView =>
        Container(
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
                child:  CircleList(
                    origin: Offset(0, 0),
                    outerRadius: 185,
                    children: List.generate(model.getCircleListLength(),
                            (index) {
                          if (model.currentPage > 1) {
                            //index = index + (model.cur rentPage * 8);
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
                                          margin: EdgeInsets.only(
                                              top: 3, right: 3),
                                          child: ClipOval(
                                            child: Container(
                                              child: ClipOval(
                                                  child: getThumbIconOfContentType(
                                                      albumMediaData.mediaType,
                                                      index)),
                                              padding: EdgeInsets.all(3),
                                              color: colorOvalBorder,
                                            ),
                                          ),
                                        ),
                                        albumMediaData.mediaType == "QCAST"
                                            ? Positioned(
                                          child: ClipOval(
                                            child: Container(
                                              padding: EdgeInsets.all(2),
                                              child: ClipOval(
                                                child: Container(
                                                  width: 24,
                                                  height: 24,
                                                  child: ImageFromNetworkView(
                                                    path: albumMediaData
                                                        .qcastCoverPhoto,
                                                    boxFit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              color: colorOvalBorder,
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                          right: 0,
                                          bottom: 0,
                                        )
                                            : SizedBox()
                                      ],
                                    ),
                                    Container(
                                      child: Text(
                                        albumMediaData.subAlbumName,
                                        style: getTextStyle(
                                            color: Colors.black,
                                            size: 13,
                                            fontWeight: FontWeight.w500),
                                        //maxFontSize: 10,
                                        //minFontSize: 6,
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
                                ) : SizedBox()
                              ],
                            ),
                            onTap: () {
                              //clickOnItem(albumMediaData);
                              moveChildToCenter(
                                  model.albumMediaDataList[index], index);
                            },
                          );
                        }),
                    centerWidget: useChildInCenter ? centeredWidgetonTap(
                        albumMediaData, selectedIndex)
                        : ClipOval(
                      child: Container(
                        child: ClipOval(
                            child: model.albumMediaDataList != null &&
                                model.albumMediaDataList.length > 0
                                ? getAlbumThumbIcon(
                                model.albumMediaDataList?.last?.mediaType,
                                model.albumMediaDataList?.last?.coverPhoto,
                                cHeight: 120, cWidth: 120, textSize: 20)
                                : Image.asset(
                                App.ic_placeholder, height: 120, width: 120)),
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
                  InkWell(
                    child: Icon(Icons.chevron_left, size: 16,), onTap: () {
                    model.goToPrevPage();
                  },),
                  Text(model.getPageInfo()),
                  InkWell(
                    child: Icon(Icons.chevron_right, size: 16,), onTap: () {
                    model.goToNextPage();
                  },)
                ],
              ), right: 16, bottom: 8,)
            ],
          ),
        );

    // contains widget that will come to the center on tap
    Widget centeredWidgetonTap(AlbumMediaData amd, int index) {
      return GestureDetector(
        onTap: () {
          clickOnItem(amd);
        },
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
                          width: 120,
                          height: 120,
                          child: ClipOval(
                              child: getThumbIconOfContentType(
                                  amd.mediaType, index)),
                          padding: EdgeInsets.all(3),
                          color: colorOvalBorder,
                        ),
                      ),
                    ),
                    amd.mediaType == "QCAST" ? Positioned(
                      child: ClipOval(
                        child: Container(
                          padding: EdgeInsets.all(2),
                          child: ClipOval(
                            child: Container(
                              width: 24,
                              height: 24,
                              child: ImageFromNetworkView(
                                path: amd.qcastCoverPhoto,
                                boxFit: BoxFit.cover,
                              ),
                            ),
                          ),
                          color: colorOvalBorder,
                          alignment: Alignment.center,
                        ),
                      ),
                      right: 0,
                      bottom: 0,
                    ) : SizedBox()
                  ],
                ),
                Container(
                  child: Text(
                    amd.subAlbumName,
                    style: getTextStyle(
                        color: Colors.black,
                        size: 13,
                        fontWeight: FontWeight.w500),
                    // maxFontSize: 10,
                    // minFontSize: 6,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  padding: EdgeInsets.only(top: 3),
                  width: 50,
                ),
              ],
            ),
            amd.mediaType != "QCAST" ? Positioned(
              child: ClipOval(
                child: Container(
                  padding: EdgeInsets.only(
                      left: 6, right: 6, top: 6, bottom: 6),
                  child: Image.asset(getImageOfContentType(
                      amd.mediaType)),
                  color: colorOvalBorder,
                  alignment: Alignment.center,
                  width: 24,
                  height: 24,
                ),
              ),
              right: 12,
              top: 10,
            ) : SizedBox()
          ],
        ),
      );
    }


    moveChildToCenter(AlbumMediaData amd, int selIndex) {
      print("check prev index:");
      print(prevSelectedIndex);
      print("::::::");
      print("check selected index:");
      print(selIndex);
      setState(() {
        if (prevSelectedIndex == null) {
          prevSelectedIndex = selIndex;
        }
        if (prevSelectedIndex == selIndex) {
          useChildInCenter = useChildInCenter ? false : true;
        } else {
          prevSelectedIndex = selIndex;
          useChildInCenter = true;
        }
        if (useChildInCenter) {
          albumMediaData = amd;
          selectedIndex = selIndex;
        }
      });
    }


    get syloAlbumsGridView =>
        Container(
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
                                        albumMediaData.mediaType, i,
                                        cHeight: 80, cWidth: 80),
                                  ),
                                  padding: EdgeInsets.all(3),
                                  color: colorOvalBorder,
                                ),
                              ),
                              albumMediaData.mediaType == "QCAST" ? Positioned(
                                child: ClipOval(
                                  child: Container(
                                    padding: EdgeInsets.all(2),
                                    child: ClipOval(
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        child: ImageFromNetworkView(
                                          path: albumMediaData.qcastCoverPhoto,
                                          boxFit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    color: colorOvalBorder,
                                    alignment: Alignment.center,
                                  ),
                                ),
                                right: 0,
                                bottom: 0,
                              ) : SizedBox()
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
                          ) : SizedBox()
                        ],
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Container(
                        child: Text(
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

    get addMoreActionButtonView =>
        Container(
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
                    alignment: Alignment.centerLeft,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: Container(
                        child: Text(
                          "Add More",
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
                    padding: EdgeInsets.only(left: 8, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        commonActionAlbumIconButton(
                              () async {
                            setState(() {
                              mediaPostTapState = MediaPostTapState.V;
                            });
                            await Future.delayed(
                                Duration(milliseconds: startDur));
                            goToVideoPostPage(context);
                            await Future.delayed(
                                Duration(milliseconds: endDur));
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
                          isGradient: mediaPostTapState == MediaPostTapState.V,
                        ),
                        commonActionAlbumIconButton(
                              () async {
                            setState(() {
                              mediaPostTapState = MediaPostTapState.S;
                            });
                            await Future.delayed(
                                Duration(milliseconds: startDur));
                            goToSoundBitePage(context);
                            await Future.delayed(
                                Duration(milliseconds: endDur));
                            setState(() {
                              mediaPostTapState = MediaPostTapState.None;
                            });
                          },
                          Image.asset(
                            App.ic_mic,
                            color: getTapWhiteIconColor(
                                mediaPostTapState == MediaPostTapState.S, null),
                          ),
                          isGradient: mediaPostTapState == MediaPostTapState.S,
                        ),
                        commonActionAlbumIconButton(
                              () async {
                            setState(() {
                              mediaPostTapState = MediaPostTapState.P;
                            });
                            await Future.delayed(
                                Duration(milliseconds: startDur));
                            goToPhotoPostPage(context);
                            await Future.delayed(
                                Duration(milliseconds: endDur));
                            setState(() {
                              mediaPostTapState = MediaPostTapState.None;
                            });
                          },
                          Image.asset(
                            App.ic_images_album,
                            color: getTapWhiteIconColor(
                                mediaPostTapState == MediaPostTapState.P, null),
                          ),
                          isGradient: mediaPostTapState == MediaPostTapState.P,
                        ),
                        commonActionAlbumIconButton(
                              () async {
                            setState(() {
                              mediaPostTapState = MediaPostTapState.M;
                            });
                            await Future.delayed(
                                Duration(milliseconds: startDur));
                            goToSongPostPage(context);
                            await Future.delayed(
                                Duration(milliseconds: endDur));
                            setState(() {
                              mediaPostTapState = MediaPostTapState.None;
                            });
                          },
                          Image.asset(
                            App.ic_music_album,
                            color: getTapWhiteIconColor(
                                mediaPostTapState == MediaPostTapState.M, null),
                          ),
                          isGradient: mediaPostTapState == MediaPostTapState.M,
                        ),
                        commonActionAlbumIconButton(
                              () async {
                            setState(() {
                              mediaPostTapState = MediaPostTapState.R;
                            });
                            await Future.delayed(
                                Duration(milliseconds: startDur));
                            goToRePostPage(context);
                            await Future.delayed(
                                Duration(milliseconds: endDur));
                            setState(() {
                              mediaPostTapState = MediaPostTapState.None;
                            });
                          },
                          Image.asset(
                            App.ic_refresh_album,
                            color: getTapWhiteIconColor(
                                mediaPostTapState == MediaPostTapState.R, null),
                          ),
                          isGradient: mediaPostTapState == MediaPostTapState.R,
                        ),
                        commonActionAlbumIconButton(
                              () async {
                            setState(() {
                              mediaPostTapState = MediaPostTapState.T;
                            });
                            await Future.delayed(
                                Duration(milliseconds: startDur));
                            goToTextPostPage(context);
                            await Future.delayed(
                                Duration(milliseconds: endDur));
                            setState(() {
                              mediaPostTapState = MediaPostTapState.None;
                            });
                          },
                          Image.asset(
                            App.ic_edit_album,
                            color: getTapWhiteIconColor(
                                mediaPostTapState == MediaPostTapState.T, null),
                          ),
                          isGradient: mediaPostTapState == MediaPostTapState.T,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

    get onBackPress =>
            () {
          if (widget.from == "ViewSyloPageState") {
            widget.callBack(6, widget.userSylo);
            //print("WidgetCall"+widget.callBack(7,widget.userSylo));
          } else if (widget.from == "SyloAlbumPageState") {
            if (widget.isAlbumGridstate) {
              widget.callBack(7, widget.userSylo, isAlbumGrid: true);
            } else {
              widget.callBack(7, widget.userSylo);
            }
            //print("WidgetCall"+widget.callBack(7,widget.userSylo));
            Navigator.pop(context);
          } else {
            //print("WidgetCall2"+widget.callBack(7,widget.userSylo));
            Navigator.pop(context);
          }
        };


  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = SyloAlbumDetailPageViewModel(this));
    albumNameController.text=model.newName.toString();
    albumNameController.selection=TextSelection.collapsed(offset: model.newName.length);
    return WillPopScope(
      onWillPop: () {
        onBackPress.call();
        return;
      },
      child: Scaffold(
        backgroundColor: getColorBg(),
        appBar: AppBar(
          title: Text(
            model.newName,
            //widget.getAlbum.albumName,
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
              onBackPress.call();
              //Navigator.pop(context);
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            confirmDeleteAlbum(context, widget.getAlbum
                                .albumName);
                          },
                          child: utilButoons(Icon(Icons.delete, color: Colors
                              .white,),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            dialogChangeAlbumName(context, widget.getAlbum);
                          },
                          child: utilButoons(
                            Icon(Icons.border_color, color: Colors.white,),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context, NavigatePageRoute(context,
                                MoveCopyAlbumDetails(userSylo: widget.userSylo,
                                  getAlbum: widget.getAlbum,
                                  albumMediaDataList: model.albumMediaDataList,)
                            ));
                          },
                          child: utilButoons(
                            Icon(Icons.move_to_inbox_outlined, color: Colors
                                .white,),
                          ),
                        ),
                      ],
                    ),
                    addMoreActionButtonView,
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  confirmDeleteAlbum(BuildContext context, String albumTitle) {
    FocusScope.of(context).requestFocus(FocusNode());
    showDialog(
      context: context,
      builder: (BuildContext c) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
          title: new Text(
            "Alert",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: new Text(
              "Do you wish to delete this album (${albumTitle})?. This action will also delete all the resources associated to this album.",
              style: TextStyle(fontWeight: FontWeight.w500)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              onPressed: () {
                Navigator.of(c).pop();
              },
            ),
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              onPressed: () {
                Navigator.of(c).pop();
                AlbumDeleteRequest adr = new AlbumDeleteRequest(
                    albumIdList: [widget.getAlbum?.albumId ?? 0]);
                model.deleteAlbum(adr);
                //widget.callBack(7, widget.userSylo);
                // Navigator.of(c).pop();
                //Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  dialogChangeAlbumName(BuildContext context, GetAlbum _album) {
    FocusScope.of(context).requestFocus(FocusNode());
    showDialog(
      context: context,
      builder: (BuildContext c) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
          title: new Text(
            "Edit Album Name",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: new SizedBox(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.1,
            width: double.infinity,
            child: Container(
              child: Material(
                color: getMatColorBg(),
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.only(
                        topRight: Radius.circular(1),
                        topLeft: Radius.circular(1),
                        bottomLeft: Radius.circular(1),
                        bottomRight: Radius.circular(1))),
                child: TextField(
                  controller: albumNameController,
                  style: TextStyle(fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    /*labelText: "${_album.albumName ?? ""}"*/
                  ),
                ),
              ),
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Cancel",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              onPressed: () {
                Navigator.of(c).pop();
              },
            ),
            new FlatButton(
              child: new Text(
                "Continue",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              onPressed: () {
                Navigator.of(c).pop();
                model.editAlbumName(
                    widget.getAlbum.albumId, albumNameController.text);
                albumNameController.clear();
              },
            ),
          ],
        );
      },
    );
  }


  Widget utilButoons(Widget icon) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width * 0.12,
        height: MediaQuery
            .of(context)
            .size
            .height * 0.06,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            decoration: new BoxDecoration(
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
            ),
            child: icon,
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
            height: cHeight ?? 50,
            width: cWidth ?? 50,
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
            height: cHeight ?? 50,
            width: cWidth ?? 50,
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
            height: cHeight ?? 50,
            width: cWidth ?? 50,
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

  clickOnItem(AlbumMediaData albumMediaData) async {
    switch (albumMediaData.mediaType) {
      case "VIDEO":
        /*{
          var result = await Navigator.push(
              context, NavigatePageRoute(context,
              SharedViewQcastPage(
                  from: runtimeType.toString(), albumMediaData: albumMediaData)
          ));
          if (result != null && result == true) {
            appState.albumList = null;
            model.getAlbumMediaData(isReCall: true);
          }*/
          await model.getSubAlbumData(albumMediaData);
          showDialog(
            context: context,
            builder: (BuildContext context) => PlayViewSideVideoPage(
              isFile: false,
              url: getMediaUrl(model.subAlbumData.mediaUrls[0]),
              cameraState: getVideoShape(model.subAlbumData.mediaUrls[0]),
              playIndicator: true,
            ),
          );
        /*}*/
        break;
      case "PHOTO":
        {
          print("tapped");
          /*var result = await Navigator.push(
              context, NavigatePageRoute(context,
              CompletedSyloViewPhotoPage(
                  from: runtimeType.toString(), albumMediaData: albumMediaData)
          ));
          if (result != null && result == true) {
            appState.albumList = null;
            model.getAlbumMediaData(isReCall: true);
          }*/
          await model.getSubAlbumData(albumMediaData);
          zoomFileImageDialogueContainWidthNew(
            context,
            model.subAlbumData,

          );
        }
        break;
      case "SONGS":
        {
          print("tapped22");
          var result = await Navigator.push(
              context, NavigatePageRoute(context,
              CompletedSyloSongPage(
                  from: runtimeType.toString(), albumMediaData: albumMediaData)
          ));
          if (result != null && result == true) {
            appState.albumList = null;
            model.getAlbumMediaData(isReCall: true);
          }
        }
        break;
      case "REPOST":
        {
          var result = await Navigator.push(
              context, NavigatePageRoute(context,
              CompletedSyloRepostPage(
                  from: runtimeType.toString(), albumMediaData: albumMediaData)
          ));
          if (result != null && result == true) {
            appState.albumList = null;
            model.getAlbumMediaData(isReCall: true);
          }
        }
        break;
      case "AUDIO":
        {
          print("tapped4444");
          /*var result = await Navigator.push(
              context, NavigatePageRoute(context,
              CompletedViewPlayAudioPage(
                  from: runtimeType.toString(), albumMediaData: albumMediaData)
          ));
          if (result != null && result == true) {
            appState.albumList = null;
            model.getAlbumMediaData(isReCall: true);
          }*/
          await model.getSubAlbumData(albumMediaData);

          showDialog(
            context: context,
            builder: (BuildContext context) => PlayViewSideAudioWidget(
              url: model.subAlbumData.mediaUrls[0],
              icon_size: 32.0,
              isLocal: false,
            ),
          );
        }
        break;
      case "TEXT":
        {
          var result = await Navigator.push(
              context, NavigatePageRoute(context,
              SharedViewLetterPage(
                  from: runtimeType.toString(), albumMediaData: albumMediaData)
          ));
          if (result != null && result == true) {
            appState.albumList = null;
            model.getAlbumMediaData(isReCall: true);
          }
        }
        break;
      case "VTAG":
        {
          var result = await Navigator.push(
              context, NavigatePageRoute(context,
              CompletedViewPlayVoiceTagPage(
                  from: runtimeType.toString(), albumMediaData: albumMediaData)
//            CompletedViewPlayVoiceTagPage()
          ));
          if (result != null && result == true) {
            appState.albumList = null;
            model.getAlbumMediaData(isReCall: true);
          }
        }
        break;
      case "QCAST":
        {
          var result = await Navigator.push(
              context, NavigatePageRoute(context,
              CompletedViewVideoPage(
                  from: runtimeType.toString(), albumMediaData: albumMediaData)
          ));
          if (result != null && result == true) {
            appState.albumList = null;
            model.getAlbumMediaData(isReCall: true);
          }
        }
        break;
      default :
        {}
        break;
    }
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

    @override
    void didChangeAppLifecycleState(AppLifecycleState state) {
      if (state == AppLifecycleState.resumed) {
        //do your stuff

        print("OnResumed");

      }
      else if(state == AppLifecycleState.paused)
      {
        print("onPaused");

      }
      else if(state == AppLifecycleState.inactive)
      {
        print("onInacttive");
      }
      else if(state == AppLifecycleState.detached)
      {
        print("onDetched");
      }
    }


}