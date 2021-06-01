import 'package:auto_size_text/auto_size_text.dart';
import 'package:circle_list/circle_list.dart';
import 'package:flutter/material.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/util/navigate_effect.dart';

import '../../../../../app.dart';
import 'opening_message_deatil_shared_page_view_model.dart';
import 'shared_detail_album_page/shared_detail_album_page.dart';

class OpeningMessageDetailSharedPage extends StatefulWidget {
  SharedSyloItem sharedSyloItem;
  OpeningMessageDetailSharedPage({this.sharedSyloItem});
  @override
  OpeningMessageDetailSharedPageState createState() => OpeningMessageDetailSharedPageState();
}

class OpeningMessageDetailSharedPageState extends State<OpeningMessageDetailSharedPage> {
  OpeningMessageDetailSharedPageViewModel model;
  bool syloAlbumDisplayView = false;

  get syloAlbumsGridView => Container(
    child: GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: appState.albumList?.length??0,
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, childAspectRatio: 0.95),
      shrinkWrap: true,
      itemBuilder: (c, i) {
        GetAlbum getAlbum = appState.albumList[i];
        return Container(
            padding: EdgeInsets.only(left: 5, top: 5),
            child: Column(
              children: <Widget>[
                InkWell(
                  child: Stack(
                    children: <Widget>[
                      ClipOval(
                        child: Container(
                          child: ClipOval(
                            child: getAlbumThumbIcon(getAlbum.mediaType,getAlbum.coverPhoto,cHeight: 82,cWidth: 82),
                          ),
                          padding: EdgeInsets.all(3),
                          color: colorOvalBorder,
                        ),
                      ),
                      Positioned(

                        child: ClipOval(
                          child: Container(
                            child: Text(getAlbum.mediaCount!=null?getAlbum.mediaCount.toString():"0", style: getTextStyle(color: Colors.black, size: 9, fontWeight: FontWeight.w800, ), overflow: TextOverflow.ellipsis, maxLines: 1,),
                            color: colorOvalBorder,
                            alignment: Alignment.center,
                            width: 24,
                            height: 24,
                          ),
                        ),
                        right: 1,
                        top: 1,
                      )
                    ],
                  ),
                  onTap: () async {
                      var result = await Navigator.push(
                          context, NavigatePageRoute(context, SharedDetailAlbumPage(getAlbum:getAlbum)));
                  },
                ),
                SizedBox(
                  height: 3,
                ),
                Container(
                  child: Text(
                    getAlbum.albumName,
                    style: getTextStyle(
                        color: colorDark,
                        size: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  padding: EdgeInsets.only(top: 3),
                )
              ],
            ),
        );
      },
    ),
  );

  @override
  void initState() {
    super.initState();
    appState.albumList = null;
  }

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
    padding: EdgeInsets.only(top: 30),
    child: Column(
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned.fill(
                child: Container(
                  margin: EdgeInsets.all(40),
                  child: borderCircle,
                )
            ),
            CircleList(
              origin: Offset(0, 0),
              children: List.generate((appState.albumList?.length??0)>9?9:appState.albumList?.length??0, (index) {
                GetAlbum getAlbum = appState.albumList[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 20,
                    ),
                    InkWell(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top:4, right:4),
                            child: ClipOval(
                              child: Container(
                                child: ClipOval(
                                  child: getAlbumThumbIcon(getAlbum.mediaType,getAlbum.coverPhoto,audioImagePadding: 13),
                                ),
                                padding: EdgeInsets.all(3),
                                color: colorOvalBorder,
                              ),
                            ),
                          ),
                          Positioned(
                            child: ClipOval(
                              child: Container(
                                child: Text(getAlbum.mediaCount!=null?getAlbum.mediaCount.toString():"0", style: getTextStyle(color: Colors.black, size: 9, fontWeight: FontWeight.w800, ), overflow: TextOverflow.ellipsis, maxLines: 1,),
                                color: colorOvalBorder,
                                alignment: Alignment.center,
                                width: 24,
                                height: 24,
                              ),
                            ),
                            right: 1,
                            top: 1,
                          )
                        ],
                      ),
                      onTap: () async {
                        var result = await Navigator.push(
                            context, NavigatePageRoute(context, SharedDetailAlbumPage(getAlbum:getAlbum)));
                      },
                    ),
                    Container(
                      child: AutoSizeText(
                        getAlbum.albumName,
                        style: getTextStyle(
                            color: Colors.black,
                            size: 13,
                            fontWeight: FontWeight.w500),
                        maxLines: 2,
                      ),
                      padding: EdgeInsets.only(top: 3),
                      alignment: Alignment.center,
                    )
                  ],
                );
              }),
              centerWidget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ClipOval(
                    child: Container(
                      width: 125,
                      height: 125,
                      child: ClipOval(
                        child: ImageFromNetworkView(
                          path: widget.sharedSyloItem?.syloPic??"",
                          boxFit: BoxFit.cover,
                        ),
                      ),
                      padding: EdgeInsets.all(3),
                      color: colorOvalBorder,
                    ),
                  ),
                ],
              ),
            ),
            model.isLoader ?
            Center(child: getCircularIndicatorWithBackSheet())
                : SizedBox(height: 0, width: 0),
          ],
        ),
      ],
    ),
  );
  get viewAllHeaderButton => Container(

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

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = OpeningMessageDetailSharedPageViewModel(this));

    return Scaffold(
      backgroundColor: getColorBg(),
      appBar: AppBar(
        title: Text(
          syloAlbumDisplayView?"Albums":"Name",
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
          viewAllHeaderButton,
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
}
