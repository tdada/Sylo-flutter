import 'package:testsylo/app.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/page/shared/shared_page.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';

class SharedPageViewModel {
  SharedPageState state;
  InterceptorApi interceptorApi;
  List<SharedSyloItem> completedSylos;
  List<SharedSyloItem> sharedSylos;
  List<SharedSyloItem> activeSylos;
  bool isLoader;
  SharedPageViewModel(SharedPageState state) {
    this.state = state;
    isLoader = false;
    completedSylos = List();
    sharedSylos = List();
    activeSylos = List();
    interceptorApi = InterceptorApi(context: state.context);
    getAllSharedSylos();
  }

  getAllSharedSylos() async {
    state.setState(() {
      isLoader = true;
    });
    SharedSylo sharedSylo = await interceptorApi.callGetSharedSylos(
        appState.userItem.userId.toString(), appState.userItem.email);
    if (sharedSylo != null) {
      appState.sharedSylo = sharedSylo;
      activeSylos = sharedSylo.activeSylos;
      sharedSylos = sharedSylo.sharedSylos;
      completedSylos = sharedSylo.completedSylos;
      state.setState(() {
        isLoader = false;
      });
    } else {
      state.setState(() {
        isLoader = false;
      });
    }
  }
}
