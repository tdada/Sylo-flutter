import 'dart:io';
import 'dart:typed_data';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:circle_list/circle_list.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/common/play_video.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/model/record_file_item.dart';
import 'package:testsylo/page/common/add_prompt_page.dart';
import 'package:testsylo/page/common/edit_prompt_page.dart';
import 'package:testsylo/page/qcast/qcat_tab/my_channel_page/my_channel_page.dart';
import 'package:testsylo/page/qcast/qcat_tab/my_channel_page/review_qcast_page/review_qcast_page_view_model.dart';
import 'package:testsylo/page/sylo/choose_sylo_view_all_page/choose_sylo_view_all_page.dart';
import 'package:testsylo/util/navigate_effect.dart';
import '../../../../../app.dart';

class ReviewQcastPage extends StatefulWidget {
  List<RecordFileItem> listRecordWithThumb = List();

  ReviewQcastPage(this.listRecordWithThumb);

  @override
  ReviewQcastPageState createState() => ReviewQcastPageState();
}

class ReviewQcastPageState extends State<ReviewQcastPage> {
  ReviewQcastPageViewModel model;
  bool thumbnailDefault = false;
  var formKey = GlobalKey<FormState>();
  TextEditingController nameController = new TextEditingController();
  TextEditingController descController = new TextEditingController();
  ThemeModel themeModel;

