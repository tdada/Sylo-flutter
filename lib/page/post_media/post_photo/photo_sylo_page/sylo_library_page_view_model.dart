import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/model/api_request.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../../../app.dart';
import 'sylo_library_page.dart';


class SyloLibraryPageViewModel{

  InterceptorApi interceptorApi;
  SyloLibraryPageState state;
  List<GetUserSylos> getUserSylosList;
  List<String> list = List();
  List<SyloLibraryVideo> listVideoItem = List();
  bool isLoad = false;
  int selectIndex = -1;
  SyloLibraryPageViewModel(this.state, ) {
    interceptorApi = InterceptorApi(context: state.context);
    getPhotoSylos(state.widget.from);
  }

  void getPhotoSylos(String type) async {
    list = List<String>.from(await interceptorApi.callGetPhotoPostSylo(appState.userItem.userId.toString(),type));
    state.setState(() { });
    if (state.widget.from=="VIDEO") {
//      showLoader(state.context, label:"getting thumbnail");
    state.setState(() {
      isLoad = true;
    });
      listVideoItem = await getVideoThumbnailForVideos(list);
//      hideLoader();
      state.setState(() {
        isLoad = false;
      });
    }
  }

   Future<List<SyloLibraryVideo>> getVideoThumbnailForVideos(List<String> videoURL) async {
     List<SyloLibraryVideo> listVideo = List();
    Directory appDocDirectory;
      appDocDirectory = await getTemporaryDirectory();

    videoURL.forEach((element) async {
      try {
        String thumnailPath = appDocDirectory.path;
        final uint8list = await VideoThumbnail.thumbnailFile(
          video: element,
          thumbnailPath:thumnailPath,
          imageFormat: ImageFormat.JPEG,
          maxHeight: 64,
          maxWidth: 64,
          quality: 75,
        );
        File _file = File(thumnailPath + "/" + element.split("/").last.split(".").first + ".jpg");
        listVideo.add(SyloLibraryVideo(link: element, thumbFile: _file));
        state.setState(() { });
      } catch (e) {
        print(e);
      }
    });
     return listVideo;
  }
}