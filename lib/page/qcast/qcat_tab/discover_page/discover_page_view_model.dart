import 'dart:convert';

import 'package:testsylo/model/qcast_dashboard_item.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';

import '../../../../app.dart';
import 'dsicover_page.dart';

class DiscoverPageViewModel {
  DiscoverPageState state;
  InterceptorApi interceptorApi;
  List<String> listFeatured = List();

  List<DiscoverQcastItem> listFeaturedQcasts;
  List<DiscoverQcastItem> listMostPopularQcasts;
  List<DiscoverQcastItem> listMySubscriptions;

  DiscoverPageViewModel(DiscoverPageState state) {
    this.state = state;
    interceptorApi = InterceptorApi(context: state.context);
    initializeLists();
    getQcastDashboard();
    listFeatured.add("");
    listFeatured.add("");
    listFeatured.add("");
    listFeatured.add("");
  }
  initializeLists() {
    if(appState.qcastDashboardItem!=null) {
      listFeaturedQcasts = appState.qcastDashboardItem.featuredQcasts;
      listMostPopularQcasts = appState.qcastDashboardItem.mostPopularQcasts;
      listMySubscriptions = appState.qcastDashboardItem.mySubscriptions;
    } else {
      listFeaturedQcasts = List();
      listMostPopularQcasts = List();
      listMySubscriptions = List();
    }
  }
  getQcastDashboard() async {
    print("UserId ->" + appState.userItem.userId.toString());
    bool isLoaderDisplay = appState.qcastDashboardItem==null ? true : false;
    try{
      var data = await interceptorApi.callGetQcastDashboard(appState.userItem.userId, isLoaderDisplay);
      if (data != null) {
        print("jsonEncode -> "+jsonEncode(data));

        QcastDashboardItem qcastDashboardItem = QcastDashboardItem.fromJson(data);
        appState.qcastDashboardItem = qcastDashboardItem;
        listFeaturedQcasts = qcastDashboardItem.featuredQcasts;
        listMostPopularQcasts = qcastDashboardItem.mostPopularQcasts;
        listMySubscriptions = qcastDashboardItem.mySubscriptions;

        print("featuredQcasts -> " + listFeaturedQcasts.length.toString());
        print("mostPopularQcasts -> " + listMostPopularQcasts.length.toString());
        print("mySubscriptions -> " + listMySubscriptions.length.toString());

        state.setState(() { });
      }
    }
    catch(e){

    }

  }
}
