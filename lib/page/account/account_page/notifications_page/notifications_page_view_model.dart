import 'dart:convert';

import 'package:testsylo/app.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/page/account/account_page/notifications_page/notifications_page.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';

class NotificationsPageViewModel {
  NotificationsPageState state;
  InterceptorApi interceptorApi;
  List<NotificationList> notificationList;


  NotificationsPageViewModel(this.state) {
    interceptorApi = InterceptorApi(context: state.context);
    notificationList = appState.notificationItem==null ? List<NotificationList>() : appState.notificationItem.notificationList;
    notificationCount();

  }

  notificationCount() async {
    for (int i = 0; i < appState.notificationItem.notificationList.length; i++) {
      try {
        NotificationListDatabase notificationListDatabase=NotificationListDatabase(
            notifyId:appState.notificationItem.notificationList[i].notifyId,
            description:appState.notificationItem.notificationList[i].description,
            title:appState.notificationItem.notificationList[i].title
        );
        await databaseHelper.insertNotification(notificationListDatabase);
      } catch (e) {
        print("Excption of" + e.toString());
      }

    }

    List<NotificationListDatabase> notificationList1 = List();
    notificationList1 = await databaseHelper.getAllNotification();
    if(notificationList1.length<appState.notificationItem.notificationList.length) {
      appState.notificationNumber = appState.notificationItem.notificationList.length-notificationList1.length;
      print("DifferenceList"+appState.notificationNumber.toString());
    }
    else{
      appState.notificationNumber = 0;
    }
    state.setState(() { });
  }
  
  callMarkReadFlag(bool isMsgRead, int notificationId) async {
    var data = await interceptorApi.callMarkReadFlag(
        appState.userItem.userId,
        isMsgRead,
        notificationId,
        false);

    if (data != null) {
      print("jsonEncode -> "+jsonEncode(data));

      NotificationItem notificationItem = NotificationItem.fromJson(data);
      appState.notificationItem = notificationItem;
      notificationList = notificationItem.notificationList;



      print("NotificationList -> " + notificationList.length.toString());

      state.setState(() { });
    }
  }

  callDeleteNotification(int notificationId) async {
    var data = await interceptorApi.callDeleteNotification(
        appState.userItem.userId,
        notificationId,
        false);

    if (data != null) {
      print("jsonEncode -> "+jsonEncode(data));

      NotificationItem notificationItem = NotificationItem.fromJson(data);
      appState.notificationItem = notificationItem;
      notificationList = notificationItem.notificationList;

      print("NotificationList -> " + notificationList.length.toString());

      state.setState(() { });
    }
  }

  callChangePushNotifySetting(bool notifyFlag) async {
    var data = await interceptorApi.callChangeNotifySetting(
        appState.userItem.userId,
        notifyFlag,
        false);

    if (data != null && data==true) {
      state.pushNotifyStatus = notifyFlag;
      appState.notificationItem.isNotificationOn = notifyFlag;
      state.setState(() { });
    }
  }
}