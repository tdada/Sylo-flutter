import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/model/draft_model.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/page/common/create_album_page.dart';
import 'package:testsylo/page/post_media/post_photo/record_voice_tag_page/record_voice_tag_page.dart';
import 'package:testsylo/page/post_media/post_photo/review_photo_post_page/review_photo_post_page_view_model.dart';
import 'package:testsylo/page/sylo/choose_sylo_view_all_page/choose_sylo_view_all_page.dart';
import 'package:testsylo/page/sylo/open_message_page/edit_open_message_page/success_message_page/success_message_page.dart';
import 'package:testsylo/page/sylo/view_sylo_page/sylo_album_page/sylo_album_page.dart';
import 'package:testsylo/util/navigate_effect.dart';
import 'package:testsylo/util/util.dart';
import '../../../../app.dart';

class ReviewPhotoPostPage extends StatefulWidget {
  List<PostPhotoModel> pickedImages = List();
  String from = "";
  MyDraft myDraft;

  ReviewPhotoPostPage({this.pickedImages, this.from = "", this.myDraft});

  @override
  ReviewPhotoPostPageState createState() => ReviewPhotoPostPageState();
}

  class ReviewPhotoPostPageState extends State<ReviewPhotoPostPage> {
    ReviewPhotoPostPageViewModel model;
    var formKey = GlobalKey<FormState>();
    TextEditingController titleController;
    TextEditingController tagController;
    bool _selectionMode = false;

    get imagesListView =>
        Container(
          height: 172,
          child: model.photoList.length != 0 ? ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemCount: model.photoList.length,
            shrinkWrap: true,
            itemBuilder: (c, i) {
              PostPhotoModel postPhotoModel = model.photoList[i];
              return Stack(
                children: <Widget>[
                  postPhotoModel.isCircle ? ClipOval(
                    child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(5),
                        child: ClipOval(
                          child: Container(
                            color: colorOvalBorder,
                            padding: EdgeInsets.all(2),
                            child:
                            ClipOval(
                              child: Container(
                                child: ImageFromPhotoPostModel(
                                    postPhotoModel, boxFit: BoxFit.fill),
                                width: 130,
                                height: 130,
                              ),
                            ),
                          ),
                        )
                    ),
                  ) : Container(
                    padding: EdgeInsets.all(12),
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: colorOvalBorder,
                      ),
                      child: Container(
                        /*decoration: BoxDecoration(
                            image: postPhotoModel.image != null
                                ? DecorationImage(
                                image: FileImage(postPhotoModel.image),
                                fit: BoxFit.cover
                            )
                                :
                            DecorationImage(
                                image: FileImage(postPhotoModel.image),
                                fit: BoxFit.cover
                            )
                        ),*/
                        child: ImageFromPhotoPostModel(postPhotoModel, boxFit: BoxFit.fill),
                        width: 130,
                        height: 172,
                      ),
                    ),
                  ),
                  Positioned(
                    right: postPhotoModel.isCircle ? 14 : 28,
                    top: postPhotoModel.isCircle ? 18 : 15,
                    child: InkWell(
                        child: ClipOval(
                          child: Container(
                              height: 25,
                              width: 25,
                              color: colorOvalBorder,
                              padding: EdgeInsets.all(2),
                              child: Icon(
                                Icons.close,
                                color: Color(0xff242424),
                                size: 20,
                              )),
                        ),
                        onTap: () async {
                          int itemIndex = i;
                          var res = await showDialog(
                            context: context,
                            builder: (BuildContext c) {
                              // return object of type Dialog
                              return AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
                                title: new Text(
                                  "Delete?",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                content: Container(
                                  child: Image.file(
                                    model.photoList[itemIndex].image,
                                    fit: BoxFit.contain,
                                  ),
                                  height: 50,
                                ),
                                actions: <Widget>[
                                  // usually buttons at the bottom of the dialog
                                  new FlatButton(
                                    child: new Text(
                                      "No",
                                      style:
                                      TextStyle(fontWeight: FontWeight.w700),
                                    ),
                                    onPressed: () {
                                      Navigator.of(c).pop();
                                    },
                                  ),
                                  new FlatButton(
                                    child: new Text(
                                      "Yes",
                                      style:
                                      TextStyle(fontWeight: FontWeight.w700),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(c, true);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                          if (res != null && res) {
                            setState(() {
                              model.photoList.removeAt(itemIndex);
                            });
                          }
                        }),
                  ),
                  Positioned(
                    left: postPhotoModel.isCircle ? 14 : 28,
                    top: postPhotoModel.isCircle ? 18 : 15,
                    child: InkWell(
                        child: ClipOval(
                          child: Container(
                              height: 25,
                              width: 25,
                              color: colorOvalBorder,
                              padding: EdgeInsets.all(2),
                              child: Icon(
                                Icons.save,
                                color: Color(0xff242424),
                                size: 20,
                              )),
                        ),
                        onTap: () async {
                          int itemIndex = i;
                          GallerySaver.saveImage(
                              model.photoList[itemIndex].image.path).then((
                              bool success) {
                            if (success) {

                              Fluttertoast.showToast(
                                  msg: "Image saved successfully",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Color(0xff9F00C5),
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                            } else {

                              Fluttertoast.showToast(
                                  msg: "Error occurred saving image",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Color(0xff9F00C5),
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                            }
                          });
                        }),
                  )
                ],
              );
            },
          ) : Center(child: Text("Please, Select the images."),
          ),
        );

    get addMoreView =>
        Container(
          margin: EdgeInsets.only(bottom: 16),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              (model.photoList.length < 4 && widget.from != "MyDraftsPageState")
                  ? Container(
                height: 25,
                margin: EdgeInsets.only(right: 8),
                child: FlatButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop(model.photoList);
                    },
                    icon: Icon(
                      Icons.add,
                      size: 18,
                    ),
                    label: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text("Add More",
                          style: getTextStyle(
                              size: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.w600)),
                    ),
                    color: colorOvalBorder,
                    disabledColor: colorOvalBorder,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    )),
              )
                  : SizedBox(),
              model.photoList.length > 0 ? Container(
                height: 25,
                child: FlatButton.icon(
                    onPressed: () async {
                      var result = await Navigator.push(
                          context,
                          NavigatePageRoute(
                              context,
                              RecordVoiceTagPage(
                                  listImages: model.photoList)));
                    },
                    icon: Icon(
                      Icons.keyboard_voice,
                      size: 18,
                    ),
                    label: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text("Annotate",
                          style: getTextStyle(
                              size: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.w600)),
                    ),
                    color: colorOvalBorder,
                    disabledColor: colorOvalBorder,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    )),
              ) : SizedBox(),
            ],
          ),
        );


    @override
    void initState() {
      super.initState();
      model = ReviewPhotoPostPageViewModel(this);
      titleController = TextEditingController();
      tagController = TextEditingController();
      if (widget.from == "MyDraftsPageState") {
        titleController.text = widget.myDraft.title ?? "";
        model.tagList = getTagFromString(widget.myDraft.tag);
      }
    }

    get albumsView =>
        Container(
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
                                  var result = await Navigator.push(
                                context,
                                NavigatePageRoute(

                                    context, SyloAlbumPage(userSylo: appState.userSylo,)));
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
//                                    for (int i = -1;
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
                                              ? model.albumsItemList[i]
                                              .mediaCount
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

    get syloView =>
        model.userSylosList != null ? Container(
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
                                            post_type: "Photo",
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
        ) : SizedBox();

    get saveButton =>
        Container(
          padding: EdgeInsets.only(left: 16, right: 8),
          child: commonButton(
                () async {
              if (formKey.currentState.validate()) {
                hideFocusKeyBoard(context);
                if (model.photoList.length == 0 ||
                    model.photoList.length > 4) {
                  commonAlert(context,
                      "Please Select Images at least one or maximum 4.");
                  return;
                }
                if (isQuickPost) {
                  List<GetUserSylos> list = getListOfSelectedSylo(
                      model.userSylosList);
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
                  List<int> result = await goToChooseSyloPage(
                      context, "Photo", selectedSyloList: selectedSyloList);
                  print("-------123"+result.join(","));
                  if (result != null) {
                    String title = titleController.text.trim();
                    List<String> listUploadedImages = await model.uploadMediaPhotoPost("Photo");
                    await model.createMediaSubAlbumPhotoNew(
                        title, listUploadedImages.join(", "),result.join(", "));
                  }
                } else {
                  print("--------"+widget.from.toString());
                  if(widget.from=="QcamPageState")
                    {
                      List<GetUserSylos> list = getListOfSelectedSylo(
                          model.userSylosList);
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
                      List<int> result = await goToChooseSyloPage(
                          context, "Photo", selectedSyloList: selectedSyloList);
                      print("------->>123"+result.join(","));
                      if (result != null) {
                        String title = titleController.text.trim();
                        List<String> listUploadedImages = await model.uploadMediaPhotoPost("Photo");
                        await model.createMediaSubAlbumPhotoNew(
                            title, listUploadedImages.join(", "),result.join(", "));
                      }
                    }else {
                    if (!model.albumSelected()) {
                      commonAlert(context, "Please Select Albums.");
                      return;
                    }
                  }


                  String title = titleController.text.trim();
                  List<String> listUploadedImages = await model.uploadMediaPhotoPost("Photo");
                  await model.createMediaSubAlbumPhotoNew(title, listUploadedImages.join(" ,"),model.albumsItemListSelected.join(","));
                  /*await Navigator.push(
                      context,
                      NavigatePageRoute(
                          context,
                          SuccessMessagePage(
                            headerName: "Photo Post",
                            message: "Your Photo is being uploaded.",
                          )));*/
                }
              }


              /*var result = await Navigator.push(
                  context,
                  NavigatePageRoute(
                      context,
                      SuccessMessagePage(
                        headerName: "Photo Post",
                        message: "Your Photos have been saved to Harper's Sylo",
                      )));*/
            },
            isQuickPost ? "Continue" : "Save",
          ),
        );

    get formView =>
        Container(
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
                        titleController, TextInputType.text,
                        "Enter Photo Title",
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
                ],
              )),
        );

    @override
    Widget build(BuildContext context) {
      print("runtimeType -> " + runtimeType.toString());
      print("runtimeType1 -> " + widget.from.toString());
      model ?? (model = ReviewPhotoPostPageViewModel(this));
      return WillPopScope(
        onWillPop: () async {
          hideFocusKeyBoard(context);
          if (widget.from != "MyDraftsPageState") {
            await commonCupertinoDialogPage(
                context,
                commonDraftWarningCenterWidget(),
                positiveAction: () async {
                  /*String title = titleController.text.trim();
            List<String> listUploadedImages =
                await model.uploadMediaPhotoPost("Photo");
            model.createMediaSubAlbumPhoto(title, listUploadedImages, draft: true);*/
                  model.saveAsDraft();
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
              "Photo Post" + getSyloPostTitlesufix(appState.userSylo),
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 17),
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
                        /*String title = titleController.text.trim();
                List<String> listUploadedImages =
                    await model.uploadMediaPhotoPost("Photo");
                model.createMediaSubAlbumPhoto(title, listUploadedImages, draft: true);*/
                        model.saveAsDraft();
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
                  imagesListView,
                  Column(
                    children: <Widget>[
                      addMoreView,
                      formView,
                      isQuickPost ? syloView : widget.from=="QcamPageState"?syloView:albumsView,
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

    getCurrentSyloId() {
      if (appState.userSylo != null) {
        return appState.userSylo.syloId != ""
            ? appState.userSylo.syloId.toString()
            : null;
      }
      return null;
    }
  }