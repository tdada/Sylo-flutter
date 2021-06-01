import 'package:testsylo/model/api_request.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';

import 'opening_message_view_sylo_page.dart';

class OpeningMessageViewSyloPageViewModel {
  OpeningMessageViewSyloPageState state;
  InterceptorApi interceptorApi;
  AddSyloItem getSyloItem;
  OpeningMessageViewSyloPageViewModel(this.state){
    interceptorApi = InterceptorApi(context: state.context);
    getCallSyloDeepCopy();
  }

  getCallSyloDeepCopy() async {

    var data = await interceptorApi.callGetSyloDeepCopy(
        state.widget.sharedSyloItem.syloId.toString(),
        true);
    if (data != null) {
      getSyloItem = AddSyloItem.fromJson(data);
      state.setState(() {});
    }
  }
}