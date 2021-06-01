import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as d;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/api_request.dart';
import 'package:testsylo/util/util.dart';


import '../../app.dart';
import '../common_service.dart';

class RestApi {
  BuildContext _context;
  CommonService commonService;


  RestApi({context}) {
    _context = context;
    commonService=CommonService();

  }

  static header(String token) {
    Map<String, String> map = {
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };

    print("TokenHeader"+token.toString());
    return map;
  }



  // calls album edit name api
  Future<d.Response> callEditAlbumNameAPI(
      int albumId, String newAlbumName) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host + App.editAlbumName;
    var body = jsonEncode(
        <String, dynamic>{"albumId": albumId, "albumName": newAlbumName});
    showLoader(_context); //label: "b");
    d.Response response;

    try {
      response = await dio.post(
        url,
        data: body,
        options: d.Options(headers: header(await commonService.getToken())),
      )/*/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/*/;
      hideLoader();
      //print('Response request: ${response.request}');
      //print('Response status: ${response.statusCode}');
      //print('Response body: ${response.body}');
      return response;
    } on d.DioError catch (e) {
      print(e);
      hideLoader();
      commonMessage(_context, e.toString());
      return null;
    }
  }

  // calls album delete api
  Future<d.Response> callDeleteAlbumAPI(AlbumDeleteRequest adr) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host + App.deleteAlbum;
    var body = jsonEncode(<String, dynamic>{"albumIdList": adr.albumIdList});
    showLoader(_context); //label: "b");
    d.Response response;
    try {
      response = await dio.post(
        url,
        data: body,
        options: d.Options(  /*{
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: ' application/json',
          //HttpHeaders.contentTypeHeader: 'application/json',
          //HttpHeaders.authorizationHeader: 'Bearer ' + prefs.getString('token')
        }*/headers: header(await commonService.getToken())),
      )/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;
      hideLoader();
      //print('Response request: ${response.request}');
      //print('Response status: ${response.statusCode}');
      //print('Response body: ${response.body}');
      return response;
    } on d.DioError catch (e) {
      print(e);
      hideLoader();
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<d.Response> callGetuserSubDetailsAPI(int userId) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host + App.getUserSubDetails;
    var body = jsonEncode(<String, dynamic>{"userId": userId});
    showLoader(_context); //label: "b");
    d.Response response;
    try {
      response = await dio.post(
        url,
        data: body,
        options: d.Options(headers: header(await commonService.getToken())));/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/
      hideLoader();
      //print('Response request: ${response.request}');
      //print('Response status: ${response.statusCode}');
      print('Response body: ${response}');
      return response;
    } on d.DioError catch (e) {
      print(e);
      hideLoader();
      commonMessage(_context, e.toString());
      return null;
    }
  }

  // calls create deliver sylo api
  Future<d.Response> callDeliverSyloAPI(int userId) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host + App.deliverSylo;
    var body = jsonEncode(<String, dynamic>{"userId": userId});
    showLoader(_context); //label: "b");
    d.Response response;
    try {
      response = await dio.post(
        url,
        data: body,
        options: d.Options(headers: header(await  commonService.getToken())))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;
      hideLoader();
      //print('Response request: ${response.request}');
      //print('Response status: ${response.statusCode}');
      print('Response body: ${response}');
      return response;
    } on d.DioError catch (e) {
      print(e);
      hideLoader();
      commonMessage(_context, e.toString());
      return null;
    }
  }

  // calls get Subscription packages
  Future<d.Response> callGetSubpackagesAPI() async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host + App.getSubPackages;

    showLoader(_context); //label: "b");
    d.Response response;
    try {
      response = await dio.get(
        url,
        options: d.Options(headers: header(await commonService.getToken())),
      )/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;
      hideLoader();
      
      print('Response request: ${response.realUri.queryParameters}');
      //print('Response status: ${response.statusCode}');
      //print('Response body: ${response.body}');
      return response;
    } on d.DioError catch (e) {
      print(e);
      hideLoader();
      commonMessage(_context, e.toString());
      return null;
    }
  }

  // calls get user cloud storage
  Future<d.Response> callGetuserStorageAPI(int userId) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host + App.getUserCloudStorage;
    var body = jsonEncode(<String, dynamic>{"userId": userId});
    // showLoader(_context); //label: "b");
    d.Response response;
    try {
      response = await dio.post(
        url,
        data: body,
        options: d.Options(headers: header(await commonService.getToken())),
      )/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;
      //  hideLoader();
      //print('Response request: ${response.request}');
      //print('Response status: ${response.statusCode}');
      //print('Response body: ${response.body}');
      return response;
    } on d.DioError catch (e) {
      print(e);
      //  hideLoader();
      commonMessage(_context, e.toString());
      return null;
    }
  }

  // calls create feedbaack api
  Future<d.Response> callCreateFeedbackAPI(FeedbackRequest fbr) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host + App.createUserFeedback;
    var body = jsonEncode(<String, dynamic>{
      "category": fbr.category,
      "stars": fbr.stars,
      "feedbackTxt": fbr.feedbackTxt,
      "userId": fbr.userId
    });
    showLoader(_context); //label: "b");
    d.Response response;
    try {
      response = await dio.post(
        url,
        data: body,
        options: d.Options( headers: header(await commonService.getToken())),
      )/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;
      hideLoader();

      return response;
    } on d.DioError catch (e) {
      print(e);
      hideLoader();
      commonMessage(_context, e.toString());
      return null;
    }
  }

  // calls create copy move albumapi
  Future<d.Response> callCopyMoveAlbumAPI(CopyMoveRequest fbr) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host + App.copymoveAlbum;
    var body = jsonEncode(<String, dynamic>{
      "sourceAlbumId": fbr.sourceAlbumId,
      "destinationAlbumIdList": fbr.destinationAlbumIdList,
      "actionType": fbr.actionType
    });
    print("====================body=================="+body);
    showLoader(_context); //label: "b");
    d.Response response;
    try {
      response = await dio.post(
        url,
        data: body,
        options: d.Options(headers: header(await commonService.getToken())),
      )/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;
      hideLoader();
      //print('Response request: ${response.request}');
      //print('Response status: ${response.statusCode}');
      //print('Response body: ${response.body}');
      return response;
    } on d.DioError catch (e) {
      print(e);
      hideLoader();
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<Response> callGetSignInProcess(
      String email, String password, String token) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host +
        App.apiSignInProcess +
        '?password=' +
        password +
        "&email=" +
        email +
        "&token=" +
        token;
    showLoader(_context);
    Response response;
    try {

      response = await http.get(Uri.parse(url))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;
      hideLoader();
      print('Response request: ${response.request}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response;
    } catch (e) {
      print(e);
      hideLoader();
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<Response> callPutForgotPasswordSentLink(String email) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host + App.apiForgetPassword + "?email=" + email;
    showLoader(_context);
    Response response;
    try {
      response = await http.put(Uri.parse(url)/*headers: header(await commonService.getToken())*/)/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;
      hideLoader();
      print('Response request: ${response.request}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response;
    } catch (e) {
      print(e);
      hideLoader();
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<Response> callResendOtpSentLink(String email) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host + App.resendCode + "?email=" + email;
    showLoader(_context);
    Response response;
    try {
      response = await http.get(Uri.parse(url)/*,headers: header(await commonService.getToken())*/)/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;
      hideLoader();
      print('Response request: ${response.request}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response;
    } catch (e) {
      print(e);
      hideLoader();
      commonMessage(_context, e.toString());
      return null;
    }
  }

  d.Dio dio = new d.Dio();

  Future<d.Response> callPostAddUser(AddUserItem addUserItem) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host + App.callAddUser;
    showLoader(_context);
    Response response;
    try {
      //response = await http.post(url, body: addUserItem.toMap());

      d.FormData formData = d.FormData.fromMap(addUserItem.toMap());
      if (addUserItem.file != null) {
        String fileNm = addUserItem.file.path.substring(
            addUserItem.file.path.lastIndexOf("/") + 1,
            addUserItem.file.path.length);

        formData.files.add(
          MapEntry(
            "file",
            d.MultipartFile.fromFileSync(addUserItem.file.path,
                filename: fileNm),
          ),
        );
      } else {}
      d.Response response = null;
      print(url);
      response = await dio.post(
        url,
        data: formData,
        /*options: d.Options(headers: header(await commonService.getToken()))*/

      )/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;

      hideLoader();
      print('Response request: ${response.realUri.path}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.data}');
      return response;
    } catch (e) {
      print(e);
      hideLoader();
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<Response> verifyEmailWithCode(String email, String code) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host +
        App.callVerifyEmailWithCode +
        "?email=" +
        email +
        "&otp=" +
        code;
    showLoader(_context);
    Response response;
    try {
      response = await http.post(Uri.parse(url))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;
      hideLoader();
      print('Response request: ${response.request}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response;
    } catch (e) {
      print(e);
      hideLoader();
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<Response> callChangePassword(String email, String newPassword) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host +
        App.changePassword +
        "?email=" +
        email +
        "&newPassword=" +
        newPassword;
    showLoader(_context);
    Response response;
    try {
      response = await http.put(Uri.parse(url))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;
      hideLoader();
      print('Response request: ${response.request}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response;
    } catch (e) {
      print(e);
      hideLoader();
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<d.Response> callAddSylo(AddSyloItem addSyloItem) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host + App.addSylo;
    showLoader(_context, label: "Posting sylo");
    Response response;

    try {
      //response = await http.post(url, body: addUserItem.toMap());

      d.FormData formData;
      if (addSyloItem.recipientNameSec != "" ||
          addSyloItem.recipientNameSec != null) {
        formData = d.FormData.fromMap(addSyloItem.tooMap());
      } else {
        formData = d.FormData.fromMap(addSyloItem.toMap());
      }
      if (addSyloItem.file != null) {
        String fileNm = addSyloItem.file.path.substring(
            addSyloItem.file.path.lastIndexOf("/") + 1,
            addSyloItem.file.path.length);

        formData.files.add(
          MapEntry(
            "syloPic",
            d.MultipartFile.fromFileSync(addSyloItem.file.path,
                filename: fileNm),
          ),
        );
      } else {}
      d.Response response = null;
      print(url);
      response = await dio.post(
        url,
        data: formData, options: d.Options(headers: header(await commonService.getToken()))
      )/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;

      hideLoader();
      print('Response request: ${response.realUri.queryParameters}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.data}');
      return response;
    } catch (e) {
      print(e);
      hideLoader();
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<Response> callGetUserSylos(String userId) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host + App.getUserSylos + "?userId=" + userId;
    //showLoader(_context);
    Response response;
    try {
      response = await http.get(Uri.parse(url),headers: header(await commonService.getToken()))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;
      //hideLoader();
      print('Response request: ${response.request}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response;
    } catch (e) {
      print(e);
      //hideLoader();
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<Response> callGetPhotoPostSylon(String userid, String type) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) {
      print("not connected");
      return null;
    }
    String url = appState.host +
        App.getSyloMediaByType +
        "?userId=$userid&mediaType=$type";
    print(url);
    showLoader(_context);
    Response response;
    try {
      response = await http.get(Uri.parse(url),headers: header(await commonService.getToken()))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;
      hideLoader();
      print('Response request: ${response.request}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response;
    } catch (e) {
      print(e);
      hideLoader();
      commonMessage(_context, e.toString());
      return null;
    }
  }

  uploadGetMediaIDAPI(FlutterUploader uploader, String userId, File file,
      {bool sync = false}) async {
    String url = appState.host + App.uploadGetMediaID;
    if (sync) {
      url = appState.host + App.uploadGetMediaIDSyn;
    }

    var fileItem = new FileItem(
        savedDir: dirname(file.path),
        filename: basename(file.path),
        fieldname: "mediaFile");

    final taskId = await uploader.enqueue(
        url: url, //required: url to upload to
        files: [fileItem], // required: list of files that you want to upload
        method: UploadMethod.POST, // HTTP method  (POST or PUT or PATCH)
        //headers: { HttpHeaders.acceptHeader: ' application/json',
        //  HttpHeaders.contentTypeHeader: 'application/json'},
        data: {"userId": userId}, // any data you want to send in upload request
        showNotification:
            true, // send local notification (android only) for upload status
        tag: "${userId} - " +
            "${DateTime.now().millisecondsSinceEpoch}".substring(5) +
            " - ${basename(file.path) ?? ""}",
        headers: header(await commonService.getToken())
    ); // unique tag for upload task

    print(taskId);

    uploader.progress.listen((progress) {
      //... code to handle progress
      print("the progress::::::::::::::::::::::::::::::::::");
      //UploadTaskStatus.
      print(progress.status);
      print(progress.status.value);
      print(progress.progress);
    }).onDone(() {});

    uploader.result.listen((result) {
      //... code to handle result
      print("the response:::::::::::::::::::::::::::::::::");
      print(result.response);

      print(result.status);
      print(result.status.description);
      print(result.status.value);

      var payload = jsonDecode(result.response);
      if (result.statusCode == 200 && result.status.value == 3) {
        /*Fluttertoast.showToast(
            msg: "Upload was successful",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Color(0xff9F00C5),
            textColor: Colors.white,
            fontSize: 16.0
        );*/
      } else {
        /*Fluttertoast.showToast(
            msg: App.txtSomethingWentWrong,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Color(0xff9F00C5),
            textColor: Colors.white,
            fontSize: 16.0
        );*/
      }
    }, onError: (ex, stacktrace) {
      // ... code to handle error
      /* Fluttertoast.showToast(
          msg: App.txtSomethingWentWrong + ": ${ex.toString()}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color(0xff9F00C5),
          textColor: Colors.white,
          fontSize: 16.0
      );*/
    });
  }

  Future<d.Response> callUploadGetMediaID(String userId, File file,
      {String loaderLabel, bool sync = false}) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host + App.uploadGetMediaID;
    if (sync) {
      url = appState.host + App.uploadGetMediaIDSyn;
    }
    showLoader(_context, label: loaderLabel ?? "Uploading video");
    Response response;

    try {
      //response = await http.post(url, body: addUserItem.toMap());

      d.FormData formData = d.FormData.fromMap({
        "userId": userId,
      });

      if (file != null) {
        String fileNm = file.path
            .substring(file.path.lastIndexOf("/") + 1, file.path.length);

        formData.files.add(
          MapEntry(
            "mediaFile",
            d.MultipartFile.fromFileSync(file.path, filename: fileNm),
          ),
        );
      } else {}

      d.Response response = null;
      print(url);
      response = await dio.post(
        url,
        data: formData,
        options:  d.Options(headers: header(await commonService.getToken()))
      )/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;

      hideLoader();
      print('Response request: ${response.realUri.queryParameters}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.data}');
      return response;
    } catch (e) {
      print(e);
      hideLoader();
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<d.Response> uploadVideoWithCoverPic(String userId, File file,
      {String loaderLabel}) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host + App.uploadVideoWithCoverPic;
    showLoader(_context, label: loaderLabel ?? "Uploading video");
    Response response;

    try {
      //response = await http.post(url, body: addUserItem.toMap());

      d.FormData formData = d.FormData.fromMap({
        "userId": userId,
      });

      if (file != null) {
        String fileNm = file.path
            .substring(file.path.lastIndexOf("/") + 1, file.path.length);

        formData.files.add(
          MapEntry(
            "mediaFile",
            d.MultipartFile.fromFileSync(file.path, filename: fileNm),
          ),
        );
      } else {}

      d.Response response = null;
      print(url);
      response = await dio.post(
        url,
        data: formData,
        options: d.Options(headers: header(await commonService.getToken()))
      ).timeout(Duration(minutes: 1),onTimeout: (){
        throw TimeoutException('Please try again!');
      });

      hideLoader();
      print('Response request: ${response.realUri.queryParameters}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.data}');
      return response;
    } catch (e) {
      print(e);
      hideLoader();
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<d.Response> callCreateAlbum(
      String albumName, String userId, String syloId) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host + App.createAlbum;
    showLoader(_context);
    Response response;

    try {
      //response = await http.post(url, body: addUserItem.toMap());

      d.FormData formData = d.FormData.fromMap({
        "albumName": albumName,
        "userId": userId,
        "syloId": syloId,
      });

      d.Response response = null;
      print(url);
      response = await dio.post(url, data: formData,options: d.Options(headers: header(await commonService.getToken())))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;

      hideLoader();
      print('Response request: ${response.realUri.queryParameters}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.data}');
      return response;
    } catch (e) {
      print(e);
      hideLoader();
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<Response> callGetAllAlbumsForSylo(String userId, String syloId) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host +
        App.getAllAlbumsForSylo +
        "?userId=" +
        userId +
        "&syloId=" +
        syloId;
//    showLoader(_context);
    Response response;
    try {
      response = await http.get(Uri.parse(url),headers: header(await commonService.getToken()))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;
//      hideLoader();
      print('Response request: ${response.request}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response;
    } catch (e) {
      print(e);
//      hideLoader();
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<d.Response> callPostUpdateUser(
      String userId, AddUserItem addUserItem) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host + App.updateUser;
    showLoader(_context);
    Response response;
    try {
      //response = await http.post(url, body: addUserItem.toMap());
      d.FormData formData;
      if (addUserItem.password != null && addUserItem.password.isNotEmpty) {
        formData = d.FormData.fromMap(addUserItem.toMap());
      } else {
        formData = d.FormData.fromMap(addUserItem.toMapWithoutPassword());
      }

      formData.fields.add(MapEntry("userId", userId));

      if (addUserItem.file != null) {
        String fileNm = addUserItem.file.path.substring(
            addUserItem.file.path.lastIndexOf("/") + 1,
            addUserItem.file.path.length);

        formData.files.add(
          MapEntry(
            "file",
            d.MultipartFile.fromFileSync(addUserItem.file.path,
                filename: fileNm),
          ),
        );
      } else {}
      d.Response response = null;
      print(formData);
      print(url);
      response = await dio.post(
        url,
        data: formData,
        options: d.Options(headers: header(await commonService.getToken()))
      )/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;

      hideLoader();
      print('Response request: ${response.realUri.queryParameters}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.data}');
      return response;
    } catch (e) {
      print(e);
      hideLoader();
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<d.Response> callCreateMediaSubAlbum(
      MediaSubAlbumItem mediaSubAlbumItem) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host + App.createMediaSubAlbum;
    showLoader(_context,
        label:
            "Posting ${mediaSubAlbumItem.mediaType[0].toUpperCase()}${mediaSubAlbumItem.mediaType.substring(1).toLowerCase()}");
    Response response;
    try {
      Map<String, dynamic> dataToSend = new Map<String, dynamic>();
      List<MapEntry> mEntries = new List<MapEntry>();

      dataToSend.addAll(mediaSubAlbumItem.toMap());

      if (mediaSubAlbumItem.mediaType != "TEXT") {
        mediaSubAlbumItem.rawMediaList.forEach((element) {
          MapEntry me = new MapEntry("rawMediaList", element.toString());
          mEntries.add(me);
        });
      }

      if (mEntries.length > 0) {
        mEntries.forEach((element) {
          dataToSend[element.key] = element.value;
        });
      }

      /*d.FormData formData;

      if (mediaSubAlbumItem.mediaType == "TEXT") {
        formData = d.FormData.fromMap(mediaSubAlbumItem.toMapForText());
      } else {
        formData = d.FormData.fromMap(mediaSubAlbumItem.toMap());
      }

      print(mediaSubAlbumItem.toMap().toString());
      if (mediaSubAlbumItem.draft == false) {
        mediaSubAlbumItem.albumList.forEach((element) {
          formData.fields.add(MapEntry("albumList", element.toString()));
        });
      }

      if (mediaSubAlbumItem.mediaType == "PHOTO" ||
          mediaSubAlbumItem.mediaType == "VIDEO" ||
          mediaSubAlbumItem.mediaType == "QCAST" ||
          mediaSubAlbumItem.mediaType == "AUDIO" ||
          mediaSubAlbumItem.mediaType == "VTAG") {
        mediaSubAlbumItem.rawMediaList.forEach((element) {
          formData.fields.add(MapEntry("rawMediaList", element.toString()));
        });
      }*/

      print("------------------");
      print(dataToSend.toString());
      d.Response response = null;
      print(url);
      response = await dio.post(url, queryParameters: dataToSend,options: d.Options(headers: header(await commonService.getToken())))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;

      hideLoader();
      print('Response request: ${response.realUri.queryParameters}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.data}');
      return response;
    } catch (e) {
      print(e);
      hideLoader();
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<d.Response> callCreateMediaSubAlbumNew(
      MediaSubAlbumItem1 mediaSubAlbumItem) async {

    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host + App.createMediaSubAlbum;
    showLoader(_context,
        label:
            "Posting ${mediaSubAlbumItem.mediaType[0].toUpperCase()}${mediaSubAlbumItem.mediaType.substring(1).toLowerCase()}");
    Response response;
    print("------------------123154646");
    try {
      Map<String, dynamic> dataToSend = new Map<String, dynamic>();
      List<MapEntry> mEntries = new List<MapEntry>();
      if (mediaSubAlbumItem.mediaType == "TEXT") {
        dataToSend.addAll(mediaSubAlbumItem.toMapForText());
      }else{
        dataToSend.addAll(mediaSubAlbumItem.toMap());
      }

      /*d.FormData formData;

      if (mediaSubAlbumItem.mediaType == "TEXT") {
        formData = d.FormData.fromMap(mediaSubAlbumItem.toMapForText());
      } else {
        formData = d.FormData.fromMap(mediaSubAlbumItem.toMap());
      }

      print(mediaSubAlbumItem.toMap().toString());
      if (mediaSubAlbumItem.draft == false) {
        mediaSubAlbumItem.albumList.forEach((element) {
          formData.fields.add(MapEntry("albumList", element.toString()));
        });
      }

      if (mediaSubAlbumItem.mediaType == "PHOTO" ||
          mediaSubAlbumItem.mediaType == "VIDEO" ||
          mediaSubAlbumItem.mediaType == "QCAST" ||
          mediaSubAlbumItem.mediaType == "AUDIO" ||
          mediaSubAlbumItem.mediaType == "VTAG") {
        mediaSubAlbumItem.rawMediaList.forEach((element) {
          formData.fields.add(MapEntry("rawMediaList", element.toString()));
        });
      }*/

      print("------------------");
      print(dataToSend.toString());
      d.Response response = null;
      print(url);
      response = await dio.post(url, queryParameters: dataToSend,options: d.Options(headers: header(await commonService.getToken())))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;

      hideLoader();
      print('Response request: ${response.realUri.queryParameters}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.data}');
      return response;
    } catch (e) {
      print(e);
      hideLoader();
      commonMessage(_context, e.toString());
      return null;
    }
  }

  createMediaSubAlbum(
      FlutterUploader uploader, MediaSubAlbumItem mediaSubAlbumItem) async {
    String url = appState.host + App.createMediaSubAlbum;

    Map<String, String> dataToSend = new Map<String, String>();
    List<MapEntry> mEntries = new List<MapEntry>();
    List<MapEntry> mEntries2 = new List<MapEntry>();

    if (mediaSubAlbumItem.mediaType == "TEXT") {
      dataToSend.addAll(mediaSubAlbumItem.toMapForText());
      //formData = d.FormData.fromMap(mediaSubAlbumItem.toMapForText());
    } else {
      dataToSend.addAll(mediaSubAlbumItem.toMap());
      //formData = d.FormData.fromMap(mediaSubAlbumItem.toMap());
    }

    print(mediaSubAlbumItem.toMap().toString());
    if (mediaSubAlbumItem.draft == false) {
      mediaSubAlbumItem.albumList.forEach((element) {
        MapEntry me = new MapEntry("albumList", element.toString());
        mEntries.add(me);

        //formData.fields.add(MapEntry("albumList", element.toString()));
      });
    }

    if (mEntries.length > 0) {
      mEntries.forEach((element) {
        dataToSend[element.key] = element.value;
      });
    }

    if (mediaSubAlbumItem.mediaType == "PHOTO" ||
        mediaSubAlbumItem.mediaType == "VIDEO" ||
        mediaSubAlbumItem.mediaType == "QCAST" ||
        mediaSubAlbumItem.mediaType == "AUDIO" ||
        mediaSubAlbumItem.mediaType == "VTAG") {
      mediaSubAlbumItem.rawMediaList.forEach((element) {
        MapEntry me = new MapEntry("rawMediaList", element.toString());
        mEntries2.add(me);
        //formData.fields.add(MapEntry("rawMediaList", element.toString()));
      });
    }

    if (mEntries2.length > 0) {
      mEntries2.forEach((element) {
        dataToSend[element.key] = element.value;
      });
    }

    final taskId = await uploader.enqueue(
        url: url, //required: url to upload to
        files: [], // required: list of files that you want to upload
        method: UploadMethod.POST, // HTTP method  (POST or PUT or PATCH)
        //headers: { HttpHeaders.acceptHeader: ' application/json',
        //  HttpHeaders.contentTypeHeader: 'application/json'},
        data: dataToSend, // any data you want to send in upload request
        showNotification:
            true, // send local notification (android only) for upload status
        tag: "${mediaSubAlbumItem?.title ?? ""}-" +
            "${DateTime.now().millisecondsSinceEpoch}",
        headers: header(await commonService.getToken())); // unique tag for upload task
    print(taskId);

    uploader.progress.listen((progress) {
      //... code to handle progress
      print("the progress::::::::::::::::::::::::::::::::::");
      //UploadTaskStatus.
      print(progress.status);
      print(progress.status.value);
      print(progress.progress);
    }).onDone(() {});

    uploader.result.listen((result) {
      //... code to handle result
      print("the response:::::::::::::::::::::::::::::::::");
      print(result.response);
      print(result.statusCode);
      print(result.status);
      print(result.status.description);
      print(result.status.value);

      var payload = jsonDecode(result.response);

      print("what is the value here: ${result.status.value}");
      print(payload);
      if (result.statusCode == 200 && result.status.value == 3) {
        /*Fluttertoast.showToast(
            msg: "Upload was successful",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Color(0xff9F00C5),
            textColor: Colors.white,
            fontSize: 16.0
        );*/
      } else {
        /*Fluttertoast.showToast(
            msg: App.txtSomethingWentWrong,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Color(0xff9F00C5),
            textColor: Colors.white,
            fontSize: 16.0
        );*/
      }
    }, onError: (ex, stacktrace) {
      // ... code to handle error
      /*Fluttertoast.showToast(
          msg: App.txtSomethingWentWrong + ": ${ex.toString()}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color(0xff9F00C5),
          textColor: Colors.white,
          fontSize: 16.0
      );*/
    });
  }

  Future<Response> callGetAlbumMediaData(String albumId) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host + App.getAlbumMediaData + "?albumId=" + albumId;
    showLoader(_context);
    Response response;
    try {
      response = await http.get(Uri.parse(url),headers: header(await commonService.getToken()))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;
      hideLoader();
      print('Response request: ${response.request}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response;
    } catch (e) {
      print(e);
      hideLoader();
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<Response> callGetSubAlbumData(String albumId) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host + App.getSubAlbumData + "?subAlbumId=" + albumId;
    showLoader(_context);
    Response response;
    try {
      response = await http.get(Uri.parse(url),headers: header(await commonService.getToken()))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;
      hideLoader();
      print('Response request: ${response.request}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response;
    } catch (e) {
      print(e);
      hideLoader();
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<Response> callVerifyEmailAddress(String email) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host + App.verifyEmailAddress + "?email=" + email;
    showLoader(_context, label: "Verifying email");
    Response response;
    try {
      response = await http.get(Uri.parse(url))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;
      hideLoader();
      print('Response request: ${response.request}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response;
    } catch (e) {
      print(e);
      hideLoader();
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<d.Response> callCreateMyChannelProfile(
      MyChannelProfileItem myChannelProfileItem) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host + App.addMyChannelProfile;
    showLoader(_context);
    Response response;

    try {
      d.FormData formData;
      formData = d.FormData.fromMap(myChannelProfileItem.toMap());

      d.Response response = null;
      print(url);
      print(formData.fields);
      response = await dio.post(url, data: formData,options: d.Options(headers: header(await commonService.getToken())))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;

      hideLoader();
      print('Response request: ${response.realUri.queryParameters}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.data}');
      return response;
    } catch (e) {
      print(e);
      hideLoader();
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<d.Response> callUpdateMyChannelProfile(
      MyChannelProfileItem myChannelProfileItem) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host + App.updateMyChannelProfile;
    showLoader(_context);
    Response response;

    try {
      d.FormData formData;
      formData = d.FormData.fromMap(myChannelProfileItem.toMap());

      d.Response response = null;
      print(url);
      print(formData.fields);
      response = await dio.put(url, data: formData,options: d.Options(headers: header(await commonService.getToken())))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;

      hideLoader();
      print('Response request: ${response.realUri.queryParameters}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.data}');
      return response;
    } catch (e) {
      print(e);
      hideLoader();
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<Response> callGetMyChannelProfile(
      String userId, String myChannelUserId) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host +
        App.getMyChannelProfile +
        "?userId=" +
        userId +
        "&myChannelUserId=" +
        myChannelUserId;
    showLoader(_context);
    Response response;
    try {
      response = await http.get(Uri.parse(url),headers: header(await commonService.getToken()))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;
      hideLoader();
      print('Response request: ${response.request}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response;
    } catch (e) {
      print(e);
      commonMessage(_context, e.toString());
      hideLoader();
      return null;
    }
  }

  Future<Response> callGetSharedSylos(String userId, String emailId) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host +
        App.getSharedSylos +
        "?userId=" +
        userId +
        "&emailId=" +
        emailId;
//    showLoader(_context);
    Response response;
    try {
      response = await http.get(Uri.parse(url),headers: header(await commonService.getToken()))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;
//      hideLoader();
      print('Response request: ${response.request}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response;
    } catch (e) {
      print(e);
//      hideLoader();
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<d.Response> callAskSyloQuestions(
      AskSyloQuestionItem askSyloQuestionItem) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host + App.askSyloQuestions;
    showLoader(_context, label: "Posting Question");
    Response response;

    try {
      d.FormData formData;

      formData = d.FormData.fromMap(askSyloQuestionItem.toMap());

      if (askSyloQuestionItem.mediaType == "AUDIO" ||
          askSyloQuestionItem.mediaType == "VIDEO" ||
          askSyloQuestionItem.mediaType == "QCAST") {
        askSyloQuestionItem.rawMediaIds.forEach((element) {
          formData.fields.add(MapEntry("rawMediaIds", element.toString()));
        });
      }

      d.Response response = null;
      print(formData.fields);
      print(url);
      response = await dio.post(url, data: formData,options: d.Options(headers: header(await commonService.getToken())))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;

      hideLoader();
      print('Response request: ${response.realUri.queryParameters}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.data}');
      return response;
    } catch (e) {
      print(e);
      hideLoader();
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<Response> callGetSyloMediaCount(String syloId) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host + App.getSyloMediaCount + "?syloId=" + syloId;
//    showLoader(_context);
    Response response;
    try {
      response = await http.get(Uri.parse(url),headers: header(await commonService.getToken()))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;
//      hideLoader();
      print('Response request: ${response.request}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response;
    } catch (e) {
      print(e);
//      hideLoader();
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<Response> callGetQcastByUser(int userId) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url =
        appState.host + App.getQcastByUser + "?userId=" + userId.toString();
    //showLoader(_context);
    Response response;
    try {
      response = await http.get(Uri.parse(url),headers: header(await commonService.getToken()))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;
      //hideLoader();
      print('Response request: ${response.request}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response;
    } catch (e) {
      print(e);
      hideLoader();
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<Response> callGetSyloQuestions(String syloId) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host + App.getSyloQuestions + "?syloId=" + syloId;
    showLoader(_context);
    Response response;
    try {
      response = await http.get(Uri.parse(url),headers: header(await commonService.getToken()))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;
      hideLoader();
      print('Response request: ${response.request}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response;
    } catch (e) {
      print(e);
      hideLoader();
      commonMessage(_context, e.toString());
      return null;
    }
  }

  callAddQcastBackground(
      FlutterUploader uploader, CreateQcastItem createQcastItem) async {
    String url = appState.host + App.addQcast;
    Map<String, String> dataToSend = new Map<String, String>();
    List<MapEntry> mEntries = new List<MapEntry>();

    dataToSend.addAll(createQcastItem.toMap());

    createQcastItem.listOfVideo.forEach((element) {
      MapEntry me = new MapEntry("listOfVideo", element.toString());
      mEntries.add(me);
      print("Ssaassaf" + me.toString());
    });

    createQcastItem.sampleQuestion.forEach((element) {
      MapEntry me = new MapEntry("sampleQuestion", element.toString());
      mEntries.add(me);
    });

    if (mEntries.length > 0) {
      mEntries.forEach((element) {
        dataToSend[element.key] = element.value;
      });
    }

    final taskId = await uploader.enqueue(
        url: url, //required: url to upload to
        files: [], // required: list of files that you want to upload
        method: UploadMethod.POST, // HTTP method  (POST or PUT or PATCH)
        //headers: { HttpHeaders.acceptHeader: ' application/json',
        //  HttpHeaders.contentTypeHeader: 'application/json'},
        data: {
          "title": createQcastItem.title,
          "Category": createQcastItem.category,
          "preview_video_id": createQcastItem.previewVideoId,
          "cover_photo": createQcastItem.coverPhoto,
          "listOfVideo": createQcastItem.listOfVideo.toString(),
          "Status": createQcastItem.status,
          "userId": createQcastItem.userId,
          "sampleQuestion": createQcastItem.sampleQuestion.toString(),
          "profileName": createQcastItem.profileName,
        }, // any data you want to send in upload request
        showNotification:
            true, // send local notification (android only) for upload status
        tag: "${createQcastItem.title ?? ""} - " +
            "${DateTime.now().millisecondsSinceEpoch}"
                .substring(5),
        headers: header(await commonService.getToken())
    ); // unique tag for upload task

    print(taskId);
    print(dataToSend);

    uploader.progress.listen((progress) {
      //... code to handle progress
      print(dataToSend);
      print("the progress1::::::::::::::::::::::::::::::::::");
      //UploadTaskStatus.
      print(progress.status);
      print(progress.status.value);
      print(progress.progress);
    }).onDone(() {
      print("Video Uploaded");
    });

    uploader.result.listen((result1) {
      //... code to handle result
      print("the response1:::::::::::::::::::::::::::::::::");
      print(result1.response);

      print(result1.status);
      print(result1.status.description);
      print(result1.status.value);

      var payload = jsonDecode(result1.response);
      if (result1.statusCode == 200 && result1.status.value == 3) {
        Fluttertoast.showToast(
            msg: "Upload was successful",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Color(0xff9F00C5),
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: App.txtSomethingWentWrong,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Color(0xff9F00C5),
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }, onError: (ex, stacktrace) {
      // ... code to handle error
      Fluttertoast.showToast(
          msg: App.txtSomethingWentWrong + ": ${ex.toString()}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color(0xff9F00C5),
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }

  Future<d.Response> callAddQcast(CreateQcastItem1 createQcastItem) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host + App.addQcast;
    //showLoader(_context);

    try {
      Map<String, String> dataToSend = new Map<String, String>();

      dataToSend.addAll(createQcastItem.toMap());

      print(dataToSend);

      d.Response response = null;
      print(url);
      response = await dio.post(url, queryParameters: {
        "title": createQcastItem.title,
        "Category": createQcastItem.category,
        "preview_video_id": createQcastItem.previewVideoId,
        "cover_photo": createQcastItem.coverPhoto,
        "listOfVideo": createQcastItem.listOfVideo,
        "Status": createQcastItem.status,
        "userId": createQcastItem.userId,
        "profileName": createQcastItem.profileName,
        "sampleQuestion": createQcastItem.sampleQuestion,
      },options: d.Options(headers: header(await commonService.getToken())))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;

      //hideLoader();
      print('Request url:' + url);
      print('Response request: ${response.realUri.queryParameters}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.data}');
      return response;
    } catch (e) {
      print(e);
      //hideLoader();
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<Response> callPblishQcast(int qcastId, int userId) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host +
        App.publishQcast +
        "?qcastId=" +
        qcastId.toString() +
        "&userId=" +
        userId.toString();
    showLoader(_context);
    Response response;
    try {
      response = await http.put(Uri.parse(url),headers: header(await commonService.getToken()))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;
      hideLoader();
      print('Request url:' + url);
      print('Response request: ${response.request}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response;
    } catch (e) {
      print(e);
      hideLoader();
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<Response> callGetQcastDashboard(int userId, bool isLoader) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url =
        appState.host + App.getQcastDashboard + "?userId=" + userId.toString();
    if (isLoader) {
      showLoader(_context);
    }
    Response response;
    try {
      response = await http.get(Uri.parse(url),headers: header(await commonService.getToken()))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;
      if (isLoader) {
        hideLoader();
      }
      print('Response request: ${response.request}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response;
    } catch (e) {
      print(e);
      if (isLoader) {
        hideLoader();
      }
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<Response> callUnSubscribeUser(
      String publisherId, String subscriberId, bool isLoader) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host +
        App.unSubscribeUser +
        "?publisherId=" +
        publisherId.toString() +
        "&subscriberId=" +
        subscriberId.toString();
    if (isLoader) {
      showLoader(_context);
    }
    Response response;
    try {
      response = await http.get(Uri.parse(url),headers: header(await commonService.getToken()))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;
      if (isLoader) {
        hideLoader();
      }
      print('Response request: ${response.request}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response;
    } catch (e) {
      print(e);
      if (isLoader) {
        hideLoader();
      }
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<Response> callSubscribeUser(
      String publisherId, String subscriberId, bool isLoader) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host +
        App.subscribeUser +
        "?publisherId=" +
        publisherId.toString() +
        "&subscriberId=" +
        subscriberId.toString();
    if (isLoader) {
      showLoader(_context);
    }
    Response response;
    try {
      response = await http.post(Uri.parse(url),headers: header(await commonService.getToken()))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;
      if (isLoader) {
        hideLoader();
      }
      print('Response request: ${response.request}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response;
    } catch (e) {
      print(e);
      if (isLoader) {
        hideLoader();
      }
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<Response> callGetQcastByCategory(
      String category, bool isLoader) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host +
        App.getQcastByCategory +
        "?category=" +
        category.toString();
    if (isLoader) {
      showLoader(_context);
    }
    Response response;
    try {
      response = await http.get(Uri.parse(url),headers: header(await commonService.getToken()))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;
      if (isLoader) {
        hideLoader();
      }
      print('Response request: ${response.request}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response;
    } catch (e) {
      print(e);
      if (isLoader) {
        hideLoader();
      }
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<Response> callGetQcastDeepCopy(
      String qcastId, String userId, bool isLoader) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host +
        App.getQcastDeepCopy +
        "?qcastId=" +
        qcastId.toString() +
        "&userId=" +
        userId.toString();
    if (isLoader) {
      showLoader(_context);
    }
    Response response;
    try {
      response = await http.get(Uri.parse(url),headers: header(await commonService.getToken()))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;
      if (isLoader) {
        hideLoader();
      }
      print('Response request: ${response.request}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response;
    } catch (e) {
      print(e);
      if (isLoader) {
        hideLoader();
      }
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<Response> callDownloadQcast(
      String qcastId, String userId, bool isLoader) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host +
        App.downloadQcast +
        "?qcastId=" +
        qcastId.toString() +
        "&userId=" +
        userId.toString();
    if (isLoader) {
      showLoader(_context);
    }
    Response response;
    try {
      response = await http.post(Uri.parse(url),headers: header(await commonService.getToken()))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;
      if (isLoader) {
        hideLoader();
      }
      print('Response request: ${response.request}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response;
    } catch (e) {
      print(e);
      if (isLoader) {
        hideLoader();
      }
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<Response> callGetMyDownloadedQcasts(int userId, bool isLoader) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host +
        App.getMyDownloadedQcasts +
        "?userId=" +
        userId.toString();
    if (isLoader) {
      showLoader(_context);
    }
    Response response;
    try {
      response = await http.get(Uri.parse(url),headers: header(await commonService.getToken()))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;
      if (isLoader) {
        hideLoader();
      }
      print('Response request: ${response.request}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response;
    } catch (e) {
      print(e);
      if (isLoader) {
        hideLoader();
      }
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<Response> callGetPrompts(int userId) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url =
        appState.host + App.getPrompts + "?userId=" + userId.toString();

      //showLoader(_context);

    Response response;
    try {
      response = await http.get(Uri.parse(url),headers: header(await commonService.getToken()))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;

       // hideLoader();

      print('Response request: ${response.request}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response;
    } catch (e) {
      print(e);

       // hideLoader();

      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<d.Response> callSaveCustomPrompt(
      CustomPromptItem customPromptItem, bool isLoader) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host + App.saveCustomPrompt;
    if (isLoader) {
      showLoader(_context);
    }
    Response response;

    try {
      d.FormData formData;

      formData = d.FormData.fromMap(customPromptItem.toMap());

      customPromptItem.promptsList.forEach((element) {
        formData.fields.add(MapEntry("promptsList", element.toString()));
      });

      d.Response response = null;
      print(formData.fields);
      print(url);
      response = await dio.post(url, data: formData,options: d.Options(headers: header(await commonService.getToken())))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;

      if (isLoader) {
        hideLoader();
      }
      print('Response request: ${response.realUri.queryParameters}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.data}');
      return response;
    } catch (e) {
      print(e);
      if (isLoader) {
        hideLoader();
      }
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<d.Response> callGetOrUpdateIP(
      InActivityPeriodItem inActivityPeriodItem, bool isLoader) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host + App.getOrUpdateIP;
    if (isLoader) {
      showLoader(_context);
    }

    try {
      d.Response response = null;
      print(inActivityPeriodItem.toMap());
      print(url);
      response =
          await dio.get(url, queryParameters: inActivityPeriodItem.toMap(),options:d.Options(headers: header(await commonService.getToken())))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;

      if (isLoader) {
        hideLoader();
      }
      print('Response request: ${response.realUri.queryParameters}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.data}');
      return response;
    } catch (e) {
      print(e);
      if (isLoader) {
        hideLoader();
      }
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<Response> callGetNotifications(int userId, bool isLoader) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url =
        appState.host + App.getNotifications + "?userId=" + userId.toString();

      //showLoader(_context);
    /*}*/
    Response response;
    try {
      response = await http.get(Uri.parse(url),headers: header(await commonService.getToken()))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;
     /* if (isLoader) {*/
        //hideLoader();
//      }
      print('Response request: ${response.request}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response;
    } catch (e) {
      print(e);
     /* if (isLoader) {*/
       // hideLoader();
      //}
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<Response> callMarkReadFlag(
      int userId, bool isMsgRead, int notificationId, bool isLoader) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host +
        App.markReadFlag +
        "?userId=" +
        userId.toString() +
        "&isMsgRead=" +
        isMsgRead.toString() +
        "&notification_id=" +
        notificationId.toString();
    if (isLoader) {
      showLoader(_context);
    }
    Response response;
    try {
      response = await http.post(Uri.parse(url),headers: header(await commonService.getToken()));
      if (isLoader) {
        hideLoader();
      }
      print('Response request: ${response.request}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response;
    } catch (e) {
      print(e);
      if (isLoader) {
        hideLoader();
      }
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<Response> callDeleteNotification(
      int userId, int notificationId, bool isLoader) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host +
        App.deleteNotification +
        "?userId=" +
        userId.toString() +
        "&notificationId=" +
        notificationId.toString();
    if (isLoader) {
      showLoader(_context);
    }
    Response response;
    try {
      response = await http.delete(Uri.parse(url),headers: header(await commonService.getToken()))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;
      if (isLoader) {
        hideLoader();
      }
      print('Response request: ${response.request}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response;
    } catch (e) {
      print(e);
      if (isLoader) {
        hideLoader();
      }
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<d.Response> callGetAllAlbumsForSyloList(
      int userId, List<String> syloIds, bool isLoader) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host +
        App.getAllAlbumsForSyloList +
        "?userId=" +
        userId.toString() +
        "&syloList=" +
        syloIds.join("&syloList=");
    if (isLoader) {
      showLoader(_context);
    }

    try {
      d.Response response = null;
      print(url);
      response = await dio.get(url,options: d.Options(headers: header(await commonService.getToken())))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;

      if (isLoader) {
        hideLoader();
      }
      print('Response request: ${response.realUri.queryParameters}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.data}');
      return response;
    } catch (e) {
      print(e);
      if (isLoader) {
        hideLoader();
      }
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<Response> callDeleteSubAlbum(int subAlbumId) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host +
        App.deleteSubAlbum +
        "?subAlbumId=" +
        subAlbumId.toString();
    //showLoader(_context);
    Response response;
    try {
      response = await http.delete(Uri.parse(url),headers: header(await commonService.getToken()))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;
      //hideLoader();
      print('Response request: ${response.request}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response;
    } catch (e) {
      print(e);
//      hideLoader();
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<Response> callGetSyloDeepCopy(String syloId, bool isLoader) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url =
        appState.host + App.getSyloDeepCopy + "?syloId=" + syloId.toString();
    if (isLoader) {
      showLoader(_context);
    }
    Response response;
    try {
      response = await http.get(Uri.parse(url),headers: header(await commonService.getToken()))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;
      if (isLoader) {
        hideLoader();
      }
      print('Response request: ${response.request}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response;
    } catch (e) {
      print(e);
      if (isLoader) {
        hideLoader();
      }
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<Response> callDeleteSylo(int syloId) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url =
        appState.host + App.deleteSylo + "?syloId=" + syloId.toString();
    //showLoader(_context);
    Response response;
    try {
      response = await http.delete(Uri.parse(url),headers: header(await commonService.getToken()))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;
      //hideLoader();
      print('Response request: ${response.request}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response;
    } catch (e) {
      print(e);
//      hideLoader();
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<d.Response> callUpdateSylo(AddSyloItem addSyloItem) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host + App.updateSylo;
    showLoader(_context, label: "Updating sylo");
    Response response;

    try {
      //response = await http.post(url, body: addUserItem.toMap());

      d.FormData formData;
      if (addSyloItem.recipientNameSec != "" &&
          addSyloItem.recipientNameSec != null) {
        formData = d.FormData.fromMap(addSyloItem.tooMap());
      } else {
        formData = d.FormData.fromMap(addSyloItem.toMap());
      }
      if (addSyloItem.file != null) {
        String fileNm = addSyloItem.file.path.substring(
            addSyloItem.file.path.lastIndexOf("/") + 1,
            addSyloItem.file.path.length);

        formData.files.add(
          MapEntry(
            "syloPic",
            d.MultipartFile.fromFileSync(addSyloItem.file.path,
                filename: fileNm),
          ),
        );
      } else {}
      d.Response response = null;
      print(url);
      print(formData.fields);
      response = await dio.post(
        url,
        data: formData,
        options:  d.Options(headers: header(await commonService.getToken()))
      )/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;

      hideLoader();
      print('Response request: ${response.realUri.queryParameters}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.data}');
      return response;
    } catch (e) {
      print(e);
      hideLoader();
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<d.Response> callGetFaqs(bool isLoader) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host + App.getFaqs;
    if (isLoader) {
      showLoader(_context);
    }

    try {
      d.Response response = null;
      print(url);
      response = await dio.get(url,options:d.Options(headers: header(await commonService.getToken())))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;

      if (isLoader) {
        hideLoader();
      }
      print('Response request: ${response.realUri.queryParameters}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.data}');
      return response;
    } catch (e) {
      print(e);
      if (isLoader) {
        hideLoader();
      }
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<d.Response> callSearchFaq(String searchKeys, bool isLoader) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host + App.searchFaq + "?searchKeys=" + searchKeys;
    if (isLoader) {
      showLoader(_context);
    }

    try {
      d.Response response = null;
      print(url);
      response = await dio.get(url,options: d.Options(headers: header(await commonService.getToken())))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;

      if (isLoader) {
        hideLoader();
      }
      print('Response request: ${response.realUri.queryParameters}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.data}');
      return response;
    } catch (e) {
      print(e);
      if (isLoader) {
        hideLoader();
      }
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<d.Response> callChangeNotifySetting(
      int userId, bool notifyFlag, bool isLoader) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host +
        App.changeNotifySetting +
        "?userId=" +
        userId.toString() +
        "&notifyFlag=" +
        notifyFlag.toString();
    if (isLoader) {
      showLoader(_context);
    }

    try {
      d.Response response = null;
      print(url);
      response = await dio.post(url,options:d.Options(headers: header(await commonService.getToken())))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;

      if (isLoader) {
        hideLoader();
      }
      print('Response request: ${response.realUri.queryParameters}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.data}');
      return response;
    } catch (e) {
      print(e);
      if (isLoader) {
        hideLoader();
      }
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<d.Response> callAddToQcast(
      String userId, String questionId, bool isLoader) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host +
        App.addToQcast +
        "?userId=" +
        userId +
        "&questionId=" +
        questionId;
    if (isLoader) {
      showLoader(_context);
    }

    try {
      d.Response response = null;
      print(url);
      response = await dio.post(url,options: d.Options(headers: header(await commonService.getToken())))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;

      if (isLoader) {
        hideLoader();
      }
      print('Response request: ${response.realUri.queryParameters}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.data}');
      return response;
    } catch (e) {
      print(e);
      if (isLoader) {
        hideLoader();
      }
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<Response> callCheckAddSyloEmail(String email, String userId) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host +
        App.addSyloEmail +
        "?userId=" +
        userId +
        "&emailId=" +
        email;
    Response response;
    try {
      response = await http.get(Uri.parse(url),headers: header(await commonService.getToken()))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;
      print('Response request: ${response.request}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response;
    } catch (e) {
      print(e);
//      hideLoader();
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<d.Response> callChangeQcastStatus(
      String operation, String userId, String qcastId) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = appState.host + App.changeQcastStatus;
    d.Response response;
    final body = {
      "userId": userId,
      "qcastId": qcastId,
      "operation": operation,
    };
    final jsonString = json.encode(body);
    try {
      response = await dio.post(url, data: {
        "userId": userId,
        "qcastId": qcastId,
        "operation": operation,
      },options: header(await commonService.getToken())
      )/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;

      print('Response request: ${response.realUri.queryParameters}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.data}');
      return response;
    } catch (e) {
      print(e);
//      hideLoader();
      commonMessage(_context, e.toString());
      return null;
    }
  }

  Future<d.Response>  callYoutubeEmbedLink(String url1) async {
    bool isConnect = await isConnectNetworkWithMessage(_context);
    if (!isConnect) return null;
    String url = "https://www.youtube.com/oembed?url=$url1&format=json";
    d.Response response;


    try {
      response = await dio.get(url,options: d.Options(headers: header(await commonService.getToken())))/*.timeout(Duration(seconds: 10),onTimeout: (){
        throw TimeoutException('Please try again!');
      })*/;
      print('Response request: ${response.realUri.queryParameters}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.data}');
      return response;
    } catch (e) {
      print(e);
//      hideLoader();
      commonMessage(_context, e.toString());
      return null;
    }
  }
}
