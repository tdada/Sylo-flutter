import 'dart:convert';
import 'package:testsylo/model/qcast_dashboard_item.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';

import 'theme_detail_list_page.dart';

class ThemeDetailListPageViewModel {
  ThemeDetailListPageState state;
  InterceptorApi interceptorApi;
  List<DiscoverQcastItem> listQcastByCatogory;
  ThemeDetailListPageViewModel(ThemeDetailListPageState state) {
    this.state = state;
    listQcastByCatogory = List();
    interceptorApi = InterceptorApi(context: state.context);
    getQcastDashboard();
  }

  getQcastDashboard() async {
    print("Category ->" + state.widget.themeModel.title);
    var data = await interceptorApi.callGetQcastByCategory(state.widget.themeModel.title, true);
    if (data != null) {
      print("jsonEncode -> "+jsonEncode(data));
      Iterable qcastList = data;
      listQcastByCatogory = qcastList.map((model) => DiscoverQcastItem.fromJson(model)).toList();
      print("QcastByCatogoryList -> " + listQcastByCatogory.length.toString());
      state.setState(() { });
    }
  }
}
