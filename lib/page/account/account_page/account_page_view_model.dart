import 'dart:convert';

import 'package:testsylo/model/model.dart';
import 'package:testsylo/page/account/account_page/account_page.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';

import '../../../app.dart';

class AccountPageViewModel {
  AccountPageState state;
  InterceptorApi interceptorApi;
  bool isLoader = false;

  AccountPageViewModel(this.state) {
    interceptorApi = InterceptorApi(context: state.context);
    getNotificationList();
  }


  getNotificationList() async {
    print("UserId ->" + appState.userItem.userId.toString());
    var data = await interceptorApi.callGetNotifications(
        appState.userItem.userId,
        false);

    if (data != null) {
      print("jsonEncode -> "+jsonEncode(data));
      NotificationItem notificationItem = NotificationItem.fromJson(data);
      appState.notificationItem = notificationItem;
      state.setState(() { });
    }
  }

  deliverSylos(int userId) async {
    state.setState(() {
      isLoader = true;
    });

    bool isSuccess = await interceptorApi.callDeliverSylo(userId);
    if (isSuccess) {
//      goToHome(state.context);
      state.setState(() {
        isLoader = false;
      });

      return;

    }
    state.setState(() {
      isLoader = false;
    });
  }


}