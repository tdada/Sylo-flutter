import 'package:testsylo/app.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/page/sylo/view_sylo_page/view_sylo_page.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';

import 'active_shared_me_sylo_page.dart';

class ActriveSharedMeSyloPageViewModel {
  ActiveSharedMeSyloPageState state;
  InterceptorApi interceptorApi;
  SyloMediaCountItem syloMediaCountItem = appState.syloMediaCountItem;
  ActriveSharedMeSyloPageViewModel(this.state){
    interceptorApi = InterceptorApi(context: state.context);
    appState.sharedSyloItem = state.widget.sharedSyloItem??null;
    getSyloMediaCount();
  }

  getSyloMediaCount() async {
    print("SyloId -> "+state.widget.sharedSyloItem.syloId.toString());
    syloMediaCountItem = await interceptorApi.callGetSyloMediaCount(state.widget.sharedSyloItem.syloId.toString());
    if(syloMediaCountItem!=null) {
      appState.syloMediaCountItem = syloMediaCountItem;
      syloMediaCountItem = syloMediaCountItem;
      state.setState(() { });
      print("Photo count" + syloMediaCountItem.photo.toString());
    }
  }

}