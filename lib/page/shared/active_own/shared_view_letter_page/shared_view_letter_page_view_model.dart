import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/page/shared/active_own/shared_view_letter_page/shared_view_letter_page.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';

class SharedViewLetterPageViewModel {
  SharedViewLetterPageState state;
  InterceptorApi interceptorApi;
  SubAlbumData subAlbumData = SubAlbumData();
  List<String> tagList = List();
  SharedViewLetterPageViewModel(this.state){
    interceptorApi = InterceptorApi(context: state.context);
    if(state.widget.from == "ActiveSyloSharedOwnPageState") {
      getSyloQuestionData();
    } else {
      getSubAlbumData();
    }
  }

  getSubAlbumData() async {
    if(state.widget.albumMediaData.subAlbumId != null) {
      subAlbumData = await interceptorApi.callGetSubAlbumData(
          state.widget.albumMediaData.subAlbumId.toString()
      );
      if (subAlbumData == null) {
        subAlbumData = SubAlbumData();
      }
      if(subAlbumData.tag!=null&&subAlbumData.tag!="") {
        tagList = subAlbumData.tag.split(',');
      }
      state.setState(() {});
    }
  }
  getSyloQuestionData() async {
    subAlbumData = SubAlbumData(
      title: state.widget.syloQuestionItem.title,
      textMsg: state.widget.syloQuestionItem.txtMsg,
      postedDate: state.widget.syloQuestionItem.postedDate,
    );
    state.setState(() {});
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