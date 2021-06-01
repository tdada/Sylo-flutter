import 'dart:io';

import 'package:flutter/material.dart';
import 'package:testsylo/common/audio_play_widget.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/model/draft_model.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/page/common/create_album_page.dart';
import 'package:testsylo/page/post_media/post_sound_bite/edit_sound_bite_post_page/edit_sound_bite_post_page_view_model.dart';
import 'package:testsylo/page/sylo/choose_sylo_view_all_page/choose_sylo_view_all_page.dart';
import 'package:testsylo/page/sylo/open_message_page/edit_open_message_page/success_message_page/success_message_page.dart';
import 'package:testsylo/util/navigate_effect.dart';
import 'package:testsylo/util/util.dart';

import '../../../../app.dart';

class EditSoundBitePostPage extends StatefulWidget {
  File path;
  String audioLink;
  String from = "";
  MyDraft myDraft;

  EditSoundBitePostPage({this.path, this.audioLink,this.from,this.myDraft});

  @override
  EditSoundBitePostPageState createState() => EditSoundBitePostPageState();
}

class EditSoundBitePostPageState extends State<EditSoundBitePostPage> {
  EditSoundBitePostPageViewModel model;
  var formKey = GlobalKey<FormState>();
  TextEditingController titleController = new TextEditingController();
  TextEditingController tagController = new TextEditingController();
  bool _selectionMode = false;

  @override
  void initState() {
    super.initState();
    print("from -> "+widget.from);
    model = EditSoundBitePostPageViewModel(this);
    if(widget.from == "MyDraftsPageState"){
      print("title: ${widget.myDraft.title} tag: ${widget.myDraft.tag}");
      titleController.text = widget.myDraft.title;
      model.tagList = getTagFromString(widget.myDraft.tag);
    }
    if(widget.from=="edit"){
      print("title: ${widget.myDraft.title} tag: ${widget.myDraft.tag}");
      titleController.text = widget.myDraft.title;
      model.tagList = getTagFromString(widget.myDraft.tag);
    }
  }

  get audioTopView => Center(
//    padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
    child: Stack(
      children: <Widget>[

        ClipOval(
          child: Container(
            height: 168,
            width: 168,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                ClipOval(
                    child: Container(
                      color: Colors.white,
                      height: 168,
                      width: 168,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            App.ic_mic_coloroval,
                            fit: BoxFit.contain,
                            width: 110,
                            height: 110,
                          ),
                        ],
                      ),
                    )),
                getAudioPlayer(),

              ],
            ),
            padding: EdgeInsets.all(3),
            color: colorOvalBorder,
          ),
        ),
        Positioned(
          right: 16,
          top: 2,
            child:ClipOval(
                child: Container(
                  color: colorOvalBorder,
                  padding: EdgeInsets.all(6),
                  child: Icon(
                    Icons.close,
                    color: colorDark,
                    size: 20,
                  ),
                )
            )
        ),
      ],
    ),
  );

  get editSoundBiteButtons => Container(
    margin: EdgeInsets.only(top: 8,bottom: 8),
    height: 25,
    child: FlatButton.icon(
        onPressed: () {
          MyDraft m = MyDraft();
          m.title = titleController.text;
          m.tag = getTagString(model.tagList);
          Navigator.pop(context,m);
        },
        icon: Icon(
          Icons.mode_edit,
          size: 16,
          color: Colors.white,
        ),
        label: Container(
          padding: EdgeInsets.only(top: 2),
          child: Text(
            "Edit Soundbite",
            style: getTextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, size: 13),
          ),
        ),
        color: colorDark,
        disabledColor: colorDark,
        padding: EdgeInsets.only(left: 4, right: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
        )),
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
                                            builder:
                                                (BuildContext context) =>
                                                CreateAlbumPage(syloId:
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

                                setState(() {

                                });
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
                                          child: getAlbumThumbIcon(
                                              model.albumsItemList[i]
                                                  .mediaType,
                                              model.albumsItemList[i]
                                                  .coverPhoto,
                                              cHeight: 74,
                                              cWidth: 74,
                                          ),
                                        ),
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
                                    context, ChooseSyloViewAllPage(post_type: "Soundbite", userSylosList: model.userSylosList,)));
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
//                                if (!_selectionMode) {
//                                  _selectionMode = true;
//                                }
//                                for(int i = 0 ; i < model.albumsItemList.length ; i++){
//
//                                  model.albumsItemList[i].isCheck = false;
//
//                                }
                                model.changeSelectSyloItem(i);

                                setState(() {

                                });
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
    padding: EdgeInsets.only(left: 16, right: 8,bottom: 16),
    child: commonButton(
          () async {
//            if(isQuickPost){
//              goToChooseSyloPage(context, "Soundbite");
//            }else {
              if (formKey.currentState.validate()) {
                hideFocusKeyBoard(context);
//                if (widget.pickedImages.length == 0 ||
//                    widget.pickedImages.length > 5) {
//                  commonAlert(context,
//                      "Please Select Images at least one or maximum 5.");
//                  return;
//                }
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
                  List<int> result = await goToChooseSyloPage(context, "Soundbite", selectedSyloList:selectedSyloList);
                  if (result!=null){
                    String title = titleController.text.trim();
                    if(widget.from == "MyDraftsPageState"){
                      model.deleteDraftItem(widget.myDraft.id);
                    }
                    List<String> listUploadedAudio =
                    await model.uploadMediaAudioPost("Audio");
                    if(listUploadedAudio.length>0) {
                      model.createMediaSubAlbumAudio(
                          title, listUploadedAudio.join(", "),result.join(", "));
                    }
                  }
                } else {
                  if (!model.albumSelected()) {
                    commonAlert(context, "Please Select Albums.");
                    return;
                  }
                  if(widget.from == "MyDraftsPageState"){
                    model.deleteDraftItem(widget.myDraft.id);
                  }
                  String title = titleController.text.trim();
                  List<String> listUploadedAudio =
                  await model.uploadMediaAudioPost("Audio");
                  if(listUploadedAudio.length>0) {
                    model.createMediaSubAlbumAudio(title, listUploadedAudio.join(","),model.albumsItemListSelected.join(","));
                  }
                }

              }
              /*var result = await Navigator.push(context,
                  NavigatePageRoute(context, SuccessMessagePage(
                    headerName: "Record Soundbite",
                    message: "Your Soundbite has been saved to Harper's Sylo",
                  )));*/
//            }
      },
      isQuickPost ?"Continue":"Save",
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
              child: commontextFieldLabel("Add title", size: 14),
            ),
            Container(
              child: commonTextField(titleController, TextInputType.text,
                  "Enter Soundbite title", autoFocus: true),
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
    model ?? (model = EditSoundBitePostPageViewModel(this));

    return WillPopScope(
      onWillPop: () async {
        hideFocusKeyBoard(context);
        if(widget.from != "MyDraftsPageState") {
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
            "Record Soundbite" + getSyloPostTitlesufix(appState.userSylo),
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
              if(widget.from != "MyDraftsPageState") {

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
                Column(
                  children: <Widget>[
                    audioTopView,
                    editSoundBiteButtons,
                    formView,
                  isQuickPost ? syloView :albumsView,
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

  getAudioPlayer() {
    if (widget.path != null) {
      return AudioPlayWidget(
        url: widget.path.path,
        icon_size: 32.0,
        isLocal: true,
      );
    }
    if(widget.audioLink != null) {
      return AudioPlayWidget(
        url: widget.audioLink,
        icon_size: 32.0,
        isLocal: false,
      );
    }
    return Container();
  }

}
