import 'dart:io';

import 'package:flutter/material.dart';
import 'package:testsylo/app.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/api_request.dart';
import 'package:testsylo/model/image_item.dart';
import 'package:testsylo/page/account/account_page/edit_profile_page/edit_profile_page.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';

class EditProfilePageViewModel {
  EditProfilePageState state;
  ImageItem profileImage = ImageItem("");
  ImageItem camImage = ImageItem("");
  ImageItem libImage = ImageItem("");
  File profileFile;
  InterceptorApi interceptorApi;
  AddUserItem addUserItem;

  EditProfilePageViewModel(this.state){
    interceptorApi = InterceptorApi(context: state.context);
  }

  updateUser() async {
    addUserItem  = AddUserItem(
        state.signupNameController.text.trim(),
        state.signupPasswordController.text.trim(),
        state.signupEmailController.text.trim(),
        profileFile,
        oldPwd: state.signupOldPasswordController.text.trim(),
    );
    bool isSuccess = await interceptorApi.callPostUpdateUser(addUserItem);
    if (isSuccess) {
      print("User Update -> ${appState.userItem.userId}");
      commonToast("Successfully updated profile");
      Navigator.of(state.context).pop(true);
    }
  }
}