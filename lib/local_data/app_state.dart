import 'package:testsylo/app.dart';
import 'package:testsylo/model/api_request.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/model/profile_business_item.dart';
import 'package:testsylo/model/prompt_item.dart';
import 'package:testsylo/model/qcast_dashboard_item.dart';
import 'package:testsylo/model/user_item.dart';

class AppState {
  static final AppState _singleton = AppState._internal();
  ProfileBusinessItem profileBusinessItem = ProfileBusinessItem();
  factory AppState() {
    return _singleton;
  }

  AppState._internal();

  //http://sylo.eu-west-2.elasticbeanstalk.com/uploadGetMediaID

  //String host = "http://syloprodapi-env.eba-w2j3qizs.eu-west-2.elasticbeanstalk.com/";
                //"http://sylouat-env.eba-dvg56py5.eu-west-2.elasticbeanstalk.com/";
  UserItem userItem = UserItem();
  String host = "http://sylo.eu-west-2.elasticbeanstalk.com/";
  AddSyloItem addSyloItem;
  List<GetUserSylos> getUserSylosList;
  List<GetAlbum> albumList = List<GetAlbum>();
  GetUserSylos userSylo;
  List<AlbumMediaData> albumMediaDataList;
  MyChannelProfileItem myChannelProfileItem;
  SharedSylo sharedSylo;
  SharedSyloItem sharedSyloItem;
  SyloMediaCountItem syloMediaCountItem = SyloMediaCountItem();
  QcastDashboardItem qcastDashboardItem;
  MyDownloadedQcastItem myDownloadedQcastItem;
  List<PromptItem> listPrompt;
  InActivityPeriodItem inActivityPeriodItem;
  NotificationItem notificationItem;
  int notificationNumber;
  RePostApplication rePostApplication = RePostApplication.None;
  SongsApplication songsApplication = SongsApplication.None;
  GetAlbum quickAddedAlbum;
  CreateQcastItem selectedDownloadedQcast;
}
