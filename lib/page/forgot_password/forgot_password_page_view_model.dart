import 'package:flutter/material.dart';
import 'package:testsylo/page/forgot_password/forgot_password_page.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';
import 'package:testsylo/util/navigate_effect.dart';
import 'package:testsylo/util/util.dart';

import 'forgot_password_verification_send_page.dart';

class ForgotPasswordPageViewModel {
  ForgotPasswordPageState state;
  InterceptorApi interceptorApi;

  ForgotPasswordPageViewModel(this.state) {
    interceptorApi = InterceptorApi(context: state.context);
  }

  callPutForgotPasswordSentLink() async {
    hideFocusKeyBoard(state.context);
    String email = state.signupEmailController.text.trim();
    bool isSuccess = await interceptorApi.callPutForgotPasswordSentLink(email);
    if (isSuccess) {
          var result = await Navigator.push(state.context, NavigatePageRoute(state.context,
                            ForgotPasswordVerificationSentPage(email: email,)));
    }
  }
}
