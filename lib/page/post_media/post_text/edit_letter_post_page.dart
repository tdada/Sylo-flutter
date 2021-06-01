import 'package:flutter/material.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/model/draft_model.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/page/common/create_album_page.dart';
import 'package:testsylo/page/post_media/post_text/edit_letter_post_page_view_model.dart';
import 'package:testsylo/page/sylo/choose_sylo_view_all_page/choose_sylo_view_all_page.dart';
import 'package:testsylo/page/sylo/open_message_page/edit_open_message_page/success_message_page/success_message_page.dart';
import 'package:testsylo/util/navigate_effect.dart';
import 'package:testsylo/util/util.dart';

import '../../../app.dart';

class EditLetterPostPage extends StatefulWidget {
  String from = "";
  MyDraft myDraft;

  EditLetterPostPage({this.from, this.myDraft});
  @override
  EditLetterPostPageState createState() => EditLetterPostPageState();
}

class EditLetterPostPageState extends State<EditLetterPostPage> {
  EditLetterPostPageViewModel model;
  var formKey = GlobalKey<FormState>();
  var messageFormKey = GlobalKey<FormState>();
  TextEditingController titleController = new TextEditingController();
  TextEditingController tagController = new TextEditingController();
  TextEditingController messageController = new TextEditingController();
  TextEditingController messageFormController = new TextEditingController();
  bool _selectionMode = false;
  bool letterPostViewflag = false;

  @override
  void initState() {
    super.initState();
    model = EditLetterPostPageViewModel(this);

    if (widget.from == "MyDraftsPageState") {
      String message = widget.myDraft.description;
      String onlyMessage = widget.myDraft.onlyMessage;
      print("message: $message onlyMessage: $onlyMessage");

      if (onlyMessage == "true") {
        letterPostViewflag = true;
        messageController.text = message;
        titleController.text = widget.myDraft.title;
        model.tagList = getTagFromString(widget.myDraft.tag);
      } else {
        messageFormController.text = message;
      }

//      if(widget.myDraft.title==null && widget.myDraft.tag.isEmpty){
//        messageFormController.text = widget.message;
//      }else{
//        letterPostViewflag = true;
//        messageController.text = widget.message;
//        titleController.text = widget.myDraft.title;
//        model.tagList = getTagFromString(widget.myDraft.tag);
//      }
    }
  }

  get dateView => Container(
        margin: EdgeInsets.only(top: 16, bottom: 16),
        child: Center(
            child: Text(
          App.getDateByFormat(DateTime.now(), App.formatDdMMMYY),
          style: getTextStyle(
            color: colorDark,
            size: 13,
          ),
        )),
      );

  get albumsView => Container(
        height: 195,
        padding: EdgeInsets.only(
          top: 24,
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
                                                cWidth: 74),
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

  get syloView => Container(
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
                                          post_type: "Notes",
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
      );

  get saveButton => Container(
        height: 50,
        child: commonButton(
          () async {
            if (!letterPostViewflag) {
              setState(() {
                letterPostViewflag = true;
                messageController.text = messageFormController.text;
              });
            } else if (isQuickPost) {
              if (formKey.currentState.validate()) {
                hideFocusKeyBoard(context);
                List<GetUserSylos> list =
                    getListOfSelectedSylo(model.userSylosList);
                if (list == null || list.length == 0) {
                  commonAlert(context, "Please Select Sylos.");
                  return;
                }
                String title = titleController.text.trim();
                String textMessage = messageController.text.trim();
                List<GetUserSylos> selectedSyloList = List();
                model.userSylosList.forEach((element) {
                  if (element.isCheck) {
                    selectedSyloList.add(element);
                  }
                });
                List<int> result = await goToChooseSyloPage(context, "Notes",
                    selectedSyloList: selectedSyloList);
                if (result != null) {
                  model.createMediaSubAlbumText(
                      title, textMessage, result.join(","));
                }
              }
            } else {
              if (formKey.currentState.validate()) {
                hideFocusKeyBoard(context);
                if (!model.albumSelected()) {
                  commonAlert(context, "Please Select Albums.");
                  return;
                }
                String title = titleController.text.trim();
                String textMessage = messageController.text.trim();
                model.createMediaSubAlbumText(title, textMessage,
                    model.albumsItemListSelected.join(", "));
              }
            }
          },
          letterPostViewflag
              ? isQuickPost
                  ? "Continue"
                  : "Save"
              : "Continue",
        ),
      );

  get formView => Container(
        padding: EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 20),
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
                      titleController, TextInputType.text, "Enter Note Title",
                      autoFocus: true),
                ),
                Container(
                  padding: EdgeInsets.only(top: 16, bottom: 8),
                  alignment: Alignment.centerLeft,
                  child: commontextFieldLabel("Add Tags", size: 14),
                ),
                commonTagField(context, tagController, tagList: model.tagListNew,
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
                }, onRemoveCallback: (index) {
                  setState(() {
                    model.tagListNew.removeAt(index);
                  });
                }),
                Container(
                  padding: EdgeInsets.only(top: 16, bottom: 8),
                  alignment: Alignment.centerLeft,
                  child: commontextFieldLabel("Write Note", size: 14),
                ),
                Container(
                  child: TextField(
                    controller: messageController,
                    maxLines: 20,
                    minLines: 4,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      helperMaxLines: 100,
                      hintText: "Write your note.",
                      hintStyle:
                          TextStyle(fontSize: 15.0, color: Color(0x00ffC3C3C3)),
                    ),
                  ),
                )
              ],
            )),
      );

