import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/page/account/account_page/security_page/security_page.dart';
import 'package:testsylo/service/common_service.dart';
import 'package:testsylo/service/secure_service/local_authentication_service.dart';

class SecurityPageViewModel {
  SecurityPageState state;
  CommonService commonService;
  LocalAuthenticationService localAuthenticationService;
  bool isAvailableInDevice;
  SecurityPageViewModel(this.state) {
    commonService =  CommonService();
    isAvailableInDevice = false;
    localAuthenticationService = LocalAuthenticationService();
    initializeStatus();
  }

  initializeStatus() async {
    isAvailableInDevice = await localAuthenticationService.checkSecureAuthAvailable();
    if (isAvailableInDevice) {
      state.fingerPrintStatus = await commonService.getSecureFPSetting();
      state.faceUnlockStatus = await commonService.getSecureFCSetting();
    } else {
      commonToast("Secure login doesn't available in your device.");
    }
    state.setState(() {});
  }


  updateFingerPrintStatus(bool value) async {
    await commonService.setSecureFPSetting(value);
    state.fingerPrintStatus = value;
    state.setState(() { });
  }

  updateFaceUnlockStatus(bool value) async {
    await commonService.setSecureFCSetting(value);
    state.faceUnlockStatus = value;
    state.setState(() { });
  }
}