import 'package:flutter/material.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/api_request.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';

import '../../../../../../../app.dart';
import 'completed_view_video_page.dart';

class CompletedViewVideoPageViewModel {
  CompletedViewVideoPageState state;
  InterceptorApi interceptorApi;
  SubAlbumData subAlbumData = SubAlbumData();
  CreateQcastItem selectedQcastItem = CreateQcastItem();
  List<String> tagList = List();
  List<String> queLink = List();
  List<int> strtTimingList = List();

  CompletedViewVideoPageViewModel(this.state){
    interceptorApi = InterceptorApi(context: state.context);
    if (state.widget.from == "SyloAlbumDetailPageState" || state.widget.from == "SharedDetailAlbumPageState") {
      getSubAlbumData();
    } else {
      initImageModel();
    }

  }

  initImageModel() {
    subAlbumData = SubAlbumData(
        title: "My 1st Qcast Interview",
        postedDate:
        App.getDateByFormat(DateTime.now(), App.formatMMMDDYY).toString(),
        mediaUrls: [
          "https://sylomediastorage.s3.eu-west-2.amazonaws.com/video1.mp4",
        ],
        qcastCoverPhoto: "https://i.picsum.photos/id/241/300/300.jpg",
        coverPhoto: "https://i.picsum.photos/id/721/300/300.jpg",
    );
    tagList.add("birthday");
    tagList.add("party");
    tagList.add("holiday");
    queLink.add("https://sylomediastorage.s3.eu-west-2.amazonaws.com/video2.mp4");
  }

  getSubAlbumData() async {
    if (state.widget.albumMediaData.subAlbumId != null) {
      subAlbumData = await interceptorApi.callGetSubAlbumData(
          state.widget.albumMediaData.subAlbumId.toString());
      if (subAlbumData == null) {
        subAlbumData = SubAlbumData();
      }
      if (subAlbumData.tag != null && subAlbumData.tag != "") {
        tagList = subAlbumData.tag.split(',');
      }
      subAlbumData.mediaUrls[0] = getMediaUrl(subAlbumData.mediaUrls[0]);
      List<String> srtTimingStrList= subAlbumData.qcastDuration.split(",");
      strtTimingList = srtTimingStrList.map((e) => int.parse(e)).toList();
      getQcast(subAlbumData.qcastId);
      state.setState(() {});
    }
  }

  getQcast(int qcasId) async {
    var data = await interceptorApi.callGetQcastDeepCopy(
        qcasId.toString(),
        appState.userItem.userId.toString(),
        false);
    if (data != null) {

      selectedQcastItem = CreateQcastItem.fromJson(data);

      print("createQcastItem for DeepCopy -> " + selectedQcastItem.toMap().toString());
      queLink = selectedQcastItem.listOfVideo;
      state.setState(() { });
    }
  }

  getMediaUrl(String link) {
    String mediaUrl = "";
    if(link[0]=="0" || link[0]=="1") {
      var arr = link.split('@');
      if (arr.length > 1) {
        mediaUrl = arr[1];
      } else {
        mediaUrl = arr[0];
      }
    }
    return mediaUrl;
  }

  callDeleteSubAlbum() async {
    Navigator.pop(state.context);
    if(subAlbumData.subAlbumId!=null){
      bool isDelete = await interceptorApi.callDeleteSubAlbum(subAlbumData.subAlbumId);
      if (isDelete != null && isDelete==true) {
        commonToast("Deleted successfully");
      }
      Navigator.pop(state.context, true);
    }
  }
}