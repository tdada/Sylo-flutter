import 'dart:convert';

import 'package:testsylo/model/albums_item.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/page/common/choose_album_page/choose_album_page.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';

import '../../../app.dart';

class ChooseAlbumPageViewModel {
  ChooseAlbumPageState state;
  InterceptorApi interceptorApi;
  Map<String, List<GetAlbum>> syloAlbumData = Map();
  ChooseAlbumPageViewModel(this.state){
    interceptorApi = InterceptorApi(context: state.context);
    getAlbumsFromSyloList();
  }

  changeSelectAlbumItem(int index, String id) {
    syloAlbumData[id][index].isCheck = !syloAlbumData[id][index].isCheck;
  }

  getAlbumsFromSyloList() async {
    List<String> syloIds = List();
    state.widget.selectedSyloList.forEach((element) {
      syloIds.add(element.syloId.toString());
    });
    if(syloIds.length>0) {
      var data = await interceptorApi.callGetAllAlbumsForSyloList(
          appState.userItem.userId, syloIds, true);
      if (data != null) {
        print("jsonEncode -> " + jsonEncode(data));
        Map<String, dynamic> albumdata = Map<String, dynamic>.from(data);
        if(albumdata.isNotEmpty) {
          state.widget.selectedSyloList.forEach((element) {
            Iterable iterableAlbumList = albumdata[element.syloId.toString()];
            List<GetAlbum> albumsItemList = iterableAlbumList != null
                ? iterableAlbumList.map((model) => GetAlbum.fromJson(model))
                .toList()
                : List();
            syloAlbumData[element.syloId.toString()] = albumsItemList;
          });

          state.setState(() {});
        }
      }
    }
  }
  List<int> getSelectedalbumsList() {
    List<int> listItem = List();
    syloAlbumData.forEach((key, value) {
      value.forEach((element) {
        if(element.isCheck == true){
          listItem.add(element.albumId);
        }
      });
    });
    return listItem;
  }
}