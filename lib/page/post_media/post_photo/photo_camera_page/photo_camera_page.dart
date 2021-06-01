import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:testsylo/bloc_item/seek_bloc.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/common/zoomable_widget.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/page/post_media/post_photo/photo_camera_page/photo_camera_page_view_model.dart';
import 'package:testsylo/page/post_media/post_photo/review_photo_post_page/review_photo_post_page.dart';
import 'package:testsylo/util/navigate_effect.dart';
import 'package:testsylo/util/util.dart';
import '../../../../app.dart';

class PhotoCameraPage extends StatefulWidget {
  String from;
  List<PostPhotoModel> imagesList = List();

  PhotoCameraPage({this.from, this.imagesList});

  @override
  PhotoCameraPageState createState() => PhotoCameraPageState();
}

  class PhotoCameraPageState extends State<PhotoCameraPage> with TickerProviderStateMixin {
  PhotoCameraPageViewModel model;
  SeekBloc seekBloc = SeekBloc();

  void _changeCamera() async {
    //await model.bloc.changeCamera();
    await model.onCameraSwitch();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
    model.controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = PhotoCameraPageViewModel(this));
    double w = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        if (model.listTakedImages.length > 0) {
          await commonCupertinoDialogPage(
              context,
              commonDraftWarningCenterWidget(),
              positiveAction: () async {
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
        return;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              str_cam == "full default" ? Container(
                  constraints: BoxConstraints(
                    minWidth: w,
                    maxHeight: w*1.78
                  ),
                  child:getCamViewByStateNew(w)) : Container(),
              Container(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Positioned(
                      bottom: 25,
                      child: Container(
                        //color: Colors.green,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                alignment: Alignment.center,
                                height: 60,
                                margin: EdgeInsets.only(bottom: 4),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  physics: BouncingScrollPhysics(),
                                  itemCount:
                                  model.listTakedImages?.length ?? 0,
                                  shrinkWrap: true,
                                  itemBuilder: (c, i) {
                                    PostPhotoModel postPhotoModel = model
                                        .listTakedImages[i];
                                    return InkWell(
                                      child: postPhotoModel.isCircle
                                          ? ClipOval(
                                        child: Container(
                                            //padding: EdgeInsets.all(5),
                                            child: ClipOval(
                                              child: Container(
                                                color: colorOvalBorder,
                                                /*padding:
                                                EdgeInsets.all(2),*/
                                                child: ClipOval(
                                                  child: Image.file(
                                                    postPhotoModel
                                                        .image,
                                                    fit: BoxFit.cover,
                                                    width: 60,
                                                    height: 60,
                                                  ),
                                                ),
                                              ),
                                            )),
                                      )
                                          : Container(
                                          //padding: EdgeInsets.all(5),
                                          child: Container(
                                            color: colorOvalBorder,
                                            //padding: EdgeInsets.all(2),
                                            child: Image.file(
                                              postPhotoModel.image,
                                              fit: BoxFit.cover,
                                              width: 60,
                                              height: 60,
                                            ),
                                          )),
                                      onTap: () {
                                        /*zoomFileImageDialogue(
                                            context,
                                            ZoomableWidget(
                                              child: Image.file(
                                                postPhotoModel.image,
                                                fit: BoxFit.fill,
                                              ),
                                            ));*/
                                      },
                                    );
                                  },
                                )),
                            /*Container(
                              padding: EdgeInsets.only(top: 10),
                              child: Text("Photo",
                                  style: getTextStyle(
                                      color: Colors.white,
                                      size: 15,
                                      fontWeight: FontWeight.w500)),
                            ),*/
                            SizedBox(
                              height: 2,
                            ),
                            isDisplayRectagleButton() ? Center(
                              child: InkWell(
                                child: Container(
                                  //color: Colors.red,
                                  width: 42,
                                  height: 42,
                                  child: Image.asset(
                                    model.cameraState == CameraState.R
                                        ? App.ic_sq
                                        : App.ic_round_record,
                                    width: 42,
                                    height: 42,
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    if (model.cameraState ==
                                        CameraState.R) {
                                      model.cameraState = CameraState.S;
                                    } else {
                                      model.cameraState = CameraState.R;
                                    }
                                  });
                                },
                              ),
                            ) :
                            SizedBox(),
                            SizedBox(
                              height: 2,
                            ),
                            InkWell(
                              onTap: () async {
                                model.takePicture();
                              },
                              child: Container(
                                width: 64,
                                height: 64,
                                child: Image.asset(App.ic_play),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 48,
                      right: 8,
                      child: InkWell(
                        onTap: () {
                          _changeCamera();
                        },
                        child: Container(
                          //color: Colors.red,
                          child: Image.asset(
                            App.ic_change_cam,
                          ),
                          width: 36,
                          height: 22,
                          margin: EdgeInsets.only(top: 8),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 10,
                      bottom: 50,
                      child: InkWell(
                        child: model.capturePicPath.length >= 1
                            ? Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(top: 3),
                                child: Text("Add",
                                    style: getTextStyle(
                                        color: Colors.white,
                                        size: 15,
                                        fontWeight: FontWeight.w500)),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    right: 4, top: 6, bottom: 6, left: 2),
                                child: Image.asset(
                                  App.ic_right,
                                ),
                                width: 16,
                                height: 16,
                              ),
                            ],
                          ),
                        )
                            : SizedBox(height: 0, width: 0),
                        onTap: () async {
                          //
                          //model.capturePicPath.forEach((file) async {
                          for (var i = 0; i <
                              model.capturePicPath.length; i++) {

                            if(model.listTakedImages[i].isCircle)
                            {
                              File croppedFile=await ImageCropper.cropImage(
                                  sourcePath: model.capturePicPath[i].path,
                                  aspectRatioPresets: [
                                    CropAspectRatioPreset.square,

                                  ],
                                  cropStyle: CropStyle.circle,
                                  androidUiSettings: AndroidUiSettings(
                                      toolbarTitle: 'Edit Image',
                                      toolbarColor: colorDark,
                                      toolbarWidgetColor: Colors.white,
                                      initAspectRatio: CropAspectRatioPreset
                                          .square,
                                      lockAspectRatio: false,

                                  ),
                                  iosUiSettings: IOSUiSettings(
                                    title: "Edit Image",
                                    minimumAspectRatio: 1.0,
                                  )
                              );/*.then((value) =>
                              model.capturePicPath[i] = value);*/
                              model.capturePicPath[i]=croppedFile;
                              model.listTakedImages[i].image=croppedFile;
                              setState(() {});
                            }
                            else{
                              print("ImageCropped"+model.capturePicPath[i].path);
                              File croppedFile=await ImageCropper.cropImage(
                                  sourcePath: model.capturePicPath[i].path,
                                  aspectRatioPresets: [
                                    CropAspectRatioPreset.square,
                                    CropAspectRatioPreset.ratio3x2,
                                    CropAspectRatioPreset.original,
                                    CropAspectRatioPreset.ratio4x3,
                                    CropAspectRatioPreset.ratio16x9
                                  ],
                                  cropStyle: CropStyle.rectangle,
                                  androidUiSettings: AndroidUiSettings(
                                      toolbarTitle: 'Edit Image',
                                      toolbarColor: colorDark,
                                      toolbarWidgetColor: Colors.white,
                                      initAspectRatio: CropAspectRatioPreset
                                          .original,
                                      lockAspectRatio: false),
                                  iosUiSettings: IOSUiSettings(
                                    title: "Edit Image",
                                    minimumAspectRatio: 1.0,
                                  )
                              );/*.then((value) =>
                              model.capturePicPath[i] = value);*/

                              model.listTakedImages[i].image=croppedFile;
                              model.capturePicPath[i]=croppedFile;


                            }
                          }
                          model.gotoPhotoReviewPageProcess();
                        },
                      ),
                    )
                  ],
                ),
              ),
              InkWell(
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Image.asset(
                    App.ic_back_white,
                    fit: BoxFit.contain,
                    width: 16,
                    height: 16,
                  ),
                ),
                onTap: () async {
                  if (model.listTakedImages.length > 0) {
                    await commonCupertinoDialogPage(
                        context,
                        commonDraftWarningCenterWidget(),
                        positiveAction: () async {
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
              Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(top: 12),
                child: Text(
                  _getTitle(),
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 15),
                ),
              )
            ],
          ),
        ),
      ),
    );

  }

  String str_cam = "full default";

  getCamViewByStateNew(w) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    if (model.cameras == null) {
      return Container();
    }
    return Container(
        child:

    /*Builder(
          builder: (context) {
            if (str_cam == "full default") {
                  return */OverflowBox(
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        CameraPreview(model.controller),
                        model.cameraState == CameraState.R
                            ? ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(isBlackBG() ? 1 : 0.5),
                            BlendMode.srcOut,
                          ), // This one will create the magic
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  backgroundBlendMode: BlendMode.dstOut,
                                ), // This one will handle background + difference out
                              ),
                              ZoomableWidget(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    height: getWHByDeviceRatio(MediaQuery
                                        .of(context)
                                        .devicePixelRatio, w),
                                    width: getWHByDeviceRatio(MediaQuery
                                        .of(context)
                                        .devicePixelRatio, w),
                                    //margin: EdgeInsets.only(top: 98),
                                    child: ClipOval(
                                      child: Container(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                                //isScale: widget.from=="MyChannelPageState" ?  false : true,
                                isScale: false,
                              ),
                            ],
                          ),
                        )
                            : Container(),
                        IgnorePointer(
                          child: Container(
                            child: StreamBuilder<double>(
                                stream: seekBloc.controller,
                                builder: (context, snapshot) {
                                  return commonRecordCamDurationIndicator(
                                      snapshot.data == null ? 0.0 : snapshot
                                          .data,
                                      w / 1.05,
                                      3.0);
                                }),
                          ),
                        ),
                      ],
                    ),
                  ));
                /*}*/
                /*else {
                  return Container();
                }
              }),*/

  }

  bool isDisplayRectagleButton() {
    if (widget.from == "SignUpProfilePageState" ||
        widget.from == "EditProfilePageState") {
      return false;
    }
    return true;
  }

    bool isBlackBG() {
      if (widget.from == "SignUpProfilePageState" ||
          widget.from == "EditProfilePageState") {
        return true;
      }
      return false;
    }

    String _getTitle() {
      String _title = "Capture Photo";
      _title = _title + getSyloPostTitlesufix(appState.userSylo);
      return _title;
    }




  }