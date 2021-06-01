import 'dart:convert';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/service/database/database_helper.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';

import '../../app.dart';
import 'dashboard_page.dart';

class DashBoardPageViewModel {
  DashBoardPageState state;
  bool isGrid = false;
  int menuIndex = 5;
  InterceptorApi interceptorApi;
  DatabaseHelper databaseHelper;
  DashBoardPageViewModel(DashBoardPageState state) {
    this.state = state;
    databaseHelper=DatabaseHelper();

    interceptorApi = InterceptorApi(context: state.context);
    if(state.widget.initIndex != null) {
      menuIndex = state.widget.initIndex;
    }
    getNotificationList();
  }

  getNotificationList() async {
    print("UserId ->" + appState.userItem.userId.toString());
    var data = await interceptorApi.callGetNotifications(
        appState.userItem.userId, false);

    if (data != null) {
      NotificationItemDatabase notificationItem =
      NotificationItemDatabase.fromJson(data);
      List<NotificationListDatabase> notificationList = List();
      notificationList = await databaseHelper.getAllNotification();
      if(notificationList.length>notificationItem.notificationList.length) {
        appState.notificationNumber = notificationItem.notificationList.length-notificationList.length;
      }
      for (int i = 0; i < notificationItem.notificationList.length; i++) {
        if (notificationList.isEmpty) {
          try {
            await databaseHelper
                .insertNotification(notificationItem.notificationList[i]);
          } catch (e) {
            print("Excption of" + e.toString());
          }
        }
      }
      List<NotificationListDatabase> notificationList1 = List();
      notificationList1 = await databaseHelper.getAllNotification();
      if(notificationList1.length<notificationItem.notificationList.length) {
        appState.notificationNumber = notificationItem.notificationList.length-notificationList1.length;
      }

      state.setState(() {

      });
    }
  }

}
