import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/model/prompt_item.dart';
import 'package:testsylo/model/record_file_with_ratio_item.dart';
import 'package:testsylo/page/common/add_prompt_page.dart';
import 'package:testsylo/page/common/add_question_page.dart';
import 'package:testsylo/page/common/add_tag_page.dart';
import 'package:testsylo/page/common/choose_album_page/choose_album_page.dart';
import 'package:testsylo/page/common/cupertino_dialog_page.dart';
import 'package:testsylo/page/common/delete_sylo_page.dart';
import 'package:testsylo/page/common/edit_prompt_page.dart';
import 'package:testsylo/page/common/success_message_page.dart';
import 'package:testsylo/page/common/thumbnail_page.dart';
import 'package:testsylo/page/dashboard/dashboard_page.dart';
import 'package:testsylo/page/dashboard/qcam_tab/qcam_page.dart';
import 'package:testsylo/page/log_in/login_page.dart';
import 'package:testsylo/page/post_media/post_photo/post_photo_page.dart';
import 'package:testsylo/page/post_media/post_song/song_post_page.dart';
import 'package:testsylo/page/post_media/post_sound_bite/post_sound_bite_page.dart';
import 'package:testsylo/page/post_media/post_sound_bite/sound_bite_trim_page/sound_bite_trim_page.dart';
import 'package:testsylo/page/post_media/post_text/edit_letter_post_page.dart';
import 'package:testsylo/page/post_media/post_video/post_video_page.dart';
import 'package:testsylo/page/post_media/reposts_page/reposts_page.dart';
import 'package:testsylo/page/qcast/qcat_tab/discover_page/record_qcast/record_qcast_page.dart';
import 'package:testsylo/page/qcast/qcat_tab/discover_page/record_qcast_list/record_qcast_list_page.dart';
import 'package:testsylo/page/qcast/qcat_tab/discover_page/subscriptions_list/detail_page/qcasts_subscribe_page/qcasts_subscribe_page.dart';
import 'package:testsylo/page/qcast/qcat_tab/discover_page/subscriptions_list/detail_page/subscriptions_detail_page.dart';
import 'package:testsylo/page/qcast/qcat_tab/questions_page/que_ans_record/que_ans_record_page.dart';
import 'package:testsylo/page/qcast/qcat_tab/questions_page/que_ans_record_edit/que_ans_record_edit_page.dart';
import 'package:testsylo/page/sylo/view_sylo_page/sylo_album_page/sylo_album_detail_page/sylo_album_detail_page.dart';
import 'package:testsylo/util/navigate_effect.dart';

import '../app.dart';
import 'loader_page.dart';

goToVideoPostPage(context) async {
  isQuickPost = false;
  appState.selectedDownloadedQcast = null;
  if (context.widget.runtimeType.toString() == "SyloActionCircularPage") {
    isQuickPost = true;
  }
  var result = await Navigator.push(
      context, NavigatePageRoute(context, PostVideoPage()));
}

goToTextPostPage(BuildContext context) async {
  isQuickPost = false;
  if (context.widget.runtimeType.toString() == "SyloActionCircularPage") {
    isQuickPost = true;
  }
  var result = await Navigator.push(
      context, NavigatePageRoute(context, EditLetterPostPage()));
}

goToSoundBitePage(context) async {
  isQuickPost = false;
  if (context.widget.runtimeType.toString() == "SyloActionCircularPage") {
    isQuickPost = true;
  }
  var result = await Navigator.push(
      context, NavigatePageRoute(context, PostSoundBitePage()));
}

goToPhotoPostPage(context) async {
  isQuickPost = false;
  if (context.widget.runtimeType.toString() == "SyloActionCircularPage") {
    isQuickPost = true;
  }
  var result = await Navigator.push(
      context, NavigatePageRoute(context, PhotoPostPage()));
}

goToRePostPage(context) async {
  isQuickPost = false;
  if (context.widget.runtimeType.toString() == "SyloActionCircularPage") {
    isQuickPost = true;
  }
  var result =
      await Navigator.push(context, NavigatePageRoute(context, RepostsPage()));
}

goToSongPostPage(context) async {
  isQuickPost = false;
  if (context.widget.runtimeType.toString() == "SyloActionCircularPage") {
    isQuickPost = true;
  }
  var result =
      await Navigator.push(context, NavigatePageRoute(context, SongPostPage()));
}

goToHome(context, from) async {
  Navigator.pushAndRemoveUntil(
      context,
      App.createRoute(page: DashBoardPage(from: from)),
      (Route<dynamic> route) => false);
}


