import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/model/api_request.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/page/sylo/view_sylo_page/sylo_album_page/sylo_album_detail_page/sylo_album_detail_page.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';
import '../../../../../app.dart';

class SyloAlbumDetailPageViewModel {
  SyloAlbumDetailPageState state;
  InterceptorApi interceptorApi;
  List<AlbumMediaData> albumMediaDataList;
  bool isLoader = false;
  SubAlbumData subAlbumData = SubAlbumData();
  String newName = "";
  List<String> tagList = List();
  List<CompletedSyloImageModel> listImages = List();

  SyloAlbumDetailPageViewModel(SyloAlbumDetailPageState state) {
    this.state = state;
    interceptorApi = InterceptorApi(context: state.context);

    getAlbumMediaData();
  }

  editAlbumName(int albumId, String newAlbumName) async {
    state.setState(() {
      isLoader = true;
    });
    bool isSuccess = await interceptorApi.callChangeAlbumName(
        albumId, newAlbumName);
    if (isSuccess) {
//      goToHome(state.context);
      state.setState(() {
        isLoader = false;
        newName = newAlbumName;
        state.widget.getAlbum.albumName = newAlbumName;
      });
      //goToHome((state.context));
    }
    state.setState(() {
      isLoader = false;
    });
  }

  deleteAlbum(AlbumDeleteRequest adr) async {
    state.setState(() {
      isLoader = true;
    });
    bool isSuccess = await interceptorApi.callDeleteAlbum(adr);
    if (isSuccess) {
//      goToHome(state.context);
      state.setState(() {
        isLoader = false;
      });
      state.widget.callBack(6, state.widget.userSylo);
      //goToHome((state.context));
    }
    state.setState(() {
      isLoader = false;
    });
  }

  getAlbumMediaData({isReCall = false}) async {
    albumMediaDataList = appState.albumMediaDataList;
    if (albumMediaDataList == null || isReCall == true) {
      List<AlbumMediaData> list = await interceptorApi
          .callGetAlbumMediaData(
          state.widget.getAlbum.albumId.toString());
      if (list == null) {
        list = List();
      }
      albumMediaDataList = list;
      appState.albumMediaDataList = albumMediaDataList;
      totalPage = (albumMediaDataList.length / 8).floor() + 1;
      state.setState(() {});
    }
  }
    int currentPage = 1;
    int totalPage = 1;


  getPageInfo() {
    return currentPage.toString() + "/" + totalPage.toString();
  }

   getSubAlbumData(AlbumMediaData albumMediaData) async {
    if (albumMediaData.subAlbumId != null) {
      subAlbumData = await interceptorApi.callGetSubAlbumData(albumMediaData.subAlbumId.toString());
      if (subAlbumData == null) {
        subAlbumData = SubAlbumData();
      }

      if (subAlbumData.tag != null && subAlbumData.tag != "") {
        tagList = subAlbumData.tag.split(',');
      }
      if(subAlbumData.coverPhoto != null) {
        listImages.add(CompletedSyloImageModel(isSquare: false, image: subAlbumData.coverPhoto));
      }
      state.setState(() {});

    }

  }

  getCircleListLength() {
    //print("albumMediaDataList -> "+albumMediaDataList.length.toString());
    print("totalPage -> " + totalPage.toString());
    if (albumMediaDataList == null) {
      return 0;
    }
    else if (albumMediaDataList.length > currentPage * 8) {
      return 8;
    }
    else if (currentPage == 1) {
      return albumMediaDataList.length;
    }
    else {
      return albumMediaDataList.length - (currentPage * 8);
    }
  }

  goToNextPage() {
    if (currentPage == totalPage) {
      return;
    }
    currentPage++;
  }

  goToPrevPage() {
    if (currentPage == totalPage) {
      return;
    }
    currentPage--;
  }
}
