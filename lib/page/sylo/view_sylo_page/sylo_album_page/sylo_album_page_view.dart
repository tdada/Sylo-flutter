import 'package:testsylo/app.dart';
import 'package:testsylo/page/sylo/view_sylo_page/sylo_album_page/sylo_album_page.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';

class SyloAlbumPageViewModel {
  SyloAlbumPageState state;
  InterceptorApi interceptorApi;
  bool isLoader;
  SyloAlbumPageViewModel(this.state) {
    interceptorApi = InterceptorApi(context: state.context);
    isLoader = false;
    if(state.widget.from!=null&&state.widget.from=="ViewAllButton"){
      state.syloAlbumDisplayView=true;
    }
    getAllAlbumsForTheSylo(state.widget.userSylo.syloId.toString());
  }
  getAllAlbumsForTheSylo(String syloId) async {
    if(appState.albumList == null){
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
}