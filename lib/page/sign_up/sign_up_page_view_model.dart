import 'package:flutter/material.dart';
import 'package:testsylo/model/api_request.dart';
import 'package:testsylo/page/sign_up/sign_up_page.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';
import 'package:testsylo/util/navigate_effect.dart';
import 'package:testsylo/util/util.dart';

import 'profile/sign_up_profile_page.dart';

class SignUpPageViewModel {
  SignUpPageState state;
  InterceptorApi interceptorApi;

  SignUpPageViewModel(this.state) {
    interceptorApi = InterceptorApi(context: state.context);
  }

  callPostAddUser() async {
    hideFocusKeyBoard(state.context);
    String userName = state.signupNameController.text.trim();
    String password = state.signupPasswordController.text.trim();
    String email = state.signupEmailController.text.trim();
    AddUserItem addUserItem = AddUserItem(userName, password, email, null);
    //bool isSuccess = await interceptorApi.callPostAddUser(addUserItem);
    //if (isSuccess) {}
    var result = await Navigator.push(state.context,
        NavigatePageRoute(state.context, SignUpProfilePage(addUserItem)));
  }
}
