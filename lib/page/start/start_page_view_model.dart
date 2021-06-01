import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/page/intro/intro_page.dart';
import 'package:testsylo/page/sign_up/profile/sign_up_profile_page.dart';
import 'package:testsylo/page/sign_up/profile/sign_up_verification_sent_page.dart';
import 'package:testsylo/page/start/start_page.dart';
import 'package:testsylo/service/common_service.dart';
import 'package:testsylo/util/navigate_effect.dart';

import '../../app.dart';

class StartPageViewModel {
  StartPageState state;
  CommonService commonService =  CommonService();

  StartPageViewModel(StartPageState state) {
    this.state = state;
    validateSession();
  }

  validateSession() async {
    Future.delayed(Duration(milliseconds: 4000)).then((onValue) {
      gotoNextPage();
    });
  }

  gotoNextPage() async {
    String id = await commonService.getUserId();
    String email = await commonService.getEmail();
    String name = await commonService.getUserName();
    String profilePic = await commonService.getProfilePic();
    if(id!=null&&id.isNotEmpty){
      appState.userItem.userId = int.parse(id);
      appState.userItem.email = email??"";
      appState.userItem.username = name??"";
      appState.userItem.profilePic = profilePic??"";

      print("User id ->"+id.toString());
      goToHome(state.context, null);


    }
    else{
      Navigator.pushAndRemoveUntil(state.context, App.createRoute(page: IntroPage()),(Route<dynamic> route) => false);
    }
  }
}
