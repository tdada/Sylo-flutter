
import 'package:testsylo/local_data/shared_prefrence.dart';

import '../app.dart';
import 'database/database_helper.dart';

class CommonService {

  setUserId(String id){

    SharedPPreferences.prefSetString(SharedPPreferences.keyUserId, id);

  }

  getUserId() async {
    String id = await SharedPPreferences.prefGetString(SharedPPreferences.keyUserId, "");
    return id;
  }

  setUserName(String name){
    SharedPPreferences.prefSetString(SharedPPreferences.username, name);
  }
  getUserName() async {
    String name = await SharedPPreferences.prefGetString(SharedPPreferences.username, "");
    return name;
  }

  setEmail(String email){
    SharedPPreferences.prefSetString(SharedPPreferences.email, email);
  }
  getEmail() async {
    String email = await SharedPPreferences.prefGetString(SharedPPreferences.email, "");
    return email;
  }

  setToken(String token){
    SharedPPreferences.prefSetString(SharedPPreferences.token, token);
  }
  getToken() async {
    String token = await SharedPPreferences.prefGetString(SharedPPreferences.token, "");
    return token;
  }

  setProfilePic(String profilePic){
    SharedPPreferences.prefSetString(SharedPPreferences.profilePic, profilePic);
  }
  getProfilePic() async {
    String profilePic = await SharedPPreferences.prefGetString(SharedPPreferences.profilePic, "");
    return profilePic;
  }

  setSecureUserInfo(String strName ,String strValue){
    SharedPPreferences.prefSetString(strName, strValue);
  }

  getSecureUserInfo(String strName) async {
    String id = await SharedPPreferences.prefGetString(strName, "");
    return id;
  }

  setSecureFCSetting(bool value){
    print(value.toString());
    SharedPPreferences.prefSetBool(SharedPPreferences.secureFC, value);
  }

  getSecureFCSetting() async {
    bool id = await SharedPPreferences.prefGetBool(SharedPPreferences.secureFC, false);
    return id;
  }

  setSecureFPSetting(bool value){
    print(value.toString());
    SharedPPreferences.prefSetBool(SharedPPreferences.secureFP, value);
  }

  getSecureFPSetting() async {
    bool id = await SharedPPreferences.prefGetBool(SharedPPreferences.secureFP, false);
    return id;
  }

  clearSecureUserData() async {
     await setSecureUserInfo(SharedPPreferences.secureUserId, "");
     await setSecureUserInfo(SharedPPreferences.secureEmail, "");
     await setSecureUserInfo(SharedPPreferences.secureUsername, "");
     await setSecureUserInfo(SharedPPreferences.secureProfilePic, "");
  }

  setSecureUserData({String id, String email, String name, String pic}) async {
    setSecureUserInfo(SharedPPreferences.secureUserId, id??"");
    setSecureUserInfo(SharedPPreferences.secureEmail, email??"");
    setSecureUserInfo(SharedPPreferences.secureUsername, name??"");
    setSecureUserInfo(SharedPPreferences.secureProfilePic, pic??"");
  }

  loggedOut() async {
    appState.myChannelProfileItem = null;
    appState.getUserSylosList = null;
    appState.inActivityPeriodItem = null;
    bool secureFPStatus = await getSecureFPSetting();
    bool secureFCStatus = await getSecureFCSetting();
    DatabaseHelper databaseHelper;
    databaseHelper = DatabaseHelper();
    await databaseHelper.deleteNotificationTable();
    SharedPPreferences.clearAllPref();
    print("secureFPStatus --->" + secureFPStatus.toString());
    print("secureFCStatus --->" + secureFCStatus.toString());
    if( secureFPStatus || secureFCStatus) {
      print("Logout --->");
      print(appState.userItem.userId.toString());
      setSecureFCSetting(secureFCStatus);
      setSecureFPSetting(secureFPStatus);
      setSecureUserData(
        id:appState.userItem.userId.toString(),
        email:appState.userItem.email.toString(),
        name:appState.userItem.username.toString(),
        pic:appState.userItem.profilePic.toString(),

      );
    }
  }
}