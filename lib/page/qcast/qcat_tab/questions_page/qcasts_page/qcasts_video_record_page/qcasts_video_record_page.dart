import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:testsylo/bloc_item/seek_bloc.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/common/play_video.dart';
import 'package:testsylo/common/play_view_side_video.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/model/draft_model.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/model/question_item.dart';
import 'package:testsylo/model/record_file_item.dart';
import 'package:testsylo/page/common/create_album_page.dart';
import 'package:testsylo/page/qcast/qcat_tab/questions_page/qcasts_page/qcasts_video_record_page/qcasts_video_record_page_view_model.dart';
import 'package:testsylo/page/sylo/choose_sylo_view_all_page/choose_sylo_view_all_page.dart';
import 'package:testsylo/util/navigate_effect.dart';
import 'package:testsylo/util/util.dart';

import '../../../../../../app.dart';

class QcastsVideoRecordPage extends StatefulWidget {
  List<RecordFileItem> listRecordWithThumb = List();
  List<QuestionItem> listQuestion = List();
  CameraState cameraState = CameraState.R;
  String from = "";
  MyDraft myDraft;

  QcastsVideoRecordPage(
      this.listRecordWithThumb, this.listQuestion, this.cameraState,
      {this.from = "", this.myDraft});

  @override
  QcastsVideoRecordPageState createState() => QcastsVideoRecordPageState();
}

class QcastsVideoRecordPageState extends State<QcastsVideoRecordPage> {
  QcastsVideoRecordPageViewModel model;
  var formKey = GlobalKey<FormState>();
  TextEditingController titleController;
  TextEditingController tagController;
  bool _selectionMode = false;

  @override
  void initState() {
    super.initState();
    model = QcastsVideoRecordPageViewModel(this);
    titleController = TextEditingController();
    tagController = TextEditingController();
    if (widget.from == "MyDraftsPageState") {
      titleController.text = widget.myDraft.title ?? "";
      model.tagList = getTagFromString(widget.myDraft.tag);
    }
    if (widget.from == "edit") {
      titleController.text = widget.myDraft.title ?? "";
      model.tagList = getTagFromString(widget.myDraft.tag);
    }
  }

