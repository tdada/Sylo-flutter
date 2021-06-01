import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:circle_list/circle_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/common/play_video.dart';
import 'package:testsylo/page/password_add/password_add_page.dart';
import 'package:testsylo/util/navigate_effect.dart';
import 'package:testsylo/model/record_file_item.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../app.dart';

class ThumbnailPage extends StatefulWidget {
  String status = "";
  List<RecordFileItem> listRecordWithThumb = List();
  Function(Uint8List) callback;
  Function(int) getSelectIndex;
  int videoIndex;
  ThumbnailPage(this.status, this.listRecordWithThumb, {this.callback, this.getSelectIndex, this.videoIndex});

  @override
  ThumbnailPageState createState() => ThumbnailPageState();
}

class ThumbnailPageState extends State<ThumbnailPage> {
  TextEditingController nameAlbumController = TextEditingController();
  var _logInformKey = GlobalKey<FormState>();

  get onPressedVerify => () async {
        var result = await Navigator.push(
            context, NavigatePageRoute(context, PasswordAddPage()));
      };

  @override
  void initState() {
    super.initState();
    randomIndex = widget.videoIndex??0;
  }

  @override
  Widget build(BuildContext context) {
    print(runtimeType.toString());

    return animatedDialogueWithTextFieldAndButton(context);
  }

