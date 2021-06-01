import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';

import '../../../../../../app.dart';
import 'shared_detail_album_page.dart';

class SharedDetailAlbumPageViewModel {
  SharedDetailAlbumPageState state;
  InterceptorApi interceptorApi;
  List<AlbumMediaData> albumMediaDataList;
  SharedDetailAlbumPageViewModel(SharedDetailAlbumPageState state){
    this.state = state;
    interceptorApi = InterceptorApi(context: state.context);
    getAlbumMediaData();
  }
  getAlbumMediaData({isReCall=false}) async {
    albumMediaDataList = appState.albumMediaDataList;
    if (albumMediaDataList == null || isReCall == true) {
      List<AlbumMediaData> list = await interceptorApi.callGetAlbumMediaData(
          state.widget.getAlbum.albumId.toString());
      if (list == null) {
        list = List();
      }
      albumMediaDataList = list;
      appState.albumMediaDataList = albumMediaDataList;
      totalPage = (albumMediaDataList.length/8).floor() +1;
      state.setState(() {});
    }
  }

  int currentPage = 1;
  int totalPage = 1;
  getPageInfo(){
    return currentPage.toString() + "/" + totalPage.toString();
  }
  getCircleListLength(){
    //print("albumMediaDataList -> "+albumMediaDataList.length.toString());
    print("totalPage -> "+totalPage.toString());
    if(albumMediaDataList==null){
      return 0;
    }
    else if(albumMediaDataList.length>currentPage * 8){
      return 8;
    }
    else if(currentPage==1){
      return albumMediaDataList.length;
    }
    else{
      return albumMediaDataList.length - (currentPage * 8);
    }

  }

  goToNextPage(){
    if(currentPage==totalPage){
      return;
    }
    currentPage++;
  }
  goToPrevPage(){
    if(currentPage==totalPage){
      return;
    }
    currentPage--;
  }
}