import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/page/post_media/post_photo/photo_sylo_page/sylo_library_page.dart';
import 'package:testsylo/page/post_media/post_photo/post_photo_page_view_model.dart';
import 'package:testsylo/util/navigate_effect.dart';
import 'package:testsylo/util/util.dart';
import '../../../app.dart';
import 'photo_camera_page/photo_camera_page.dart';
import 'review_photo_post_page/review_photo_post_page.dart';

class PhotoPostPage extends StatefulWidget {
  @override
  PhotoPostPageState createState() => PhotoPostPageState();
}

  class PhotoPostPageState extends State<PhotoPostPage> {
    PhotoPostPageViewModel model;
    SoundTapState soundTapState = SoundTapState.None;

    get pickCam =>
        InkWell(
          onTap: () async {
            setState(() {
              soundTapState = SoundTapState.R;
            });
            await Future.delayed(Duration(milliseconds: startDur));
            var result = await Navigator.push(
                context,
                NavigatePageRoute(
                    context, PhotoCameraPage(imagesList: model.photoList)));
            if (result != null) {
              model.photoList = result;
            } else {
              model.photoList = List();
            }
            await Future.delayed(Duration(milliseconds: endDur));
            setState(() {
              soundTapState = SoundTapState.None;
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ClipOval(
                child: Container(
                  padding: EdgeInsets.all(2),
//            color: colorLightRound,
                  decoration: BoxDecoration(
                      gradient:
                      getTapBackColor(
                          soundTapState == SoundTapState.R, colorLightRound)),
                  child: ClipOval(
                    //borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: <Widget>[
                        Container(
                            width: 175,
                            height: 175,
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
                                      width: 60,
                                      height: 45,
                                      color: getTapWhiteIconColor(
                                          soundTapState == SoundTapState.R,
                                          null),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Center(
                                        child: Text(
                                          "Camera",
                                          textAlign: TextAlign.center,
                                          style: getTextStyle(
                                              size: 15,
                                              color: getTapWhiteLabelColor(
                                                  soundTapState ==
                                                      SoundTapState.R,
                                                  Colors.black),
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

            setState(() {
              soundTapState = SoundTapState.L;
            });
            await Future.delayed(Duration(milliseconds: startDur));
//    choose multiple
            try {
              FilePickerResult _result = await FilePicker.platform.pickFiles(
                  allowMultiple: true, type: FileType.image);
              if (_result != null && _result.paths.length > 0) {
                await ImageCropper.cropImage(
                    sourcePath: _result.paths[0],
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
                    )
                ).then((file) async {
                  if (file == null) return;
                  _result.paths[0] = file.path;
                  //_path[0] = file;
                  List<File> files = new List<File>();
                  files.add(new File(_result.paths[0]));
                  await model.getSelectedImageList(files);
                  var result = await Navigator.push(
                      context,
                      NavigatePageRoute(
                          context,
                          ReviewPhotoPostPage(pickedImages: model.photoList)));
                  if (result != null) {
                    model.photoList = result;
                  } else {
                    model.photoList = List();
                  }
                });
              }
            } catch (e) {}
            await Future.delayed(Duration(milliseconds: endDur));
            setState(() {
              soundTapState = SoundTapState.None;
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ClipOval(
                child: Container(
                  padding: EdgeInsets.all(2),
//            color: colorLightRound,
                  decoration: BoxDecoration(
                      gradient:
                      getTapBackColor(
                          soundTapState == SoundTapState.L, colorLightRound)),
                  child: ClipOval(
                    //borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: <Widget>[
                        Container(
                            width: 140,
                            height: 140,
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
                                      width: 60,
                                      height: 45,
                                      color: getTapWhiteIconColor(
                                          soundTapState == SoundTapState.L,
                                          null),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Center(
                                        child: Text(
                                          "Library",
                                          textAlign: TextAlign.center,
                                          style: getTextStyle(
                                              size: 15,
                                              color: getTapWhiteLabelColor(
                                                  soundTapState ==
                                                      SoundTapState.L,
                                                  Colors.black),
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

    get pickSylo =>
        InkWell(
          onTap: () async {
            setState(() {
              soundTapState = SoundTapState.S;
            });
            await Future.delayed(Duration(milliseconds: startDur));
            var resultt = await Navigator.push(
                context,
                NavigatePageRoute(
                    context, SyloLibraryPage("PHOTO")));
            if (resultt != null) {
              var result = await Navigator.push(
                  context,
                  NavigatePageRoute(
                      context, ReviewPhotoPostPage(pickedImages: resultt)));
              print("Im Here");
              if (result != null) {
                model.photoList = result;
              } else {
                model.photoList = List();
              }
            }
            await Future.delayed(Duration(milliseconds: endDur));
            setState(() {
              soundTapState = SoundTapState.None;
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ClipOval(
                child: Container(
                  padding: EdgeInsets.all(2),
//            color: colorLightRound,
                  decoration: BoxDecoration(
                      gradient:
                      getTapBackColor(
                          soundTapState == SoundTapState.S, colorLightRound)),
                  child: ClipOval(
                    //borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: <Widget>[
                        Container(
                            width: 140,
                            height: 140,
                            child: Container(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      App.ic_sylo_pick,
                                      width: 60,
                                      height: 45,
                                      color: getTapWhiteIconColor(
                                          soundTapState == SoundTapState.S,
                                          null),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Center(
                                        child: Text(
                                          App.app_name,
                                          textAlign: TextAlign.center,
                                          style: getTextStyle(
                                              size: 15,
                                              color: getTapWhiteLabelColor(
                                                  soundTapState ==
                                                      SoundTapState.S,
                                                  Colors.black),
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
      model ?? (model = PhotoPostPageViewModel(this));
      return Scaffold(
        backgroundColor: getColorBg(),
        appBar: AppBar(
          title: Text(
            "Photo Post" + getSyloPostTitlesufix(appState.userSylo),
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
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 125,
                        ),
                        pickCam,
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            pickSylo,
                            pickLib,
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }