  import 'dart:io';

class AddUserItem {
  String userName = "";
  String password = "";
  String oldPwd = "";
  String email = "";
  File file;
  String token="";

  AddUserItem(this.userName, this.password, this.email, this.file, {this.token, this.oldPwd});

  Map<String, String> toMap() {
    var map = new Map<String, String>();
    map['userName'] = userName;
    if(oldPwd!=null) {
      map['oldPwd'] = oldPwd;
    }
    map['password'] = password;
    map['email'] = email;
    if(token!=""){
      map['token'] = token;
    }
    return map;
  }

  Map<String, String> toMapWithoutPassword() {
    var map = new Map<String, String>();
    map['userName'] = userName;
    map['email'] = email;
    return map;
  }
}

class AddSyloItem {

  int userId = 0;
  String recipientEmail = "";
  String recipientName = "";
  String displayName = "";
  String recipientBirthday = "";
  String age = "";
  String relationship = "";
  String familyRelationship = "";
  String coRecipientName = "";
  String coRecipientEmail = "";

  String recipientEmailSec = "";
  String recipientNameSec = "";
  String recipientBirthdaySec = "";
  String ageSec = "";
  String relationshipSec = "";
  String familyRelationshipSec = "";
  String coRecipientNameSec = "";
  String coRecipientEmailSec = "";

  String openingMsg = "";
  bool notifyUser = false;
  String openingVideo;
  File file;
  int syloId;
  String syloPic;
  String creationDate;
  bool grouped;
  String openingVideoUrl;


  AddSyloItem({
      this.userId,
      this.recipientEmail,
      this.recipientName,
      this.displayName,
      this.recipientBirthday,
      this.age,
      this.relationship,
      this.familyRelationship,
      this.coRecipientName,
      this.coRecipientEmail,
      this.recipientEmailSec,
      this.recipientNameSec,
      this.recipientBirthdaySec,
      this.ageSec,
      this.relationshipSec,
      this.familyRelationshipSec,
      this.coRecipientNameSec,
      this.coRecipientEmailSec,
      this.openingMsg,
      this.openingVideo,
      this.notifyUser,
      this.file,
      this.syloId,
      this.syloPic,
      this.creationDate,
      this.grouped,
      this.openingVideoUrl,
  });

  Map<String, String> toMap() {
    var map = new Map<String, String>();
    map['userId'] = userId.toString();
    map['recipientEmail'] = recipientEmail;
    map['displayName'] = displayName;
    map['recipientName'] = recipientName;
    map['recipientBirthday'] = recipientBirthday;
    map['age'] = age;
    map['relationship'] = relationship;
    map['familyRelationship'] = familyRelationship;
    if(int.parse(age)<18) {
      map['coRecipientName'] = coRecipientName;
      map['coRecipientEmail'] = coRecipientEmail;
    }
    if(openingMsg!=null) {
      map['openingMsg'] = openingMsg;
    }
    map['notifyUser'] = notifyUser.toString();
    if(openingVideo!=null) {
      map['openingVideo'] = openingVideo;
    }
    if(syloPic!=null){
      map['syloPicCloudUrl'] = syloPic;
    }
    if(syloId!=null){
      map['syloId'] = syloId.toString();
    }
    return map;
  }
  Map<String, String> tooMap() {
    var map = new Map<String, String>();
    map['userId'] = userId.toString();
    map['recipientEmail'] = recipientEmail;
    map['displayName'] = displayName;
    map['recipientName'] = recipientName;
    map['recipientBirthday'] = recipientBirthday;
    map['age'] = age;
    map['relationship'] = relationship;
    map['familyRelationship'] = familyRelationship;
    if(int.parse(age)<18) {
      map['coRecipientName'] = coRecipientName;
      map['coRecipientEmail'] = coRecipientEmail;
    }
    map['recipientNameSec'] = recipientNameSec;
    map['recipientEmailSec'] = recipientEmailSec;
    map['ageSec'] = ageSec;
    map['recipientBirthdaySec'] = recipientBirthdaySec;
    map['relationshipSec'] = relationshipSec;
    map['familyRelationshipSec'] = familyRelationshipSec;
    map['coRecipientNameSec'] = coRecipientNameSec;
    map['coRecipientEmailSec'] = coRecipientEmailSec;
    if(openingMsg!=null) {
      map['openingMsg'] = openingMsg;
    }
    map['notifyUser'] = notifyUser.toString();
    if(openingVideo!=null) {
      map['openingVideo'] = openingVideo;
    }
    if(syloPic!=null){
      map['syloPicCloudUrl'] = syloPic;
    }
    if(syloId!=null){
      map['syloId'] = syloId.toString();
    }
    return map;
  }

