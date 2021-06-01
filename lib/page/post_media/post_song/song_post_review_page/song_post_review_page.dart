import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/model/draft_model.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/page/common/create_album_page.dart';
import 'package:testsylo/page/post_media/post_song/song_post_review_page/song_post_review_page_view_model.dart';
import 'package:testsylo/page/sylo/choose_sylo_view_all_page/choose_sylo_view_all_page.dart';
import 'package:testsylo/page/sylo/open_message_page/edit_open_message_page/success_message_page/success_message_page.dart';
import 'package:testsylo/util/navigate_effect.dart';
import 'package:testsylo/util/util.dart';

import '../../../../app.dart';

class SongPostReviewPage extends StatefulWidget {
  String type = "";
  String link = "";
  String from = "";
  MyDraft myDraft;
  SongPostReviewPage({this.type, this.link,this.from,this.myDraft});

  @override
  SongPostReviewPageState createState() => SongPostReviewPageState();
}

class SongPostReviewPageState extends State<SongPostReviewPage> {
  SongPostReviewPageViewModel model;
  var formKey = GlobalKey<FormState>();
  TextEditingController titleController = new TextEditingController();
  TextEditingController messageController = new TextEditingController();
  TextEditingController tagController = new TextEditingController();
  bool _selectionMode = false;

  @override
  void initState() {
    super.initState();
    model = SongPostReviewPageViewModel(this);
    if(widget.from == "MyDraftsPageState") {
      titleController.text = widget.myDraft.title??"";
      messageController.text = widget.myDraft.description;
      model.tagList = getTagFromString(widget.myDraft.tag);
    }
  }

