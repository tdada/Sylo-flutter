import 'package:testsylo/app.dart';
import 'package:testsylo/page/sylo/view_sylo_page/view_sylo_page.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';

class ViewSyloPageViewModel {
  ViewSyloPageState state;
  InterceptorApi interceptorApi;
  bool isLoader = false;

  ViewSyloPageViewModel(this.state){
    interceptorApi = InterceptorApi(context: state.context);
    appState.userSylo = null;
    appState.userSylo = state.widget.userSylo;
  }

  getAllAlbumsForTheSylo(String syloId) async {
    state.setState(() {
      isLoader = true;
    });
    bool isSuccess = await interceptorApi.callGetAllAlbumsForSylo(syloId);
    if (isSuccess) {
//      goToHome(state.context);
      state.setState(() {
        isLoader = false;
      });
    }
    state.setState(() {
      isLoader = false;
    });
  }
}