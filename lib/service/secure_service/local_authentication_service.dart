import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:testsylo/local_data/shared_prefrence.dart';

import '../../app.dart';
import '../common_service.dart';

class LocalAuthenticationService {
  final localAuthentication = LocalAuthentication();

  bool isAuthenticated = false;
  CommonService commonService =  CommonService();

  Future<bool> checkSecureAuthAvailable() async {
    bool canCheckBiometrics =
        await localAuthentication.canCheckBiometrics;
    return canCheckBiometrics;
  }

  Future<bool> authenticate() async {
    isAuthenticated = false;
    try {
      isAuthenticated = await localAuthentication.authenticateWithBiometrics(
        localizedReason: 'authenticate to access',
        useErrorDialogs: true,
        stickyAuth: true,
      );

      if (isAuthenticated != null && isAuthenticated==true) {
        String id = await commonService.getSecureUserInfo(SharedPPreferences.secureUserId);
        String email = await commonService.getSecureUserInfo(SharedPPreferences.secureEmail);
        String name = await commonService.getSecureUserInfo(SharedPPreferences.secureUsername);
        String profilePic = await commonService.getSecureUserInfo(SharedPPreferences.secureProfilePic);

        if(id!=null&&id.isNotEmpty){
          appState.userItem.userId = int.parse(id);
          appState.userItem.email = email??"";
          appState.userItem.username = name??"";
          appState.userItem.profilePic = profilePic??"";
          commonService.setUserId(id);
          commonService.setEmail(appState.userItem.email);
          commonService.setUserName(appState.userItem.username);
          commonService.setProfilePic(appState.userItem.profilePic);
          commonService.setToken(appState.userItem.token);
          print("User id ->"+id.toString());
        }
      } else {
        isAuthenticated = false;
      }
    } on PlatformException catch (e) {
      print(e);
    }
    return isAuthenticated;
  }
}