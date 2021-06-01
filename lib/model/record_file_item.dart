import 'dart:io';

import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'draft_model.dart';

class RecordFileItem {
  File file;
  File thumbPath;
  File thumbPath1;
  double aspectRatio = 0.0;
  String link;
  RecordFileItem(this.file, this.aspectRatio, {this.link, this.thumbPath});

  factory RecordFileItem.fromMyDraftMedia(MyDraftMedia myDraftMedia) =>
      RecordFileItem(
        myDraftMedia.image != null ? File(myDraftMedia.image) : null,
        null,
        link: myDraftMedia.link,
      );

  Future<File> get videoThumb async {
    if (thumbPath != null) {
      return thumbPath;
    }

    String pathStr = await VideoThumbnail.thumbnailFile(
      video: file.path,
      imageFormat: ImageFormat.PNG,
    );


    thumbPath = File(pathStr);
    return thumbPath;
  }

  Future<File> get videoThumb1 async {
    if (thumbPath != null) {
      return thumbPath;
    }

    String pathStr = await VideoThumbnail.thumbnailFile(
      video: file.path,
      imageFormat: ImageFormat.PNG,
    );


    thumbPath = File(pathStr);
    return thumbPath;
  }

  List<File> listThumb;

  Future<List<File>> get getAllThumb async {
    listThumb = List();

    for (int i = 0; i < 5; i++) {
      String pathStr = await VideoThumbnail.thumbnailFile(
          video: file.path, timeMs: i * 1000);
      listThumb.add(File(pathStr));

    }

    return listThumb;
  }
}