//  get messageSaveButton => Container(
//    child: commonButton(() {
////      goToChooseSyloPage(context, widget.post_type);
//      _letterPostView = true;
//    }, "Continue"),
//  );

  Iterable<T> distinct<T>(Iterable<T> elements) sync* {
    final visited = <T>{};
    for (final el in elements) {
      if (visited.contains(el)) continue;
      yield el;
      visited.add(el);
    }
  }

  get messageFormView => Container(
        padding: EdgeInsets.only(top: 8, left: 16, right: 16),
        child: Form(
            key: messageFormKey,
            child: TextField(
              controller: messageFormController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration.collapsed(
                hintText: "Write your note.",
                hintStyle:
                    TextStyle(fontSize: 15.0, color: Color(0x00ffC3C3C3)),
              ),
            )),
      );

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = EditLetterPostPageViewModel(this));

    return WillPopScope(
      onWillPop: () async {
        if (letterPostViewflag) {
          hideFocusKeyBoard(context);
          if (widget.from != "MyDraftsPageState") {
            await commonCupertinoDialogPage(
                context, commonDraftWarningCenterWidget(),
                positiveAction: () async {
              model.saveAsADraft(messageController.text, "true");
              Navigator.pop(context);
            }, negativeAction: () {
              setState(() {
                // call draft dialogue here
                letterPostViewflag = false;
                Navigator.pop(context);
              });
            });
          } else {
            Navigator.pop(context);
          }
        } else {
          hideFocusKeyBoard(context);
          if (widget.from != "MyDraftsPageState") {
            await commonCupertinoDialogPage(
                context, commonDraftWarningCenterWidget(),
                positiveAction: () async {
              model.saveAsADraft(messageFormController.text, "false");
              Navigator.pop(context);
            }, negativeAction: () {
              setState(() {
                Navigator.pop(context);
                Navigator.pop(context);
              });
            });
          } else {
            Navigator.pop(context);
            Navigator.pop(context);
          }
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: getColorBg(),
        appBar: AppBar(
          title: Text(
            (!letterPostViewflag ? "Write a Note" : "Write a Note") +
                getSyloPostTitlesufix(appState.userSylo),
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
              if (letterPostViewflag) {
                hideFocusKeyBoard(context);
                if (widget.from != "MyDraftsPageState") {
                  await commonCupertinoDialogPage(
                      context, commonDraftWarningCenterWidget(),
                      positiveAction: () async {
                    model.saveAsADraft(messageController.text, "true");
                    Navigator.pop(context);
                  }, negativeAction: () {
                    setState(() {
                      letterPostViewflag = false;
                      Navigator.pop(context);
                    });
                  });
                } else {
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              } else {
                hideFocusKeyBoard(context);
                if (widget.from != "MyDraftsPageState") {
                  await commonCupertinoDialogPage(
                      context, commonDraftWarningCenterWidget(),
                      positiveAction: () async {
                    model.saveAsADraft(messageFormController.text, "false");
                    Navigator.pop(context);
                  }, negativeAction: () {
                    setState(() {
                      // call draft dialogue here
                      Navigator.pop(context);
                      Navigator.pop(context);
                    });
                  });
                } else {
                  Navigator.pop(context);
                }
              }
            },
          ),
          backgroundColor: Colors.white,
        ),
        floatingActionButton: letterPostViewflag
            ? Container(height: 0)
            : Container(
                color: Colors.transparent,
                height: 60,
                alignment: Alignment.center,
                child: saveButton,
                padding: EdgeInsets.only(left: 32),
              ),
        body: SafeArea(
          child: Container(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                letterPostViewflag
                    ? Column(
                        children: <Widget>[
                          dateView,
                          formView,
                          isQuickPost ? syloView : albumsView,
                          Container(
                            child: saveButton,
                            padding:
                                EdgeInsets.only(left: 16, right: 16, top: 20),
                          )
                        ],
                      )
                    : Column(
                        children: <Widget>[
                          messageFormView,
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
