import 'dart:convert';
import 'dart:io';
/*import 'package:firebase_messaging/firebase_messaging.dart';*/
import 'package:flutter/material.dart';
import 'package:testsylo/app.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/image_item.dart';
import 'package:testsylo/page/sign_up/profile/sign_up_profile_page.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';
import 'package:testsylo/util/navigate_effect.dart';

import 'sign_up_verification_sent_page.dart';

class SignUpProfilePageViewModel {
  SignUpProfilePageState state;
  ImageItem profileImage = ImageItem("");
  ImageItem camImage = ImageItem("");
  ImageItem libImage = ImageItem("");
  File profileFile;
  //FirebaseMessaging firebaseMessaging;
  InterceptorApi interceptorApi;

  SignUpProfilePageViewModel(SignUpProfilePageState state) {
    this.state = state;
    //firebaseMessaging = FirebaseMessaging();
    interceptorApi = InterceptorApi(context: state.context);
  }

  callPostAddUser() async {
    if(profileFile==null){
      return commonMessage(state.context, "Please, Add your profile picture.");
    }
    state.widget.addUserItem.file = profileFile;
    String token = /*await firebaseMessaging.getToken()*/"";
    print("Firebase token -> $token");
    state.widget.addUserItem.token = token??"";
    bool isSuccess =
        await interceptorApi.callPostAddUser(state.widget.addUserItem);
    if (isSuccess) {
      var result = await Navigator.push(state.context,
          NavigatePageRoute(state.context, SignUpVerificationSentPage(appState.userItem.email, state.runtimeType.toString())));
    }
  }
}
