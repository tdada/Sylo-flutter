import 'dart:convert';

import 'package:testsylo/app.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/model/help_info_item.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';

import 'help_info_page.dart';

class HelpInfoPageViewModel {
  HelpInfoPageState state;
  InterceptorApi interceptorApi;
  List<HelpInfoModel> helpInfoList = List<HelpInfoModel>();
  List<HelpInfoModel> faqResultList = List<HelpInfoModel>();
  List<HelpInfoModel> searchResultList = List<HelpInfoModel>();
  HelpInfoPageViewModel(this.state){
    interceptorApi = InterceptorApi(context: state.context);
    getFaqData();
  }

  getFaqData() async {
    var data = await interceptorApi.callGetFaqs(true);
    if(data!=null) {
      print("jsonEncode -> "+jsonEncode(data));
      Iterable faqList = data as Iterable;
      List<FaqModel> listFaqModel = faqList.map((model) => FaqModel.fromJson(model)).toList();
      listFaqModel.forEach((faqItem) {
        if(faqResultList.singleWhere((element) => element.title==faqItem.category, orElse: () => null) != null) {
          int index = faqResultList.indexWhere((element) => element.title==faqItem.category);
          faqResultList[index].queList.add(QuestionsModel(question: faqItem.question, answer: faqItem.answer));
        } else {
          faqResultList.add(HelpInfoModel(title: faqItem.category, queList: [QuestionsModel(question: faqItem.question, answer: faqItem.answer)]));
        }
      });
      helpInfoList = faqResultList;
      state.setState(() { });
    }
  }

  searchFaqData(String searchKeywords) async {
    var data = await interceptorApi.callSearchFaq(searchKeywords, true);
    if(data!=null) {
      print("jsonEncode -> "+jsonEncode(data));
      Iterable faqList = data as Iterable;
      List<FaqModel> listFaqModel = faqList.map((model) => FaqModel.fromJson(model)).toList();
      listFaqModel.forEach((faqItem) {
        if(searchResultList.singleWhere((element) => element.title==faqItem.category, orElse: () => null) != null) {
          int index = searchResultList.indexWhere((element) => element.title==faqItem.category);
          searchResultList[index].queList.add(QuestionsModel(question: faqItem.question, answer: faqItem.answer));
        } else {
          searchResultList.add(HelpInfoModel(title: faqItem.category, queList: [QuestionsModel(question: faqItem.question, answer: faqItem.answer)]));
        }
      });
      helpInfoList = searchResultList;
      state.setState(() { });
    }
  }
}