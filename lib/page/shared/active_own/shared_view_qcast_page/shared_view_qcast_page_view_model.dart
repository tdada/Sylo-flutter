import 'package:flutter/material.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/page/shared/active_own/shared_view_qcast_page/shared_view_qcast_page.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';

import '../../../../app.dart';

class SharedViewQcastPageViewModel {
  SharedViewQcastPageState state;
  InterceptorApi interceptorApi;
  SubAlbumData subAlbumData = SubAlbumData();
  List<String> tagList = List();
  bool disableAddQcast = false;
  List<CompletedSyloImageModel> listImages = List();

  SharedViewQcastPageViewModel(this.state){
    interceptorApi = InterceptorApi(context: state.context);
    if (state.widget.from == "SyloAlbumDetailPageState" || state.widget.from == "SharedDetailAlbumPageState") {
      getSubAlbumData();
    } else if(state.widget.from == "ActiveSyloSharedOwnPageState") {
      getSyloQuestion();
    } else {
      initImageModel();
    }
  }

  initImageModel() {
    subAlbumData = SubAlbumData(
        title: "Hi Daddy",
        postedDate:
        App.getDateByFormat(DateTime.now(), App.formatMMMDDYY).toString(),
        mediaUrls: [
          "https://sylomediastorage.s3.eu-west-2.amazonaws.com/video1.mp4",
        ]);
    tagList.add("birthday");
    tagList.add("party");
    tagList.add("holiday");
    listImages.add(CompletedSyloImageModel(isSquare: false, image: "https://i.picsum.photos/id/721/300/300.jpg"));
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
      if(subAlbumData.coverPhoto != null) {
        listImages.add(CompletedSyloImageModel(isSquare: false, image: subAlbumData.coverPhoto));
      }
      state.setState(() {});
    }
  }

  getSyloQuestion(){
    subAlbumData = SubAlbumData(
      title: state.widget.syloQuestionItem.title,
      postedDate: state.widget.syloQuestionItem.postedDate,
      coverPhoto: state.widget.syloQuestionItem.coverPhoto,
      mediaUrls: state.widget.syloQuestionItem.rawMediaIds,
    );
    listImages.add(CompletedSyloImageModel(isSquare: false, image: state.widget.syloQuestionItem.coverPhoto));
    disableAddQcast = state.widget.syloQuestionItem.addedToQcast;
    state.setState(() {});
  }

  callDeleteSubAlbum() async {
    Navigator.pop(state.context);
    if(subAlbumData.subAlbumId!=null){
      bool isDelete = await interceptorApi.callDeleteSubAlbum(subAlbumData.subAlbumId);
      if(isDelete!=null || isDelete == true){
        commonToast("Deleted successfully");
        Navigator.pop(state.context,true);
      }
    }
  }

  callAddToQcastQueastios() async {
    var result = await interceptorApi.callAddToQcast(appState.userItem.userId.toString(), state.widget.syloQuestionItem.questionId.toString(), false);
    if(result!=null && result==true) {
      commonToast("Successfully added into Qcast");
      Navigator.pop(state.context, true);
    }
  }
}