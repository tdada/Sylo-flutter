import 'dart:io';

import 'package:flutter/material.dart';
import 'package:testsylo/app.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/api_request.dart';
import 'package:testsylo/model/image_item.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/page/sylo/open_message_page/open_message_page.dart';
import 'package:testsylo/service/common_service.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';
import 'package:testsylo/util/navigate_effect.dart';
import 'package:testsylo/util/util.dart';

import 'add_sylo_page.dart';

class AddSyloPageViewModel {
  AddSyloPageState state;
  ImageItem profileImage = ImageItem("");
  List<SyloProfileModel> listRec = List();
  InterceptorApi interceptorApi;
  CommonService commonService;
  AddSyloItem getSyloItem;
  bool anotherRecipientMode = false;
  SyloProfileModel cacheMainProfile;
  var formKey = GlobalKey<FormState>();

  AddSyloPageViewModel(this.state) {
    interceptorApi = InterceptorApi(context: state.context);
    commonService = CommonService();
    if(state.widget.isEdit){
      getCallSyloDeepCopy();
    }
  }

  addRec() async {
    if (formKey.currentState.validate()) {
      if (state.relationModel == null) {
        commonMessage(state.context, "Select relationship");
        return;
      }
      if (state.relationModel?.index==0 && state.relationFamilyModel == null) {
        commonMessage(state.context, "Select family relationship");
        return;
      }

      hideFocusKeyBoard(state.context);

      bool isEmailVerify = await checkAddSyloEmail(state.recipientEmailController.text);
      if(!isEmailVerify){
        return;
      }
//      print("Email -> ${state.recipientEmailController.text.toString()}");
//      bool verifyfirstEmail = await callVerifyEmailAddress(state.recipientEmailController.text.toString());
//      if (verifyfirstEmail!=true) {
//        return;
//      }
//      if(int.parse(state.recipientAgeController.text)<18) {
//        print("Email -> ${state.recipientCoEmailController.text.toString()}");
//        bool verifySecondEmail = await callVerifyEmailAddress(state.recipientCoEmailController.text.toString());
//        if (verifySecondEmail!=true) {
//          return;
//        }
//      }

      String recipientName = state.recipientNameController.text.trim();
      String displayName = state.displayNameController.text.trim();
      String recipientEmail = state.recipientEmailController.text.trim();
      String recipientBDay = state.recipientBDayController.text.trim();
      String recipientAge = state.recipientAgeController.text.trim();
      String recipientRelationship = state.relationModel.text;
      String recipientFamilyRelationship = state.relationFamilyModel?.text??"";
      String recipientCoName = state.recipientCoNameController.text.trim();
      String recipientCoEmail = state.recipientCoEmailController.text.trim();

      SyloProfileModel item = SyloProfileModel(
          recipientName: recipientName,
          displayName: displayName,
          recipientEmail: recipientEmail,
          recipientBDay: recipientBDay,
          recipientAge: recipientAge,
          recipientRelationship: recipientRelationship,
          recipientFamilyRelationship: recipientFamilyRelationship,
          recipientCoName: recipientCoName,
          recipientCoEmail: recipientCoEmail);

      listRec.add(item);

      state.setState(() {
        state.displayNameController.text = "";
        state.recipientNameController.text = "";
        state.recipientEmailController.text = "";
        state.recipientBDayController.text = "";
        state.recipientAgeController.text = "";
        state.recipientCoNameController.text = "";
        state.recipientCoEmailController.text = "";
        state.relationModel = null;
        state.relationFamilyModel = null;
        state.recipientEnable = false;
        state.emailNotification = false;
      });
    }
  }

  editRec(int index) {}

