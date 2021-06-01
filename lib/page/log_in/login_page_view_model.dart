/*import 'package:firebase_messaging/firebase_messaging.dart';*/
import 'package:testsylo/app.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/page/log_in/login_page.dart';
import 'package:testsylo/service/common_service.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';
import 'package:testsylo/service/secure_service/local_authentication_service.dart';
import 'package:testsylo/service/secure_service/service_locator.dart';
import 'package:testsylo/util/util.dart';

class LogInPageViewModel {
  LogInPageState state;
  InterceptorApi interceptorApi;
  //FirebaseMessaging firebaseMessaging;
  LocalAuthenticationService localAuth;
  CommonService commonService;
  bool isAvailableInDevice;
  LogInPageViewModel(this.state) {
    //firebaseMessaging = FirebaseMessaging();
    interceptorApi = InterceptorApi(context: state.context);
    commonService = CommonService();
    isAvailableInDevice = false;
    localAuth = locator<LocalAuthenticationService>();
    initializeStatus();
  }

  initializeStatus() async {
    isAvailableInDevice = await localAuth.checkSecureAuthAvailable();
    if(isAvailableInDevice){
      state.setState(() {});
    }
  }

  callGetSignInProcess() async {
    hideFocusKeyBoard(state.context);
    String email = state.loginEmailController.text.trim();
    String password = state.loginPasswordController.text.trim();
    String token = /*await firebaseMessaging.getToken()*/"";
    print("Firebase token -> $token");
    bool isSuccess = await interceptorApi.callGetSignInProcess(email, password, token??"");
    if (isSuccess) {
      goToHome(state.context, "signin");
    }
  }

  void secureLogin() async {
    bool secureFPStatus = await commonService.getSecureFPSetting();
    bool secureFCStatus = await commonService.getSecureFCSetting();
    if (secureFPStatus || secureFCStatus) {
        bool _isSecureLogin = await localAuth.authenticate();
        if (_isSecureLogin) {
          goToHome(state.context, null);
        } else {
          //commonMessage(state.context, "Secure login fail.");
        }
    } else {
      commonMessage(state.context, "Please, First Enable Security Settings.");
    }
  }
}
