import 'dart:convert';

import 'package:testsylo/model/api_request.dart';
import 'package:testsylo/model/drop_down_item.dart';
import 'package:testsylo/page/account/account_page/inactivity_period/inactivity_period_page.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';

import '../../../../app.dart';

class InActivityPeriodPageViewModel {
  InActivityPeriodPageState state;
  List<DropDownItem> notifyMeList = List<DropDownItem>();
  InterceptorApi interceptorApi;
  InActivityPeriodItem inActivityPeriodItem;
  InActivityPeriodPageViewModel(this.state) {
    interceptorApi = InterceptorApi(context: state.context);
    initialize();
  }

  initNotifyMeList() {
    notifyMeList.add(DropDownItem(label: "3 day before Inactive Period", index: 3));
    notifyMeList.add(DropDownItem(label: "5 day before Inactive Period", index: 5));
    notifyMeList.add(DropDownItem(label: "7 day before Inactive Period", index: 7));
    notifyMeList.add(DropDownItem(label: "9 day before Inactive Period", index: 9));
  }

  initialize()async {
    if(appState.inActivityPeriodItem!=null) {
      inActivityPeriodItem = appState.inActivityPeriodItem;
    } else {
      inActivityPeriodItem = InActivityPeriodItem();
      await getOrUpdateIP(InActivityPeriodItem(userId: appState.userItem.userId));
    }
    state.setState(() { });
  }

  getOrUpdateIP(InActivityPeriodItem _inActivityPeriodItem) async {
    var data = await interceptorApi.callGetOrUpdateIP(_inActivityPeriodItem, false);
      if (data != null) {
        print("jsonEncode -> "+jsonEncode(data));
        inActivityPeriodItem =  InActivityPeriodItem.fromJson(data);
        appState.inActivityPeriodItem = inActivityPeriodItem;
        print("inActivityPeriodItem -> " + inActivityPeriodItem.toMap().toString());
        state.sliderValue = inActivityPeriodItem.inactivityPeriod?.toDouble()??10.0;
        state.notifyDropDownItem = inActivityPeriodItem.reminderDays==null?notifyMeList.first:notifyMeList.where((element) => element.index==inActivityPeriodItem.reminderDays).first;

      }
  }

}