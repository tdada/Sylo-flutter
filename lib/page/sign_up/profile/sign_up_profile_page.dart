import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/api_request.dart';
import 'package:testsylo/page/post_media/post_photo/photo_camera_page/photo_camera_page.dart';
import 'package:testsylo/page/sign_up/profile/sign_up_profile_page_view_model.dart';
import 'package:testsylo/page/sign_up/profile/sign_up_verification_sent_page.dart';
import 'package:testsylo/util/navigate_effect.dart';
import '../../../app.dart';

class SignUpProfilePage extends StatefulWidget {
  AddUserItem addUserItem;

  SignUpProfilePage(this.addUserItem);

  @override
  SignUpProfilePageState createState() => SignUpProfilePageState();
}

  class SignUpProfilePageState extends State<SignUpProfilePage> {
    SignUpProfilePageViewModel model;
    SoundTapState soundTapState = SoundTapState.None;

    get onPressedContinue =>
            () async {
          model.callPostAddUser();
        };

    get pickProfile =>
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
                setState(() {
                  model.profileImage.path = _image;
                  model.profileFile = _image;
                });
              }
            } catch (e) {}
          },
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ClipOval(
                child: Container(
                  /*decoration: BoxDecoration(
                      gradient:
                      getTapBackColor(
                          soundTapState == SoundTapState.S, colorLightRound)),*/
                  decoration: BoxDecoration(
                      gradient:
                      getTapBackColor(
                          soundTapState == SoundTapState.S, colorLightRound)),
                  padding: EdgeInsets.all(2),
                  /*color: colorHover,*/
                  child: ClipOval(
                    //borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: <Widget>[
                        Container(
                            width: 140,
                            height: 140,
                            child: model.profileImage.path == null
                                ? Container(
                              child: Center(
                                child: Opacity(
                                  child: Image.asset(
                                    App.ic_sylo_pick,
                                    width: 50,
                                    height: 50,
                                    color: getTapWhiteIconColor(
                                        soundTapState == SoundTapState.L,
                                        null),
                                  ),
                                  opacity: 0.5,
                                ),
                              ),
                            ) : fileWidget(
                                model.profileImage.path, 140.0, 140.0)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

    get pickCam =>
        InkWell(
          onTap: () async {
            var result = await Navigator.push(
                context,
                NavigatePageRoute(
                    context, PhotoCameraPage(from: runtimeType.toString())));
            if(result!=null) {
              setState(() {
                model.profileFile = result;
                model.profileImage.path = result;
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
                            width: 105,
                            height: 105,
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
                                      width: 55,
                                      height: 40,
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
                            )),
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
                setState(() {
                  model.profileImage.path = _image;
                  model.profileFile = _image;
                });
              }
            } catch (e) {}
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
                            width: 105,
                            height: 105,
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
                                      width: 55,
                                      height: 40,
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
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

    @override
    Widget build(BuildContext context) {
      print("runtimeType -> " + runtimeType.toString());
      model ?? (model = SignUpProfilePageViewModel(this));
      return Scaffold(
        backgroundColor: getColorBg(),
        appBar: AppBar(
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
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 8,),
                  alignment: Alignment.center,
                  child: Text(
                    "To begin you will need to setup your\nSylo Profile",
                    style: getTextStyle(color: Colors.black,
                        size: 15,
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,),
                ),
                SizedBox(height: 25),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        pickProfile,
                        SizedBox(height: 16,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            pickCam,
                            pickLib,
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: commonButton(onPressedContinue, "Continue"),
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),),
              ],
            ),
          ),
        ),
      );
    }
  }