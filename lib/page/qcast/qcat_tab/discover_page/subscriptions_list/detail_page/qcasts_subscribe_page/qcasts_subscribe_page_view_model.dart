import 'dart:convert';

import 'package:testsylo/app.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/api_request.dart';
import 'package:testsylo/model/qcast_item.dart';
import 'package:testsylo/page/qcast/qcat_tab/discover_page/subscriptions_list/detail_page/qcasts_subscribe_page/qcasts_subscribe_page.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';

class QcastsSubscribePageViewModel {
  QcastsSubscribePageState state;
  String isSubscribe;
  InterceptorApi interceptorApi;
  MyChannelProfileItem myChannelProfileItem = MyChannelProfileItem();
  List<QcastItem> listPublishQcastItem = List();
  QcastsSubscribePageViewModel(QcastsSubscribePageState qcastsSubscribePageState){
    state = qcastsSubscribePageState;
    interceptorApi = InterceptorApi(context: state.context);
    print("myChannelUserId ->"+state.widget.discoverQcastItem.userId.toString());
    getMyChannel();
    getQcastList();
  }

  getMyChannel() async {
    myChannelProfileItem = await interceptorApi.callGetMyChannelProfile(
        appState.userItem.userId.toString(),
        state.widget.discoverQcastItem.userId.toString()
    );
    if(myChannelProfileItem!=null) {
      if(myChannelProfileItem.isAlreadySubscribed=="Yes"||myChannelProfileItem.isAlreadySubscribed=="No") {
        isSubscribe = myChannelProfileItem.isAlreadySubscribed;
      }
      state.setState(() {
      });
    }
  }

  callUnsubscribe() async {
    bool isUnsubscribe = await interceptorApi.callUnSubscribeUser(
        state.widget.discoverQcastItem.userId.toString(),
        appState.userItem.userId.toString(),
        false);
    if(isUnsubscribe) {
      isSubscribe = "No";
      state.needToChangeState = true;
      commonToast("Unsubscribed successfully");
      state.setState(() {
      });
    }
  }

  callSubscribe() async {
    bool subscribeResult = await interceptorApi.callSubscribeUser(
        state.widget.discoverQcastItem.userId.toString(),
        appState.userItem.userId.toString(),
        false);
    if(subscribeResult) {
      isSubscribe = "Yes";
      state.needToChangeState = true;
      commonToast("Subscribed successfully");
      state.setState(() {
      });
    }
  }

  getQcastList() async {

    var data = await interceptorApi.callGetQcastByUser(state.widget.discoverQcastItem.userId);
    if (data != null) {
      print("jsonEncode -> "+jsonEncode(data));

      Iterable listPublish = data["publishedQcastsList"];
      listPublishQcastItem = listPublish.map((model) => QcastItem.fromJson(model)).toList();

      state.setState(() { });

      print("listPublishQcastItem -> "+listPublishQcastItem.length.toString());
    }
  }

}