  get topBannerLinkView => Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        height: 162,
        child: Row(
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  child: ClipOval(
                    child: Container(
                      color: colorOvalBorder,
                      padding: EdgeInsets.all(2),
                      child: ClipOval(
                        child: Container(
                          width: 162,
                          child: Image.asset(
                            getIconString(widget.type),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                /*Icon(
                  Icons.play_circle_filled,
                  color: Color(0x59707070),
                  size: 54,
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: ClipOval(
                      child: Container(
                          color: colorOvalBorder,
                          padding: EdgeInsets.all(6),
                          child: Icon(
                            Icons.close,
                            size: 14,
                          ))),
                ),*/
              ],
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 10, left: 2, bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Image.asset(
                          getIconString(widget.type),
                          fit: BoxFit.fill,
                          height: 30,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        AutoSizeText(
                          widget.type,
                          style: getTextStyle(
                              color: Colors.black,
                              size: 18,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 4, bottom: 4),
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        widget.link,
                        style: getTextStyle(
                            color: colorTextPara,
                            fontWeight: FontWeight.w500),
                        maxLines: 1,
                        minFontSize: 10, maxFontSize: 14, overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );

  get albumsView => Container(
        height: 195,
        padding: EdgeInsets.only(
          top: 10,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
          child: Container(
            padding: EdgeInsets.only(top: 4, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 16, right: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text(
                            "Albums",
                            style: getTextStyle(
                                size: 18,
                                fontWeight: FontWeight.w800,
                                color: Colors.black),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            InkWell(
                              onTap: () async {
                                /*var result = await Navigator.push(
                                context,
                                NavigatePageRoute(
                                    context, SyloAlbumPage()));*/
                              },
                              child: Container(
                                child: Text(
                                  "View all",
                                  style: getTextStyle(
                                      color: colorSectionHead,
                                      size: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                padding: EdgeInsets.only(),
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_right,
                              size: 24,
                              color: colorSectionHead,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemCount: model.albumsItemList.length + 1,
                    /*  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, childAspectRatio: 0.5),
               */
                    shrinkWrap: true,
                    itemBuilder: (c, i) {
                      i = i - 1;
                      if (i == -1) {
                        return Container(
                          padding: EdgeInsets.only(left: 16),
                          child: Stack(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  ClipOval(
                                    child: Container(
                                      child: ClipOval(
                                        child: Container(
                                          color: Colors.white,
                                          width: 74,
                                          height: 74,
                                          child: InkWell(
                                            onTap: () async {
                                              String result = await showDialog(
                                                context: context,
                                                builder: (BuildContext
                                                context) =>
                                                    CreateAlbumPage(
                                                        syloId:
                                                        getCurrentSyloId()),
                                              );
                                              if (result != null) {
                                                setState(() {});
                                              }
                                            },
                                            child: Container(
                                              child: Image.asset(
                                                App.ic_create_album,
                                                fit: BoxFit.contain,
                                              ),
                                              padding: EdgeInsets.only(
                                                  left: 3,
                                                  right: 3,
                                                  top: 8,
                                                  bottom: 8),
                                            ),
                                          ),
                                        ),
                                      ),
                                      padding: EdgeInsets.all(3),
                                      color: colorOvalBorder,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    child: Text(
                                      "Create Album",
                                      style: getTextStyle(
                                          color: Colors.black,
                                          size: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    padding: EdgeInsets.only(top: 3),
                                  )
                                ],
                                mainAxisSize: MainAxisSize.min,
                              ),
                            ],
                          ),
                        );
                      }
                      return Container(
                        padding: EdgeInsets.only(left: 16),
                        child: Column(
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                InkWell(
                                  onTap: () async {
//                                    if (!_selectionMode) {
//                                      _selectionMode = true;
//                                    }
//                                    for (int i = 0;
//                                        i < model.albumsItemList.length;
//                                        i++) {
//                                      model.albumsItemList[i].isCheck = false;
//                                    }
                                    model.changeSelectItem(i);

                                    setState(() {});
//                                        var result = await Navigator.push(
//                                            context,
//                                            NavigatePageRoute(
//                                                context, SyloAlbumDetailPage()));
                                  },
                                  child: ClipOval(
                                    child: Container(
                                      child: Stack(
                                        children: <Widget>[
                                          ClipOval(
                                            child: getAlbumThumbIcon(
                                                model.albumsItemList[i]
                                                    .mediaType,
                                                model.albumsItemList[i]
                                                    .coverPhoto,
                                                cHeight: 74,
                                                cWidth: 74)
                                          ),
                                          model.albumsItemList[i].isCheck
                                              ? ClipOval(
                                                  child: Container(
                                                    width: 74,
                                                    height: 74,
                                                    color: Color.fromRGBO(
                                                        106, 13, 173, 0.3),
                                                    child: Icon(
                                                      Icons.check,
                                                      size: 30,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                              : Container(width: 0)
                                        ],
                                      ),
                                      padding: EdgeInsets.all(3),
                                      color: colorOvalBorder,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  child: ClipOval(
                                    child: Container(
                                      child: Text(
                                        model.albumsItemList[i].mediaCount != null
                                            ? model.albumsItemList[i].mediaCount
                                            .toString()
                                            : "0",
                                        style: getTextStyle(
                                          color: Colors.black,
                                          size: 9,
                                          fontWeight: FontWeight.w800,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
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
                              height: 8,
                            ),
                            Container(
                              child: Text(
//                                    "John Elder",
                                model.albumsItemList[i].albumName,
                                style: getTextStyle(
                                    color: Colors.black,
                                    size: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                              padding: EdgeInsets.only(top: 3),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  get syloView => model.userSylosList != null ? Container(
        height: 195,
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
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 16, right: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text(
                            "Choose Sylo",
                            style: getTextStyle(
                                size: 18,
                                fontWeight: FontWeight.w800,
                                color: Colors.black),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            InkWell(
                              onTap: () async {
                                var result = await Navigator.push(
                                    context,
                                    NavigatePageRoute(
                                        context, ChooseSyloViewAllPage(post_type: "Songs", userSylosList: model.userSylosList,)));
                                if(result != null){
                                  model.userSylosList = result;
                                }
                                setState(() {
                                });
                              },
                              child: Container(
                                child: Text(
                                  "View all",
                                  style: getTextStyle(
                                      color: colorSectionHead,
                                      size: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                padding: EdgeInsets.only(),
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_right,
                              size: 24,
                              color: colorSectionHead,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemCount: model.userSylosList.length,
                    /*  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, childAspectRatio: 0.5),
               */
                    shrinkWrap: true,
                    itemBuilder: (c, i) {
                      return Container(
                        padding: EdgeInsets.only(left: 16),
                        child: Stack(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                InkWell(
                                  onTap: () async {
//                                    if (!_selectionMode) {
//                                      _selectionMode = true;
//                                    }
//                                    for (int i = 0;
//                                        i < model.albumsItemList.length;
//                                        i++) {
//                                      model.albumsItemList[i].isCheck = false;
//                                    }
                                    model.changeSelectSyloItem(i);

                                    setState(() {});
//                                        var result = await Navigator.push(
//                                            context,
//                                            NavigatePageRoute(
//                                                context, SyloAlbumDetailPage()));
                                  },
                                  child: ClipOval(
                                    child: Container(
                                      child: Stack(
                                        children: <Widget>[
                                          ClipOval(
                                            child: Container(
                                              color: Colors.white,
                                              width: 74,
                                              height: 74,
                                              child: ImageFromNetworkView(
                                                path: model.userSylosList[i]
                                                    .syloPic !=
                                                    null
                                                    ? model.userSylosList[i]
                                                    .syloPic
                                                    : "",
                                                boxFit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          model.userSylosList[i].isCheck
                                              ? ClipOval(
                                                  child: Container(
                                                    width: 74,
                                                    height: 74,
                                                    color: Color.fromRGBO(
                                                        106, 13, 173, 0.3),
                                                    child: Icon(
                                                      Icons.check,
                                                      size: 30,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                              : Container(width: 0)
                                        ],
                                      ),
                                      padding: EdgeInsets.all(3),
                                      color: colorOvalBorder,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  child: Text(
                                   model.userSylosList[i].displayName ?? model.userSylosList[i].syloName,
                                    style: getTextStyle(
                                        color: Colors.black,
                                        size: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  padding: EdgeInsets.only(top: 3),
                                ),
                                Container(
                                  child: Text(
                                    model.userSylosList[i].syloAge,
                                    style: getTextStyle(
                                        color: Color(0x00ff707070),
                                        size: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  padding: EdgeInsets.only(top: 3),
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ):SizedBox();

  get saveButton => Container(
        padding: EdgeInsets.only(left: 16, right: 8),
        child: commonButton(
          () async {
//            if (isQuickPost) {
//              goToChooseSyloPage(context, "Songs");
//            } else {
              if (formKey.currentState.validate()) {
                hideFocusKeyBoard(context);
                if(messageController.text.trim().isEmpty) {
                  commonAlert(context, "Please Enter Description.");
                  return;
                }
                if(isQuickPost){
                  List<GetUserSylos> list = getListOfSelectedSylo(model.userSylosList);
                  if (list==null || list.length == 0) {
                    commonAlert(context, "Please Select Sylos.");
                    return;
                  }
                  List<GetUserSylos> selectedSyloList = List();
                  model.userSylosList.forEach((element) {
                    if(element.isCheck) {
                      selectedSyloList.add(element);
                    }
                  });
                  List<int> result = await goToChooseSyloPage(context, "Songs", selectedSyloList:selectedSyloList);
                  if ( result!=null){
                    String title = titleController.text.trim();
                    String description = messageController.text.trim();

                    model.createMediaSubAlbumSong(title, description, albumIdList: result);
                  }
                } else {
                  if (!model.albumSelected()) {
                    commonAlert(context, "Please Select Albums.");
                    return;
                  }
                  String title = titleController.text.trim();
                  String description = messageController.text.trim();

                  model.createMediaSubAlbumSong(title, description);
                }
              }
              /*var result = await Navigator.push(
                  context,
                  NavigatePageRoute(
                      context,
                      SuccessMessagePage(
                        headerName: "Songs",
                        message: "Your Songs have been saved to Harper's Sylo",
                      )));*/
//            }
          },
          isQuickPost ? "Continue" : "Save",
        ),
      );

  get formView => Container(
        padding: EdgeInsets.only(top: 8, left: 16, right: 16),
        child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: commontextFieldLabel("Add Title", size: 14),
                ),
                Container(
                  child: commonTextField(
                      titleController, TextInputType.text, "Enter Song Title",
                      autoFocus: true),
                ),
                Container(
                  padding: EdgeInsets.only(top: 16, bottom: 8),
                  alignment: Alignment.centerLeft,
                  child: commontextFieldLabel("Add Tags", size: 14),
                ),
                commonTagField(
                    context,
                    tagController,
                    tagList: model.tagListNew,
                    onChangeCallback: (tagItem) {
                      setState(() {

                        model.tagList.add(TagModel(name: tagItem));
                        model.tagList.forEach((item) {
                          var i = model.tagListNew.indexWhere((x) => x.name==tagItem);
                          if (i <= -1) {
                            model.tagListNew.add(TagModel(name: tagItem));
                          }
                        });

                        tagController.text = "";
                      });
                    },
                    onRemoveCallback: (index) {
                      setState(() {
                        model.tagListNew.removeAt(index);
                      });
                    }
                ),
                Container(
                  padding: EdgeInsets.only(top: 16, bottom: 8),
                  alignment: Alignment.centerLeft,
                  child:
                      commontextFieldLabel("Song Description", size: 14),
                ),
                Container(
                  child: TextField(
                    controller: messageController,
                    maxLines: null,
                    minLines: 2,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration.collapsed(
                      hintText: "Write Song Description",
                      hintStyle:
                          TextStyle(fontSize: 15.0, color: Color(0x00ffC3C3C3)),
                    ),
                  ),
                )
              ],
            )),
      );

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = SongPostReviewPageViewModel(this));

    return WillPopScope(
        onWillPop: () async {
            hideFocusKeyBoard(context);
            if (widget.from != "MyDraftsPageState") {
              await commonCupertinoDialogPage(
                  context,
                  commonDraftWarningCenterWidget(),
                  positiveAction: () async {
                    model.saveAsADraft();
                    Navigator.pop(context);
                  },
                  negativeAction: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                  }
              );
            } else {
              Navigator.pop(context);
            }
          return false;
        },
      child: Scaffold(
        backgroundColor: getColorBg(),
        appBar: AppBar(
          title: Text(
            "Song Post" + getSyloPostTitlesufix(appState.userSylo),
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
            onTap: () async {
              hideFocusKeyBoard(context);
              if (widget.from != "MyDraftsPageState") {
                await commonCupertinoDialogPage(
                    context,
                    commonDraftWarningCenterWidget(),
              positiveAction: () async {
              model.saveAsADraft();
              Navigator.pop(context);
              },
              negativeAction: () {
                Navigator.pop(context);
                Navigator.pop(context);
              }
              );
              } else {
              Navigator.pop(context);
              }
            },
          ),
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: Container(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
//              imagesListView,
                Column(
                  children: <Widget>[
                    topBannerLinkView,
                    formView,
                    isQuickPost ? syloView : albumsView,
                    saveButton,
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getIconString(String type) {
    if (type == "Spotify") {
      return App.ic_soptify;
    } else if (type == "iTunes") {
      return App.ic_itunes;
    } else if (type == "Soundcloud") {
      return App.ic_soundcloud;
    }
    return App.ic_utube_music;
  }

  getCurrentSyloId() {
    if (appState.userSylo != null) {
      return appState.userSylo.syloId != ""
          ? appState.userSylo.syloId.toString()
          : null;
    }
    return null;
  }
}