  callPostAddSylo() async {
    hideFocusKeyBoard(state.context);
    print("getUserId -> " + await commonService.getUserId());
    String userId = await commonService.getUserId();
    String recipientEmail = "";
    String recipientName = "";
    String displayName = "";
    String recipientBirthday = "";
    String age = "";
    String relationship = "";
    String familyRelationship = "";
    String coRecipientName = "";
    String coRecipientEmail = "";

    String recipientEmailSec = "";
    String recipientNameSec = "";
    String recipientBirthdaySec = "";
    String ageSec = "";
    String relationshipSec = "";
    String familyRelationshipSec = "";
    String coRecipientNameSec = "";
    String coRecipientEmailSec = "";
    File profileImageFile = profileImage.path;
    bool notifyUser = state.notifyRecipient;

    if (listRec.length > 0) {
      recipientEmail = listRec[0].recipientEmail;
      recipientName = listRec[0].recipientName;
      recipientBirthday = listRec[0].recipientBDay;
      age = listRec[0].recipientAge;
      displayName = listRec[0].displayName;
      relationship = listRec[0].recipientRelationship;
      familyRelationship = listRec[0].recipientFamilyRelationship;
      coRecipientName = listRec[0].recipientCoName;
      coRecipientEmail = listRec[0].recipientCoEmail;
      recipientEmailSec = state.recipientEmailController.text.trim();
      recipientNameSec = state.recipientNameController.text.trim();
      recipientBirthdaySec = state.recipientBDayController.text.trim();
      ageSec = state.recipientAgeController.text.trim();
      relationshipSec = state.relationModel.text;
      familyRelationshipSec = state.relationFamilyModel?.text??"";
      coRecipientNameSec = state.recipientCoNameController.text.trim();
      coRecipientEmailSec = state.recipientCoEmailController.text.trim();
    } else {
      recipientEmail = state.recipientEmailController.text.trim();
      recipientName = state.recipientNameController.text.trim();
      displayName = state.displayNameController.text.trim();
      recipientBirthday = state.recipientBDayController.text.trim();
      age = state.recipientAgeController.text.trim();
      relationship = state.relationModel.text;
      familyRelationship = state.relationFamilyModel?.text??"";
      coRecipientName = state.recipientCoNameController.text.trim();
      coRecipientEmail = state.recipientCoEmailController.text.trim();
    }

    AddSyloItem addSyloItem = AddSyloItem(
      file: profileImageFile,
      notifyUser: notifyUser,
      userId: int.parse(userId),
      recipientEmail: recipientEmail,
      displayName: displayName,
      recipientName: recipientName,
      recipientBirthday: recipientBirthday,
      age: age,
      relationship: relationship,
      familyRelationship: familyRelationship,
      coRecipientName: coRecipientName,
      coRecipientEmail: coRecipientEmail,
      recipientEmailSec: recipientEmailSec,
      recipientNameSec: recipientNameSec,
      recipientBirthdaySec: recipientBirthdaySec,
      ageSec: ageSec,
      relationshipSec: relationshipSec,
      familyRelationshipSec: familyRelationshipSec,
      coRecipientNameSec: coRecipientNameSec,
      coRecipientEmailSec: coRecipientEmailSec,
    );
    appState.addSyloItem = addSyloItem;


    /* Record Opening Message */

    /*var result = await Navigator.push(
        state.context, NavigatePageRoute(state.context, OpenMessagePage()));*/

    /* Add Sylo Api Calling */

    bool isSuccess = await interceptorApi.callAddSylo(appState.addSyloItem);
    if (isSuccess) {
      goToHome(state.context,null);
    }
  }

//  callVerifyEmailAddress(String email) async {
//    bool isVerify = await interceptorApi.callVerifyEmailAddress(email);
//    if (isVerify) {
//     return isVerify;
//    }
//  }
  getCallSyloDeepCopy() async {

    var data = await interceptorApi.callGetSyloDeepCopy(
        state.widget.userSylo.syloId.toString(),
        true);
    if (data != null) {

      getSyloItem = AddSyloItem.fromJson(data);

      print("Sylo for DeepCopy -> " + getSyloItem.toMap().toString());
      initializeDataForEdit(getSyloItem);
    }
  }

  initializeDataForEdit(AddSyloItem getSyloItem) {
    state.displayNameController.text = getSyloItem.displayName;
    state.recipientNameController.text = getSyloItem.recipientName;
    state.recipientEmailController.text = getSyloItem.recipientEmail;
    state.recipientBDayController.text = getSyloItem.recipientBirthday;
    state.recipientAgeController.text = getSyloItem.age;
    state.recipientCoNameController.text = getSyloItem.coRecipientName;
    state.recipientCoEmailController.text = getSyloItem.coRecipientEmail;
    state.notifyRecipient = getSyloItem.notifyUser;
    relationshipList.forEach((element) {
      if(element.text == getSyloItem.relationship) {
        state.relationModel = element;
      }
    });
    relationshipFamilyList.forEach((element) {
      if(element.text == getSyloItem.familyRelationship) {
        state.relationFamilyModel = element;
      }
    });

    if(getSyloItem.recipientNameSec!=null && getSyloItem.recipientNameSec!="") {
      listRec.add(SyloProfileModel(
        displayName: getSyloItem.displayName,
        recipientName: getSyloItem.recipientNameSec,
        recipientEmail: getSyloItem.recipientEmailSec,
        recipientBDay: getSyloItem.recipientBirthday,
        recipientAge: getSyloItem.ageSec,
        recipientCoName: getSyloItem.coRecipientNameSec,
        recipientCoEmail: getSyloItem.coRecipientEmailSec,
        recipientRelationship: getSyloItem.relationshipSec,
        recipientFamilyRelationship: getSyloItem.familyRelationshipSec,
      ));
    }
    state.setState(() { });
  }