  Widget appBar() {
    return Container(
      height: 45,
      child: Material(
        color: getMatColorBg(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 16),
              width: 32,
              height: 32,
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    "Add Question",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 17),
                  ),
                ),
              ),
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.only(right: 16),
                width: 32,
                height: 32,
              ),
            )
          ],
        ),
      ),
    );
  }

  animatedDialogueWithTextFieldAndButton(context) {
    var mediaQuery = MediaQuery.of(context);
    return AnimatedContainer(
      padding: mediaQuery.viewInsets,
      duration: const Duration(milliseconds: 300),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Material(
                color: Colors.transparent,
                child: Container(
                  padding:
                      EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Container(
                      child: SafeArea(
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(0)),
                              ),
                              child:
                                  /*ListView(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                children: <Widget>[
                                  appBar(),
                                  Container(

                                    child: Center(child: Text("Enter your question here", style: getTextStyle(color: Colors.black, fontWeight: FontWeight.w500, size: 14),)),
                                  ),
                                  Form(
                                    key: _logInformKey,
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        top: 16,
                                        left: 16,
                                        right: 16
                                      ),
                                      child: Material(
                                        color: getMatColorBg(),
                                        elevation: 0.0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: new BorderRadius.only(
                                                topRight: Radius.circular(1),
                                                topLeft: Radius.circular(1),
                                                bottomLeft: Radius.circular(1),
                                                bottomRight:
                                                    Radius.circular(1))),
                                        child: Container(
                                          height: 35,
                                          child: TextFormField(

                                            controller: nameAlbumController,
                                            keyboardType: TextInputType.text,
                                            style: getTextStyle(size: 16, color: Colors.black, fontWeight: FontWeight.w400),
                                            decoration: InputDecoration(
                                              border: new OutlineInputBorder(
                                                borderRadius: const BorderRadius.all(
                                                  const Radius.circular(5.0),
                                                ),
                                                borderSide: BorderSide(width: 0.5, color: colorOvalBorder),
                                              ),
                                              contentPadding: EdgeInsets.only(left: 8),
                                              hintText: "",
                                              hintStyle:
                                              TextStyle(fontSize: 17.0),
                                            ),
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return App.errorFieldRequired;
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  Container(height: 1, color: colorOvalBorder, margin: EdgeInsets.only(top: 16),),

                                  Container(
                                    height: 50,
                                    child: Row(

                                      children: <Widget>[
                                        Expanded(

                                          child: InkWell(
                                            onTap: (){
                                              Navigator.pop(context);
                                            },
                                            child: Center(

                                              child: Text("Cancel", style: getTextStyle(color: Color(0x00ffC3C3C3), size: 18, fontWeight: FontWeight.w700),),

                                            ),
                                          ),

                                        ),
                                        Container(width: 1, color: colorOvalBorder,),
                                        Expanded(

                                          child: InkWell(
                                            onTap: (){
                                              if(_logInformKey.currentState.validate()) {
                                                _logInformKey.currentState.save();
                                                Navigator.pop(context, nameAlbumController.text);
                                              }

                                            },
                                            child: Center(

                                              child: Text("Save", style: getTextStyle(color: colorDark, size: 18, fontWeight: FontWeight.w700),),


                                            ),
                                          ),

                                        )


                                      ],

                                    ),
                                  )

                                ],
                              )*/
                                  viewByStatus),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get viewByStatus {
    if (widget.status == "random" || widget.status == "previewVideo") {
      return getRandomThumbs;
    } else {
      return Container();
    }
  }

  int editIndex = 0;

  Widget get getRandomThumbs {
    return ListView(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        Container(
          height: 45,
          child: Material(
            color: getMatColorBg(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 16),
                  width: 32,
                  height: 32,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      widget.status == "previewVideo" ? "Select Preview Video" : "Random Thumbnail",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 17),
                    ),
                  ),
                ),
                widget.listRecordWithThumb.length > 1 && widget.status != "previewVideo" && widget.videoIndex == null ? InkWell(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: Container(
                      margin: EdgeInsets.only(right: 16),
                      padding:
                          EdgeInsets.only(left: 8, right: 8, top: 3, bottom: 3),
                      color: colorOvalBorder,
                      child: Text(
                        "Refresh",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 13),
                      ),
                    ),
                  ),
                  onTap: (){

                    randomIndex = Random().nextInt(widget.listRecordWithThumb.length);


                    print("randomIndex -> " + randomIndex.toString());

                    setState(() {
                      _imageBytes = null;
                    });


                  },
                ) : Container()
              ],
            ),
          ),
        ),
        widget.status == "previewVideo" ? circularListView : FutureBuilder(
            future: generateThumbnail(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                _imageBytes = snapshot.data;
                return Container(
                  height: 150,
                  padding:
                  EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
                  alignment: Alignment.center,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemCount: _imageBytes.length,
                    shrinkWrap: true,
                    itemBuilder: (c, index) {

                      return
                        index<3?
                        InkWell(
                        onTap: () {
                          setState(() {
                            editIndex = index;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ClipOval(
                                child: Container(
                                  child: ClipOval(
                                    child: Image(
                                      image: MemoryImage(_imageBytes[index]),
                                      fit: BoxFit.cover,
                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                  padding: EdgeInsets.all(4),
                                  color: index == editIndex
                                      ? colorOvalBorder2
                                      : colorOvalBorder,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ):(Container());
                    }
                  ),
                );
              } else {
                return Container(
                  height: 75,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            }),
        Container(
          height: 1,
          color: colorOvalBorder,
          margin: EdgeInsets.only(top: 16),
        ),
        Container(
          height: 50,
          child: Row(
            children: <Widget>[
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Center(
                    child: Text(
                      "Cancel",
                      style: getTextStyle(
                          color: Color(0x00ffC3C3C3),
                          size: 18,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
              Container(
                width: 1,
                color: colorOvalBorder,
              ),
              Expanded(
                child: InkWell(
                  onTap:
                      () {
//                        _imageBytes[editIndex]
                        widget.status == "previewVideo" ? widget.getSelectIndex(editIndex) :
                        widget.callback(_imageBytes[editIndex]);
                    Navigator.pop(context);
                  },
                  child: Center(
                    child: Text(
                      widget.status == "previewVideo" ? "Use This Video" : "Use This Frame",
                      style: getTextStyle(
                          color: colorDark,
                          size: 18,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
  List<Uint8List> _imageBytes;
  int randomIndex;
  Future<List<Uint8List>> generateThumbnail() async {
    if(_imageBytes!=null) return _imageBytes;
    final String _videoPath = widget.listRecordWithThumb[randomIndex].file.path;
    VideoPlayerController controller = VideoPlayerController.file(widget.listRecordWithThumb[randomIndex].file);
    await controller.initialize();
    double _eachPart = controller.value.duration.inMilliseconds / 10;

    List<Uint8List> _byteList = [];

    for (int i = 1; i <= 10; i++) {
      Uint8List _bytes;
      _bytes = await VideoThumbnail.thumbnailData(
        video: _videoPath,
        imageFormat: ImageFormat.JPEG,
        timeMs: (_eachPart * i).toInt(),
        quality: 50,
      );

      _byteList.add(_bytes);

    }
    return _byteList;
  }
  Widget get circularListView {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width-32,
            height: MediaQuery.of(context).size.width-32,
            child: Stack(
//            alignment: Alignment.center,
              children: <Widget>[
                Positioned.fill(
                    child: Container(
                      margin: EdgeInsets.all(40),
                      child: borderCircle,
                    )),
                CircleList(
                  initialAngle: 160.2,
                  origin: Offset(0, 0),
                  outerRadius: (MediaQuery.of(context).size.width-32)/2,
                  children:
                  List.generate(widget.listRecordWithThumb.length, (index) {
                    RecordFileItem item = widget.listRecordWithThumb[index];
                    return InkWell(
                      onTap: () {
                        setState(() {
                          editIndex = -1;
                        });

                        Future.delayed(const Duration(milliseconds: 400), () {
                          setState(() {
                            editIndex = index;
                          });
                        });
                      },
                      child: Container(
                          width: 60,
                          height: 60,
                          child: Stack(
                            children: [
                              ClipOval(
                              child: Image.file(
                                item.thumbPath,
                                fit: BoxFit.cover,
                                width: 54,
                                height: 54,
                              ),
                        ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  padding: EdgeInsets.zero,
                                  width: 24,
                                  height: 24,
                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    "${index + 1}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  ),
                                ),
                              )
                            ],
                          ),
                        padding: EdgeInsets.all(3),
                        decoration:BoxDecoration(color: index == editIndex
                            ? colorOvalBorder2
                            : colorOvalBorder,
                        shape: BoxShape.circle)
                      ),
                    );
                  }),
                  centerWidget: Stack(
                    children: <Widget>[
                      ClipOval(
                        child: Container(
                          child: InkWell(
                            child: ClipOval(
                              child: Container(
                                width: 105,
                                height: 105,
                                child: editIndex == -1
                                    ? Container(
                                  child: CircularProgressIndicator(),
                                  width: 24,
                                  height: 24,
                                  alignment: Alignment.center,
                                )
                                    : PlayVideoPage(
                                  url: widget
                                      .listRecordWithThumb[editIndex]
                                      .file
                                      .path,
                                  isFile: true,
                                ),
                              ),
                            ),
                          ),
                          padding: EdgeInsets.all(3),
                          color: colorOvalBorder,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
    return Container(
      child:
//      Column(
//        crossAxisAlignment: CrossAxisAlignment.center,
//        children: <Widget>[
          Stack(
//            alignment: Alignment.center,
            children: <Widget>[
              Positioned.fill(
                  child: Container(
                    margin: EdgeInsets.all(40),
                    child: borderCircle,
                  )),
              CircleList(
                origin: Offset(0, 0),
                outerRadius: 185,
                children:
                List.generate(widget.listRecordWithThumb.length, (index) {
                  RecordFileItem item = widget.listRecordWithThumb[index];
                  return InkWell(
                    onTap: () {
                      setState(() {
                        editIndex = -1;
                      });

                      Future.delayed(const Duration(milliseconds: 400), () {
                        setState(() {
                          editIndex = index;
                        });
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ClipOval(
                          child: Container(
                            child: ClipOval(
                              child: Image.file(
                                item.thumbPath,
                                fit: BoxFit.cover,
                                width: 54,
                                height: 54,
                              ),
                            ),
                            padding: EdgeInsets.all(4),
                            color: index == editIndex
                                ? colorOvalBorder2
                                : colorOvalBorder,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                centerWidget: Stack(
                  children: <Widget>[
                    ClipOval(
                      child: Container(
                        child: InkWell(
                          child: ClipOval(
                            child: Container(
                              width: 125,
                              height: 125,
                              child: editIndex == -1
                                  ? Container(
                                child: CircularProgressIndicator(),
                                width: 24,
                                height: 24,
                                alignment: Alignment.center,
                              )
                                  : PlayVideoPage(
                                url: widget
                                    .listRecordWithThumb[editIndex]
                                    .file
                                    .path,
                                isFile: true,
                              ),
                            ),
                          ),
                        ),
                        padding: EdgeInsets.all(3),
                        color: colorOvalBorder,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
//        ],
//      ),
    );
  }
  get borderCircle => ClipOval(
    child: Container(
      padding: EdgeInsets.all(1),
      color: colorOvalBorder2,
      child: ClipOval(
        child: Container(
          color: Colors.white,
        ),
      ),
    ),
  );
}
