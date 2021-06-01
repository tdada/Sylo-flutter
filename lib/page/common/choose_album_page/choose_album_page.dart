import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/albums_item.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/page/sylo/open_message_page/edit_open_message_page/success_message_page/success_message_page.dart';
import 'package:testsylo/page/sylo/view_sylo_page/sylo_album_page/sylo_album_page.dart';
import 'package:testsylo/util/navigate_effect.dart';

import '../../../app.dart';
import '../create_album_page.dart';
import 'choose_album_page_view_model.dart';

class ChooseAlbumPage extends StatefulWidget {
  String post_type = "";
  List<GetUserSylos> selectedSyloList = List();
  ChooseAlbumPage({this.post_type, this.selectedSyloList});

  @override
  ChooseAlbumPageState createState() => ChooseAlbumPageState();
}

class ChooseAlbumPageState extends State<ChooseAlbumPage> {
  ChooseAlbumPageViewModel model;
  bool _selectionMode = false;

  Widget albumsView(String _syloId) {
    return Container(
      height: 195,

      padding: EdgeInsets.only(
        top: 12,
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
                flex: 1,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemCount: (model.syloAlbumData[_syloId]?.length ?? 0) + 1,
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
                                              builder: (BuildContext context) =>
                                                  CreateAlbumPage(
                                                syloId: _syloId,
                                                quickAlbum: true,
                                              ),
                                            );
                                            if (result != null) {
                                              print("QuickAddedAlbum -->");
                                              print(appState.quickAddedAlbum);
                                              if (appState.quickAddedAlbum !=
                                                  null) {
                                                model.syloAlbumData[_syloId]
                                                    .add(appState
                                                        .quickAddedAlbum);
                                              }
                                              appState.quickAddedAlbum = null;
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
                    GetAlbum albumItem = model.syloAlbumData[_syloId][i];
                    return Container(
                      padding: EdgeInsets.only(left: 16),
                      child: Column(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              InkWell(
                                onTap: () async {
                                  model.changeSelectAlbumItem(i, _syloId);
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
                                              albumItem.mediaType,
                                              albumItem.coverPhoto,
                                              cHeight: 74,
                                              cWidth: 74),
                                        ),
                                        albumItem.isCheck
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
                                      albumItem.mediaCount != null
                                          ? albumItem.mediaCount.toString()
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
                            child: AutoSizeText(
                              albumItem.albumName,
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
              )

            ],
          ),
        ),
      ),
    );
  }

  Widget albumsViewGrid(String _syloId) {
    return Container(


      padding: EdgeInsets.only(
        top: 12,
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

              Container(
                height: MediaQuery.of(context).size.height,
                child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  itemCount: (model.syloAlbumData[_syloId]?.length ?? 0) + 1,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, childAspectRatio: 0.9),
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
                                              builder: (BuildContext context) =>
                                                  CreateAlbumPage(
                                                    syloId: _syloId,
                                                    quickAlbum: true,
                                                  ),
                                            );
                                            if (result != null) {
                                              print("QuickAddedAlbum -->");
                                              print(appState.quickAddedAlbum);
                                              if (appState.quickAddedAlbum !=
                                                  null) {
                                                model.syloAlbumData[_syloId]
                                                    .add(appState
                                                    .quickAddedAlbum);
                                              }
                                              appState.quickAddedAlbum = null;
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
                    GetAlbum albumItem = model.syloAlbumData[_syloId][i];
                    return Container(
                      padding: EdgeInsets.only(left: 16),
                      child: Column(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              InkWell(
                                onTap: () async {
                                  model.changeSelectAlbumItem(i, _syloId);
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
                                              albumItem.mediaType,
                                              albumItem.coverPhoto,
                                              cHeight: 74,
                                              cWidth: 74),
                                        ),
                                        albumItem.isCheck
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
                                      albumItem.mediaCount != null
                                          ? albumItem.mediaCount.toString()
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
                            child: AutoSizeText(
                              albumItem.albumName,
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
  }

  get saveButton => Container(
        child: commonButton(() {
          if (model.getSelectedalbumsList().length > 0) {
//          goToSuccessMessagePage(widget.post_type)
            Navigator.pop(context, model.getSelectedalbumsList());
          } else {
            commonAlert(context, "Please, Select at least one album.");
          }
        }, "Save"),
      );

  get topView => ListView.builder(
//    scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemCount: widget.selectedSyloList?.length,
        /*  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, childAspectRatio: 0.5),
               */
        shrinkWrap: true,
        itemBuilder: (c, i) {
          GetUserSylos userSyloItem = widget.selectedSyloList[i];
          return Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  children: <Widget>[
                    ClipOval(
                      child: Container(
                        child: ClipOval(
                          child: Container(
                            color: Colors.white,
                            width: 30,
                            height: 30,
                            child: InkWell(
                              onTap: () async {},
                              child: Container(
                                child: ImageFromNetworkView(
                                  path: userSyloItem.syloPic != null
                                      ? userSyloItem.syloPic
                                      : "",
                                  boxFit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        padding: EdgeInsets.all(3),
                        color: colorOvalBorder,
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      userSyloItem.displayName ?? userSyloItem.syloName,
                      style: getTextStyle(
                          color: colorDark,
                          size: 16,
                          fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
              widget.selectedSyloList.length>1? albumsView(widget.selectedSyloList[i].syloId.toString()):
              albumsViewGrid(widget.selectedSyloList[i].syloId.toString()),
            ],
          );
        },
      );


  get topViewGrid => Container(

    child: ListView.builder(
//    scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      itemCount: widget.selectedSyloList?.length,

      shrinkWrap: true,
      itemBuilder: (c, i) {
        GetUserSylos userSyloItem = widget.selectedSyloList[i];
        return Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Row(
                children: <Widget>[
                  ClipOval(
                    child: Container(
                      child: ClipOval(
                        child: Container(
                          color: Colors.white,
                          width: 30,
                          height: 30,
                          child: InkWell(
                            onTap: () async {},
                            child: Container(
                              child: ImageFromNetworkView(
                                path: userSyloItem.syloPic != null
                                    ? userSyloItem.syloPic
                                    : "",
                                boxFit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      padding: EdgeInsets.all(3),
                      color: colorOvalBorder,
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    userSyloItem.displayName ?? userSyloItem.syloName,
                    style: getTextStyle(
                        color: colorDark,
                        size: 16,
                        fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Row(
                children: <Widget>[
                  ClipOval(
                    child: Container(
                      child: ClipOval(
                        child: Container(
                          color: Colors.white,
                          width: 30,
                          height: 30,
                          child: InkWell(
                            onTap: () async {},
                            child: Container(
                              child: ImageFromNetworkView(
                                path: userSyloItem.syloPic != null
                                    ? userSyloItem.syloPic
                                    : "",
                                boxFit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      padding: EdgeInsets.all(3),
                      color: colorOvalBorder,
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    userSyloItem.displayName ?? userSyloItem.syloName,
                    style: getTextStyle(
                        color: colorDark,
                        size: 16,
                        fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
            albumsView(widget.selectedSyloList[i].syloId.toString()),
          ],
        );
      },
    ),
  );


  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = ChooseAlbumPageViewModel(this));

    return Scaffold(
      backgroundColor: getColorBg(),
      appBar: AppBar(
        title: Text(
          "Choose album",
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
      bottomNavigationBar: Container(
        height: 60,
        child: saveButton,
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
        ),
        margin: EdgeInsets.only(bottom: 16),
      ),
      body: SafeArea(
        child: Container(
          child: ListView(shrinkWrap: true,physics: BouncingScrollPhysics(), children: <Widget>[
            topView
//            albumsView,
          ]),
        ),
      ),
    );
  }

  goToSuccessMessagePage(String post_type) async {
    var result = await Navigator.push(
        context,
        NavigatePageRoute(
            context,
            SuccessMessagePage(
              headerName: "$post_type Post",
              message: "Your $post_type has been saved to Harper's Sylo",
            )));
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
