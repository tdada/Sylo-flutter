import 'package:testsylo/model/draft_model.dart';
import 'package:testsylo/page/dashboard/sylo_action_circular_page/my_drafts_page/my_drafts_page.dart';
import 'package:testsylo/service/database/database_helper.dart';

class MyDraftsPageViewModel {
  MyDraftsPageState state;
  DatabaseHelper databaseHelper;
  List<MyDraft>  myDraftList=List();
  List<DisplayDraftItem> myAllDraftList = List<DisplayDraftItem>();
  MyDraftsPageViewModel(this.state){
    databaseHelper = DatabaseHelper();
    initialized();
  }
  initialized() async {
    myDraftList = await databaseHelper.getAllDraft();
    for(int i=0; i<myDraftList.length; i++){
      myDraftList[i].myDraftMedia = await databaseHelper.getAllMediaForDraftItem(myDraftList[i].id);
    }

    if(myDraftList!=null && myDraftList.length>0) {
      makeFullList();
    } else {
      myAllDraftList = List<DisplayDraftItem>();
      state.setState(() {});
    }
  }
  makeFullList(){
    myAllDraftList = List<DisplayDraftItem>();
    myDraftList.forEach((myDraftItem) {
      if(myAllDraftList.singleWhere((element) => element.title==myDraftItem.mediaType, orElse: () => null) != null) {
        int index = myAllDraftList.indexWhere((element) => element.title==myDraftItem.mediaType);
        myAllDraftList[index].myDraftList.add(myDraftItem);
      } else {
        myAllDraftList.add(DisplayDraftItem(title: myDraftItem.mediaType, myDraftList: myDraftItem!=null ? [myDraftItem] : []));
      }
    });
    state.setState(() { print("Total Drafts: ${myAllDraftList.length}");});
  }

  deleteDraftItem(int id, String mediaType) async {
    int isDelete = await  databaseHelper.deleteDraftWithMedia(id,mediaType);
    print(isDelete.toString());
    if(isDelete!=null){
      initialized();
    }
  }
}
