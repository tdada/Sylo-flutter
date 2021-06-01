import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:testsylo/model/api_request.dart';
import 'package:testsylo/model/qcast_dashboard_item.dart';
import 'package:testsylo/model/qcasts_selectable_item.dart';
import 'package:testsylo/page/qcast/qcat_tab/questions_page/qcasts_page/qcasts_page.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';

import '../../../../../app.dart';

class QcastsPageViewModel {
  QcastsPageState state;
  InterceptorApi interceptorApi;
  MyDownloadedQcastItem myDownloadedQcastItem;
  List<DiscoverQcastItem> recipientQcastsList;
  List<DiscoverQcastItem> downloadedQcastsList;
  int downloadedQcastSelectIndex = -1;
  int recipientQcastSelectIndex = -1;
  CreateQcastItem selectedQcastItem = CreateQcastItem();
  QcastsPageViewModel(this.state) {
    interceptorApi = InterceptorApi(context: state.context);
    initializeLists();
    getMyDownloadedQcasts();
  }
  initializeLists() {
    if(appState.myDownloadedQcastItem!=null) {
      recipientQcastsList = appState.myDownloadedQcastItem.recipientQcasts;
      downloadedQcastsList = appState.myDownloadedQcastItem.downloadedQcasts;
    } else {
      recipientQcastsList = List();
      downloadedQcastsList = List();
    }
  }
  getMyDownloadedQcasts() async {
    print("UserId ->" + appState.userItem.userId.toString());
    bool isLoaderDisplay = appState.myDownloadedQcastItem==null ? true : false;
    var data = await interceptorApi.callGetMyDownloadedQcasts(
        appState.userItem.userId,
        isLoaderDisplay);

    if (data != null) {
      print("jsonEncode -> "+jsonEncode(data));

      MyDownloadedQcastItem myDownloadedQcastItem = MyDownloadedQcastItem.fromJson(data);
      appState.myDownloadedQcastItem = myDownloadedQcastItem;
      recipientQcastsList = myDownloadedQcastItem.recipientQcasts;
      downloadedQcastsList = myDownloadedQcastItem.downloadedQcasts;

      print("recipientQcastsList -> " + recipientQcastsList.length.toString());
      print("downloadedQcastsList -> " + downloadedQcastsList.length.toString());

      state.setState(() { });
    }
  }
  getQcast(int qcasId) async {
//    bool isLoaderDisplay = appState.qcastDashboardItem==null ? true : false;
    var data = await interceptorApi.callGetQcastDeepCopy(
        qcasId.toString(),
        appState.userItem.userId.toString(),
        true);
    if (data != null) {

      selectedQcastItem = CreateQcastItem.fromJson(data);

      print("createQcastItem for DeepCopy -> " + selectedQcastItem.toMap().toString());

      state.setState(() { });
    }
  }
}
