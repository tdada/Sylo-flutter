import 'dart:convert';
import 'dart:math';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/service/database/database_helper.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';

import '../../app.dart';
import 'home_sylo_page.dart';

class HomeSyloPageViewModel {
  HomeSyloPageState state;
  bool isGrid = false;
  InterceptorApi interceptorApi;
  DatabaseHelper databaseHelper;
  List<GetUserSylos> getUserSylosList;
  List<GetUserSylos> gridgetUserSylosList;

  List<List<GetUserSylos>> chunkgetUserSylosList = List();

  HomeSyloPageViewModel(HomeSyloPageState state) {
    this.state = state;
    databaseHelper = DatabaseHelper();
    interceptorApi = InterceptorApi(context: state.context);
    getUserSylos();
    //getNotificationList();
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
      if(notificationList1.length>notificationItem.notificationList.length) {
        appState.notificationNumber = notificationItem.notificationList.length-notificationList1.length;
      }

      state.setState(() {

      });
    }
  }




  getUserSylos() async {
    getUserSylosList = appState.getUserSylosList;
    gridgetUserSylosList = appState.getUserSylosList;
    if (getUserSylosList == null ||
        state.widget.from == "_SuccessMessagePageState" ||
        state.widget.from == "DashBoardPageState" ||
        state.widget.from == "AddSyloPageState") {
      List<GetUserSylos> list = await interceptorApi.callGetUserSylos();
      if (list == null) {
        list = List();
      }
      getUserSylosList = list;
      gridgetUserSylosList = list;
      appState.getUserSylosList = getUserSylosList;
      totalPage = (getUserSylosList.length / 8).floor() + 1;
    }
    chunkgetUserSylosList = chunk(getUserSylosList, 8);
    if(chunkgetUserSylosList.isNotEmpty) {
      getUserSylosList = chunkgetUserSylosList[0];
    }
    state.setState(() {});
  }

  int currentPage = 1;
  int totalPage = 1;

  getCircleListLength() {
    print("albumMediaDataList -> " + getUserSylosList.length.toString());
    print("totalPage -> " + totalPage.toString());
    if (getUserSylosList == null) {
      return 0;
    } else if (getUserSylosList.length > currentPage * 8) {
      return 8;
    } else if (currentPage == 1) {
      return getUserSylosList.length;
    } else {
      return getUserSylosList.length - (currentPage * 8);
    }
  }

  goToNextPage() {
    if (currentPage == totalPage) {
      return;
    }
    currentPage++;
  }

  goToPrevPage() {
    if (currentPage == totalPage) {
      return;
    }
    currentPage--;
  }

  List<List<T>> chunk<T>(List<T> lst, int size) {
    return List.generate((lst.length / size).ceil(),
        (i) => lst.sublist(i * size, min(i * size + size, lst.length)));
  }
}