  factory AddSyloItem.fromJson(Map<String, dynamic> json) => AddSyloItem(
    syloId: json["syloId"],
    recipientName: json["recipientName"],
    recipientEmail: json["recipientEmail"],
    displayName: json["displayName"] == null ? null : json["displayName"],
    recipientBirthday: json["recipientBirthday"],
    age: json["age"].toString(),
    relationship: json["relationship"],
    familyRelationship: json["familyRelationship"],
    coRecipientName: json["coRecipientName"],
    coRecipientEmail: json["coRecipientEmail"],
    recipientNameSec: json["recipientNameSec"] == null ? null : json["recipientNameSec"],
    recipientEmailSec: json["recipientEmailSec"] == null ? null : json["recipientEmailSec"],
    recipientBirthdaySec: json["recipientBirthdaySec"] == null ? null : json["recipientBirthdaySec"],
    ageSec: json["ageSec"].toString(),
    relationshipSec: json["relationshipSec"] == null ? null : json["relationshipSec"],
    familyRelationshipSec: json["familyRelationshipSec"] == null ? null : json["familyRelationshipSec"],
    coRecipientNameSec: json["coRecipientNameSec"] == null ? null : json["coRecipientNameSec"],
    coRecipientEmailSec: json["coRecipientEmailSec"] == null ? null : json["coRecipientEmailSec"],
    syloPic: json["syloPic"],
    userId: json["userId"],
    notifyUser: json["notifyUser"],
    openingMsg: json["openingMsg"],
    openingVideo: json["openingVideo"],
    creationDate: json["creationDate"],
    grouped: json["grouped"],
    openingVideoUrl: json["openingVideoUrl"] == null ? null : json["openingVideoUrl"],
  );
}

class MediaSubAlbumItem {

  int userId = 0;
  int qcastId = 0;
  String title = "";
  String description = "";
  String directURL = "";
  String tag = "";
  String qcastDuration = "";
  String mediaType = "";
  String textMsg = "";
  String cover_photo = "";
  List<int> albumList = List();
  List<String> rawMediaList = List();
  bool draft = false;

  MediaSubAlbumItem({
    this.userId,
    this.title,
    this.tag,
    this.mediaType,
    this.albumList,
    this.rawMediaList,
    this.textMsg,
    this.cover_photo,
    this.description,
    this.directURL,
    this.qcastId,
    this.qcastDuration,
    this.draft=false,
   });

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['userId'] = userId.toString();
    if(title != null && title != "") {
      map['title'] = title;
    }
    if(tag != null && tag != "") {
      map['tag'] = tag;
    }
    map['mediaType'] = mediaType;
    if(cover_photo!=null && cover_photo.length>0){
      map['coverPhoto'] = cover_photo;
    }
    if(description != null && description != ""){
      map['description'] = description;
    }
    if(directURL != null && directURL != ""){
      map['directURL'] = directURL;
    }
    if(qcastId != null && qcastId != 0){
      map['qcastId'] = qcastId;
    }
    if(qcastDuration != null && qcastDuration != ""){
      map['qcastDuration'] = qcastDuration;
    }
    if(draft != null && draft == true){
      map['draft'] = draft;
    }

//    map['albumList'] = albumList;
//    map['rawMediaList'] = rawMediaList;

//    albumList.forEach((element) {map['albumList'] = element;});
//    rawMediaList.forEach((element) {map['rawMediaList'] = element;});
    return map;
  }

  Map<String, dynamic> toMapForText() {
    var map = new Map<String, dynamic>();
    map['userId'] = userId.toString();
    if(title != null && title != "") {
      map['title'] = title;
    }
    if(tag != null && tag != "") {
      map['tag'] = tag;
    }
    map['mediaType'] = mediaType;
    map['textMsg'] = textMsg;
    if(draft != null && draft == true){
      map['draft'] = draft;
    }
    return map;
  }
}
class MediaSubAlbumItem1 {

