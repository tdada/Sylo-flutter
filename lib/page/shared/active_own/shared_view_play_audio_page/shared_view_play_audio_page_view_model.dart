
import 'shared_view_play_audio_page.dart';

class SharedViewPlayAudioPageViewModel {
  SharedViewPlayAudioPageState state;

  String title = "";
  String date = "";
  String audioUrl = "";

  SharedViewPlayAudioPageViewModel(this.state){
    if(state.widget.from == "ActiveSyloSharedOwnPageState") {
      getSyloQuestionData();
    }
  }

  getSyloQuestionData() {
    title = state.widget.syloQuestionItem.title;
    date = state.widget.syloQuestionItem.postedDate;
    audioUrl = state.widget.syloQuestionItem.rawMediaIds[0];
    state.setState(() {});
  }
}