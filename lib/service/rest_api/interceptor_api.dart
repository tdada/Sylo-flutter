

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as d;
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as gt;
import 'package:http/http.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/api_request.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/model/user_item.dart';
import 'package:testsylo/page/sylo/open_message_page/edit_open_message_page/success_message_page/success_message_page.dart';
import 'package:testsylo/service/rest_api/rest_api.dart';

import '../../app.dart';
import '../common_service.dart';

class InterceptorApi {

  BuildContext _context;
  RestApi restApi;
  final uploader = FlutterUploader();
  CommonService commonService;
  InterceptorApi({context}) {
    _context = context;
    restApi = RestApi(context: context);
    commonService = CommonService();
  }


    Future<bool> callChangeAlbumName(int albumId, String newAlbumName) async {
      print('callChangeAlbumName');
      d.Response response = await restApi.callEditAlbumNameAPI(
          albumId, newAlbumName);
      if (response == null) {}
      else if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.data);
        //var data = jsonDecode(response.data);
        try {
          EditAlbumResponse ear = EditAlbumResponse.fromJson(response.data);
          if (ear.id == 200) {
            commonMessage(_context, ear.msg);
            return true;
          }
          else {
            commonMessage(_context, ear.msg);
            return false;
          }
        } catch (e) {
          commonMessage(_context, "error ocurred parsing data");
        }
      }
      else if (response.statusCode == 500) {
        var data = jsonDecode(response.data);
        String msg = data["message"];
        commonMessage(_context, msg);
        return false;
      }
      else {
        commonMessage(_context, App.txtSomethingWentWrong);
      }
      return false;
    }

    Future<bool> callDeleteAlbum(AlbumDeleteRequest adr) async {
        print('callChangeAlbumName');
        d.Response response = await restApi.callDeleteAlbumAPI(adr);
        if (response == null) {}
        else if (response.statusCode == 200 || response.statusCode == 201) {
          print(response.data);
          //var data = jsonDecode(response.data);
          try {
            AlbumDeleteResponse ear = AlbumDeleteResponse.fromJson(
                response.data);
            if (ear.id == 200) {
              commonMessage(_context, ear.msg);
              return true;
            }
            else {
              commonMessage(_context, ear.msg);
              return false;
            }
          } catch (e) {
            commonMessage(_context, "error ocurred parsing data");
          }
        }
        else if (response.statusCode == 500) {
          var data = jsonDecode(response.data);
          String msg = data["message"];
          commonMessage(_context, msg);
          return false;
        }
        else {
          commonMessage(_context, App.txtSomethingWentWrong);
        }
        return false;
      }

  Future<bool> callDeliverSylo(int userId) async {
    print('callDeliverSylo');
    d.Response response = await restApi.callDeliverSyloAPI(userId);
    if (response == null) {}
    else if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.data);
      //var data = jsonDecode(response.data);
      try {
        AlbumDeleteResponse ear = AlbumDeleteResponse.fromJson(
            response.data);
        if (ear.id == 200) {
          commonMessage(_context, ear.msg);
          return true;
        }
        else {
          commonMessage(_context, ear.msg);
          return false;
        }
      } catch (e) {
        commonMessage(_context, "error ocurred parsing data");
      }
    }
    else if (response.statusCode == 500) {
      var data = jsonDecode(response.data);
      String msg = data["message"];
      commonMessage(_context, msg);
      return false;
    }
    else {
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return false;
  }

  Future<bool> callGetSubpackages() async {
    print('callGetSubpackages');
    d.Response response = await restApi.callGetSubpackagesAPI();
    if (response == null) {}
    else if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.data);
      return true;
      //var data = jsonDecode(response.data);
     /** try {
        //AlbumDeleteResponse ear = AlbumDeleteResponse.fromJson(
          //  response.data);
        if (ear.id == 200) {
          commonMessage(_context, ear.msg);
          return true;
        }
        else {
          commonMessage(_context, ear.msg);
          return false;
        }
      } catch (e) {
        commonMessage(_context, "error ocurred parsing data");
      } **/
    }
    else if (response.statusCode == 500) {
      var data = jsonDecode(response.data);
      String msg = data["message"];
      commonMessage(_context, msg);
      return false;
    }
    else {
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return false;
  }

  Future<Map<String, dynamic>> callGetUserSubDetails(int userId) async {
    print('callGetUserSubDetails');
    Map<String, dynamic> resultData = new Map<String, dynamic>();
    d.Response response = await restApi.callGetuserSubDetailsAPI(userId);
    if (response == null) {
      resultData['result'] = false;
      resultData['data'] = null;
      return resultData;
    }
    else if (response.statusCode == 200 || response.statusCode == 201) {
      print(response);
      //var data = jsonDecode(response.data);
      /**try {
        UserStorage us = UserStorage.fromJson(response.data);

        if (us.id == 200 || us.id == 201) {
          commonMessage(_context, us.msg ?? "");
          resultData['result'] = true;
          resultData['storage'] = us?.data?.kB ?? 0.0;
          return resultData;;
        }
        else {
          commonMessage(_context, us.msg ?? "");
          resultData['result'] = false;
          resultData['storage'] = -1;
          return resultData;
        }
      } catch (e) {
        commonMessage(_context, "error ocurred parsing data");
      } **/
    }
    else if (response.statusCode == 500) {
      var data = jsonDecode(response.data);
      String msg = data["message"];
      commonMessage(_context, msg);
      resultData['result'] = false;
      resultData['data'] = null;
      return resultData;
    }
    else {
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    resultData['result'] = false;
    resultData['data'] = null;
    return resultData;
  }



  Future<Map<String, dynamic>> callGetUserStorage(int userId) async {
    print('callGetuserStorage');
    Map<String, dynamic> resultData = new Map<String, dynamic>();
    d.Response response = await restApi.callGetuserStorageAPI(userId);
    if (response == null) {
      resultData['result'] = false;
      resultData['storage'] = -1;
      return resultData;
    }
    else if (response.statusCode == 200 || response.statusCode == 201) {
      print(response);
      //var data = jsonDecode(response.data);
      try {
        UserStorage us = UserStorage.fromJson(response.data);

        if (us.id == 200 || us.id == 201) {
          //commonMessage(_context, us.msg ?? "");
          resultData['result'] = true;
          resultData['storage'] = us?.data?.kB ?? 0.0;
          return resultData;;
        }
        else {
          commonMessage(_context, us.msg ?? "");
          resultData['result'] = false;
          resultData['storage'] = -1;
          return resultData;
        }
      } catch (e) {
        commonMessage(_context, "error ocurred parsing data");
      }
    }
    else if (response.statusCode == 500) {
      var data = jsonDecode(response.data);
      String msg = data["message"];
      commonMessage(_context, msg);
      resultData['result'] = false;
      resultData['storage'] = -1;
      return resultData;
    }
    else {
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    resultData['result'] = false;
    resultData['storage'] = -1;
    return resultData;
  }

    Future<bool> callCreateFeedback(FeedbackRequest fbr) async {
          print('callCreateFeedback');
          d.Response response = await restApi.callCreateFeedbackAPI(fbr);
          if (response == null) {}
          else if (response.statusCode == 200 || response.statusCode == 201) {
            print(response.data);
            //var data = jsonDecode(response.data);
            try {
              AlbumDeleteResponse ear = AlbumDeleteResponse.fromJson(
                  response.data);
              if (ear.id == 200) {
                commonMessage(_context, ear.msg);
                return true;
              }
              else {
                commonMessage(_context, ear.msg);
                return false;
              }
            } catch (e) {
              commonMessage(_context, "error ocurred parsing data");
            }
          }
          else if (response.statusCode == 500) {
            var data = jsonDecode(response.data);
            String msg = data["message"];
            commonMessage(_context, msg);
            return false;
          }
          else {
            commonMessage(_context, App.txtSomethingWentWrong);
          }
          return false;
        }

    Future<bool> callCopyMoveAlbum(CopyMoveRequest fbr) async {
            print('callCopyMoveAlbum');
             d.Response response = await restApi.callCopyMoveAlbumAPI(fbr);
             if (response == null) {}
            else if (response.statusCode == 200 || response.statusCode == 201) {
              print(response.data);
              //var data = jsonDecode(response.data);
              try {
                AlbumDeleteResponse ear = AlbumDeleteResponse.fromJson(
                    response.data);
                if (ear.id == 200) {
                  commonMessage(_context, ear.msg);
                  return true;
                }
                else {
                  //commonMessage(_context, ear.msg);
                  return false;
                }
              } catch (e) {
                //commonMessage(_context, "error ocurred parsing data");
              }
            }
            else if (response.statusCode == 500) {
              var data = jsonDecode(response.data);
              String msg = data["message"];
              commonMessage(_context, msg);
              return false;
            }
            else {
              commonMessage(_context, App.txtSomethingWentWrong);
            }
            return false;
          }


  Future<bool> callGetSignInProcess(String email, String password, String token) async {
    print('callGetSignInProcess');
    Response response = await restApi.callGetSignInProcess(email, password, token);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var data = jsonDecode(response.body);
      int id  = data["id"];
      String msg  = data["msg"];
      if(id==200){
//        commonMessage(_context, msg);
        appState.userItem = UserItem.fromJson(data["data"]);
        commonService.setUserId(data["data"]["userId"].toString());
        commonService.setEmail(data["data"]["email"].toString());
        commonService.setUserName(data["data"]["username"].toString());
        commonService.setProfilePic(data["data"]["profilePic"].toString());
        commonService.setToken(data["data"]["token"].toString());

        return true;
      }
      else if(id==105){
        commonMessage(_context, msg+" \nKindly verify it.", callback: callResendOtpSentLink, email: email);
        return false;
      }
      else{
        commonMessage(_context, msg);
        return false;
      }
    }
    else if(response.statusCode==500){
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return false;
    }
    else{
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return false;

  }

  Future<bool> callPutForgotPasswordSentLink(String email) async {
    print('callPutForgotPasswordSentLink');
    Response response = await restApi.callPutForgotPasswordSentLink(email);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var data = jsonDecode(response.body);
      int id  = data["id"];
      String msg  = data["msg"];
      if(id==200){
//            commonMessage(_context, msg);
        return true;
      }
      else{
        commonMessage(_context, msg);
        return false;
      }
    }
    else if(response.statusCode==500){
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return false;
    }
    else{
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return false;

  }

  callGetPhotoPostSylo(String userid, String type) async{
    print('callGetImageSylo');
    Response response = await restApi.callGetPhotoPostSylon(userid,type);
    List<String> list = List();

    if(response==null){
      print('response null');
    }
    else if(response.statusCode==200 || response.statusCode==201){
      var data = jsonDecode(response.body);
      int id  = data["id"];
      String msg  = data["msg"];
      if(id==200){
        var listdata = data['listData'];

        for(var i in listdata[0]){
          list.add(i.toString());
        }

//        commonMessage(_context, msg);
        return list;
      }
      else{
        commonMessage(_context, msg);
        return null;
      }
    }
    return null;
  }

  Future<bool> callResendOtpSentLink(String email) async {
    print('callResendOtpSentLink');
    Response response = await restApi.callResendOtpSentLink(email);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var data = jsonDecode(response.body);
      int id  = data["id"];
      String msg  = data["msg"];
      if(id==200){
        commonMessage(_context, msg);
        return true;
      }
      else{
        commonMessage(_context, msg);
        return false;
      }
    }
    else if(response.statusCode==500){
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return false;
    }

    else{
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return false;

  }



  Future<bool> callPostAddUser(AddUserItem addUserItem) async {
    print('callPostAddUser');
    d.Response response = await restApi.callPostAddUser(addUserItem);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var resdata = (response.data);
      int id  = resdata["id"];
      String msg  = resdata["msg"];
      if(id==200){
        //commonMessage(_context, msg);
        appState.userItem = UserItem.fromJson(resdata["data"]);
        commonService.setUserId(resdata["data"]["userId"].toString());
        commonService.setEmail(resdata["data"]["email"].toString());
        commonService.setUserName(resdata["data"]["username"].toString());
        commonService.setProfilePic(resdata["data"]["profilePic"].toString());

        print(appState.userItem.toMap());
        return true;
      }
      else{
        commonMessage(_context, msg);
        return false;
      }
    }
    else if(response.statusCode==500){
      var data = (response.data);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return false;
    }
    else{
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return false;

  }

  Future<bool> verifyEmailWithCode(String email, code) async {
    print('verifyEmailWithCode');
    Response response = await restApi.verifyEmailWithCode(email, code);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var data = jsonDecode(response.body);
      int id  = data["id"];
      String msg  = data["msg"];
      if(id==200){
        return true;
      }
      else{
        Navigator.pop(_context);
        commonMessage(_context, msg);
        return false;
      }
    }
    else if(response.statusCode==500){
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      Navigator.pop(_context);
      commonMessage(_context, msg);
      return false;
    }
    else{
      Navigator.pop(_context);
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return false;

  }
  Future<bool> callChangePassword(String email, String newPassword) async {
    print("callChangePassword");
    Response response = await restApi.callChangePassword(email, newPassword);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var data = jsonDecode(response.body);
      int id  = data["id"];
      String msg  = data["msg"];
      if(id==200){
        successMessageDialog(_context, msg);
        return true;
      }
      else{
        commonMessage(_context, msg);
        return false;
      }
    }
    else if(response.statusCode==500){
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return false;
    }
    else{
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return false;
  }

  Future<bool> callAddSylo(AddSyloItem addSyloItem) async {
    print('callAddSylo');
    d.Response response = await restApi.callAddSylo(addSyloItem);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var resdata = (response.data);
      int id  = resdata["id"];
      String msg  = resdata["msg"];
      if(id==200){
        appState.getUserSylosList = null;
        commonMessage(_context, msg);
//        appState.userItem = UserItem.fromJson(resdata["data"]);
//        print(appState.userItem.toMap());
        return true;
      }
      else{
        commonMessage(_context, msg);
        return false;
      }
    }
    else if(response.statusCode==500){
      var data = (response.data);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return false;
    }
    else{
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return false;

  }

  Future<List<GetUserSylos>> callGetUserSylos() async {
    print('callGetUserSylos');
    String userId = await commonService.getUserId();
    Response response = await restApi.callGetUserSylos(userId);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var data = jsonDecode(response.body);
      int id  = data["id"];
      String msg  = data["msg"];
      if(id==200){
        Iterable userSyloList = data["listData"][0];
        List<GetUserSylos> list = userSyloList.map((model) => GetUserSylos.fromJson(model)).toList();
        print("Response -> ${userSyloList}");
        return list;
      }
      else{
        commonMessage(_context, msg);
        return null;
      }
    }
    else if(response.statusCode==500){
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return null;
    }
    else if(response.statusCode==401)
    {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else{
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return null;

  }

  uploadGetMediaID(File file, {String loaderLabel, bool sync=false}) async{
    print('uploadGetMediaID');
    String userId = await commonService.getUserId();
    await restApi.uploadGetMediaIDAPI(uploader, userId, file);
    /*gt.Get.offAll(SuccessMessagePage(
      headerName: "UPLOAD IN PROGRESS",
      message: "Your media is being uploaded. You can continue with other activities.",
    ));*/
  }

  Future<String> callUploadGetMediaID(File file, {String loaderLabel, bool sync=false}) async {
    print('callUploadGetMediaID');
    String userId = await commonService.getUserId();
    d.Response response = await restApi.callUploadGetMediaID(userId, file, loaderLabel:loaderLabel, sync:sync);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var resdata = (response.data);
      int id  = resdata["id"];
      String msg  = resdata["msg"];
      if(id==200){
        return resdata["data"];
      }
      else{
        commonMessage(_context, msg);
        return null;
      }
    }
    else if(response.statusCode==500){
      var data = (response.data);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return null;
    }
    else if(response.statusCode==401)
    {
      var data = response.data;
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else{
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return null;

  }
  Future<dynamic> uploadVideoWithCoverPic(File file, {String loaderLabel}) async {
    print('uploadVideoWithCoverPic');
    String userId = await commonService.getUserId();
    d.Response response = await restApi.uploadVideoWithCoverPic(userId, file, loaderLabel:loaderLabel);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var resdata = (response.data);
      int id  = resdata["id"];
      String msg  = resdata["msg"];
      if(id==200){
        return resdata["data"];
      }
      else{
        commonMessage(_context, msg);
        return null;
      }
    }
    else if(response.statusCode==500){
      var data = (response.data);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return null;
    }
    else if(response.statusCode==401)
    {
      var data = response.data;
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else{
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return null;

  }

  Future<bool> callCreateAlbum(String albumName, String syloId, {bool quickAlbum}) async {
    print('callCreateAlbum');
    String userId = await commonService.getUserId();
    d.Response response = await restApi.callCreateAlbum(albumName, userId, syloId);
    Navigator.pop(_context, "success");
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var resdata = (response.data);
      int id  = resdata["id"];
      String msg  = resdata["msg"];
      if(id==200){
        print(resdata["data"]);
        print("isQuickPost --> "+quickAlbum.toString());
        commonMessage(_context, "Album Saved", isSuccessIcon: true);
        if(quickAlbum!=null && quickAlbum==true) {
          appState.quickAddedAlbum = GetAlbum.fromJson(resdata["data"]);
        } else {
          appState.albumList.add(GetAlbum.fromJson(resdata["data"]));
        }
        return true;
      }
      else{
        commonMessage(_context, msg);
        return false;
      }
    }
    else if(response.statusCode==500){
      var data = (response.data);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return false;
    }
    else if(response.statusCode==401)
    {
      var data = response.data;
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else{
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return false;

  }

  Future<bool> callGetAllAlbumsForSylo(String syloId) async {
    print('callGetAllAlbumsForSylo');
    String userId = await commonService.getUserId();
    Response response = await restApi.callGetAllAlbumsForSylo(userId, syloId);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var data = jsonDecode(response.body);
      int id  = data["id"];
      String msg  = data["msg"];
      if(id==200){
        Iterable albumList = data["listData"][0];
        appState.albumList = albumList.map((model) => GetAlbum.fromJson(model)).toList();
        print(appState.albumList);
        print("Response -> ${albumList}");
        return true;
      }
      else{
        commonMessage(_context, msg);
        return false;
      }
    }
    else if(response.statusCode==500){
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return false;
    }
    else if(response.statusCode==401)
    {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else{
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return false;

  }

  Future<bool> callPostUpdateUser(AddUserItem addUserItem) async {
    print('callPostUpdateUser');
    String userId = await commonService.getUserId();
    d.Response response = await restApi.callPostUpdateUser(userId, addUserItem);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var resdata = (response.data);
      int id  = resdata["id"];
      String msg  = resdata["msg"];
      if(id==200){
        //commonMessage(_context, msg);
        appState.userItem = UserItem.fromJson(resdata["data"]);
//        commonService.setUserId(resdata["data"]["userId"].toString());
        commonService.setEmail(resdata["data"]["email"].toString());
        commonService.setUserName(resdata["data"]["username"].toString());
        commonService.setProfilePic(resdata["data"]["profilePic"].toString());

        print(appState.userItem.toMap());
        return true;
      }
      else{
        commonMessage(_context, msg);
        return false;
      }
    }
    else if(response.statusCode==500){
      var data = (response.data);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return false;
    }
    else if(response.statusCode==401)
    {
      var data = response.data;
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else{
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return false;

  }

  createMediaSubAlbum(MediaSubAlbumItem mediaSubAlbumItem) async {
    print('callCreateMediaSubAlbum');
    String userId = await commonService.getUserId();
    mediaSubAlbumItem.userId = int.parse(userId);
    await restApi.createMediaSubAlbum(uploader, mediaSubAlbumItem);  //callCreateMediaSubAlbum(mediaSubAlbumItem);
    gt.Get.offAll(SuccessMessagePage(
      headerName: "UPLOAD IN PROGRESS",
      message: "Your media is being uploaded. You can continue with other activities.",
    ));

  }

  Future<bool> callCreateMediaSubAlbum(MediaSubAlbumItem mediaSubAlbumItem) async {
    print('callCreateMediaSubAlbum');
    String userId = await commonService.getUserId();
    mediaSubAlbumItem.userId = int.parse(userId);
    d.Response response = await restApi.callCreateMediaSubAlbum(mediaSubAlbumItem);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var resdata = (response.data);
      int id  = resdata["id"];
      String msg  = resdata["msg"];
      if(id==200){
//        commonMessage(_context, msg);

        return true;
      }
      else{
        commonMessage(_context, msg);
        return false;
      }
    }
    else if(response.statusCode==500){
      var data = (response.data);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return false;
    }
    else if(response.statusCode==401)
    {
      var data = response.data;
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else{
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return false;

  }

  Future<bool> callCreateMediaSubAlbumNew(MediaSubAlbumItem1 mediaSubAlbumItem) async {
    print('callCreateMediaSubAlbum');
    String userId = await commonService.getUserId();
    mediaSubAlbumItem.userId = int.parse(userId);
    d.Response response = await restApi.callCreateMediaSubAlbumNew(mediaSubAlbumItem);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var resdata = (response.data);
      int id  = resdata["id"];
      String msg  = resdata["msg"];
      if(id==200){
//        commonMessage(_context, msg);

        return true;
      }
      else{
        commonMessage(_context, msg);
        return false;
      }
    }
    else if(response.statusCode==500){
      var data = (response.data);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return false;
    }
    else if(response.statusCode==401)
    {
      var data = response.data;
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else{
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return false;

  }

  Future<List<AlbumMediaData>> callGetAlbumMediaData(String albumId) async {
    print('callGetAlbumMediaData');
    Response response = await restApi.callGetAlbumMediaData(albumId);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var data = jsonDecode(response.body);
      int id  = data["id"];
      String msg  = data["msg"];
      if(id==200){
        Iterable albumMediaDataList = data["listData"][0];
        List<AlbumMediaData> list = albumMediaDataList.map((model) => AlbumMediaData.fromJson(model)).toList();
        print("Response -> ${albumMediaDataList}");
        return list;
      }
      else{
        commonMessage(_context, msg);
        return null;
      }
    }
    else if(response.statusCode==500){
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return null;
    }
    else if(response.statusCode==401)
    {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else{
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return null;

  }

  Future<SubAlbumData> callGetSubAlbumData(String albumId) async {
    print('callGetSubAlbumData');
    print("SubAlbumId -> $albumId");
    Response response = await restApi.callGetSubAlbumData(albumId);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var data = jsonDecode(response.body);
      int id  = data["id"];
      String msg  = data["msg"];
      if(id==200){
        SubAlbumData subAlbumData =  SubAlbumData.fromJson(data["data"]);
        print("Response -> ${subAlbumData}");
        return subAlbumData;
      }
      else{
        commonMessage(_context, msg);
        return null;
      }
    }
    else if(response.statusCode==500){
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return null;
    }
    else if(response.statusCode==401)
    {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else{
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return null;

  }

  Future<bool> callVerifyEmailAddress(String email) async {
    print('callVerifyEmailAddress');
    Response response = await restApi.callVerifyEmailAddress(email);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var data = jsonDecode(response.body);
      int id  = data["id"];
      String msg  = data["msg"];
      if(id==200){
        return true;
      }
      else{
        commonMessage(_context, msg);
        return false;
      }
    }
    else if(response.statusCode==500){
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return false;
    }
    else if(response.statusCode==401)
    {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else{
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return false;

  }

  Future<MyChannelProfileItem> callCreateMyChannelProfile(MyChannelProfileItem myChannelProfileItem) async {
    print('callCreateMyChannelProfile');
    d.Response response = await restApi.callCreateMyChannelProfile(myChannelProfileItem);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var resdata = (response.data);
      int id  = resdata["id"];
      String msg  = resdata["msg"];
      if(id==200){
        return MyChannelProfileItem.fromUpdatedJson(resdata["data"]);
      }
      else{
        commonMessage(_context, msg);
        return null;
      }
    }
    else if(response.statusCode==500){
      var data = (response.data);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return null;
    }
    else if(response.statusCode==401)
    {
      var data = response.data;
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else{
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return null;

  }

  Future<MyChannelProfileItem> callUpdateMyChannelProfile(MyChannelProfileItem myChannelProfileItem) async {
    print('callUpdateMyChannelProfile');
    d.Response response = await restApi.callUpdateMyChannelProfile(myChannelProfileItem);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var resdata = (response.data);
      int id  = resdata["id"];
      String msg  = resdata["msg"];
      if(id==200){
        return MyChannelProfileItem.fromUpdatedJson(resdata["data"]);
      }
      else{
        commonMessage(_context, msg);
        return null;
      }
    }
    else if(response.statusCode==500){
      var data = (response.data);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return null;
    }
    else if(response.statusCode==401)
    {
      var data = response.data;
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else{
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return null;

  }

  Future<MyChannelProfileItem> callGetMyChannelProfile(String userId, String myChannelUserId) async {
    print('callGetMyChannelProfile');
    print("myChannelUserId -> $myChannelUserId");
    Response response = await restApi.callGetMyChannelProfile(userId, myChannelUserId);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var data = jsonDecode(response.body);
      int id  = data["id"];
      String msg  = data["msg"];
      if(id==200){
        print(MyChannelProfileItem.fromJson(data["data"]));
        MyChannelProfileItem myChannelProfileItem = MyChannelProfileItem.fromJson(data["data"]);
//        appState.myChannelProfileItem =  MyChannelProfileItem.fromJson(data["data"]);
        print("Response -> ${appState.myChannelProfileItem}");
        return myChannelProfileItem;
      } else if (id==404) {
        return null;
      } else {
        commonMessage(_context, msg);
        return null;
      }
    }
    else if(response.statusCode==401)
    {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else if(response.statusCode==500){
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return null;
    }
    else{
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return null;

  }

  Future<SharedSylo> callGetSharedSylos(String userId, String emailId) async {
    print('callGetSharedSylos');
    String userId = await commonService.getUserId();
    Response response = await restApi.callGetSharedSylos(userId, emailId);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var data = jsonDecode(response.body);
      int id  = data["id"];
      String msg  = data["msg"];
      if(id==200){
        SharedSylo sharedSylo = SharedSylo.fromJson(data["data"]);
        return sharedSylo;
      }
      else{
        commonMessage(_context, msg);
        return null;
      }
    }
    else if(response.statusCode==500){
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return null;
    }
    else if(response.statusCode==401)
    {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else{
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return null;

  }

  Future<bool> callAskSyloQuestions(AskSyloQuestionItem askSyloQuestionItem) async {
    print('callAskSyloQuestions');
    String userId = await commonService.getUserId();
//    askSyloQuestionItem.userId = int.parse(userId);
    d.Response response = await restApi.callAskSyloQuestions(askSyloQuestionItem);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var resdata = (response.data);
      int id  = resdata["id"];
      String msg  = resdata["msg"];
      if(id==200){
        commonToast("Successfully posted your Question");

        return true;
      }
      else{
        commonMessage(_context, msg);
        return false;
      }
    }
    else if(response.statusCode==500){
      var data = (response.data);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return false;
    }
    else if(response.statusCode==401)
    {
      var data = response.data;
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else{
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return false;

  }

  Future<SyloMediaCountItem> callGetSyloMediaCount(String syloId) async {
    print('callGetSyloMediaCount');
    print("SyloId -> $syloId");
    Response response = await restApi.callGetSyloMediaCount(syloId);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var data = jsonDecode(response.body);
      int id  = data["id"];
      String msg  = data["msg"];
      if(id==200) {
        SyloMediaCountItem syloMediaCountItem =  SyloMediaCountItem.fromJson(data["data"]);
        print("Response -> ${syloMediaCountItem}");
        return syloMediaCountItem;
      } else {
        commonMessage(_context, msg);
        return null;
      }
    } else if(response.statusCode==500) {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return null;
    }
    else if(response.statusCode==401)
    {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else {
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return null;
  }

  Future<List<SyloQuestionItem>> callGetSyloQuestions(String syloId) async {
    print('callGetSyloQuestions');
    print("SyloId -> $syloId");
    Response response = await restApi.callGetSyloQuestions(syloId);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var data = jsonDecode(response.body);
      int id  = data["id"];
      String msg  = data["msg"];
      if(id==200) {
        Iterable syloQuestionList = data["listData"][0];
        List<SyloQuestionItem> syloQuestionItemList = syloQuestionList.map((model) => SyloQuestionItem.fromJson(model)).toList();
        return syloQuestionItemList;
      } else {
        commonMessage(_context, msg);
        return null;
      }
    } else if(response.statusCode==500) {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return null;
    }
    else if(response.statusCode==401)
    {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else {
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return null;
  }

  Future<dynamic> callGetQcastByUser(int userId) async {
    print('callGetQcastByUser');
    print("userId -> $userId");
    Response response = await restApi.callGetQcastByUser(userId);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var data = jsonDecode(response.body);
      int id  = data["id"];
      String msg  = data["msg"];
      if(id==200) {
        return data["data"];
      } else {
        commonMessage(_context, msg);
        return null;
      }
    } else if(response.statusCode==500) {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return null;
    }
    else if(response.statusCode==401)
    {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else {
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return null;
  }
  Future<dynamic> callPblishQcast(int userId, int qcastId) async {
    print('callGetQcastByUser');
    print("userId -> $userId");
    Response response = await restApi.callPblishQcast(qcastId, userId);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var data = jsonDecode(response.body);
      int id  = data["id"];
      String msg  = data["msg"];
      if(id==200) {
        return data["data"];
      } else {
        commonMessage(_context, msg);
        return null;
      }
    } else if(response.statusCode==500) {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return null;
    }
    else if(response.statusCode==401)
    {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else {
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return null;
  }

  callAddQcastBackground(CreateQcastItem createQcastItem) async{
    print('callAddQcastBackground');

    await restApi.callAddQcastBackground(uploader, createQcastItem);
    Fluttertoast.showToast(
        msg: "Your qcast is being uploaded. You can continue with other activities.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xff9F00C5),
        textColor: Colors.white,
        fontSize: 16.0
    );
   /** gt.Get.offAll(SuccessMessagePage(
      headerName: "UPLOAD IN PROGRESS",
      message: "Your qcast is being uploaded. You can continue with other activities.",
    )); **/
  }


  Future<bool> callAddQcast(CreateQcastItem1 createQcastItem) async {
    print('callAddQcast');
    d.Response response = await restApi.callAddQcast(createQcastItem);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var resdata = (response.data);
      int id  = resdata["id"];
      String msg  = resdata["msg"];
      if(id==200){
//        return MyChannelProfileItem.fromUpdatedJson(resdata["data"]);
        return true;
      }
      else{
        commonMessage(_context, msg);
        return null;
      }
    }
    else if(response.statusCode==500){
      var data = (response.data);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return null;
    }
    else if(response.statusCode==400){

      return false;
    }
    else if(response.statusCode==401)
    {
      var data = response.data;
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else{
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return null;

  }

  Future<dynamic> callGetQcastDashboard(int userId, bool isLoader) async {
    print('callGetQcastDashboard');
    print("userId -> $userId");
    Response response = await restApi.callGetQcastDashboard(userId, isLoader);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var data = jsonDecode(response.body);
      int id  = data["id"];
      String msg  = data["msg"];
      if(id==200) {
        return data["data"];
      } else {
        commonMessage(_context, msg);
        return null;
      }
    } else if(response.statusCode==500) {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return null;
    }
    else if(response.statusCode==401)
    {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else {
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return null;
  }

  Future<bool> callUnSubscribeUser(String publisherId, String subscriberId, bool isLoader) async {
    print('callUnSubscribeUser');
    print("publisherId -> $publisherId");
    print("subscriberId -> $subscriberId");
    Response response = await restApi.callUnSubscribeUser(publisherId, subscriberId, isLoader);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var data = jsonDecode(response.body);
      int id  = data["id"];
      String msg  = data["msg"];
      if(id==200) {
        return true;
      } else {
        commonMessage(_context, msg);
        return false;
      }
    } else if(response.statusCode==500) {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return false;
    }
    else if(response.statusCode==401)
    {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else {
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return false;
  }

  Future<bool> callSubscribeUser(String publisherId, String subscriberId, bool isLoader) async {
    print('callSubscribeUser');
    print("publisherId -> $publisherId");
    print("subscriberId -> $subscriberId");
    Response response = await restApi.callSubscribeUser(publisherId, subscriberId, isLoader);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var data = jsonDecode(response.body);
      int id  = data["id"];
      String msg  = data["msg"];
      if(id==200) {
        return true;
      } else {
        commonMessage(_context, msg);
        return false;
      }
    } else if(response.statusCode==500) {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return false;
    }
    else if(response.statusCode==401)
    {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else {
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return false;
  }

  Future<dynamic> callGetQcastByCategory(String category, bool isLoader) async {
    print('callGetQcastByCategory');
    print("Category -> $category");
    Response response = await restApi.callGetQcastByCategory(category, isLoader);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var data = jsonDecode(response.body);
      int id  = data["id"];
      String msg  = data["msg"];
      if(id==200) {
        return data["listData"][0];
      } else {
        commonMessage(_context, msg);
        return null;
      }
    } else if(response.statusCode==500) {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return null;
    }
    else if(response.statusCode==401)
    {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else {
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return null;
  }

  Future<dynamic> callGetQcastDeepCopy(String qcastId, String userId, bool isLoader) async {
    print('callGetQcastDeepCopy');
    print("qcastId -> $qcastId  && userId -> $userId");
    Response response = await restApi.callGetQcastDeepCopy(qcastId, userId, isLoader);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var data = jsonDecode(response.body);
      int id  = data["id"];
      String msg  = data["msg"];
      if(id==200) {
        return data["data"];
      } else {
        commonMessage(_context, msg);
        return null;
      }
    } else if(response.statusCode==500) {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return null;
    }
    else if(response.statusCode==401)
    {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else {
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return null;
  }

  Future<bool> callDownloadQcast(String qcastId, String userId, bool isLoader) async {
    print('callDownloadQcast');
    print("qcastId -> $qcastId  && userId -> $userId");
    Response response = await restApi.callDownloadQcast(qcastId, userId, isLoader);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var data = jsonDecode(response.body);
      int id  = data["id"];
      String msg  = data["msg"];
      if(id==200) {
        return true;
      } else {
        commonMessage(_context, msg);
        return false;
      }
    } else if(response.statusCode==500) {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return false;
    }
    else if(response.statusCode==401)
    {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else {
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return false;
  }

  Future<dynamic> callGetMyDownloadedQcasts(int userId, bool isLoader) async {
    print('callGetMyDownloadedQcasts');
    print("userId -> $userId");
    Response response = await restApi.callGetMyDownloadedQcasts(userId, isLoader);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var data = jsonDecode(response.body);
      int id  = data["id"];
      String msg  = data["msg"];
      if(id==200) {
        return data["data"];
      } else {
        commonMessage(_context, msg);
        return null;
      }
    } else if(response.statusCode==500) {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return null;
    }
    else if(response.statusCode==401)
    {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else {
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return null;
  }

  Future<dynamic> callGetPrompts(int userId) async {
    print('callGetPrompts');
    print("userId -> $userId");
    Response response = await restApi.callGetPrompts(userId);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var data = jsonDecode(response.body);
      int id  = data["id"];
      String msg  = data["msg"];
      if(id==200) {
        return data["listData"][0];
      } else {
        commonMessage(_context, msg);
        return null;
      }
    } else if(response.statusCode==500) {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return null;
    }
    else if(response.statusCode==401)
    {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else {
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return null;
  }

  Future<dynamic> callSaveCustomPrompt(CustomPromptItem customPromptItem, bool isLoader) async {
    print('callSaveCustomPrompt');
    d.Response response = await restApi.callSaveCustomPrompt(customPromptItem, isLoader);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var resdata = (response.data);
      int id  = resdata["id"];
      String msg  = resdata["msg"];
      if(id==200){
        return resdata['listData'][0];
      }
      else{
        commonMessage(_context, msg);
        return null;
      }
    }
    else if(response.statusCode==500){
      var data = (response.data);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return null;
    }
    else if(response.statusCode==401)
    {
      var data = response.data;
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else{
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return null;
  }

  Future<dynamic> callGetOrUpdateIP(InActivityPeriodItem inActivityPeriodItem, bool isLoader) async {
    print('callGetOrUpdateIP');
    d.Response response = await restApi.callGetOrUpdateIP(inActivityPeriodItem, isLoader);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var resdata = (response.data);
      int id  = resdata["id"];
      String msg  = resdata["msg"];
      if(id==200){
        return resdata['data'];
      }
      else{
        commonMessage(_context, msg);
        return null;
      }
    }
    else if(response.statusCode==500){
      var data = (response.data);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return null;
    }
    else if(response.statusCode==401)
    {
      var data = response.data;
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else{
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return null;
  }

  Future<dynamic> callGetNotifications(int userId, bool isLoader) async {
    print('callGetNotifications');
    print("userId -> $userId");
    Response response = await restApi.callGetNotifications(userId, isLoader);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var data = jsonDecode(response.body);
      int id  = data["id"];
      String msg  = data["msg"];
      if(id==200) {
        return data["data"];
      } else {
        commonMessage(_context, msg);
        return null;
      }
    } else if(response.statusCode==500) {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessage(_context, msg);

      return null;
    }
    else if(response.statusCode==401)
    {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else {
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return null;
  }


  Future<dynamic> callMarkReadFlag(int userId, bool isMsgRead, int notificationId, bool isLoader) async {
    print('callMarkReadFlag');
    print("userId -> $userId isMsgRead -> $isMsgRead notificationId -> $notificationId");
    Response response = await restApi.callMarkReadFlag(userId, isMsgRead, notificationId, isLoader);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var data = jsonDecode(response.body);
      int id  = data["id"];
      String msg  = data["msg"];
      if(id==200) {
        return data["data"];
      } else {
        commonMessage(_context, msg);
        return null;
      }
    } else if(response.statusCode==500) {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return null;
    }
    else if(response.statusCode==401)
    {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else {
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return null;
  }

  Future<dynamic> callDeleteNotification(int userId, int notificationId, bool isLoader) async {
    print('callDeleteNotification');
    print("userId -> $userId notificationId -> $notificationId");
    Response response = await restApi.callDeleteNotification(userId, notificationId, isLoader);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var data = jsonDecode(response.body);
      int id  = data["id"];
      String msg  = data["msg"];
      if(id==200) {
        return data["data"];
      } else {
        commonMessage(_context, msg);
        return null;
      }
    } else if(response.statusCode==500) {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return null;
    }
    else if(response.statusCode==401)
    {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else {
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return null;
  }

  Future<dynamic> callGetAllAlbumsForSyloList(int userId, List<String> syloIds, bool isLoader) async {
    print('callGetAllAlbumsForSyloList');
    d.Response response = await restApi.callGetAllAlbumsForSyloList(userId, syloIds, isLoader);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var resdata = (response.data);
      int id  = resdata["id"];
      String msg  = resdata["msg"];
      if(id==200){
        return resdata['data'];
      }
      else{
        commonMessage(_context, msg);
        return null;
      }
    }
    else if(response.statusCode==500){
      var data = (response.data);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return null;
    }
    else if(response.statusCode==401)
    {
      var data = response.data;
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else{
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return null;
  }

  Future<bool> callDeleteSubAlbum(int subAlbumId) async {
    print('callSubscribeUser');
    print('subAlbumId - >' + subAlbumId.toString());

    Response response = await restApi.callDeleteSubAlbum(subAlbumId);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var data = jsonDecode(response.body);
      int id  = data["id"];
      String msg  = data["msg"];
      if(id==200) {
        return true;
      } else {
        commonMessage(_context, msg);
        return false;
      }
    } else if(response.statusCode==500) {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return false;
    }
    else if(response.statusCode==401)
    {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else {
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return false;
  }

  Future<dynamic> callGetSyloDeepCopy(String syloId, bool isLoader) async {
    print('callGetSyloDeepCopy');
    print("syloId -> $syloId");
    Response response = await restApi.callGetSyloDeepCopy(syloId, isLoader);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var data = jsonDecode(response.body);
      int id  = data["id"];
      String msg  = data["msg"];
      if(id==200) {
        return data["data"];
      } else {
        commonMessage(_context, msg);
        return null;
      }
    } else if(response.statusCode==500) {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return null;
    }
    else if(response.statusCode==401)
    {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else {
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return null;
  }

  Future<bool> callDeleteSylo(int syloId) async {
    print('callDeleteSylo');
    print('syloId - >' + syloId.toString());

    Response response = await restApi.callDeleteSylo(syloId);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var data = jsonDecode(response.body);
      int id  = data["id"];
      String msg  = data["msg"];
      if(id==200) {
        return true;
      } else {
        commonMessage(_context, msg);
        return false;
      }
    } else if(response.statusCode==500) {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return false;
    }
    else if(response.statusCode==401)
    {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else {
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return false;
  }

  Future<dynamic> callUpdateSylo(AddSyloItem addSyloItem) async {
    print('callUpdateSylo');
    d.Response response = await restApi.callUpdateSylo(addSyloItem);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var resdata = (response.data);
      int id  = resdata["id"];
      String msg  = resdata["msg"];
      if(id==200){
        return resdata["data"];
      }
      else{
        commonMessage(_context, msg);
        return null;
      }
    }
    else if(response.statusCode==500){
      var data = (response.data);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return null;
    }
    else if(response.statusCode==401)
    {
      var data = response.data;
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else{
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return null;
  }

  Future<dynamic> callGetFaqs(bool isLoader) async {
    print('callGetFaqs');
    d.Response response = await restApi.callGetFaqs(isLoader);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var resdata = (response.data);
      int id  = resdata["id"];

      String msg  = resdata["msg"];
      if(id==200){
        return resdata['listData'][0];
      }
      else{
        commonMessage(_context, msg);
        return null;
      }
    }
    else if(response.statusCode==500){
      var data = (response.data);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return null;
    }
    else if(response.statusCode==401)
    {
      var data = response.data;
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else{
      commonMessage(_context, App.txtSomethingWentWrong);
      return null;
    }
  }

  Future<dynamic> callSearchFaq(String searchKeys, bool isLoader) async {
    print('callSearchFaq');
    d.Response response = await restApi.callSearchFaq(searchKeys, isLoader);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var resdata = (response.data);
      int id  = resdata["id"];
      String msg  = resdata["msg"];
      if(id==200){
        return resdata['listData'][0];
      }
      else{
        commonMessage(_context, msg);
        return null;
      }
    }
    else if(response.statusCode==500){
      var data = (response.data);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return null;
    }
    else if(response.statusCode==401)
    {
      var data = response.data;
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else{
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return null;
  }

  Future<bool> callChangeNotifySetting(int userId, bool notifyFlag, bool isLoader) async {
    print('callChangeNotifySetting');
    d.Response response = await restApi.callChangeNotifySetting(userId, notifyFlag, isLoader);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var resdata = (response.data);
      int id  = resdata["id"];
      String msg  = resdata["msg"];
      if(id==200){
        return true;
      }
      else{
        commonMessage(_context, msg);
        return false;
      }
    }
    else if(response.statusCode==500){
      var data = (response.data);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return false;
    }
    else if(response.statusCode==401)
    {
      var data = response.data;
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else{
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return false;
  }

  Future<bool> callAddToQcast(String userId, String questionId, bool isLoader) async {
    print('callAddToQcast');
    d.Response response = await restApi.callAddToQcast(userId, questionId, isLoader);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var resdata = (response.data);
      int id  = resdata["id"];
      String msg  = resdata["msg"];
      if(id==200){
        return true;
      }
      else{
        commonMessage(_context, msg);
        return false;
      }
    }
    else if(response.statusCode==500){
      var data = (response.data);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return false;
    }
    else if(response.statusCode==401)
    {
      var data = response.data;
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else{
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return false;
  }

  Future<bool> callCheckAddSyloEmail(String email,String userId) async {
    print("callCheckAddSyloEmail");

    Response response = await restApi.callCheckAddSyloEmail(email,userId);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var data = jsonDecode(response.body);
      int id  = data["id"];
      String msg  = data["msg"];
      if(id==200) {
        return true;
      } else {
        commonMessage(_context, msg);
        return false;
      }
    } else if(response.statusCode==500) {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessage(_context, msg);
      return false;
    }
    else if(response.statusCode==401)
    {
      var data = jsonDecode(response.body);
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else {
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return false;
  }

  Future<bool> callChangeQcastStatus(String userId,String qcastsId,String operation) async {
    print("callChangeQcastStatus");

    d.Response response = await restApi.callChangeQcastStatus(operation,userId,qcastsId);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var data = (response.data);
      int id  = data["id"];
      String msg  = data["msg"];
      if(id==200) {
        return true;
      } else {
        commonMessage(_context, msg);
        return false;
      }
    } else if(response.statusCode==500) {
      var data = jsonDecode(response.data);
      String msg  = data["msg"];
      commonMessage(_context, msg);
      return false;
    }
    else if(response.statusCode==401)
    {
      var data = response.data;
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else {
      commonMessage(_context, App.txtSomethingWentWrong);
    }
    return false;
  }


  Future<dynamic> callYoutubeEmbedLink(String url) async {
    print("callYoutubeEmbedLink");

    d.Response response = await restApi.callYoutubeEmbedLink(url);
    if(response==null){

    }
    else if(response.statusCode==200 || response.statusCode==201){
      var data = (response.data);
      String id  = data["title"];
      String msg  = data["author_name"];
      String thumbnail_url  = data["thumbnail_url"];
      print("data---?"+data.toString());
      if(id==200) {
        return data;
      } else {
        //commonMessage(_context, msg);
        return data;
      }
    } else if(response.statusCode==500) {
      var data = jsonDecode(response.data);
      String msg  = data["msg"];
      //
      // commonMessage(_context, msg);
      return data;
    }
    else if(response.statusCode==401)
    {
      var data = response.data;
      String msg  = data["message"];
      commonMessageToken(_context, msg);
      return null;
    }
    else {
      //commonMessage(_context, App.txtSomethingWentWrong);
    }
    return null;
  }
}