  get borderCircle =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(1),
          color: colorOvalBorder2,
          child: ClipOval(
            child: Container(
              color: Colors.white,
//          height: MediaQuery.of(context).size.width - 80,
//          width: MediaQuery.of(context).size.width - 80,
            ),
          ),
        ),
      );

  Widget get circularList {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned.fill(
                  child: Container(
                    margin: EdgeInsets.all(40),
                    child: borderCircle,
                  )),
              CircleList(
                initialAngle: 160.2,
                origin: Offset(0, 0),
                outerRadius: 185,
                children:
                List.generate(widget.listRecordWithThumb.length, (index) {
                  RecordFileItem item = widget.listRecordWithThumb[index];
                  return InkWell(
                      onTap: () {
                        setState(() {
                          model.editIndex = -1;
                        });
                        Future.delayed(const Duration(milliseconds: 400), () {
                          setState(() {
                            model.editIndex = index;
                          });
                        });
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            color: index == model.editIndex
                                ? colorOvalBorder2
                                : colorOvalBorder,
                            shape: BoxShape.circle),
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
                                padding: EdgeInsets.only(top: 3),
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
                        padding: EdgeInsets.all(4),
                      ));
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
                              child: model.editIndex == -1
                                  ? Container(
                                child: CircularProgressIndicator(),
                                width: 24,
                                height: 24,
                                alignment: Alignment.center,
                              )
                                  : PlayVideoPage(
                                url: widget
                                    .listRecordWithThumb[model.editIndex]
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
        ],
      ),
    );
  }

  get thumbCircularList =>
      Container(
        height: 200,
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            CircleList(
              children:
              List.generate(widget.listRecordWithThumb.length, (index) {
                RecordFileItem item = widget.listRecordWithThumb[index];
                return InkWell(
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ClipOval(
                        child: Container(
                          child: ClipOval(
                            child: Image.file(
                              item.thumbPath,
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                            ),
                          ),
                          padding: EdgeInsets.all(3),
                          color: colorOvalBorder,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              /*  centerWidget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ClipOval(
                    child: Container(
                      width: 100,
                      height: 100,
                      child: InkWell(
                        child: ClipOval(
                          child: PlayVideoPage(
                            url: widget
                                .listRecordWithThumb[model.editIndex].file.path,
                            isFile: true,
                          ),
                        ),
                        onLongPress: () {},
                      ),
                      padding: EdgeInsets.all(3),
                      color: colorOvalBorder,
                    ),
                  ),
                ],
              ),*/
            ),
          ],
        ),
      );

  get titleField =>
      Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 16, left: 8),
            alignment: Alignment.centerLeft,
            child: commontextFieldLabel("Add title", size: 14),
          ),
          Container(
            padding: EdgeInsets.only(left: 8),
            child: commonTextField(
                nameController, TextInputType.text, "Enter Title",
                maxLength: 28),
          ),
        ],
      );

  get dropdownField =>
      Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 16, left: 8),
            alignment: Alignment.centerLeft,
            child: commontextFieldLabel("Category", size: 14),
          ),
          Container(
            padding: EdgeInsets.only(left: 8),
            alignment: Alignment.centerLeft,
            child: relationShipDropDownSelection,
          ),
          Container(
            padding: EdgeInsets.only(left: 8),
            color: Color(0x00ffC3C3C3),
            height: 1,
            margin: EdgeInsets.only(top: 5),
          ),
        ],
      );

  Widget get relationShipDropDownSelection {
    var items = themeModelList.map((item) {
      return new DropdownMenuItem<ThemeModel>(
        value: item,
        child: new Text(
          item.title,
          style: new TextStyle(color: Colors.black),
        ),
      );
    }).toList();
    return Container(
      padding: EdgeInsets.only(top: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ThemeModel>(
            value: themeModel,
            isDense: true,
            isExpanded: true,
            icon: Icon(
              Icons.keyboard_arrow_down,
              size: 32,
              color: colorDark,
            ),
            hint: Text(
              "Select",
              style: TextStyle(color: Colors.black),
            ),
            onChanged: (ThemeModel i) {
              FocusScope.of(context).requestFocus(FocusNode());
              setState(() {
                themeModel = i;
              });
            },
            items: items),
      ),
    );
  }

  get exampleQuestionField =>
      Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 16, left: 8),
            alignment: Alignment.centerLeft,
            child:
            commontextFieldLabel("Write three example Questions", size: 14),
          ),
          listPromptView,
          addFormButton,
          Container(
            padding: EdgeInsets.only(top: 16, left: 8),
            alignment: Alignment.centerLeft,
            child: commontextFieldLabel("Description"),
          ),
          Container(
            padding: EdgeInsets.only(left: 8),
            child: commonTextField(
                descController,
                TextInputType.multiline,
                "Enter Your Description",
                maxLines: 5,
                maxLength: 175),
          ),
        ],
      );

  get addFormButton =>
      Center(
        child: Container(
//    padding: EdgeInsets.only(top: 16, left: 16, right: 16),
          height: 25,
          width: 144,
          child: RaisedButton(
            onPressed: () async {
              if (model.reviewQuestionsList.length <= 2) {
                var result = await showDialog(
                  context: context,
                  builder: (BuildContext context) => AddPromptPage(),
                );
                if (result != null) {
                  model.reviewQuestionsList.add(result);
                  setState(() {});
                }
              } else {
                commonToast("You can not add more than 3 questions");
              }
            },
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            padding: EdgeInsets.all(0.0),
            child: Ink(
              decoration: BoxDecoration(
                  color: colorDark,
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: colorDark, width: 1.1)),
              child: Container(
                constraints: BoxConstraints(minHeight: 50.0),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    Text(
                      "Add your Question",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 12),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  get listPromptView =>
      Container(
          padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              itemCount: model.reviewQuestionsList.length,
              shrinkWrap: true,
              itemBuilder: (c, i) {
                String item = model.reviewQuestionsList[i];
                return Container(
                    padding: EdgeInsets.only(left: 8, top: 8),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Text(
                        "${i + 1}.",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: 16),
                      ),
                      title: GestureDetector(
                          child: Text(
                            item,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontSize: 14),
                          ),
                          onTap: () async {
                            var result = await showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  EditPromptPage(text: item),
                            );
                            if (result != null) {
                              model.reviewQuestionsList[i] = result;
                              setState(() {});
                            }
                          }

                      ),
                      trailing: GestureDetector(
                          onTap: () {
                            model.removePrompt(i);
                          },
                          child: Icon(
                            Icons.remove_circle,
                            color: Colors.red,
                          )),
                    ));
              }));

  get editAddButtons =>
      Padding(
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              height: 25,
              child: FlatButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.mode_edit,
                    size: 14,
                  ),
                  label: Text(
                    "Edit Video",
                    style: getTextStyle(
                        size: 13,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                  color: colorOvalBorder,
                  disabledColor: colorOvalBorder,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  )),
            ),
            /*Container(
              height: 25,
              child: FlatButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.add,
                    size: 14,
                  ),
                  label: Text("Add More",
                      style: getTextStyle(
                          size: 13,
                          color: Colors.black,
                          fontWeight: FontWeight.w600)),
                  color: colorOvalBorder,
                  disabledColor: colorOvalBorder,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  )),
            )*/
          ],
        ),
      );

  get savePublishButton =>
      Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 54,
              width: 150,
              child: RaisedButton(
                onPressed: () async {
                  await model.validatereviewForm("Save");
                  },
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: colorSectionHead)),
                padding: EdgeInsets.all(0.0),
                child: Ink(
                  child: Container(
                    constraints:
                    BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                    alignment: Alignment.center,
                    child: Text(
                      "Save",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: colorSectionHead,
                          fontWeight: FontWeight.w800,
                          fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
            Container(
                height: 54,
                width: 150,
                child: commonButton(() async {
                  model.validatereviewForm("Publish");
                }, "Publish"))
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = ReviewQcastPageViewModel(this));
    return Scaffold(
      backgroundColor: getColorBg(),
      appBar: AppBar(
        title: Text(
          "Review Video",
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
      body: SafeArea(
        child: CupertinoScrollbar(
            child: Container(
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  circularList,
                  Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 12,
                          ),
                          editAddButtons,
                          imageButtonWidget(
                                  () =>
                                  commonAlert(context, () {
                                    /* setState(() {
                                  model.thumbnailImage.path = null;
                                  thumbnailDefault = false;
                                });*/
                                    //print("aaaa");
                                    showThumbnailListByStatus(
                                      context,
                                      "random",
                                      widget.listRecordWithThumb,
                                      updateThumbByte,
                                      null,
                                      model.editIndex,
                                    );
                                  }, () async {
                                    try {
                                      FilePickerResult result = await FilePicker
                                          .platform
                                          .pickFiles(type: FileType.image);
                                      if (result != null &&
                                          result.files.single.path != null &&
                                          result.files.single.path.isNotEmpty) {
                                        File _image =
                                        await FlutterExifRotation.rotateImage(
                                            path: result.files.single.path);
                                        _image = _image
                                            .renameSync(
                                            result.files.single.path);
                                        setState(() {
                                          model.thumbnailImage.path = _image;
                                          model.thumbnailByte = null;
                                          thumbnailDefault = false;
                                        });
                                      }
                                    } catch (e) {}
                                  }, () {
                                    showThumbnailListByStatus(
                                        context,
                                        "random",
                                        widget.listRecordWithThumb,
                                        updateThumbByte,
                                        null,
                                        null);
                                    /* setState(() {
                                  thumbnailDefault = true;
                                });*/
                                  }),
                              "Generate Thumbnail",
                              thumbnailDefault,
                              "ThumbnailPreview",
                              model.thumbnailImage.path),
                          titleField,
                          dropdownField,
                          SizedBox(
                            height: 16,
                          ),
                          imageButtonWidget(
                                  () =>
                                  showThumbnailListByStatus(
                                      context,
                                      "previewVideo",
                                      widget.listRecordWithThumb,
                                      null,
                                      getSelectedvideoIndex,
                                      null),
                              "Add Video Preview",
                              false,
                              "VideoPreview"),
                          exampleQuestionField,
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  syloView,
                  SizedBox(
                    height: 16,
                  ),
                  savePublishButton,
                  SizedBox(
                    height: 16,
                  ),
                ],
              ),
            )),
      ),
    );




  }

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
                                    context, ChooseSyloViewAllPage(post_type: "Annograph", userSylosList: model.userSylosList,)));
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



  Widget imageButtonWidget(VoidCallback onPressed, String buttontext,
      bool defaultImage, String status,
      [File imagePath, String image = ""]) {
    return Row(
      children: <Widget>[
        ClipOval(
          child: Container(
            child: ClipOval(
              child: Stack(
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    height: 75,
                    width: 75,
                  ),
                  getImagePreview(status, imagePath),
                ],
              ),
            ),
            padding: EdgeInsets.all(3),
            color: colorOvalBorder,
          ),
        ),
        SizedBox(
          width: 12,
        ),
        InkWell(
          onTap: onPressed,
          child: ClipRRect(
              child: Container(
                  width: 152,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: colorDark,
                      ),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Center(
                      child: Text(
                    buttontext,
                    style: TextStyle(
                        color: colorDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  )))),
        ),
      ],
    );
  }

  void commonAlert(BuildContext context, VoidCallback onPressSelectVideo,
      VoidCallback onPressUpload, VoidCallback onPressRandom) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Generate Thumbnail",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 20),
                Container(
                  height: 25,
                  child: FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                        onPressSelectVideo.call();
                      },
                      child: Text("Select from video"),
                      color: colorOvalBorder,
                      disabledColor: colorOvalBorder,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      )),
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  height: 25,
                  child: FlatButton(
                      onPressed: () {
                        onPressUpload.call();
                        Navigator.of(context).pop(true);
                      },
                      child: Text("Upload"),
                      color: colorOvalBorder,
                      disabledColor: colorOvalBorder,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      )),
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  height: 25,
                  child: FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                        onPressRandom.call();
                      },
                      child: Text("Random "),
                      color: colorOvalBorder,
                      disabledColor: colorOvalBorder,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      )),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  getImagePreview(String status, File imagePath) {
    if (status == "VideoPreview") {
      if (model.previewVideoIndex != null) {
        RecordFileItem item =
            widget.listRecordWithThumb[model.previewVideoIndex];
        return Container(
          color: Colors.white,
          height: 75,
          width: 75,
          child: Image.file(
            item.thumbPath,
            fit: BoxFit.cover,
            width: 54,
            height: 54,
          ),
        );
      }
      return Container(
        color: Colors.white,
        height: 75,
        width: 75,
      );
    } else {
      if (imagePath != null) {
        return Container(
            width: 75, height: 75, child: fileWidget(imagePath, 125.0, 125.0));
      } else if (model.thumbnailByte != null) {
        return Image(
          image: MemoryImage(model.thumbnailByte),
          fit: BoxFit.cover,
          width: 75,
          height: 75,
        );
      }
      return Container(
        color: Colors.white,
        height: 75,
        width: 75,
      );
    }
  }

  updateThumbByte(unit8List) async {
    model.thumbnailByte = unit8List;
    model.thumbnailImage.path = null;
    thumbnailDefault = false;
    setState(() {});
  }

  getSelectedvideoIndex(index) async {
    print("Selected index : - $index");
    model.previewVideoIndex = index;
    setState(() {});
  }
}
