import 'dart:io';

import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/model/image_item.dart';
import 'package:testsylo/page/sylo/open_message_page/edit_open_message_page/edit_open_message_page.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';

import '../../../../app.dart';

class EditOpenMessagePageViewModel {
  EditOpenMessagePageState state;
  ImageItem profileImage = ImageItem("");
  int editIndex = 0;
  InterceptorApi interceptorApi;

  EditOpenMessagePageViewModel(this.state){
    interceptorApi = InterceptorApi(context: state.context);
  }

  addSyloPost(String openMessage, File openingVideo) async {
    appState.addSyloItem.openingMsg = openMessage;
//    appState.addSyloItem.openingVideo = openingVideo;
    String mediaUploaded = await interceptorApi.callUploadGetMediaID(openingVideo);
    //String mediaUploaded = "";
    //mediaUploaded = await interceptorApi.uploadGetMediaID(openingVideo);
    if (mediaUploaded!=null) {
      appState.addSyloItem.openingVideo = mediaUploaded;
      bool isSuccess = await interceptorApi.callAddSylo(appState.addSyloItem);
      if (isSuccess) {
        goToHome(state.context,null);
      }
    }

  }
}