import 'package:flutter/material.dart';
import 'package:testsylo/app.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/model/api_request.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/page/sylo/view_sylo_page/sylo_album_page/sylo_album_detail_page/sylo_album_detail_page.dart';
import 'package:testsylo/page/sylo/view_sylo_page/sylo_album_page/sylo_album_page.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';
import 'package:testsylo/util/navigate_effect.dart';
import '../../view_sylo_page.dart';
import 'copymovealbumitems.dart';

class CopyMoveViewModel {
  InterceptorApi interceptorApi;
  MoveCopyAlbumDetailsState state;
  List<GetUserSylos> userSylosList;
  bool isLoader = false;

  CopyMoveViewModel(MoveCopyAlbumDetailsState state) {
    this.state = state;
    interceptorApi = InterceptorApi(context: state.context);
    userSylosList = initializeSyloItems(appState.getUserSylosList);
  }

  copyMoveAlbum(CopyMoveRequest fbr) async {
    /*state.setState(() {
      isLoader = true;
    });*/

    bool isSuccess = await interceptorApi.callCopyMoveAlbum(fbr);
    if (isSuccess) {
//      goToHome(state.context);
      /*state.setState(() {
        isLoader = false;
      });*/

      //state.widget.callBack(6, state.widget.userSylo);

    }

    /*state.setState(() {
      isLoader = false;
    });*/
  }

  changeSelectSyloItem(int index) {
    userSylosList[index].isCheck = !userSylosList[index].isCheck;
  }
}