  editAnotherRecipient(){
    cacheMainProfile = SyloProfileModel(
        displayName: state.displayNameController.text.trim(),
        recipientName: state.recipientNameController.text.trim(),
        recipientEmail: state.recipientEmailController.text..trim(),
        recipientBDay: state.recipientBDayController.text.trim(),
        recipientAge: state.recipientAgeController.text.trim(),
        recipientCoName: state.recipientCoNameController.text.trim(),
        recipientCoEmail: state.recipientCoEmailController.text.trim(),
        recipientRelationship:state.relationModel.text,
        recipientFamilyRelationship:state.relationFamilyModel?.text??"",
    );

    SyloProfileModel _syloProfileModel = listRec[0];
    state.displayNameController.text = _syloProfileModel.displayName;
    state.recipientNameController.text = _syloProfileModel.recipientName;
    state.recipientEmailController.text = _syloProfileModel.recipientEmail;
    state.recipientBDayController.text = _syloProfileModel.recipientBDay;
    state.recipientAgeController.text = _syloProfileModel.recipientAge;
    state.recipientCoNameController.text = _syloProfileModel.recipientCoName;
    state.recipientCoEmailController.text = _syloProfileModel.recipientCoEmail;
    relationshipList.forEach((element) {
      if(element.text == _syloProfileModel.recipientRelationship) {
        state.relationModel = element;
      }
    });
    relationshipFamilyList.forEach((element) {
      if(element.text == _syloProfileModel.recipientFamilyRelationship) {
        state.relationFamilyModel = element;
      }
    });
    state.setState(() { });
  }

  loadFirstRecipientData(){

    SyloProfileModel item = SyloProfileModel(
        displayName: state.displayNameController.text.trim(),
        recipientName: state.recipientNameController.text.trim(),
        recipientEmail: state.recipientEmailController.text.trim(),
        recipientBDay: state.recipientBDayController.text.trim(),
        recipientAge: state.recipientAgeController.text.trim(),
        recipientRelationship: state.relationModel.text,
        recipientFamilyRelationship: state.relationFamilyModel?.text??"",
        recipientCoName: state.recipientCoNameController.text.trim(),
        recipientCoEmail: state.recipientCoEmailController.text.trim());

    listRec[0] = item;

    state.setState(() {
      state.displayNameController.text = cacheMainProfile.displayName;
      state.recipientNameController.text = cacheMainProfile.recipientName;
      state.recipientEmailController.text = cacheMainProfile.recipientEmail;
      state.recipientBDayController.text = cacheMainProfile.recipientBDay;
      state.recipientAgeController.text = cacheMainProfile.recipientAge;
      state.recipientCoNameController.text = cacheMainProfile.recipientCoName;
      state.recipientCoEmailController.text = cacheMainProfile.recipientCoEmail;
      relationshipList.forEach((element) {
        if(element.text == cacheMainProfile.recipientRelationship) {
          state.relationModel = element;
        }
      });
      relationshipFamilyList.forEach((element) {
        if(element.text == cacheMainProfile.recipientFamilyRelationship) {
          state.relationFamilyModel = element;
        }
      });
    });
  }

  getCallDeleteSylo() async {
    var data = await interceptorApi.callDeleteSylo(
        state.widget.userSylo.syloId);
    if (data != null && data == true) {
      commonToast("Successfully Deleted");
      goToHome(state.context, state.runtimeType.toString());
    }
  }

  Future<String> getmediaId(File file) async {
    String mediaUploaded = await interceptorApi.callUploadGetMediaID(file, loaderLabel: "Uploading profile", sync: true);
    if(mediaUploaded != null) {
      return mediaUploaded;
    }
    return null;
  }

