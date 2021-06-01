import 'dart:io';
import 'dart:typed_data';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/model/prompt_item.dart';
import 'package:testsylo/model/question_item.dart';
import 'package:testsylo/model/record_file_item.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../app.dart';

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

Connectivity connectivity = Connectivity();

Future<bool> isConnectNetworkWithMessage(BuildContext context) async {
  var connectivityResult = await connectivity.checkConnectivity();
  bool isConnect = getConnectionValue(connectivityResult);
  if (!isConnect) {
    commonMessage(
      context,
      "Network connection required to fetch data.",
    );
  }
  return isConnect;
}

Future<bool> isConnectNetwork(BuildContext context) async {
  var connectivityResult = await connectivity.checkConnectivity();
  bool isConnect = getConnectionValue(connectivityResult);
  return isConnect;
}

// Method to convert the connectivity to a string value
bool getConnectionValue(var connectivityResult) {
  bool status = false;
  switch (connectivityResult) {
    case ConnectivityResult.mobile:
      status = true;
      break;
    case ConnectivityResult.wifi:
      status = true;
      break;
    case ConnectivityResult.none:
      status = false;
      break;
    default:
      status = false;
      break;
  }
  return status;
}

loadPdfViewer(String path) {}

openKeyBoard(BuildContext context, FocusNode focusNode) {
  FocusScope.of(context).requestFocus(focusNode);
  // SystemChannels.textInput.invokeMethod('TextInput.hide');
}

hideFocusKeyBoard(c) {
  FocusScope.of(c).requestFocus(FocusNode());
}

getDirPath() {
  if (Platform.isAndroid) {
    return Directory("/storage/emulated/0/Download/" + App.app_name);
  } else {
    return getTemporaryDirectory();
  }
}

Future<void> checkPermission() async {
  PermissionStatus status = await Permission.storage.status;
  if (!status.isGranted) {
    await Future.delayed(Duration(milliseconds: 150));
    await Permission.storage.request();
  }
}

Future<List<Uint8List>> generateVideoThumbnail(
    File videoFile, int numberOfThumbnails,
    {int quality = 75}) async {
  final String _videoPath = videoFile.path;
  VideoPlayerController videoPlayerController;
  videoPlayerController = VideoPlayerController.file(videoFile);
  print(videoPlayerController);
  int videoDuration = videoPlayerController.value.duration.inMilliseconds;

  double _eachPart = videoDuration / numberOfThumbnails;

  List<Uint8List> _byteList = [];

  for (int i = 1; i <= numberOfThumbnails; i++) {
    Uint8List _bytes;
    _bytes = await VideoThumbnail.thumbnailData(
      video: _videoPath,
      imageFormat: ImageFormat.JPEG,
      timeMs: (_eachPart * i).toInt(),
      quality: quality,
    );

    _byteList.add(_bytes);
  }
  return _byteList;
}

Future<void> writeToFile(Uint8List data, String path) {
  print("Byte saved path -> $path");
  final buffer = data.buffer;
  return new File(path)
      .writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
}

Future<File> saveByteFile(unit8List) async {
  Directory appDocDirectory;
  appDocDirectory = await getTemporaryDirectory();
  String path = appDocDirectory.path +
      "/" +
      DateTime.now().millisecondsSinceEpoch.toString() +
      ".jpg";
  await writeToFile(unit8List, path);
  return File(path);
}

getPromptsQuestionListFromPromptsList(List<PromptItem> listPrompt) {
  List<String> promptsQuestionList = List();
  if (listPrompt != null) {
    listPrompt.forEach((element) {
      promptsQuestionList.addAll(element.prompts);
    });
  }
  return promptsQuestionList;
}

Future<File> getVideoThumbFileFromRecordFileItem(
    BuildContext _context, RecordFileItem recordFileItem) async {
  if (recordFileItem?.file != null) {
    showLoader(_context, label: "Generating Thumbnail");
    Uint8List byteArry = await generateThumbnailFromVideo(recordFileItem.file);
    File file = await saveByteFile(byteArry);
    hideLoader();
    return file;
  } else if (recordFileItem?.link != null) {
    return recordFileItem.thumbPath;
  }
  return null;
}

getTimeStringFromQcastQuestions(List<QuestionItem> listQuestion) {
  if (listQuestion != null) {
    List<String> strtTimeList = List();
    listQuestion.forEach((element) {
      strtTimeList.add(element.start_time.toString());
    });
    return strtTimeList.join(",");
  }
  return "";
}

String getSyloPostTitlesufix(GetUserSylos userSylo) {
  String syloNameStr = "";
  if (!isQuickPost && userSylo != null && userSylo.syloName.isNotEmpty) {
    syloNameStr = " / " + userSylo.syloName.trim().split(" ").first;
  }
  return syloNameStr;
}

String getMultilineFixCharacter(String _name,
    {int length = 12, int maxLimit = 12}) {
  StringBuffer sb = new StringBuffer();
  List<String> readLines =
      splitStringByLength(_name, length, maxLimit: maxLimit);
  for (String line in readLines) {
    sb.write(line + "\n");
  }
  return sb.toString();
}

List<String> splitStringByLength(String str, int length, {int maxLimit = 28}) {
  if (str.length <= length) {
    return [str];
  } else if (str.length <= maxLimit) {
    return [str.substring(0, length), str.substring(length)];
  }
  return [str.substring(0, length), str.substring(length, maxLimit)];
}
