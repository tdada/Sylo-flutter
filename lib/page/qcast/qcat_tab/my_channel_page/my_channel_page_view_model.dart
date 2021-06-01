import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:testsylo/app.dart';
import 'package:testsylo/model/api_request.dart';
import 'package:testsylo/model/image_item.dart';
import 'package:testsylo/model/qcast_item.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';

import 'my_channel_page.dart';

class MyChannelPageViewModel {
  MyChannelPageState state;
  int subScribers = 0;
  int qcastSeries = 0;
  int questions = 0;
  String coverPhoto;
  bool updateFormStatus = false;
  InterceptorApi interceptorApi;
  ImageItem profileImage = ImageItem("");
  MyChannelProfileItem myChannelProfileItem = MyChannelProfileItem();
  List<QcastItem> listSaveQcastItem = List();
  List<QcastItem> listPublishQcastItem = List();

  MyChannelPageViewModel(MyChannelPageState state) {
    interceptorApi = InterceptorApi(context: state.context);
    this.state = state;
//    if (appState.myChannelProfileItem == null) {
    getMyChannel();
//    } else {
//      updateData(appState.myChannelProfileItem);
//      state.setState(() {
//        state.isSave = !state.isSave;
//      });
//    }
    getQcastList();
  }

  Future<String> getmediaId(File file) async {
    String mediaUploaded = await interceptorApi.callUploadGetMediaID(file,
        loaderLabel: "Uploading profile", sync: true);
    if (mediaUploaded != null) {
      return mediaUploaded;
    }
    return null;
  }

  Future<bool> changeQcastStatus(
      String userId, String qcastId, String operation) async {
    bool qcaststatus =
        await interceptorApi.callChangeQcastStatus(userId, qcastId, operation);
    return qcaststatus;
  }

  void updateStatusChange(value) {
    updateFormStatus = true;
  }

  createMyChannel(MyChannelProfileItem myChannelProfileItem) async {
    String link = await getmediaId(profileImage.path);
    myChannelProfileItem.link = link ?? "";

    MyChannelProfileItem result =
        await interceptorApi.callCreateMyChannelProfile(myChannelProfileItem);
    if (result != null) {
      appState.myChannelProfileItem = MyChannelProfileItem();
      appState.myChannelProfileItem.channelId = result.channelId;
      appState.myChannelProfileItem.profileName = result.profileName;
      appState.myChannelProfileItem.qcastMoto = result.qcastMoto;
      appState.myChannelProfileItem.description = result.description;
      appState.myChannelProfileItem.coverPhoto = result.coverPhoto;
      updateData(result);
      state.setState(() {
        state.isSave = !state.isSave;
        updateFormStatus = false;
      });
    }
  }

  updateMyChannel(MyChannelProfileItem myChannelProfileItem) async {
    if (profileImage != null && profileImage.path != null) {
      String link = await getmediaId(profileImage.path);
      if (link != null) {
        myChannelProfileItem.link = link ?? "";
        print(link);
      }
    }

    if (updateFormStatus != null && updateFormStatus == true) {
      MyChannelProfileItem result =
          await interceptorApi.callUpdateMyChannelProfile(myChannelProfileItem);
      if (result != null) {
        appState.myChannelProfileItem = MyChannelProfileItem();
        appState.myChannelProfileItem.channelId = result.channelId;
        appState.myChannelProfileItem.profileName = result.profileName;
        appState.myChannelProfileItem.qcastMoto = result.qcastMoto;
        appState.myChannelProfileItem.description = result.description;
        appState.myChannelProfileItem.coverPhoto = result.coverPhoto;
      }
    }
    updateData(appState.myChannelProfileItem);
    state.setState(() {
      state.isSave = !state.isSave;
      updateFormStatus = false;
    });
    //getMyChannel();
  }

  getMyChannel() async {
    MyChannelProfileItem myChannelProfileItem =
        await interceptorApi.callGetMyChannelProfile(
            appState.userItem.userId.toString(),
            appState.userItem.userId.toString());
    if (myChannelProfileItem != null) {
      appState.myChannelProfileItem = myChannelProfileItem;
      updateData(myChannelProfileItem);
      state.setState(() {
        state.isSave = !state.isSave;
        updateFormStatus = false;
      });
    } else {
      state.setState(() {});
    }
  }

  updateData(MyChannelProfileItem myChannelProfileItem) {
    profileImage.path = null;
    state.nameController.text = myChannelProfileItem.profileName;
    state.mottoController.text = myChannelProfileItem.qcastMoto;
    state.descController.text = myChannelProfileItem.description;
    if (!updateFormStatus) {
      subScribers = myChannelProfileItem.subscribers ?? 0;
      qcastSeries = myChannelProfileItem.qcastSerices ?? 0;
      questions = myChannelProfileItem.totalQuestions ?? 0;
    }
    coverPhoto = myChannelProfileItem.coverPhoto;
  }

  getQcastList() async {
    var data =
        await interceptorApi.callGetQcastByUser(appState.userItem.userId);
    if (data != null) {
      //var listSaved = data["savedQcastsList"];

      print("jsonEncode -> " + jsonEncode(data));

      Iterable listSaved = data["savedQcastsList"];
      listSaveQcastItem =
          listSaved.map((model) => QcastItem.fromJson(model)).toList();

      Iterable listPublish = data["publishedQcastsList"];
      listPublishQcastItem =
          listPublish.map((model) => QcastItem.fromJson(model)).toList();

      state.setState(() {});

      print("listSaveQcastItem -> " + listSaveQcastItem.length.toString());
      print(
          "listPublishQcastItem -> " + listPublishQcastItem.length.toString());
    }
  }

  publishQcastList(int qcastId) async {
    var data =
        await interceptorApi.callPblishQcast(appState.userItem.userId, qcastId);
    if (data != null) {
      //var listSaved = data["savedQcastsList"];

      print("jsonEncode -> " + jsonEncode(data));

      Iterable listSaved = data["savedQcastsList"];
      listSaveQcastItem =
          listSaved.map((model) => QcastItem.fromJson(model)).toList();

      Iterable listPublish = data["publishedQcastsList"];
      listPublishQcastItem =
          listPublish.map((model) => QcastItem.fromJson(model)).toList();

      print("listSaveQcastItem -> " + listSaveQcastItem.length.toString());
      print(
          "listPublishQcastItem -> " + listPublishQcastItem.length.toString());

      state.setState(() {});
    }
  }
}