  int userId = 0;
  int qcastId = 0;
  String title = "";
  String description = "";
  String directURL = "";
  String tag = "";
  String qcastDuration = "";
  String mediaType = "";
  String textMsg = "";
  String cover_photo = "";
  String albumList = "";
  String rawMediaList = "";
  bool draft = false;

  MediaSubAlbumItem1({
    this.userId,
    this.title,
    this.tag,
    this.mediaType,
    this.albumList,
    this.rawMediaList,
    this.textMsg,
    this.cover_photo,
    this.description,
    this.directURL,
    this.qcastId,
    this.qcastDuration,
    this.draft=false,
  });

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['userId'] = userId.toString();
    if(title != null && title != "") {
      map['title'] = title;
    }
    if(tag != null && tag != "") {
      map['tag'] = tag;
    }
    map['mediaType'] = mediaType;
    if(cover_photo!=null && cover_photo.length>0){
      map['coverPhoto'] = cover_photo;
    }
    if(description != null && description != ""){
      map['description'] = description;
    }
    if(directURL != null && directURL != ""){
      map['directURL'] = directURL;
    }
    if(qcastId != null && qcastId != 0){
      map['qcastId'] = qcastId;
    }
    if(qcastDuration != null && qcastDuration != ""){
      map['qcastDuration'] = qcastDuration;
    }
    if(draft != null && draft == true){
      map['draft'] = draft;
    }
    if(rawMediaList != null && rawMediaList != ""){
      map['rawMediaList'] = rawMediaList;
    }
    if(albumList != null && albumList != ""){
      map['albumList'] = albumList;
    }

//    map['albumList'] = albumList;
//    map['rawMediaList'] = rawMediaList;

//    albumList.forEach((element) {map['albumList'] = element;});
//    rawMediaList.forEach((element) {map['rawMediaList'] = element;});
    return map;
  }

  Map<String, dynamic> toMapForText() {
    var map = new Map<String, dynamic>();
    map['userId'] = userId.toString();
    if(title != null && title != "") {
      map['title'] = title;
    }
    if(tag != null && tag != "") {
      map['tag'] = tag;
    }
    map['mediaType'] = mediaType;
    map['textMsg'] = textMsg;
    if(draft != null && draft == true){
      map['draft'] = draft;
    }
    if(albumList != null && albumList != ""){
      map['albumList'] = albumList;
    }
    return map;
  }
}

class MyChannelProfileItem {

  int userId = 0;
  int channelId = 0;
  String profileName = "";
  String qcastMoto = "";
  String description = "";
  File profilePic;
  String link = "";
  String coverPhoto = "";
  int myChannelUserId = 0;
  int subscribers = 0;
  int qcastSerices = 0;
  int totalQuestions = 0;
  String isAlreadySubscribed = "";

  MyChannelProfileItem({
    this.userId,
    this.profileName,
    this.qcastMoto,
    this.description,
    this.profilePic,
    this.link,
    this.coverPhoto,
    this.channelId,
    this.myChannelUserId,
    this.subscribers,
    this.qcastSerices,
    this.totalQuestions,
    this.isAlreadySubscribed,
  });

  Map<String, String> toMap() {
    var map = new Map<String, String>();
    map['userId'] = userId.toString();
    map['profileName'] = profileName;
    map['qcastMoto'] = qcastMoto;
    map['description'] = description;
    if( link!=null ) {
      map['profilePic'] = link;
    }
    return map;
  }

