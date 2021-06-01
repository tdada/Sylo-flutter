import 'dart:io';

import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/page/post_media/post_photo/post_photo_page.dart';

class PhotoPostPageViewModel {
  PhotoPostPageState state;
  List<PostPhotoModel> photoList = List();
  PhotoPostPageViewModel(this.state);

  Future getSelectedImageList(List<File> _path) async {
    _path.forEach((element) async {
      File _image = (await FlutterExifRotation.rotateImage(path: element.path)).renameSync(element.path);
      photoList.add(PostPhotoModel(image: _image, isCircle: false));
    });
  }

}
