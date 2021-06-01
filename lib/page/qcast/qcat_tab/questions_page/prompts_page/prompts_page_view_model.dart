
import 'dart:convert';

import 'package:testsylo/app.dart';
import 'package:testsylo/model/api_request.dart';
import 'package:testsylo/model/prompt_item.dart';
import 'package:testsylo/page/qcast/qcat_tab/questions_page/prompts_page/prompts_page.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';

class PromptsPageViewModel {
 PromptsPageState state;
 List<PromptItem> listPrompt;
 InterceptorApi interceptorApi;
 PromptsPageViewModel(PromptsPageState state){
  this.state = state;
  interceptorApi = InterceptorApi(context: state.context);
  initializeLists();
  getPrompts();
 }

 initializeLists() {
  if(appState.listPrompt!=null) {
   listPrompt = appState.listPrompt;
  } else {
   listPrompt = List();
  }
 }

 getPrompts() async {
  print("userId ->" + appState.userItem.userId.toString());
  bool isLoaderDisplay = appState.listPrompt==null ? true : false;
  var data = await interceptorApi.callGetPrompts(appState.userItem.userId);
  if (data != null) {
   print("jsonEncode -> "+jsonEncode(data));
   Iterable qcastList = data;
   listPrompt = qcastList.map((model) => PromptItem.fromJson(model)).toList();
   appState.listPrompt = listPrompt;
   print("PromptsListLength -> " + listPrompt.length.toString());
   state.setState(() { });
  }
 }

 Future<bool> getMyChannel() async {
  if (appState.myChannelProfileItem == null) {
   MyChannelProfileItem myChannelProfileItem = await interceptorApi.callGetMyChannelProfile(appState.userItem.userId.toString(), appState.userItem.userId.toString());
   if(myChannelProfileItem!=null) {
    appState.myChannelProfileItem =  myChannelProfileItem;
    state.setState(() {
    });
   }
  }
  return appState.myChannelProfileItem == null ? false : true;
 }

}