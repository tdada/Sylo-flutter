import 'package:testsylo/model/model.dart';

import 'completed_sylo_letter_page.dart';

class CompletedSyloLetterPageViewModel {
  CompletedSyloLetterPageState state;
  List<TagModel> tagList = List<TagModel>();

  CompletedSyloLetterPageViewModel(this.state){
    initImageModel();
  }
  initImageModel(){
    tagList.add(TagModel(name: "birthday"));
    tagList.add(TagModel(name: "party"));
    tagList.add(TagModel(name: "holiday"));
  }
}