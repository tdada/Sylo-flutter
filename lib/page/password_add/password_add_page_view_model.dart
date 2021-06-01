import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/page/log_in/login_page.dart';
import 'package:testsylo/page/password_add/password_add_page.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';

class PasswordAddPageViewModel {
  PasswordAddPageState state;
  InterceptorApi interceptorApi;
  bool isChangePass = false;

  PasswordAddPageViewModel(this.state){
    interceptorApi = InterceptorApi(context: state.context);
  }

  setNewPassword(String email, String newPassword) async {
    bool isSuccess = await interceptorApi.callChangePassword(email, newPassword);
    print("user email -> "+email);
    if (isSuccess) {
    }
  }

}