  factory MyChannelProfileItem.fromJson(Map<dynamic, dynamic> json) {
    print("json -> "+json.toString());
    return MyChannelProfileItem(
//        userId: json["userId"],
        channelId: json["channelId"],
        profileName: json["profileName"],
        qcastMoto: json["qcastMoto"],
        description: json["description"],
        coverPhoto: json["coverPhoto"],
        myChannelUserId: json["myChannelUserId"],
        subscribers: json["subscribers"],
        qcastSerices: json["qcastSerices"],
        totalQuestions: json["totalQuestions"],
        isAlreadySubscribed: json["isAlreadySubscribed"],
    );
  }
  factory MyChannelProfileItem.fromUpdatedJson(Map<dynamic, dynamic> json) {
    print("json -> "+json.toString());
    return MyChannelProfileItem(
      channelId: json["channelId"],
      profileName: json["profileName"],
      qcastMoto: json["qcastMoto"],
      description: json["description"],
      coverPhoto: json["coverPhoto"],
      userId: json["userId"],
    );
  }
}

class AskSyloQuestionItem {
  String syloID;
  String title;
  String mediaType;
  String txtMsg;
  String userId;
  String coverPhoto;
  List<String> rawMediaIds;

  AskSyloQuestionItem({
    this.syloID,
    this.title,
    this.mediaType,
    this.txtMsg,
    this.userId,
    this.rawMediaIds,
    this.coverPhoto,
});
  Map<String, String> toMap() {
    var map = new Map<String, String>();
    map['syloID'] = syloID;
    map['title'] = title;
    map['mediaType'] = mediaType;
    if(txtMsg != null) {
      map['txtMsg'] = txtMsg;
    }
    if(coverPhoto != null) {
      map['coverPhoto'] = coverPhoto;
    }
    map['userId'] = userId;
    return map;
  }
}

class CreateQcastItem {
  String title;
  String category;
  String previewVideoId;
  String coverPhoto;
  List<String> listOfVideo;
  int numberOfVideo;
  String status;
  String userId;
  List<String> sampleQuestion;
  String profileName;
  String description;
  bool downloadedByUser;
  int qcastId;

  CreateQcastItem({
    this.title,
    this.category,
    this.previewVideoId,
    this.coverPhoto,
    this.listOfVideo,
    this.status,
    this.userId,
    this.sampleQuestion,
    this.profileName,
    this.numberOfVideo,
    this.downloadedByUser,
    this.description,
    this.qcastId,
  });

  factory CreateQcastItem.fromJson(Map<String, dynamic> json) => CreateQcastItem(
    qcastId: json["qcastId"],
    title: json["title"],
    category: json["category"],
    previewVideoId: json["previewVideoId"],
    coverPhoto: json["coverPhoto"],
    listOfVideo: List<String>.from(json["listOfVideos"].map((x) => x)),
    numberOfVideo: json["numberOfVideo"],
    userId: json["userId"].toString(),
    sampleQuestion: json["sampleQuestions"]==null?List<String>():List<String>.from(json["sampleQuestions"].map((x) => x)),
    downloadedByUser: json["downloadedByUser"],
    description: json["description"],
  );

  Map<String, String> toMap() {
    var map = new Map<String, String>();
    map['title'] = title;
    map['Category'] = category;
    map['preview_video_id'] = previewVideoId;
    map['cover_photo'] = coverPhoto;
    map['Status'] = status;
    map['userId'] = userId;
    map['profileName'] = profileName;
    map['description'] = description;
    return map;
  }
}

class CreateQcastItem1 {
  String title;
  String category;
  String previewVideoId;
  String coverPhoto;
  String listOfVideo;
  int numberOfVideo;
  String status;
  String userId;
  String sampleQuestion;
  String profileName;
  String description;
  bool downloadedByUser;
  int qcastId;

  CreateQcastItem1({
    this.title,
    this.category,
    this.previewVideoId,
    this.coverPhoto,
    this.listOfVideo,
    this.status,
    this.userId,
    this.sampleQuestion,
    this.profileName,
    this.description,
    this.numberOfVideo,
    this.downloadedByUser,
    this.qcastId,
  });

