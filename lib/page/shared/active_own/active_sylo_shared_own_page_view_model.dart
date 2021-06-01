


import 'package:testsylo/app.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';

import 'active_sylo_shared_own.dart';

class ActiveSyloSharedOwnPageViewModel {
  ActiveSyloSharedOwnPageState state;
  InterceptorApi interceptorApi;
  List<SyloQuestionItem> syloQuestionItem = List();
  ActiveSyloSharedOwnPageViewModel(this.state){
    interceptorApi = InterceptorApi(context: state.context);
    getSyloQuestion();
    setUserSylodata();
  }

  getSyloQuestion() async {
    if(state.widget.activeSylo == null) {
      return;
    }
    print("Sylo Id -> " + state.widget.activeSylo.syloId.toString());
    syloQuestionItem = await interceptorApi.callGetSyloQuestions(state.widget.activeSylo.syloId.toString());
    if (syloQuestionItem != null) {
      state.setState(() {
      });
      print("syloQuestionItem -> ${syloQuestionItem.length}");
    }
  }

  void setUserSylodata() {
    if(state.widget.activeSylo != null) {
      appState.userSylo = GetUserSylos(
        syloId: state.widget.activeSylo.syloId,
        userId: appState.userItem.userId,
        displayName: state.widget.activeSylo.displayName,
        syloName: state.widget.activeSylo.syloName,
        syloPic: state.widget.activeSylo.syloPic
      );
    }
  }

  updateAlbumsForSylo() async {
    if(!state.isUpdateAlbumsForSylo) {
      bool isSuccess = await interceptorApi.callGetAllAlbumsForSylo(
          state.widget.activeSylo.syloId.toString());
      if (isSuccess) {
        state.isUpdateAlbumsForSylo = true;
        state.setState(() {});
      }
    }
  }
}