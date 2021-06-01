import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/api_request.dart';
import 'package:testsylo/model/qcast_dashboard_item.dart';
import 'package:testsylo/model/qcast_item.dart';
import 'package:testsylo/util/util.dart';

import '../../../../app.dart';
import 'my_channel_page_view_model.dart';

class MyChannelPage extends StatefulWidget {
  String from = "";

  MyChannelPage({this.from});

  @override
  MyChannelPageState createState() => MyChannelPageState();
}

enum Fruit {
  apple,
  banana,
}

class MyChannelPageState extends State<MyChannelPage> {
  int _radioValue = 0;

  ValueNotifier<Fruit> _selectedItem = new ValueNotifier<Fruit>(Fruit.apple);

  MyChannelPageViewModel model;
  int value1 = 1;
  var formKey = GlobalKey<FormState>();
  TextEditingController nameController = new TextEditingController();
  TextEditingController mottoController = new TextEditingController();
  TextEditingController descController = new TextEditingController();

  get pickProfile => InkWell(
        onTap: () async {
          print('uuuuuuuuuu');
          if (!isSave) {
            try {
              FilePickerResult result =
                  await FilePicker.platform.pickFiles(type: FileType.image);
              if (result != null &&
                  result.files.single.path != null &&
                  result.files.single.path.isNotEmpty) {
                File _image = await FlutterExifRotation.rotateImage(
                    path: result.files.single.path);
                //_image = _image.renameSync(result.files.single.path);

                await ImageCropper.cropImage(
                    sourcePath: _image.path,
                    aspectRatioPresets: [
                      CropAspectRatioPreset.square,
                      CropAspectRatioPreset.ratio3x2,
                      CropAspectRatioPreset.original,
                      CropAspectRatioPreset.ratio4x3,
                      CropAspectRatioPreset.ratio16x9
                    ],
                    androidUiSettings: AndroidUiSettings(
                        toolbarTitle: 'Edit Image',
                        toolbarColor: Colors.deepOrange,
                        toolbarWidgetColor: Colors.white,
                        initAspectRatio: CropAspectRatioPreset.original,
                        lockAspectRatio: false),
                    iosUiSettings: IOSUiSettings(
                      title: "Edit Image",
                      minimumAspectRatio: 1.0,
                    )).then((value) {
                  setState(() {
                    model.profileImage.path = value;
                    model.coverPhoto = null;
                    model.updateFormStatus = true;
                  });
                });
              }
            } catch (e) {}
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            ClipOval(
              child: Container(
                padding: EdgeInsets.all(2),
                color: colorOvalBorder,
                child: ClipOval(
                  //borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: 125,
                        height: 125,
                        child: getProfilepic(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  get editPress => () {
        setState(() {
          isSave = !isSave;
          isEdit = true;

        });
      };
  get editPress1 => () {
    setState(() {
      isEdit = false;
      isSave = false;
      isCancel =true;
    });
  };

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = MyChannelPageViewModel(this));
    return Scaffold(
      backgroundColor: getColorBg(),
      appBar: widget.from == "ReviewQcastPageState"
          ? AppBar(
              title: Text(
                "My Channel",
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
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              backgroundColor: Colors.white,
            )
          : null,
      body: SafeArea(
        child: CupertinoScrollbar(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              appState.myChannelProfileItem == null
                  ? Container(
                      padding: EdgeInsets.only(
                        top: 16,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "To begin you will need to setup your Qcast channel",
                        style: getTextStyle(color: Colors.black, size: 13),
                      ))
                  : Container(
                      height: 16,
                    ),
              SizedBox(
                height: 16,
              ),
              pickProfile,
              !isSave
                  ? Form(
                      key: formKey,
                      child: Container(
                        padding: EdgeInsets.only(left: 12, right: 12),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top: 8, left: 8),
                              alignment: Alignment.centerLeft,
                              child: commontextFieldLabel("Qcast Channel Name"),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 8),
                              child: commonTextField(
                                nameController,
                                TextInputType.text,
                                "Enter Your Qcast Channel Name",
                                onChange: model.updateStatusChange,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 16, left: 8),
                              alignment: Alignment.centerLeft,
                              child: commontextFieldLabel("Qcast Motto"),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 8),
                              child: commonTextField(
                                mottoController,
                                TextInputType.text,
                                "Enter Your Qcast Motto",
                                onChange: model.updateStatusChange,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 16, left: 8),
                              alignment: Alignment.centerLeft,
                              child: commontextFieldLabel("Qcast Description"),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 8),
                              child: commonTextField(
                                  descController,
                                  TextInputType.multiline,
                                  "Enter Your Qcast Description",
                                  onChange: model.updateStatusChange,
                                  maxLines: 5,
                                  maxLength: 175),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
              !isSave
                  ? Container()
                  : Column(
                      children: <Widget>[
                        Container(
                          child: Text(
                            nameController.text,
                            style: getTextStyle(
                                color: colorDark,
                                fontWeight: FontWeight.w800,
                                size: 22),
                          ),
                        ),
                        Container(
                          child: Text(
                            mottoController.text,
                            style: getTextStyle(
                                color: Color(0x00ffC3C3C3),
                                fontWeight: FontWeight.w800,
                                size: 18),
                          ),
                          padding: EdgeInsets.only(top: 8, left: 16, right: 16),
                        ),
                        Container(
                          child: Text(
                            descController.text,
                            textAlign: TextAlign.center,
                            style: getTextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                size: 18),
                          ),
                          padding: EdgeInsets.only(top: 8, left: 16, right: 16),
                        ),
                        Container(
                            height: 100,
                            margin: EdgeInsets.only(
                                top: 12, bottom: 4, left: 16, right: 16),
                            child: coundIndicatorBanner(model.subScribers,
                                model.qcastSeries, model.questions))
                      ],
                    ),
              savedQcastsView,
              publishQcastsView,
              model.listSaveQcastItem.length != 0 ||
                      model.listSaveQcastItem.length != 0
                  ? Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: commonButtonWithCorner(
                                  functionCreateProfile,
                                  isSave
                                      ? " Create Qcast"
                                      : isEdit
                                          ? " Save Qcast Channel"
                                          : " Create Qcast Channel",
                                  Image.asset(
                                    App.ic_q,
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                                padding:
                                    EdgeInsets.only(top: 16, left: 4, right: 4),
                              ),
                            ),
                            !isSave
                                ? Container()
                                : Expanded(
                                    child: Container(
                                      child: commonButton(editPress, "Edit",
                                          red: 10),
                                      padding: EdgeInsets.only(
                                          top: 16, left: 4, right: 4),
                                    ),
                                  ),
                          ],
                        ),
                        isSave
                            ? Container()
                            : Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: commonButtonWithCorner(
                                        () {
                                          model.getMyChannel();
                                        },
                                        "Cancel",
                                        null,
                                      ),
                                      padding: EdgeInsets.only(
                                          top: 16, left: 4, right: 4),
                                    ),
                                  ),
                                ],
                              ),
                        commonEndView(),
                      ],
                    )
                  : Column(
                      children: [
                        isSave
                            ? SizedBox(
                                height: 70,
                              )
                            : SizedBox(
                                height: 25,
                              ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: commonButtonWithCorner(
                                  functionCreateProfile,
                                  isSave
                                      ? " Create Qcast"
                                      : isEdit
                                          ? " Save Qcast Channel"
                                          : " Create Qcast Channel",
                                  Image.asset(
                                    App.ic_q,
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                                padding:
                                    EdgeInsets.only(top: 16, left: 4, right: 4),
                              ),
                            ),
                            !isSave
                                ? Container()
                                : Expanded(
                                    child: Container(
                                      child: commonButton(editPress, "Edit",
                                          red: 10),
                                      padding: EdgeInsets.only(
                                          top: 16, left: 4, right: 4),
                                    ),
                                  ),
                          ],
                        ),
                        isSave
                            ? Container()
                            : Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: commonButtonWithCorner(
                                        () {
                                          model.getMyChannel();
                                        },
                                        "Cancel",
                                        null,
                                      ),
                                      padding: EdgeInsets.only(
                                          top: 16, left: 4, right: 4),
                                    ),
                                  ),
                                ],
                              ),
                        commonEndView(),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Function> functionCreateProfile() async {
    hideFocusKeyBoard(context);
    if (model.profileImage?.path == null && model.coverPhoto == null) {
      commonMessage(context, "Choose profile picture");
    } else if (isSave) {
      goToRecordQCastPage(context, runtimeType.toString(), null);
    } else if (formKey.currentState.validate()) {
      if (isEdit) {
        model.myChannelProfileItem.userId = appState.userItem.userId;
        model.myChannelProfileItem.profileName = nameController.text.trim();
        model.myChannelProfileItem.qcastMoto = mottoController.text.trim();
        model.myChannelProfileItem.description = descController.text.trim();
        model.updateMyChannel(model.myChannelProfileItem);
      } else {


          print(appState.userItem.userId.toString());
          print(model.profileImage.path);
          model.myChannelProfileItem = MyChannelProfileItem(
            userId: appState.userItem.userId,
            profilePic: model.profileImage.path,
            profileName: nameController.text.trim(),
            qcastMoto: mottoController.text.trim(),
            description: descController.text.trim(),
          );
          model.createMyChannel(model.myChannelProfileItem);
      }
//      setState(() {
//        isSave = !isSave;
//      });
    }
    return null;
    if (model.profileImage.path == null) {
      commonMessage(context, "Please select profile picture");
    } else if (formKey.currentState.validate()) {
      formKey.currentState.save();
    }
  }

  bool isSave = false;
  bool isEdit = false;
  bool isCancel = false;

  void selectRadio(int value) {
    setState(() {
      value1 = value;
    });
  }

  getProfilepic() {
    if (model.coverPhoto != null) {
      return Container(
        color: Colors.white,
        width: 125,
        height: 125,
        child: ImageFromNetworkView(
          path: model.coverPhoto ?? "",
          boxFit: BoxFit.cover,
        ),
      );
    } else if (model.profileImage.path != null) {
      return fileWidget(model.profileImage.path, 125.0, 125.0);
    }
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              App.ic_logo_purple,
              width: 40,
              height: 40,
            ),
            SizedBox(
              height: 4,
            ),
            Center(
                child: Text(
              "Upload Qcast\nProfile Picture",
              textAlign: TextAlign.center,
              style: getTextStyle(
                  size: 13, color: colorDark, fontWeight: FontWeight.w500),
            ))
          ],
        ),
      ),
    );
  }

  get savedQcastsView => Container(
        child: model.listSaveQcastItem.length == 0
            ? Container()
            : Column(
                children: <Widget>[
                  SizedBox(
                    height: 8,
                  ),
                  Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        child: Text(
                          "Saved Qcasts",
                          style: getTextStyle(
                              size: 15, fontWeight: FontWeight.w800),
                        ),
                        margin: EdgeInsets.only(left: 16),
                      )),
                  Divider(
                    height: 14,
                  ),
                  GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: model.listSaveQcastItem.length,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, childAspectRatio: 0.8),
                    shrinkWrap: true,
                    itemBuilder: (c, i) {
                      QcastItem item = model.listSaveQcastItem[i];
                      return GestureDetector(
                        onLongPress: () {
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                titlePadding:
                                    EdgeInsets.only(top: 10, bottom: 10),
                                contentPadding: EdgeInsets.zero,
                                buttonPadding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15.0))),
                                content: StatefulBuilder(
                                  builder: (BuildContext context,
                                      StateSetter setState) {
                                    return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          /*List<Widget>.generate(2, (int index) {
                                        return*/
                                          new Image.asset(
                                            App.ic_alert_new,
                                            height: 24,
                                            width: 24,
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 20, bottom: 10),
                                            child: Text("Confirmation"),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text(
                                                "Are you sure want to delete this Qcast?"),
                                          )

                                          /*}),*/
                                        ]);
                                  },
                                ),
                                actions: [
                                  new FlatButton(
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop(
                                              false); // dismisses only the dialog and returns false
                                    },
                                    child: Text('No'),
                                  ),
                                  FlatButton(
                                    onPressed: () async {
                                      bool qcaststatus =
                                          await model.changeQcastStatus(
                                              appState.userItem.userId
                                                  .toString(),
                                              item.qcastUserid.toString(),
                                              "1");
                                      if (qcaststatus) {
                                        setState(() {
                                          model.listSaveQcastItem.remove(item);
                                        });
                                        commonToast(
                                            "Your Qcast Deleted Successfully");
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop(true);
                                      } else {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop(true);
                                      }
                                      // dismisses only the dialog and returns true
                                    },
                                    child: Text('Yes'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.only(left: 5, top: 5),
                          child: Column(
                            children: <Widget>[
                              Stack(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          DiscoverQcastItem qcastItem =
                                              DiscoverQcastItem(
                                            qcasId: item.qcastUserid,
                                            name: item.name,
                                            description: item.description,
                                            coverPhoto: item.coverPhoto,
                                          );
                                          goToDescriptionPage(
                                              context, qcastItem);
                                        },
                                        child: ClipOval(
                                          child: Container(
                                            child: ClipOval(
                                                child: Container(
                                              child: ImageFromNetworkView(
                                                path: item.coverPhoto,
                                                boxFit: BoxFit.cover,
                                              ),
                                              width: 75,
                                              height: 75,
                                            )),
                                            padding: EdgeInsets.all(3),
                                            color: colorOvalBorder,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              AutoSizeText(
                                item.description,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: getTextStyle(
                                  size: 14,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    /*Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: InkWell(
                                        child: Material(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              side: BorderSide(
                                                  color: colorSectionHead,
                                                  width: 0.5)),
                                          child: Container(
                                            child: Text(
                                              "Post",
                                              style: getTextStyle(
                                                  color: colorDark,
                                                  size: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            padding: EdgeInsets.only(
                                                left: 5,
                                                right: 5,
                                                top: 3,
                                                bottom: 3),
                                          ),
                                        ),
                                        onTap: () {
                                          QcastItem ii =
                                              model.listSaveQcastItem[i];
                                          model
                                              .publishQcastList(ii.qcastUserid);
                                        },
                                      ),
                                    ),*/
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: InkWell(
                                        child: Material(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              side: BorderSide(
                                                  color: colorSectionHead,
                                                  width: 0.5)),
                                          child: Container(
                                            child: Text(
                                              "Publish",
                                              style: getTextStyle(
                                                  color: colorDark,
                                                  size: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            padding: EdgeInsets.only(
                                                left: 5,
                                                right: 5,
                                                top: 3,
                                                bottom: 3),
                                          ),
                                        ),
                                        onTap: () {
                                          QcastItem ii =
                                              model.listSaveQcastItem[i];
                                          model
                                              .publishQcastList(ii.qcastUserid);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
      );

  get publishQcastsView => Container(
        child: model.listPublishQcastItem.length == 0
            ? Container()
            : Column(
                children: <Widget>[
                  SizedBox(
                    height: 8,
                  ),
                  Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        child: Text(
                          "Published Qcasts",
                          style: getTextStyle(
                              size: 15, fontWeight: FontWeight.w800),
                        ),
                        margin: EdgeInsets.only(left: 16),
                      )),
                  Divider(
                    height: 14,
                  ),
                  GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: model.listPublishQcastItem.length,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, childAspectRatio: 0.8),
                    shrinkWrap: true,
                    itemBuilder: (c, i) {
                      QcastItem item = model.listPublishQcastItem[i];
                      return GestureDetector(
                        onLongPress: () {
                          print("LongPRessClicked");
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                titlePadding:
                                    EdgeInsets.only(top: 10, bottom: 10),
                                contentPadding: EdgeInsets.zero,
                                buttonPadding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15.0))),
                                content: StatefulBuilder(
                                  builder: (BuildContext context,
                                      StateSetter setState) {
                                    return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          /*List<Widget>.generate(2, (int index) {
                                        return*/
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 20, bottom: 10),
                                            child: Text("Confirmation"),
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                value: 1,
                                                groupValue: value1,
                                                onChanged: (int value) {
                                                  setState(
                                                      () => selectRadio(value));
                                                },
                                              ),
                                              Text("Delete")
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                value: 0,
                                                groupValue: value1,
                                                onChanged: (int value) {
                                                  setState(
                                                      () => selectRadio(value));
                                                },
                                              ),
                                              Text("Unpublish")
                                            ],
                                          ),

                                          /*}),*/
                                        ]);
                                  },
                                ),
                                actions: [
                                  new FlatButton(
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop(
                                              false); // dismisses only the dialog and returns false
                                    },
                                    child: Text('No'),
                                  ),
                                  FlatButton(
                                    onPressed: () async {
                                      bool qcaststatus =
                                          await model.changeQcastStatus(
                                              appState.userItem.userId
                                                  .toString(),
                                              item.qcastUserid.toString(),
                                              value1.toString());
                                      if (qcaststatus) {
                                        if (value1 == 1) {
                                          setState(() {
                                            model.listPublishQcastItem
                                                .remove(item);
                                          });
                                          commonToast(
                                              "Your Qcast Deleted Successfully");
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop(true);
                                        } else {
                                          commonToast(
                                              "Your Qcast Unpublish Successfully");
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop(true);
                                          await model.getQcastList();
                                        }
                                      } else {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop(true);
                                      }
                                      // dismisses only the dialog and returns true
                                    },
                                    child: Text('Yes'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.only(left: 5, top: 5),
                          child: Column(
                            children: <Widget>[
                              Stack(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          DiscoverQcastItem qcastItem =
                                              DiscoverQcastItem(
                                                  qcasId: item.qcastUserid,
                                                  name: item.name,
                                                  description: item.description,
                                                  coverPhoto: item.coverPhoto);
                                          goToDescriptionPage(
                                              context, qcastItem);
                                        },
                                        child: ClipOval(
                                          child: Container(
                                            child: ClipOval(
                                                child: Container(
                                              child: ImageFromNetworkView(
                                                path: item.coverPhoto,
                                                boxFit: BoxFit.cover,
                                              ),
                                              width: 75,
                                              height: 75,
                                            )),
                                            padding: EdgeInsets.all(3),
                                            color: colorOvalBorder,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              AutoSizeText(
                                item.description,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: getTextStyle(
                                  size: 14,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              /*Container(
                    padding: EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: InkWell(
                            child: Material(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(5.0),
                                  side: BorderSide(
                                      color: colorSectionHead,
                                      width: 0.5)),
                              child: Container(
                                child: Text(
                                  "Post",
                                  style: getTextStyle(
                                      color: colorDark,
                                      size: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                padding: EdgeInsets.only(
                                    left: 5,
                                    right: 5,
                                    top: 3,
                                    bottom: 3),
                              ),
                            ),
                            onTap: () {
                              QcastItem ii =
                              model.listSaveQcastItem[i];
                              model
                                  .publishQcastList(ii.qcastUserid);
                            },
                          ),
                        ),

                      ],
                    ),
                  )*/
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
      );
}
