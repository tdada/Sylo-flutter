import 'package:testsylo/model/model.dart';
import 'package:testsylo/page/post_media/post_sound_bite/upload_sound_from_sylo_page/upload_sound_from_sylo_page.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';

import '../../../../app.dart';

class UploadSoundFromSyloPageViewModel {
  UploadSoundFromSyloPageState state;
  InterceptorApi interceptorApi;
  List<SoundBiteItem> soundItemList= List<SoundBiteItem>();

  UploadSoundFromSyloPageViewModel(this.state){
    interceptorApi = InterceptorApi(context: state.context);
    getPhotoSylos("AUDIO");
  }
  changeSelectItem(int index) {
    soundItemList[index].isCheck = !soundItemList[index].isCheck;
  }
  void getPhotoSylos(String type) async {
    List<String> list = List();
    list = List<String>.from(await interceptorApi.callGetPhotoPostSylo(appState.userItem.userId.toString(),type));
    list.forEach((element) {
      soundItemList.add(SoundBiteItem(element, false));
    });
    state.setState(() { });
  }
}