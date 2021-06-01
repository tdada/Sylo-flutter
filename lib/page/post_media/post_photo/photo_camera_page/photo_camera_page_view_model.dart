import 'dart:io';

import 'package:camera/camera.dart';
//import 'package:camera_camera/page/bloc/bloc_camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/draft_model.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/page/post_media/post_photo/photo_camera_page/photo_camera_page.dart';
import 'package:flutter/material.dart';
import 'package:testsylo/page/post_media/post_photo/review_photo_post_page/review_photo_post_page.dart';
import 'package:testsylo/util/navigate_effect.dart';
import 'package:testsylo/util/util.dart';
import '../../../../app.dart';

class PhotoCameraPageViewModel {
  PhotoCameraPageState state;
  CameraController controller;
  CameraDescription description;
  List<CameraDescription> cameras;
  int selectedCameraIndex=0;
  AnimationController textAnimOpacity;
  String pictureSavePath = '';
  List<File> capturePicPath = List<File>();
  List<PostPhotoModel> listTakedImages = List();
 // var bloc = BlocCamera();
  CameraState cameraState = CameraState.R;

  PhotoCameraPageViewModel(PhotoCameraPageState state) {
    this.state = state;
    textAnimOpacity = AnimationController(
        vsync: this.state, duration: Duration(milliseconds: 800));
    initCam();
  }

  /*initCam() async {
    *//*if (bloc.controllCamera != null) {
      //controller.dispose();
    }
    *//**//*controller = CameraController(description, ResolutionPreset.high);
    controller.initialize().then((_) {
      state.setState(() {});
    });*//**//*

    bloc.getCameras();
    bloc.cameras.listen((data) {
      bloc.controllCamera = CameraController(
        data[1],
        ResolutionPreset.high,
      );
      bloc.cameraOn.sink.add(0);
      bloc.controllCamera.initialize().then((_) {
        bloc.selectCamera.sink.add(true);
        bloc.changeCamera();
        //if (widget.initialCamera == CameraSide.front) bloc.changeCamera();
        state.setState(() {});

      });
    });*//*
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

  }*/

  initCam() async {
    if (cameras == null) {
      cameras = await availableCameras();
      cameras.forEach((f) {
        print(f.name);
        print(f.lensDirection);
      });
    }

    cameras = cameras.reversed.toList();

    description = cameras[0];

    if (controller != null) {
      controller.dispose();
    }


    controller = CameraController(description, ResolutionPreset.high);

    await controller.initialize().then((value) => {
    state.setState(() {
    })
    });


    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  takePicture() async {
    try {
      Directory appDocDirectory;
      if (Platform.isIOS) {
        appDocDirectory = await getTemporaryDirectory();
      } else {
        appDocDirectory = await getExternalStorageDirectory();
      }
      // can add extension like ".mp4" ".wav" ".m4a" ".aac"
      pictureSavePath = appDocDirectory.path +
          "/" +
          DateTime.now().millisecondsSinceEpoch.toString() +
          ".jpg";

      var path=await controller.takePicture();
      pictureSavePath=await path.path;
      print("Take a pic Path >> $pictureSavePath");
      File rotatedFile = await FlutterExifRotation.rotateImage(path: pictureSavePath);

      File _image = rotatedFile.renameSync(pictureSavePath);
      capturePicPath.add(
//          File(pictureSavePath)
          _image
      );
      listTakedImages.add(PostPhotoModel(image:
//      File(pictureSavePath)
          _image
          , isCircle: cameraState == CameraState.R));
      state.setState(() {});
      if (state.widget.from == "SignUpProfilePageState" ||
          state.widget.from == "EditProfilePageState") {
        Navigator.pop(state.context, capturePicPath[0]);
      } else {
        if (capturePicPath.length >= 4) {
          //gotoPhotoReviewPageProcess();
          for (var i = 0; i < capturePicPath.length; i++) {
            if(listTakedImages[i].isCircle)
              {
                File croppedFile= await ImageCropper.cropImage(
                    sourcePath: capturePicPath[i].path,
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
                        lockAspectRatio: false),
                    iosUiSettings: IOSUiSettings(
                      title: "Edit Image",
                      minimumAspectRatio: 1.0,
                    )
                );/*.then((value) =>
                capturePicPath[i] = value);*/
                listTakedImages[i].image=croppedFile;
                capturePicPath[i]=croppedFile;
              }
            else{
              File croppedFile=await ImageCropper.cropImage(
                  sourcePath: capturePicPath[i].path,
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
              capturePicPath[i] = value);*/
              listTakedImages[i].image=croppedFile;
              capturePicPath[i]=croppedFile;
            }

          }
          await gotoPhotoReviewPageProcess();
        }
      }
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
  }

  gotoPhotoReviewPageProcess() async {
    List<PostPhotoModel> photoList = List();

    if (state.widget.imagesList != null) {
      photoList = state.widget.imagesList;
    }
//    capturePicPath.forEach((element) {
//      photoList.add(PostPhotoModel(image: element, isCircle: true));
//    });
    photoList.addAll(listTakedImages);


    Navigator.pop(
        state.context,
        await Navigator.push(
            state.context,
            NavigatePageRoute(
                state.context, ReviewPhotoPostPage(pickedImages: photoList))));
  }

  saveAsDraft() async {
    List<String> mediaList = await savePhotoAsDraft(
        myDraft: MyDraft(mediaType: App.MediaTypeMap["photo"]),
        photoList: listTakedImages
    );
    if(mediaList.length>0) {
      commonToast("successfully saved as Draft");
      goToHome(state.context, null);
    }
  }

   onCameraSwitch() async {
    final CameraDescription cameraDescription =
    (controller.description == cameras[0]) ? cameras[1] : cameras[0];
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(cameraDescription, ResolutionPreset.max);
    controller.addListener(() {
      if (state.mounted) state.setState(() {});
      if (controller.value.hasError) {
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
    }

    if (state.mounted) {
      state.setState(() {});
    }
  }
}
