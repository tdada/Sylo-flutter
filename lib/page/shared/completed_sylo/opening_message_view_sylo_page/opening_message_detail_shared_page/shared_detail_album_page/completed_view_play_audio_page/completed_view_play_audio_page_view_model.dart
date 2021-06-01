import 'package:flutter/material.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';

import '../../../../../../../app.dart';
import 'completed_view_play_audio_page.dart';

class CompletedViewPlayAudioPageViewModel {
  CompletedViewPlayAudioPageState state;
  InterceptorApi interceptorApi;
  SubAlbumData subAlbumData = SubAlbumData();
  List<String> tagList = List();

  CompletedViewPlayAudioPageViewModel(this.state){
    interceptorApi = InterceptorApi(context: state.context);
    if (state.widget.from == "SyloAlbumDetailPageState" || state.widget.from == "SharedDetailAlbumPageState") {
      getSubAlbumData();
    } else {
      initImageModel();
    }
  }

  initImageModel() {
    subAlbumData = SubAlbumData(
        title: "Mommy's Boy",
        postedDate:
        App.getDateByFormat(DateTime.now(), App.formatMMMDDYY).toString(),
        mediaUrls: [
          "https://firebasestorage.googleapis.com/v0/b/tranform-9a6c6.appspot.com/o/alarm_sound%2FMelody%20Of%20My%20Dreams.mp3?alt=media&token=bda8fa01-c963-49ee-8005-b7266930e482",
        ]);
    tagList.add("birthday");
    tagList.add("party");
    tagList.add("holiday");
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
      state.setState(() {});
    }
  }

  callDeleteSubAlbum() async {
    Navigator.pop(state.context);
    if(subAlbumData.subAlbumId!=null){
      bool isDelete = await interceptorApi.callDeleteSubAlbum(subAlbumData.subAlbumId);
      if (isDelete != null && isDelete==true) {
        commonToast("Deleted successfully");
        Navigator.pop(state.context, true);
      }
    }
  }

}
