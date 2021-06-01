import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/model/model.dart';

import '../../../app.dart';
import 'choose_sylo_view_all_page.dart';

class ChooseSyloViewAllPageViewModel {
  ChooseSyloViewAllPageState state;
  List<GetUserSylos> userSylosList;

  ChooseSyloViewAllPageViewModel(this.state){
    userSylosList = state.widget.userSylosList;
    updateSelectCount();
  }

  changeSelectItem(int index) {
    userSylosList[index].isCheck = !userSylosList[index].isCheck;
  }
  updateSelectCount() {
    state.selectedItem = userSylosList.where((c) => c.isCheck == true).toList().length;
  }
}