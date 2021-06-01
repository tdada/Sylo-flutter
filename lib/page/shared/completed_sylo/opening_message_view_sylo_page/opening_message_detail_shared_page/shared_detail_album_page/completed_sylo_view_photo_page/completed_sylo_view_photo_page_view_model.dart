import 'package:flutter/material.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';

import '../../../../../../../app.dart';
import 'completed_sylo_view_photo_page.dart';

class CompletedSyloViewPhotoPageViewModel {
  CompletedSyloViewPhotoPageState state;

  InterceptorApi interceptorApi;
  SubAlbumData subAlbumData = SubAlbumData();
  List<String> tagList = List();

  CompletedSyloViewPhotoPageViewModel(this.state) {
    interceptorApi = InterceptorApi(context: state.context);
    if (state.widget.from == "SyloAlbumDetailPageState" || state.widget.from == "SharedDetailAlbumPageState") {
      getSubAlbumData();
    } else {
      initImageModel();
    }
  }

  initImageModel() {
    subAlbumData = SubAlbumData(
        title: "Dayout with Aunty",
        postedDate:
            App.getDateByFormat(DateTime.now(), App.formatMMMDDYY).toString(),
        mediaUrls: [
          "https://picsum.photos/seed/picsum/300/200",
          "https://picsum.photos/id/1/200/300",
          "https://picsum.photos/id/1001/200/300",
          "https://picsum.photos/id/1005/200/300",
          "https://picsum.photos/id/1011/200/300",
          "https://picsum.photos/id/102/200/300"
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
    if (subAlbumData.subAlbumId != null) {
      bool isDelete = await interceptorApi.callDeleteSubAlbum(subAlbumData.subAlbumId);
      if (isDelete != null && isDelete==true) {
        commonToast("Deleted successfully");
        Navigator.pop(state.context, true);
      }
    }
  }
}
