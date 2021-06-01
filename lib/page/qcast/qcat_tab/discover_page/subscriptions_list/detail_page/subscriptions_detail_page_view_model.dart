import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:testsylo/model/api_request.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';

import '../../../../../../app.dart';
import 'subscriptions_detail_page.dart';


class SubscriptionsDetailPageViewModel {
  SubscriptionsDetailPageState state;
  InterceptorApi interceptorApi;
  String coverPhoto1="";
  CreateQcastItem createQcastItem = CreateQcastItem();
  SubscriptionsDetailPageViewModel(this.state)  {
    this.state = state;
    interceptorApi = InterceptorApi(context: state.context);
    getQcast();
  }

  getQcast() async  {
//    bool isLoaderDisplay = appState.qcastDashboardItem==null ? true : false;
    var data = await interceptorApi.callGetQcastDeepCopy(
        state.widget.discoverQcastItem.qcasId.toString(),
        appState.userItem.userId.toString(),
        true);
    if (data != null) {

      createQcastItem = CreateQcastItem.fromJson(data);

      print("createQcastItem for DeepCopy -> " + createQcastItem.toMap().toString());



      state.setState(() {
        coverPhoto1=createQcastItem.coverPhoto;
        print("1createQcastItem for DeepCopy -> " + String.fromCharCodes(new Runes(createQcastItem.description)));


      });
    }
  }

  Future<bool> callDownload() async {
    bool result = await interceptorApi.callDownloadQcast(
        state.widget.discoverQcastItem.qcasId.toString(),
        appState.userItem.userId.toString(),
        false);
    if (result != null && result==true ) {
      return true;
    }
    return false;
  }
}