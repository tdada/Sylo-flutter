import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/page/post_media/post_photo/photo_camera_page/photo_camera_page.dart';
import 'package:testsylo/util/navigate_effect.dart';
import '../../../../app.dart';
import 'edit_profile_page_view_page.dart';
class EditProfilePage extends StatefulWidget {
  @override
  EditProfilePageState createState() => EditProfilePageState();
}

  class EditProfilePageState extends State<EditProfilePage> {
    EditProfilePageViewModel model;
    var _userProfileformKey = GlobalKey<FormState>();
    final FocusNode myFocusNodeNameSignup = FocusNode();
    final FocusNode myFocusNodeEmailSignup = FocusNode();
    final FocusNode myFocusNodeOldPasswordSignup = FocusNode();
    final FocusNode myFocusNodePasswordSignup = FocusNode();
    final FocusNode myFocusNodeConfirmPasswordSignup = FocusNode();
    TextEditingController signupNameController = new TextEditingController(
        text: appState.userItem.username);
    TextEditingController signupEmailController = new TextEditingController(
        text: appState.userItem.email);
    TextEditingController signupOldPasswordController = new TextEditingController();
    TextEditingController signupPasswordController = new TextEditingController();
    TextEditingController signupConfirmPasswordController = new TextEditingController();
    bool _obscureTextOldPassword = true;
    bool _obscureTextPassword = true;
    bool _obscureConfirmTextPassword = true;

    get nameFieldLabel =>
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            "Change Full Name",
            style: getTextStyle(color: Color(0x00ffC3C3C3), size: 14),
          ),
        );

    get nameFormField =>
        Container(
          child: Material(
            color: getMatColorBg(),
            elevation: 0.0,
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.only(
                    topRight: Radius.circular(1),
                    topLeft: Radius.circular(1),
                    bottomLeft: Radius.circular(1),
                    bottomRight: Radius.circular(1))),
            child: Container(
              child: TextFormField(
                focusNode: myFocusNodeNameSignup,
                controller: signupNameController,
                keyboardType: TextInputType.text,
                style: getTextStyle(size: 16, color: Colors.black),
                validator: (value) {
                  if (value.isEmpty) {
                    return App.errorNameOnly;
                  }
                  /*else if (isNumeric(value) &&
                                                    value.trim().length < 7) {
                                                  return App.errorMobileInValid;
                                                }*/
                  else {
                    return null;
                  }
                },
              ),
            ),
          ),
        );

    get emailFieldLabel =>
        Container(
          padding: EdgeInsets.only(top: 12),
          alignment: Alignment.centerLeft,
          child: Text(
//      "Change Email",
            "Email",
            style: getTextStyle(color: Color(0x00ffC3C3C3), size: 14),
          ),
        );

    get emailFormField =>
        Container(
          child: Material(
            color: getMatColorBg(),
            elevation: 0.0,
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.only(
                    topRight: Radius.circular(1),
                    topLeft: Radius.circular(1),
                    bottomLeft: Radius.circular(1),
                    bottomRight: Radius.circular(1))),
            child: Container(
              child: TextFormField(
                enabled: false,
                focusNode: myFocusNodeEmailSignup,
                controller: signupEmailController,
                keyboardType: TextInputType.emailAddress,
                style: getTextStyle(size: 16, color: Color(0x00ffC3C3C3)),
                validator: (value) {
                  if (value.isEmpty) {
                    return App.errorEmail;
                  } else if (!RegExp(
                      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                      .hasMatch(value)) {
                    return App.errorEmailInValid;
                  }
                  /*else if (isNumeric(value) &&
                                                    value.trim().length < 7) {
                                                  return App.errorMobileInValid;
                                                }*/
                  else {
                    return null;
                  }
                },
              ),
            ),
          ),
        );

    get oldPasswordFieldLabel =>
        Container(
          padding: EdgeInsets.only(top: 12),
          alignment: Alignment.centerLeft,
          child: Text(
            "Old Password",
            style: getTextStyle(color: Color(0x00ffC3C3C3), size: 14),
          ),
        );

    get oldPasswordFormField =>
        Container(
          child: Material(
            color: getMatColorBg(),
            elevation: 0.0,
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.only(
                    topRight: Radius.circular(1),
                    topLeft: Radius.circular(1),
                    bottomLeft: Radius.circular(1),
                    bottomRight: Radius.circular(1))),
            child: Container(
              child: TextFormField(
                focusNode: myFocusNodeOldPasswordSignup,
                controller: signupOldPasswordController,
                obscureText: _obscureTextOldPassword,
                style: TextStyle(fontSize: 16.0, color: Colors.black),
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: _toggleOldPass,
                    child: Icon(
                      _obscureTextOldPassword
                          ? FontAwesomeIcons.eyeSlash
                          : FontAwesomeIcons.eye,
                      size: 15.0,
                      color: colorDark,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

    get passwordFieldLabel =>
        Container(
          padding: EdgeInsets.only(top: 12),
          alignment: Alignment.centerLeft,
          child: Text(
            "Change Password",
            style: getTextStyle(color: Color(0x00ffC3C3C3), size: 14),
          ),
        );

    get passwordFormField =>
        Container(
          child: Material(
            color: getMatColorBg(),
            elevation: 0.0,
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.only(
                    topRight: Radius.circular(1),
                    topLeft: Radius.circular(1),
                    bottomLeft: Radius.circular(1),
                    bottomRight: Radius.circular(1))),
            child: Container(
              child: TextFormField(
                focusNode: myFocusNodePasswordSignup,
                controller: signupPasswordController,
                obscureText: _obscureTextPassword,
                style: TextStyle(fontSize: 16.0, color: Colors.black),
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: _toggleLogin,
                    child: Icon(
                      _obscureTextPassword
                          ? FontAwesomeIcons.eyeSlash
                          : FontAwesomeIcons.eye,
                      size: 15.0,
                      color: colorDark,
                    ),
                  ),
                ),
//          validator: (value) {
//            if (value.isEmpty) {
//              return App.errorPassword;
//            } else {
//              return null;
//            }
//          },
              ),
            ),
          ),
        );

    get confirmPasswordFieldLabel =>
        Container(
          padding: EdgeInsets.only(top: 12),
          alignment: Alignment.centerLeft,
          child: Text(
            "Confirm Password",
            style: getTextStyle(color: Color(0x00ffC3C3C3), size: 14),
          ),
        );

    get confirmPasswordFormField =>
        Container(
          child: Material(
            color: getMatColorBg(),
            elevation: 0.0,
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.only(
                    topRight: Radius.circular(1),
                    topLeft: Radius.circular(1),
                    bottomLeft: Radius.circular(1),
                    bottomRight: Radius.circular(1))),
            child: Container(
              child: TextFormField(
                focusNode: myFocusNodeConfirmPasswordSignup,
                controller: signupConfirmPasswordController,
                obscureText: _obscureConfirmTextPassword,
                style: TextStyle(fontSize: 16.0, color: Colors.black),
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: _toggleConfirmPass,
                    child: Icon(
                      _obscureConfirmTextPassword
                          ? FontAwesomeIcons.eyeSlash
                          : FontAwesomeIcons.eye,
                      size: 15.0,
                      color: colorDark,
                    ),
                  ),
                ),
//          validator: (value) {
//            if (value.isEmpty) {
//              return App.errorPassword;
//            } else {
//              return null;
//            }
//          },
              ),
            ),
          ),
        );

    get formView =>
        Column(
          children: <Widget>[
            Form(
              key: _userProfileformKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10,),
                  nameFieldLabel,
                  nameFormField,
                  emailFieldLabel,
                  emailFormField,
                  oldPasswordFieldLabel,
                  oldPasswordFormField,
                  passwordFieldLabel,
                  passwordFormField,
                  confirmPasswordFieldLabel,
                  confirmPasswordFormField,
                  Container(height: 25,),
                  Container(
                    height: 58,
                    child: btnView,
                    padding: EdgeInsets.only(left: 16, right: 16,),
                    margin: EdgeInsets.only(bottom: 16),
                  ),

                ],
              ),
            ),
          ],
        );

  void _toggleOldPass() {
    setState(() {
      _obscureTextOldPassword = !_obscureTextOldPassword;
    });
  }
  void _toggleLogin() {
    setState(() {
      _obscureTextPassword = !_obscureTextPassword;
    });
  }
  void _toggleConfirmPass() {
    setState(() {
      _obscureConfirmTextPassword = !_obscureConfirmTextPassword;
    });
  }
    get btnView =>
        Container(
          child: commonButton(
                () async {
              if (_userProfileformKey.currentState.validate()) {
                _userProfileformKey.currentState.save();
                if (signupPasswordController.text != "" ||
                    signupConfirmPasswordController.text != "") {
                  if (signupPasswordController.text !=
                      signupConfirmPasswordController.text) {
                    commonMessage(context,
                        "Your enter password doesn't match with confirm password.");
                    return;
                  }
                }
                await model.updateUser();
              }
            },
            "Save",
          ),
        );

    get avtarView =>
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            pickProfile,
            Container(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              alignment: Alignment.center,
              child: Text(
                "Change Profile Photo",
                style: getTextStyle(color: Color(0x00ffC3C3C3), size: 14),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                pickCam,
                SizedBox(width: 25,),
                pickLib,
              ],
            ),
            SizedBox(height: 16,),
          ],
        );

    get pickProfile =>
        InkWell(
          child: Container(
              child: ClipOval(
                child: Container(
                  child: ClipOval(
                    child: Container(
                      child: model.profileImage.path == null ? Container(
                        height: 125,
                        width: 125,
                        child: ImageFromNetworkView(
                          path: appState.userItem.profilePic != null ? appState
                              .userItem.profilePic : "",
                          boxFit: BoxFit.cover,
                        ),
                      ) : fileWidget(
                          model.profileImage.path, 125.0, 125.0),
                    ),
                  ),
                  padding: EdgeInsets.all(2),
                  color: colorOvalBorder,
                ),
              )),
        );

    get pickCam =>
        InkWell(
          onTap: () async {
            var result = await Navigator.push(
                context,
                NavigatePageRoute(
                    context, PhotoCameraPage(from: runtimeType.toString())));

            if(result != null ){
              await ImageCropper.cropImage(
                  sourcePath: result.path,
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
                      initAspectRatio: CropAspectRatioPreset
                          .original,
                      lockAspectRatio: false),
                  iosUiSettings: IOSUiSettings(
                    title: "Edit Image",
                    minimumAspectRatio: 1.0,
                  )
              ).then((value) {
                setState(() {
                  model.profileImage.path = value;
                  model.profileFile = value;
                });
              });
            }

          },
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ClipOval(
                child: Container(
                  padding: EdgeInsets.all(2),
                  color: colorLightRound,
                  child: ClipOval(
                    //borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: <Widget>[
                        Container(
                            width: 72,
                            height: 72,
                            child: Container(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      App.ic_cam,
                                      width: 46,
                                      height: 32,
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Center(
                                        child: Text(
                                          "Camera",
                                          textAlign: TextAlign.center,
                                          style: getTextStyle(
                                              size: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w800),
                                        ))
                                  ],
                                ),
                              ),
                            )
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

    get pickLib =>
        InkWell(
          onTap: () async {
            try {
              FilePickerResult result = await FilePicker.platform.pickFiles(
                  type: FileType.image);
              if (result != null && result.files.single.path != null &&
                  result.files.single.path.isNotEmpty) {
                File _image = await FlutterExifRotation.rotateImage(
                    path: result.files.single.path);
                _image = _image.renameSync(result.files.single.path);
                if(_image != null){
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
                          initAspectRatio: CropAspectRatioPreset
                              .original,
                          lockAspectRatio: false),
                      iosUiSettings: IOSUiSettings(
                        title: "Edit Image",
                        minimumAspectRatio: 1.0,
                      )
                  ).then((value) {
                    setState(() {
                      model.profileImage.path = value;
                      model.profileFile = value;
                    });
                  });
                }
              }
            } catch (e) {}
          },
          child:
          ClipOval(
            child: Container(
              padding: EdgeInsets.all(2),
              color: colorLightRound,
              child: ClipOval(
                //borderRadius: BorderRadius.circular(10),
                  child:
                  Container(
                    width: 72,
                    height: 72,
                    child: Container(
                      child: Center(
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              App.ic_lib,
                              width: 46,
                              height: 32,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Center(
                                child: Text(
                                  "Library",
                                  textAlign: TextAlign.center,
                                  style: getTextStyle(
                                      size: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800),
                                ))
                          ],
                        ),
                      ),
                    ),
                  )
              ),
            ),
          ),
        );

    @override
    Widget build(BuildContext context) {
      print("runtimeType -> " + runtimeType.toString());
      model ?? (model = EditProfilePageViewModel(this));
      return Scaffold(
        backgroundColor: getColorBg(),
        appBar: AppBar(
          title: Text(
            "Edit Profile",
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
            child: ListView(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              children: <Widget>[
                avtarView,
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: formView,
                ),
              ],
            )),
      );
    }
  }