goToSpecificTabOfHome(context, homePageIndex, subPageIndex) {
  Navigator.pushAndRemoveUntil(
      context,
      App.createRoute(
          page: DashBoardPage(
              initIndex: homePageIndex ?? 0, subInitIndex: subPageIndex ?? 0)),
      (Route<dynamic> route) => false);
}

goToRecordQCastPage(context, from, list) async {
  //

  var result = await Navigator.push(
      context, NavigatePageRoute(context, RecordQcastPage(from, list, null)));
}



goToRecordQCamPage(context, from, list) async {
  //

  var result = await Navigator.push(
      context, NavigatePageRoute(context, QcamPage(from, list, null)));
}



goToQueAnsPage(context, from, listQ) async {
  var result = await Navigator.push(
      context, NavigatePageRoute(context, QueAnsRecordPage(from, listQ)));
}

goToTrimVideo(context, from, List<RecordFileWithRatioItem> listRecording, listQuestion, CameraState cameraState) async {
  var result = await Navigator.push(
      context,
      NavigatePageRoute(
          context,
          QueAnsRecordEditPage(
              listRecording, from, listQuestion, cameraState)));
}

goToRecordVideoListDeletePage(
    context,
    from,
    List<RecordFileWithRatioItem> listRecording,
    listPrompt,
    cameraState) async {
  var result = await Navigator.push(
      context,
      NavigatePageRoute(context,
          RecordQcastListPage(listRecording, from, listPrompt, cameraState)));
}

goToAddQue(context) {
  showDialog(
    context: context,
    builder: (BuildContext context) => AddQuestionPage(),
  );
}

createNewPrompt(context) {
  showDialog(
    context: context,
    builder: (BuildContext context) => AddPromptPage(),
  );
}

editNewPrompt(context, String item) {
  showDialog(
    context: context,
    builder: (BuildContext context) => EditPromptPage(text: item),
  );
}

showThumbnailListByStatus(context, status, listRecordWithThumb, callback,
    getSelectIndex, videoIndex) {
  showDialog(
      context: context,
      builder: (BuildContext context) => ThumbnailPage(
            status,
            listRecordWithThumb,
            callback: callback,
            getSelectIndex: getSelectIndex,
            videoIndex: videoIndex,
          ));
}

BuildContext c;
showLoader(context, {String label}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      c = context;
      return LoaderPage(label: label);
    },
  );
}

hideLoader() {
  Navigator.pop(c);
}

deleteSyloPage(context) async {
  var result = await showDialog(
    context: context,
    builder: (BuildContext context) => DeleteSyloPage(),
  );
  return result;
}

goToAddTag(context, Function(String) callback) {
  showDialog(
    context: context,
    builder: (BuildContext context) => AddTagPage(callback),
  );
}

goToTrimAudio(context, path, t, {from, imageList}) async {
  var result = await Navigator.push(
      context,
      NavigatePageRoute(context,
          SoundBiteTrimPage(path, t, from: from, listImages: imageList)));
}

goToChooseSyloPage(context, post_type, {selectedSyloList}) async {
  var result = await Navigator.push(
      context,
      NavigatePageRoute(
          context,
          ChooseAlbumPage(
            post_type: post_type,
            selectedSyloList: selectedSyloList,
          )));
  return result;
}



goToSubscription(context, discoverQcastItem) async {
  var result = await Navigator.push(
      context,
      NavigatePageRoute(
          context, QcastsSubscribePage(discoverQcastItem: discoverQcastItem)));
  return result;
}

goToDescriptionPage(context, discoverQcastItem, {isAllowUserView}) async {
  var result = await Navigator.push(
      context,
      NavigatePageRoute(
          context,
          SubscriptionsDetailPage(
              discoverQcastItem: discoverQcastItem,
              isAllowUserView: isAllowUserView ?? false)));
  return result;
}

goToLoginPage(context) async {
  Navigator.pushAndRemoveUntil(context, App.createRoute(page: LogInPage()),
      (Route<dynamic> route) => false);
}

successMessageDialog(context, String message) async {
  showDialog(
    context: context,
    builder: (BuildContext context) => SuccessMessageDialog(message),
  );
}

goToAlbumDetailPage(context, GetAlbum getAlbum, String from,
    GetUserSylos userSylo, callBack) async {
  var result = await Navigator.push(
      context,
      NavigatePageRoute(
          context,
          SyloAlbumDetailPage(
              getAlbum: getAlbum,
              from: from,
              userSylo: userSylo,
              callBack: callBack)));
}

commonCupertinoDialogPage(context, centerWidget,
    {positiveAction, negativeAction, negativeActionLabel}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) => CupertinoDialogPage(
        centerWidget: centerWidget,
        positiveAction: positiveAction,
        negativeAction: negativeAction,
        negativeActionLabel: negativeActionLabel),
  );
}
