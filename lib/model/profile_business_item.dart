import 'dart:io';

import '../app.dart';

class ProfileBusinessItem {
  File localPath;
  String connectBy;
  String businessName;

  ProfileBusinessItem();

  getConnectByImage(){
    if(connectBy=="Google"){
      return App.ic_google;
    }
    else if(connectBy=="Facebook"){
      return App.ic_fb;
    }
    else{
      return App.ic_placeholder;
    }
  }
}
