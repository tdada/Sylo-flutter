import 'dart:io';

import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class RecordFileWithRatioItem {
  File file;
  double aspectRatio = 0.0;
  RecordFileWithRatioItem(this.file, this.aspectRatio);
}