  updateSylo() async {
    hideFocusKeyBoard(state.context);
    if(anotherRecipientMode){
      commonMessage(state.context, "Please, Save the another Recipient.");
      return;
    }
    if (!formKey.currentState.validate()) {
      return;
    }
    if(state.relationModel==null){
      commonMessage(state.context, "Select relationship");
      return;
    }
    if(state.relationModel?.index==0 && state.relationFamilyModel==null){
      commonMessage(state.context, "Select family relationship");
      return;
    }
    if(state.recipientEmailController.text.trim()!= getSyloItem.recipientEmail) {
      bool isEmailVerify = await checkAddSyloEmail(
          state.recipientEmailController.text);
      if (!isEmailVerify) {
        return;
      }
    }

    String syloPic = "";
    if(profileImage.path!=null){
      syloPic = await getmediaId(profileImage.path);
      syloPic = syloPic.split("/").last;
    } else {
      syloPic = getSyloItem.syloPic;
      syloPic = syloPic.split("/").last;
    }
    String userId = appState.userSylo.userId.toString();
    String recipientEmail = "";
    String recipientName = "";
    String displayName = "";
    String recipientBirthday = "";
    String age = "";
    String relationship = "";
    String familyRelationship = "";
    String coRecipientName = "";
    String coRecipientEmail = "";

    String recipientEmailSec = "";
    String recipientNameSec = "";
    String recipientBirthdaySec = "";
    String ageSec = "";
    String relationshipSec = "";
    String familyRelationshipSec = "";
    String coRecipientNameSec = "";
    String coRecipientEmailSec = "";
    File profileImageFile = profileImage.path;
    bool notifyUser = state.notifyRecipient;

    if (listRec.length > 0) {
      recipientEmail = listRec[0].recipientEmail;
      recipientName = listRec[0].recipientName;
      recipientBirthday = listRec[0].recipientBDay;
      displayName = listRec[0].displayName;
      age = listRec[0].recipientAge;
      relationship = listRec[0].recipientRelationship;
      familyRelationship = listRec[0].recipientFamilyRelationship;
      coRecipientName = listRec[0].recipientCoName;
      coRecipientEmail = listRec[0].recipientCoEmail;
      recipientEmailSec = state.recipientEmailController.text.trim();
      recipientNameSec = state.recipientNameController.text.trim();
      recipientBirthdaySec = state.recipientBDayController.text.trim();
      ageSec = state.recipientAgeController.text.trim();
      relationshipSec = state.relationModel.text;
      familyRelationshipSec = state.relationFamilyModel?.text??"";
      coRecipientNameSec = state.recipientCoNameController.text.trim();
      coRecipientEmailSec = state.recipientCoEmailController.text.trim();
    } else {
      displayName = state.displayNameController.text.trim();
      recipientEmail = state.recipientEmailController.text.trim();
      recipientName = state.recipientNameController.text.trim();
      recipientBirthday = state.recipientBDayController.text.trim();
      age = state.recipientAgeController.text.trim();
      relationship = state.relationModel.text;
      familyRelationship = state.relationFamilyModel?.text??"";
      coRecipientName = state.recipientCoNameController.text.trim();
      coRecipientEmail = state.recipientCoEmailController.text.trim();
    }

    AddSyloItem addSyloItem = AddSyloItem(
      syloId: getSyloItem.syloId,
      notifyUser: notifyUser,
      userId: int.parse(userId),
      recipientEmail: recipientEmail,
      displayName: displayName,
      recipientName: recipientName,
      recipientBirthday: recipientBirthday,
      age: age,
      relationship: relationship,
      familyRelationship: familyRelationship,
      coRecipientName: coRecipientName,
      coRecipientEmail: coRecipientEmail,
      recipientEmailSec: recipientEmailSec,
      recipientNameSec: recipientNameSec,
      recipientBirthdaySec: recipientBirthdaySec,
      ageSec: ageSec,
      relationshipSec: relationshipSec,
      familyRelationshipSec: familyRelationshipSec,
      coRecipientNameSec: coRecipientNameSec,
      coRecipientEmailSec: coRecipientEmailSec,
      syloPic: syloPic,
      openingMsg: getSyloItem.openingMsg,
      openingVideo: getSyloItem.openingVideo,
    );
    var result = await interceptorApi.callUpdateSylo(addSyloItem);
    if(result!=null){
      getSyloItem = AddSyloItem.fromJson(result);
      Navigator.pop(state.context, getSyloItem);
    }
  }

  Future<bool> checkAddSyloEmail(String email) async {
    bool result = await interceptorApi.callCheckAddSyloEmail(email.trim(), appState.userItem.userId.toString());
    return result;
  }
}