  get pickProfile => InkWell(
        onTap: () async {
          try {} catch (e) {}
        },
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            widget.cameraState == CameraState.R
                ? ClipOval(
                    child: Container(
                        color: colorOvalBorder,
                        width: 120,
                        height: 120,
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Image.file(
                              widget.listRecordWithThumb[0].thumbPath),
                        )
//                PlayVideoPage(
//                  isFile: widget.listRecordWithThumb[0].link==null ? true : false,
//                  url: widget.listRecordWithThumb[0].link==null ? widget.listRecordWithThumb[0].file.path : widget.listRecordWithThumb[0].link,
//                  callback: functionGetProgress,
//                ),
                        ),
                  )
                : Container(
                    color: colorOvalBorder,
                    width: 120,
                    height: 120,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child:
                          Image.file(widget.listRecordWithThumb[0].thumbPath),
                    )
//              PlayVideoPage(
//                isFile: widget.listRecordWithThumb[0].link==null ? true : false,
//                url: widget.listRecordWithThumb[0].link==null ? widget.listRecordWithThumb[0].file.path : widget.listRecordWithThumb[0].link,
//                callback: functionGetProgress,
//              ),
                    ),
            IgnorePointer(
              child: StreamBuilder(
                  stream: seekBloc.controller,
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      print("seekBloc -> " + snapshot.data.toString());
                      return Stack(
                        children: <Widget>[
                          commonDurationIndicator(snapshot.data, 110, 2.5),
                          Positioned(
                            right: 2,
                            bottom: 2,
                            child: Container(
                              alignment: Alignment.topCenter,
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: <Widget>[
                                  FutureBuilder(
                                      future: model
                                          .getQuestionThumbIfQueListNotNull(),
                                      builder: (context, snapshot) {
                                        //print("Question -> " + snapshot.data.toString());
                                        return snapshot.data == null ||
                                                snapshot.data.isEmpty
                                            ? Container()
                                            : ClipOval(
                                                child: Container(
                                                    color: colorOvalBorder,
                                                    width: 32,
                                                    height: 32,
                                                    child: ImageFromNetworkView(
                                                      path: snapshot.data,
                                                      boxFit: BoxFit.cover,
                                                    )),
                                              );
                                      }),
                                  /*IgnorePointer(
                                child: StreamBuilder(
                                    stream: seekBloc.controller,
                                    builder: (context, snapshot) {
                                      if (snapshot.data != null) {
                                        //print("seekBloc -> " + snapshot.data.toString());
                                        return commonDurationIndicator(
                                            snapshot.data, 110, 2.5);
                                      } else {
                                        return Container();
                                      }
                                    }),
                              ),*/
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Container(
                        width: 110,
                        height: 110,
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                alignment: Alignment.topCenter,
                                child: Stack(
                                  alignment: Alignment.topCenter,
                                  children: <Widget>[
                                    FutureBuilder(
                                        future: model
                                            .getQuestionThumbIfQueListNotNull(),
                                        builder: (context, snapshot) {
                                          //print("Question -> " + snapshot.data.toString());
                                          return snapshot.data == null ||
                                                  snapshot.data.isEmpty
                                              ? Container()
                                              : ClipOval(
                                                  child: Container(
                                                      color: colorOvalBorder,
                                                      width: 35,
                                                      height: 35,
                                                      child:
                                                          ImageFromNetworkView(
                                                        path: snapshot.data,
                                                        boxFit: BoxFit.cover,
                                                      )),
                                                );
                                        }),
                                    /*IgnorePointer(
                                child: StreamBuilder(
                                    stream: seekBloc.controller,
                                    builder: (context, snapshot) {
                                      if (snapshot.data != null) {
                                        //print("seekBloc -> " + snapshot.data.toString());
                                        return commonDurationIndicator(
                                            snapshot.data, 110, 2.5);
                                      } else {
                                        return Container();
                                      }
                                    }),
                              ),*/
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }),
            ),
            IconButton(
              icon: Icon(
                Icons.play_arrow,
                size: 48.0,
                color: colorBlack,
              ),
              padding: EdgeInsets.all(0),
              onPressed: () async {

                showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      PlayViewSideVideoPage(
                    isFile: widget.listRecordWithThumb[0].link == null
                        ? true
                        : false,
                    url: widget.listRecordWithThumb[0].link == null
                        ? widget.listRecordWithThumb[0].file.path
                        : widget.listRecordWithThumb[0].link,
                    cameraState: widget.cameraState,
                    playIndicator: false,
                  ),
                );
              },
            ),
          ],
        ),
      );

  get editVideoButtons => widget.from != "MyDraftsPageState"
      ? Container(
          height: 30,
          child: FlatButton.icon(
              onPressed: () {
                widget.myDraft = MyDraft();
                widget.myDraft.title = titleController.text;
                widget.myDraft.tag = getTagString(model.tagList);
                Navigator.pop(context, widget.myDraft);
              },
              icon: Icon(
                Icons.mode_edit,
                size: 14,
              ),
              label: Text(
                "Edit Video",
                style: getTextStyle(
                    color: Colors.black, fontWeight: FontWeight.w600, size: 15),
              ),
              color: colorOvalBorder,
              disabledColor: colorOvalBorder,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              )),
        )
      : SizedBox();

  get titleField => Container(
        padding: EdgeInsets.only(left: 8, right: 8),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 8, left: 8),
              alignment: Alignment.centerLeft,
              child: commontextFieldLabel(
                  appState.selectedDownloadedQcast != null
                      ? "Enter Qcast Interview Title"
                      : "Add Title",
                  size: 14),
            ),
            Container(
              padding: EdgeInsets.only(left: 8),
              child: commonTextField(
                  titleController,
                  TextInputType.text,
                  appState.selectedDownloadedQcast != null
                      ? "Enter Qcast Interview Title"
                      : "Enter Video Title",
                  autoFocus: true),
            ),
          ],
        ),
      );

  get tagField => Container(
        padding: EdgeInsets.only(left: 8, right: 8),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 16, left: 8, bottom: 8),
              alignment: Alignment.centerLeft,
              child: commontextFieldLabel("Add Tags", size: 14),
            ),
            Container(
              padding: EdgeInsets.only(left: 8, bottom: 8),
              alignment: Alignment.centerLeft,
              child: commonTagField(context, tagController,
                  tagList: model.tagListNew, onChangeCallback: (tagItem) {
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
              }, onRemoveCallback: (index) {
                setState(() {
                  model.tagListNew.removeAt(index);
                });
              }),
            ),
          ],
        ),
      );

  get albumsView => Container(
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
                                /*  var result = await Navigator.push(
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
                                                  cWidth: 74)),
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
                                        model.albumsItemList[i].mediaCount !=
                                                null
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

  get syloView => model.userSylosList != null
      ? Container(
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
                                          context,
                                          ChooseSyloViewAllPage(
                                            post_type: "Video",
                                            userSylosList: model.userSylosList,
                                          )));
                                  if (result != null) {
                                    model.userSylosList = result;
                                  }
                                  setState(() {});
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
                      //gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      //crossAxisCount: 4, childAspectRatio: 0.5),
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
        )
      : SizedBox();

  get saveButton => Container(
        child: commonButton(() async {
          if (formKey.currentState.validate()) {
            hideFocusKeyBoard(context);
            List<int> _albumListResult;
            if (isQuickPost) {
              List<GetUserSylos> list =
                  getListOfSelectedSylo(model.userSylosList);
              if (list == null || list.length == 0) {
                commonAlert(context, "Please Select Sylos.");
                return;
              }
              List<GetUserSylos> selectedSyloList = List();
              model.userSylosList.forEach((element) {
                if (element.isCheck) {
                  selectedSyloList.add(element);
                }
              });
              _albumListResult = await goToChooseSyloPage(context, "Video",
                  selectedSyloList: selectedSyloList);
              if (_albumListResult == null) {
                return;
              }
            } else {
              if (widget.from == "edit") {
                if (!model.albumSelected()) {
                  commonAlert(context, "Please Select Albums.");
                  return;
                }
              }
              else if(widget.from == "QcamPageState"){

                  List<GetUserSylos> list =
                  getListOfSelectedSylo(model.userSylosList);
                  if (list == null || list.length == 0) {
                    commonAlert(context, "Please Select Sylos.");
                    return;
                  }
                  List<GetUserSylos> selectedSyloList = List();
                  model.userSylosList.forEach((element) {
                    if (element.isCheck) {
                      selectedSyloList.add(element);
                    }
                  });
                  _albumListResult =
                  await goToChooseSyloPage(context, "Video",
                      selectedSyloList: selectedSyloList);
                  if (_albumListResult == null) {
                    return;
                  }
              }
              else {
                if (!model.albumSelected()) {
                  commonAlert(context, "Please Select Albums.");
                  return;
                }
              }
            }
            String title = titleController.text.trim();
            File thumbnailFile = await model.getVideoThumbFile();
            String coverPhoto;
            if (thumbnailFile != null) {
              print("File path -> " + thumbnailFile.path.toString());
              coverPhoto = await model.uploadGeneratedThumbnail(thumbnailFile);
              print("Cover path -> " + thumbnailFile.path.toString());
            }
            if (coverPhoto != null) {
              List<String> uploadedImages =
                  await model.uploadMediaPhotoPost("Video");
              print("Cover path1 -> " + uploadedImages.length.toString());
              if (uploadedImages != null && uploadedImages.length > 0) {
                if (isQuickPost) {
                  if (appState.selectedDownloadedQcast != null) {
                    model.createMediaSubAlbumQcast(
                        title,
                        uploadedImages.join(", "),
                        coverPhoto,
                        appState.selectedDownloadedQcast.qcastId,
                        _albumListResult.join(", "));
                  } else {
                    model.createMediaSubAlbumPhoto(
                      title,
                      uploadedImages.join(", "),
                      coverPhoto,
                      _albumListResult.join(","),
                    );
                  }
                } else {
                  model.createMediaSubAlbumPhoto(
                      title,
                      uploadedImages.join(", "),
                      coverPhoto,
                      model.albumsItemListSelected.join(","));
                }
              }
            }
          }
        }, isQuickPost ? "Continue" : "Save"),
        padding: EdgeInsets.only(left: 16, right: 16),
      );

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    print("runtimeType1 -> " + widget.from.toString());

    model ?? (model = QcastsVideoRecordPageViewModel(this));

    return WillPopScope(
      onWillPop: () async {
        hideFocusKeyBoard(context);
        if (widget.from != "MyDraftsPageState") {
          if (widget.listRecordWithThumb[0] != null) {
            await commonCupertinoDialogPage(
                context, commonDraftWarningCenterWidget(),
                positiveAction: () async {
              await model.saveAsDraft();
            }, negativeAction: () {
              Navigator.pop(context);
              Navigator.pop(context);
            });
          } else {
            Navigator.pop(context);
          }
        } else {
          Navigator.pop(context);
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: getColorBg(),
        appBar: AppBar(
          title: Text(
            appState.selectedDownloadedQcast != null
                ? "Edit Qcast Interview"
                : _getTitle(),
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
                if (widget.listRecordWithThumb[0] != null) {
                  await commonCupertinoDialogPage(
                      context, commonDraftWarningCenterWidget(),
                      positiveAction: () async {
                    await model.saveAsDraft();
                  }, negativeAction: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                      });
                } else {
                  Navigator.pop(context);
                }
              } else {
                Navigator.pop(context);
              }
            },
          ),
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: CupertinoScrollbar(
              child: Container(
            child:
                ListView(physics: BouncingScrollPhysics(), children: <Widget>[
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    pickProfile,
                    SizedBox(
                      height: 12,
                    ),
                    editVideoButtons,
                    titleField,
                    SizedBox(
                      height: 8,
                    ),
                    tagField,
                    widget.from == "QcamPageState"
                        ? syloView
                        : isQuickPost
                            ? syloView
                            : albumsView,
                    saveButton,
                  ],
                ),
              ),
            ]),
          )),
        ),
      ),
    );
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

  SeekBloc seekBloc = SeekBloc();

  getCurrentSyloId() {
    if (appState.userSylo != null) {
      return appState.userSylo.syloId != ""
          ? appState.userSylo.syloId.toString()
          : null;
    }
    return null;
  }

  String _getTitle() {
    return "Review Video" + getSyloPostTitlesufix(appState.userSylo);
  }
}
