import 'package:testsylo/page/shared/completed_sylo/opening_message_view_sylo_page/opening_message_detail_shared_page/opening_message_detail_shared_page.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';

class OpeningMessageDetailSharedPageViewModel {
  OpeningMessageDetailSharedPageState state;
  InterceptorApi interceptorApi;
  bool isLoader = false;
  OpeningMessageDetailSharedPageViewModel(this.state){
    interceptorApi = InterceptorApi(context: state.context);
    getAllAlbumsForTheSylo(state.widget.sharedSyloItem.syloId.toString());
  }

  getAllAlbumsForTheSylo(String syloId) async {
    state.setState(() {
      isLoader = true;
    });
    bool isSuccess = await interceptorApi.callGetAllAlbumsForSylo(syloId);
    if (isSuccess) {
      state.setState(() {
        isLoader = false;
      });
    }
    state.setState(() {
      isLoader = false;
    });
  }
}