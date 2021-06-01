import 'dart:io';

import 'package:testsylo/app.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/model/image_item.dart';
import 'package:testsylo/page/qcast/qcat_tab/my_channel_page/review_qcast_prompt_page/review_qcast_prompt_page.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';

class ReviewQcastPromptPageViewModel {
  ReviewQcastPromptPageState state;
  ImageItem thumbnailImage = ImageItem("");
  List<String> reviewQuestionsList = List();
  int editIndex = 0;
//  InterceptorApi interceptorApi;
  ReviewQcastPromptPageViewModel(this.state) {
//    interceptorApi = InterceptorApi(context: state.context);
    reviewQuestionsList.add("What to do be a good husband?");
    reviewQuestionsList.add("What to do be a good husband?");
  }
  /*addSyloPost(String openMessage, File openingVideo) async {
    appState.addSyloItem.openingMsg = openMessage;
//    appState.addSyloItem.openingVideo = openingVideo;
    bool mediaUploaded = await interceptorApi.callUploadGetMediaID(openingVideo);
    if (mediaUploaded) {
      bool isSuccess = await interceptorApi.callAddSylo(appState.addSyloItem);
      if (isSuccess) {
        goToHome(state.context);
      }
    }

  }*/
}