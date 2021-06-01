import 'dart:io';
//import 'package:file_picker/file_picker.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/page/sylo/add_sylo_page/add_sylo_page_view_model.dart';
import 'package:testsylo/page/sylo/open_message_page/open_message_page.dart';
import 'package:testsylo/util/navigate_effect.dart';
import 'package:testsylo/util/util.dart';
import 'package:testsylo/common/common_widget.dart';
import '../../../app.dart';

class AddSyloPage extends StatefulWidget {
  bool isEdit;
  GetUserSylos userSylo;

  AddSyloPage({this.userSylo, this.isEdit = false});

  @override
  AddSyloPageState createState() => AddSyloPageState();
}

class AddSyloPageState extends State<AddSyloPage> {
  AddSyloPageViewModel model;
  bool notifyRecipient = false;
  bool iAgree = true;
  bool recipientEnable = false;
  bool emailNotification = true;

  get pickProfile => InkWell(
        onTap: () async {
          try {
            FilePickerResult result =
                await FilePicker.platform.pickFiles(type: FileType.image);
            if (result != null &&
                result.files.single.path != null &&
                result.files.single.path.isNotEmpty) {
              File _image = await FlutterExifRotation.rotateImage(
                  path: result.files.single.path);
              _image = _image.renameSync(result.files.single.path);
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
                      toolbarColor: colorgradient1,
                      toolbarWidgetColor: Colors.white,
                      initAspectRatio: CropAspectRatioPreset.original,
                      lockAspectRatio: false),
                  iosUiSettings: IOSUiSettings(
                    title: "Edit Image",
                    minimumAspectRatio: 1.0,
                  )).then((value) {
                setState(() {
                  model.profileImage.path = value;
                  //model.coverPhoto = null;
                  //model.updateFormStatus = true;
                });
              });
              /*setState(() {
                model.profileImage.path = _image;
              });*/
            }
          } catch (e) {}
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
                          width: 140,
                          height: 140,
                          child: model.profileImage.path == null
                              ? widget.isEdit
                                  ? /*Image.network(model.getSyloItem.syloPic ?? "",fit: BoxFit.cover)*/
                          ImageFromNetworkView(
                            path: widget.userSylo.syloPic != null
                                ? widget.userSylo.syloPic
                                : "",
                            boxFit: BoxFit.cover,
                          )
                                  : Container(
                                      color: Colors.white,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
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
                                                child: AutoSizeText(
                                              "Upload Profile Picture",
                                              textAlign: TextAlign.center,
                                              style: getTextStyle(
                                                  size: 13,
                                                  color: colorDark,
                                                  fontWeight: FontWeight.w500),
                                            ))
                                          ],
                                        ),
                                      ),
                                    )
                              : fileWidget(
                                  model.profileImage.path, 140.0, 140.0)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  get onPressedContinue => () async {
        /* var result = await Navigator.push(
        context, NavigatePageRoute(context,
        SignUpVerificationSentPage()
    ));*/
        if (model.profileImage.path == null) {
          commonMessage(
              context, "Please choose a photo for your Sylo profile.");
          return;
        } else if (!model.formKey.currentState.validate()) {
          return;
        }
        if (relationModel == null) {
          commonMessage(context, "Select relationship");
          return;
        }
        if (relationModel?.index == 0 && relationFamilyModel == null) {
          commonMessage(context, "Select family relationship");
          return;
        }
        bool isEmailVerify =
            await model.checkAddSyloEmail(recipientEmailController.text);
        if (!isEmailVerify) {
          return;
        }
//        print("Email -> ${recipientEmailController.text.toString()}");
//        bool verifyfirstEmail = await model.callVerifyEmailAddress(recipientEmailController.text.toString());
//        if (verifyfirstEmail!=true) {
//          return;
//        }
//        if(int.parse(recipientAgeController.text)<18) {
//          print("Email -> ${recipientCoEmailController.text.toString()}");
//          bool verifySecondEmail = await model.callVerifyEmailAddress(recipientCoEmailController.text.toString());
//          if (verifySecondEmail!=true) {
//            return;
//          }
//        }
        await model.callPostAddSylo();
        /*showDialog(
          context: context,
          builder: (BuildContext context) => AnimatedContainer(
            padding: MediaQuery.of(context).viewInsets,
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
                        padding: EdgeInsets.only(
                            top: 8, bottom: 8, left: 16, right: 16),
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
                                    padding: EdgeInsets.only(left: 8, right: 8),
                                    child: ListView(
                                      shrinkWrap: true,
                                      physics: BouncingScrollPhysics(),
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(
                                              top: 32,
                                              bottom: 32,
                                              left: 8,
                                              right: 8),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "A Secured Email Address is one which you can guarantee will be accessed by only your Assigned Sylo Recipient.",
                                            textAlign: TextAlign.center,
                                            style: getTextStyle(size: 14),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              child: commonButton(
                                                  onPressedContinueDialogue,
                                                  "Continue"),
                                              padding: EdgeInsets.only(top: 16),
                                              width: 200,
                                              height: 60,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 16,
                                        ),
                                      ],
                                    )),
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
          ),
        );*/
      };

  get bottomCheckBoxes => Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 16, top: 28),
            child: Row(
              children: <Widget>[
                InkWell(
                  child: Icon(
                    notifyRecipient
                        ? FontAwesomeIcons.checkCircle
                        : FontAwesomeIcons.circle,
                    color: colorDark,
                    size: 20,
                  ),
                  onTap: () {
                    setState(() {
                      notifyRecipient = !notifyRecipient;
                    });
                  },
                ),
                SizedBox(width: 4),
                Text(
                  "Notify the Recipient about their Sylo",
                  style: getTextStyle(
                    color: Colors.black,
                    size: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 4),
//          Icon(Icons.info,color: colorLightRound,size: 19,),
                getInfoIcon(App.notifyInfoToolTip, context)
              ],
            ),
          ),
          !widget.isEdit
              ? Container(
                  padding: EdgeInsets.only(left: 16, top: 20, bottom: 28),
                  child: Row(
                    children: <Widget>[
                      InkWell(
                        child: Icon(
                          iAgree
                              ? FontAwesomeIcons.checkCircle
                              : FontAwesomeIcons.circle,
                          color: colorDark,
                          size: 20,
                        ),
                        onTap: () {
                          setState(() {
                            iAgree = !iAgree;
                          });
                        },
                      ),
                      SizedBox(width: 4),
                      RichText(
                        text: TextSpan(
                          text: "I agree with Sylo's ",
                          style: getTextStyle(
                            color: Colors.black,
                            size: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Terms and Conditions.',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {},
                                style: getTextStyle(
                                    color: colorSectionHead,
                                    size: 15,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ))
              : Container(
                  padding: EdgeInsets.only(top: 22),
                ),
        ],
      );

  get addFormButton => model.listRec.length == 1 ? Container() : Container();
  /*Container(
          padding: EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 40,
                child: RaisedButton(
                  onPressed: () {
                    model.addRec();
                  },
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  padding: EdgeInsets.all(0.0),
                  child: Ink(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: colorDark, width: 1.1)),
                    child: Container(
                      constraints: BoxConstraints(minHeight: 50.0),
                      alignment: Alignment.center,
                      child: Text(
                        "  Add another Recipient  ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: colorDark,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );*/

  get continueButton => Container(
        child: commonButton(
//            onPressedContinueDialogue,
            onPressedContinue,
            "Continue"),
        margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
      );

  double t = 16, l = 16, r = 16;
  TextEditingController displayNameController = TextEditingController();
  TextEditingController recipientNameController = TextEditingController();
  TextEditingController recipientEmailController = TextEditingController();
  TextEditingController recipientBDayController = TextEditingController();
  TextEditingController recipientAgeController =
      TextEditingController(text: "0");
  TextEditingController recipientCoNameController = TextEditingController();
  TextEditingController recipientCoEmailController = TextEditingController();

  get addSyloFormView => Container(
        padding: EdgeInsets.only(left: l, right: r),
        child: Form(
          key: model.formKey,
          child: Column(
            children: <Widget>[
              pickProfile,
              // Rec, name
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: t),
                child: commontextFieldLabel("Display Name", size: 13),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: commonTextField(
                    displayNameController, TextInputType.text, "",
                    maxLength: 12,onChange: (val){
                      if(val.length>=12){

                      }


                }),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: t),
                child: commontextFieldLabel("Recipient's Full Name", size: 13),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: commonTextField(
                    recipientNameController, TextInputType.text, "",
                    maxLength: 28,onChange: (val){
                  if(val.length>=28){

                  }


                }),
              ),
              //
              // email
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: t),
                child: Row(
                  children: <Widget>[
                    commontextFieldLabel(
                      "Recipient's Secured Email Address",
                      size: 13,
                    ),
                    SizedBox(
                      width: 4,
                    ),
//                    widget.isEdit
                    false
                        ? InkWell(
                            child: Text(
                              "(Unverified)",
                              style: getTextStyle(
                                  color: colorSectionHead, size: 13),
                            ),
                            onTap: () {},
                          )
                        : Container()
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: commonTextField(
                    recipientEmailController, TextInputType.emailAddress, "",
                    /*suffixWidget: widget.isEdit
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              height: 22,
                              width: 86,
                              child: commonButtonWithFilledSingleColorCorner(
                                () {
//                              print("On Tap Resend email");
                                },
                                Text(
                                  "Resend email",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12),
                                ),
                                colorDark,
                                red: 5,
                              ),
                            ),
                          ],
                        )
                      : null,*/
                    callback: () async {
                  if (emailNotification) {
//                      hideFocusKeyBoard(context);
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) => AnimatedContainer(
                        padding: MediaQuery.of(context).viewInsets,
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
                                    padding: EdgeInsets.only(
                                        top: 8, bottom: 8, left: 16, right: 16),
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      child: Container(
                                        child: SafeArea(
                                          child: Material(
                                            color: Colors.transparent,
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                          top: Radius.circular(
                                                              0)),
                                                ),
                                                padding: EdgeInsets.only(
                                                    left: 8, right: 8),
                                                child: ListView(
                                                  shrinkWrap: true,
                                                  physics:
                                                      BouncingScrollPhysics(),
                                                  children: <Widget>[
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          top: 32,
                                                          bottom: 32,
                                                          left: 8,
                                                          right: 8),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        "A Secured Email Address is one which you can guarantee will be accessed by only your Assigned Sylo Recipient.",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: getTextStyle(
                                                            size: 14),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Container(
                                                          child: commonButton(
//                                                              onPressedContinueDialogue,
                                                              () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          }, "Continue"),
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 16),
                                                          width: 200,
                                                          height: 60,
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 16,
                                                    ),
                                                  ],
                                                )),
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
                      ),
                    );
                    setState(() {
                      emailNotification = false;
                    });
                  }
                }),
              ),
              // BDay
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: t),
                child: commontextFieldLabel("Recipient's Birthday (DD/MM/YYYY)",
                    size: 13),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: commonTextField(
                    recipientBDayController, TextInputType.datetime, "",
                    callback: () async {
                  hideFocusKeyBoard(context);
                  await selectDate();
                }),
              ),
              // Age
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: t),
                child: commontextFieldLabel(
                    "Recipient's Age (at time of Sylo's creation)",
                    size: 13),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: commonTextField(
                    recipientAgeController, TextInputType.number, "",
                    enabled: false),
              ),
              // Relationship
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: t),
                child:
                    commontextFieldLabel("Recipient's Relationship", size: 13),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: relationShipDropDownSelection,
              ),
              Container(
                color: Color(0x00ffC3C3C3),
                height: 1,
                margin: EdgeInsets.only(top: 5),
              ),
              //  Family Relationship
              relationModel?.index == 0
                  ? Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(top: t),
                          child: commontextFieldLabel(
                              "Recipient's Family Relationship",
                              size: 13),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: relationShipFamilyDropDownSelection,
                        ),
                        Container(
                          color: Color(0x00ffC3C3C3),
                          height: 1,
                          margin: EdgeInsets.only(top: 5),
                        ),
                      ],
                    )
                  : SizedBox(),
              // Co Rec. name
              recipientEnable
                  ? Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(top: t),
                          child: commontextFieldLabel("Co-Recipient's Name",
                              size: 13),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: commonTextField(
                              recipientCoNameController, TextInputType.text, "",
                              enabled: recipientEnable),
                        ),
                        // Co rec. email
                        // email
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(top: t),
                          child: Row(
                            children: <Widget>[
                              commontextFieldLabel(
                                  "Co-Recipient's Secured Email Address",
                                  size: 13),
                              SizedBox(
                                width: 4,
                              ),
                              widget.isEdit
                                  ? InkWell(
                                      child: Text(
                                        "(Verified)",
                                        style: getTextStyle(
                                            color: colorSectionHead, size: 13),
                                      ),
                                      onTap: () {},
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: commonTextField(recipientCoEmailController,
                              TextInputType.emailAddress, "",
                              enabled: recipientEnable),
                        ),
                      ],
                    )
                  : SizedBox(),
            ],
          ),
        ),
      );

  RelationModel relationModel;

  Widget get relationShipDropDownSelection {
    var items = relationshipList.map((item) {
      return new DropdownMenuItem<RelationModel>(
        value: item,
        child: new Text(
          item.text,
          style: new TextStyle(color: Colors.black),
        ),
      );
    }).toList();
    return Container(
      padding: EdgeInsets.only(
        top: t,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<RelationModel>(
            value: relationModel,
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
            onChanged: (RelationModel i) {
              FocusScope.of(context).requestFocus(FocusNode());
              setState(() {
                relationModel = i;
              });
            },
            items: items),
      ),
    );
  }

  RelationModel relationFamilyModel;

  Widget get relationShipFamilyDropDownSelection {
    var items = relationshipFamilyList.map((item) {
      return new DropdownMenuItem<RelationModel>(
        value: item,
        child: new Text(
          item.text,
          style: new TextStyle(color: Colors.black),
        ),
      );
    }).toList();
    return Container(
      padding: EdgeInsets.only(
        top: t,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<RelationModel>(
            value: relationFamilyModel,
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
            onChanged: (RelationModel i) {
              FocusScope.of(context).requestFocus(FocusNode());
              setState(() {
                relationFamilyModel = i;

                if (i.index == 4) {

                  recipientEnable = true;
                }
                else{
                  recipientEnable = false;
                }

              });
            },
            items: items),
      ),
    );
  }

  get onPressedContinueDialogue => () async {
        await model.callPostAddSylo();
        /*var result = await Navigator.push(
            context, NavigatePageRoute(context, OpenMessagePage()));*/
      };

  get deleteButton => Container(
        margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Column(
          children: <Widget>[
            Container(
              child: commonButtonWithCorner(
                    () {
                  model.updateSylo();
                },
                "Edit Sylo",
                null,
                red: 20,
              ),
              padding: EdgeInsets.only(left: 4, right: 4),
            ),
            Container(
              child: commonButtonWithFilledSingleColorCorner(
                () async {
                  var result = await deleteSyloPage(context);
                  if (result != null && result == true) {
                    model.getCallDeleteSylo();
                  } else {
                    Navigator.pop(context);
                  }
                },
                Text(
                  "Delete Sylo",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 18),
                ),
                colorDark,
                red: 20,
              ),
              padding: EdgeInsets.only(left: 4, right: 4,top:10),
            ),

          ],
        ),
      );

  get listRecView => Container(
        padding: EdgeInsets.only(left: 8, right: 8, top: 16),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          itemCount: model.listRec.length,
          shrinkWrap: true,
          itemBuilder: (c, i) {
            SyloProfileModel item = model.listRec[i];
            return Container(
              padding: EdgeInsets.only(left: 8, top: 8),
              child: Card(
                child: Container(
                  padding:
                      EdgeInsets.only(left: 16, right: 16, top: 3, bottom: 3),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: Text(
                            item.recipientName,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      InkWell(
                        child: Icon(
                          Icons.delete,
                          size: 16,
                        ),
                        onTap: () {
                          int index = i;
                          hideFocusKeyBoard(context);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              // return object of type Dialog
                              return AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
                                title: new Text(
                                  "Alert",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                content: new Text("Confirm delete? ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500)),
                                actions: <Widget>[
                                  // usually buttons at the bottom of the dialog
                                  new FlatButton(
                                    child: new Text(
                                      "No",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  new FlatButton(
                                    child: new Text(
                                      "Yes",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        model.anotherRecipientMode = false;
                                        model.listRec.removeAt(index);
                                      });
                                    },
                                  ),
                                ],
                              );
                            },
                          );

                        },
                      ),
                      widget.isEdit
                          ? InkWell(
                              child: model.anotherRecipientMode
                                  ? Container(
                                      padding: EdgeInsets.only(
                                          left: 8, right: 4, top: 4, bottom: 4),
                                      child: Text(
                                        "Save",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.green),
                                      ),
                                    )
                                  : Container(
                                      padding: EdgeInsets.only(
                                          left: 8, right: 4, top: 4, bottom: 4),
                                      child: Icon(
                                        Icons.edit,
                                        size: 16,
                                      ),
                                    ),
                              onTap: () async {
                                int index = i;
                                hideFocusKeyBoard(context);
                                model.anotherRecipientMode =
                                    !model.anotherRecipientMode;
                                if (model.anotherRecipientMode) {
                                  model.editAnotherRecipient();
                                } else {
                                  if (model.formKey.currentState.validate()) {
                                    if (relationModel == null) {
                                      commonMessage(
                                          context, "Select relationship");
                                      return;
                                    }
                                    if (relationModel?.index == 0 &&
                                        relationFamilyModel == null) {
                                      commonMessage(context,
                                          "Select family relationship");
                                      return;
                                    }
                                    hideFocusKeyBoard(context);
                                    model.loadFirstRecipientData();
                                  }
                                }
                                setState(() {});
                              },
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = AddSyloPageViewModel(this));
    return WillPopScope(
      onWillPop: () async {
        hideFocusKeyBoard(context);
        await commonCupertinoDialogPage(
          context,
          commonExitWarningCenterWidget(),
          positiveAction: () async {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          negativeActionLabel: "No",
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: getColorBg(),
        appBar: AppBar(
          title: Text(
            widget.isEdit ? "Edit Sylo" : "Add Sylo",
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
              await commonCupertinoDialogPage(
                context,
                commonExitWarningCenterWidget(),
                positiveAction: () async {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                negativeActionLabel: "No",
              );
            },
          ),
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: Container(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                addSyloFormView,
                addFormButton,
                listRecView,
                bottomCheckBoxes,
                widget.isEdit ? deleteButton : continueButton,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future selectDate() async {
    DateTime initDate = new DateTime.now();
    if (recipientBDayController.text.isNotEmpty) {
      List dateElementList = recipientBDayController.text.split("/");
      if (dateElementList.length == 3) {
        initDate = DateTime(int.parse(dateElementList[2]),
            int.parse(dateElementList[1]), int.parse(dateElementList[0]));
      }
    }




    DateTime picked = await showDatePicker(
      context: context,
      initialDate: initDate,
      firstDate: new DateTime(1930),
      lastDate: new DateTime.now(),
      locale: Locale("en","GB"),
      initialDatePickerMode: DatePickerMode.day,
      initialEntryMode: DatePickerEntryMode.calendar,
      fieldHintText: App.formatDateForADD,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: colorDark,
            accentColor: colorDark,
            colorScheme: ColorScheme.light(primary: colorDark),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );
    if (picked != null)
      setState(() {
        recipientBDayController.text =
            App.getDateByFormat(picked, App.formatDateForAddSylo);
        int age = calculateAge(picked);
        recipientAgeController.text = age.toString();
        if (age < 18) {
          recipientEnable = true;
        } else {
          recipientEnable = false;
        }
      });
  }

  calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }
}