  factory CreateQcastItem1.fromJson(Map<String, dynamic> json) => CreateQcastItem1(
    qcastId: json["qcastId"],
    title: json["title"],
    category: json["category"],
    previewVideoId: json["previewVideoId"],
    coverPhoto: json["coverPhoto"],
    listOfVideo: json["listOfVideos"],
    numberOfVideo: json["numberOfVideo"],
    userId: json["userId"].toString(),
    description: json["description"].toString(),
    sampleQuestion: json["sampleQuestions"],
    downloadedByUser: json["downloadedByUser"],
  );

  Map<String, String> toMap() {
    var map = new Map<String, String>();
    map['title'] = title;
    map['Category'] = category;
    map['preview_video_id'] = previewVideoId;
    map['cover_photo'] = coverPhoto;
    map['Status'] = status;
    map['sampleQuestion'] = sampleQuestion;
    map['listOfVideos'] = listOfVideo;
    map['userId'] = userId;
    map['profileName'] = profileName;
    map['description'] = description;
    return map;
  }
}

class CustomPromptItem {
  String title;
  String userId;
  List<String> promptsList = List();
  CustomPromptItem({
    this.title,
    this.promptsList,
    this.userId,
  });

  Map<String, String> toMap() {
    var map = new Map<String, String>();
    map['title'] = title;
    map['userId'] = userId;
    return map;
  }
}
class InActivityPeriodItem {
  int userId;
  int inactivityPeriod;
  int reminderDays;
  InActivityPeriodItem({this.userId, this.inactivityPeriod, this.reminderDays});

  Map<String, int> toMap() {
    var map = new Map<String, int>();
    map['userId'] = userId;
    if(inactivityPeriod!=null) {
      map['inactivityPeriod'] = inactivityPeriod;
    }
    if(reminderDays!=null) {
      map['reminderDays'] = reminderDays;
    }
    return map;
  }

  factory InActivityPeriodItem.fromJson(Map<String, dynamic> json) => InActivityPeriodItem(
    userId: json["userId"],
    inactivityPeriod: json["inactivityPeriod"],
    reminderDays: json["reminderDays"],
  );
}
class SyloLibraryVideo {
  String link;
  File thumbFile;
  SyloLibraryVideo({this.link, this.thumbFile});
}

class AlbumDeleteRequest {
  List<int> albumIdList;

  AlbumDeleteRequest({this.albumIdList});

  AlbumDeleteRequest.fromJson(Map<String, dynamic> json) {
    albumIdList = json['albumIdList'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['albumIdList'] = this.albumIdList;
    return data;
  }
}

      class FeedbackRequest {
        String category;
        String stars;
        String feedbackTxt;
        String userId;

        FeedbackRequest(
            {this.category, this.stars, this.feedbackTxt, this.userId});

        FeedbackRequest.fromJson(Map<String, dynamic> json) {
          category = json['category'];
          stars = json['stars'];
          feedbackTxt = json['feedbackTxt'];
          userId = json['userId'];
        }

        Map<String, dynamic> toJson() {
          final Map<String, dynamic> data = new Map<String, dynamic>();
          data['category'] = this.category;
          data['stars'] = this.stars;
          data['feedbackTxt'] = this.feedbackTxt;
          data['userId'] = this.userId;
          return data;
        }
      }
      class CopyMoveRequest {
        int sourceAlbumId;
        List<int> destinationAlbumIdList;
        String actionType;

        CopyMoveRequest(
            {this.sourceAlbumId, this.destinationAlbumIdList, this.actionType});

        CopyMoveRequest.fromJson(Map<String, dynamic> json) {
          sourceAlbumId = json['sourceAlbumId'];
          destinationAlbumIdList = json['destinationAlbumIdList'].cast<int>();
          actionType = json['actionType'];
        }

        Map<String, dynamic> toJson() {
          final Map<String, dynamic> data = new Map<String, dynamic>();
          data['sourceAlbumId'] = this.sourceAlbumId;
          data['destinationAlbumIdList'] = this.destinationAlbumIdList;
          data['actionType'] = this.actionType;
          return data;
        }
      }