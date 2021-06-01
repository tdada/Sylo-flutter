import 'package:flutter/material.dart';
import 'package:testsylo/app.dart';
import 'package:testsylo/model/api_request.dart';
import 'package:testsylo/page/account/account_page/account_page.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';
import 'package:testsylo/util/navigate_effect.dart';

import 'feed_back_page.dart';

class FeedBackPageViewModel {
  InterceptorApi interceptorApi;
  FeedBackPageState state;
  bool isLoader = false;

  FeedBackPageViewModel(FeedBackPageState state) {
    this.state = state;
    interceptorApi = InterceptorApi(context: state.context);
  }

  createFeedback(FeedbackRequest fbr) async {
    state.setState(() {
      isLoader = true;
    });
    fbr.userId = appState.userItem.userId.toString();
    bool isSuccess = await interceptorApi.callCreateFeedback(fbr);
    if (isSuccess) {
//      goToHome(state.context);
      state.setState(() {
        isLoader = false;
      });
      state.feedbackTxtController.clear();
      state.rating = 0.0;
      state.operation = null;
      //Navigator.push(
      //    state.context, NavigatePageRoute(state.context, AccountPage()));
      //state.widget.callBack(6, state.widget.userSylo);
      //goToHome((state.context));
    }
    state.setState(() {
      isLoader = false;
    });
  }
}