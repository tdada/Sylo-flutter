class GetUserSylos {
  int syloId;
  int userId;
  String syloName;
  String displayName;
  String syloPic;
  int albumCount;
  String syloAge;
  bool isCheck;

  GetUserSylos({
    this.syloId,
    this.userId,
    this.syloName,
    this.displayName,
    this.syloPic,
    this.albumCount,
    this.syloAge,
    this.isCheck = false,
  });

  factory GetUserSylos.fromJson(Map<String, dynamic> json) => GetUserSylos(
    syloId: json["syloId"],
    userId: json["userId"],
    syloName: json["syloName"],
    displayName: json["displayName"],
    syloPic: json["syloPic"],
    albumCount: json["albumCount"],
    syloAge: json["syloAge"],
  );
}

class GetAlbum {
  String albumName;
  int albumId;
  int mediaCount;
  String mediaType;
  String coverPhoto;
  bool isCheck;
  bool selected = false;

  GetAlbum({
    this.albumName,
    this.albumId,
    this.mediaCount,
    this.mediaType,
    this.coverPhoto,
    this.isCheck = false,
  });

  factory GetAlbum.fromJson(Map<String, dynamic> json) =>
      GetAlbum(
        albumName: json["albumName"],
        albumId: json["albumId"],
        mediaCount: json["mediaCount"],
        mediaType: json["mediaType"],
        coverPhoto: json["coverPhoto"],
      );
}

class AlbumMediaData {
  int subAlbumId;
  String subAlbumName;
  String mediaType;
  String coverPhoto;
  String qcastCoverPhoto;

  AlbumMediaData({
    this.subAlbumId,
    this.subAlbumName,
    this.mediaType,
    this.coverPhoto,
    this.qcastCoverPhoto,
  });

  factory AlbumMediaData.fromJson(Map<String, dynamic> json) => AlbumMediaData(
    subAlbumId: json["subAlbumId"],
    subAlbumName: json["subAlbumName"],
    mediaType: json["mediaType"],
    coverPhoto: json["coverPhoto"],
    qcastCoverPhoto: json["qcastCoverPhoto"] == null ? null : json["qcastCoverPhoto"],
  );

  Map<String, dynamic> toJson() => {
    "subAlbumId": subAlbumId,
    "subAlbumName": subAlbumName,
    "mediaType": mediaType,
    "coverPhoto": coverPhoto,
  };
}

class SubAlbumData {
  int subAlbumId;
  String title;
  String tag;
  String mediaType;
  int userId;
  dynamic directUrl;
  dynamic description;
  String textMsg;
  String coverPhoto;
  List<dynamic> mediaUrls;
  String postedDate;
  String qcastCoverPhoto;
  String qcastDuration;
  int qcastId;

  SubAlbumData({
    this.subAlbumId,
    this.title,
    this.tag,
    this.mediaType,
    this.userId,
    this.directUrl,
    this.description,
    this.textMsg,
    this.coverPhoto,
    this.mediaUrls,
    this.postedDate,
    this.qcastCoverPhoto,
    this.qcastDuration,
    this.qcastId,
  });

  factory SubAlbumData.fromJson(Map<String, dynamic> json) => SubAlbumData(
    subAlbumId: json["subAlbumId"],
    title: json["title"],
    tag: json["tag"],
    mediaType: json["mediaType"],
    userId: json["userId"],
    directUrl: json["directURL"],
    description: json["description"],
    textMsg: json["textMsg"],
    coverPhoto: json["coverPhoto"],
    mediaUrls: json["mediaUrls"],
    postedDate: json["postedDate"],
    qcastCoverPhoto : json["qcastCoverPhoto"] == null ? null : json["qcastCoverPhoto"],
    qcastDuration : json["qcastDuration"] == null ? null : json["qcastDuration"],
    qcastId : json["qcastId"] == null ? null : int.parse(json["qcastId"]),
  );

  Map<String, dynamic> toJson() => {
    "subAlbumId": subAlbumId,
    "title": title,
    "tag": tag,
    "mediaType": mediaType,
    "userId": userId,
    "directURL": directUrl,
    "description": description,
    "textMsg": textMsg,
    "coverPhoto": coverPhoto,
    "mediaUrls": mediaUrls,
    "postedDate": postedDate,
  };
}

class SharedSylo {
  SharedSylo({
    this.completedSylos,
    this.activeSylos,
    this.sharedSylos,
  });

  List<SharedSyloItem> completedSylos;
  List<SharedSyloItem> activeSylos;
  List<SharedSyloItem> sharedSylos;

  factory SharedSylo.fromJson(Map<String, dynamic> json) => SharedSylo(
    completedSylos: json["completedSylos"]!=null ? List<SharedSyloItem>.from(json["completedSylos"].map((x) => SharedSyloItem.fromJson(x))):List<SharedSyloItem>(),
    activeSylos: json["activeSylos"]!=null ? List<SharedSyloItem>.from(json["activeSylos"].map((x) => SharedSyloItem.fromJson(x))):List<SharedSyloItem>(),
    sharedSylos: json["sharedSylos"]!=null ? List<SharedSyloItem>.from(json["sharedSylos"].map((x) => SharedSyloItem.fromJson(x))):List<SharedSyloItem>(),
  );

  Map<String, dynamic> toJson() => {
    "completedSylos": List<dynamic>.from(completedSylos.map((x) => x.toJson())),
    "activeSylos": List<dynamic>.from(activeSylos.map((x) => x.toJson())),
    "sharedSylos": List<dynamic>.from(sharedSylos.map((x) => x.toJson())),
  };
}

class SharedSyloItem {
  SharedSyloItem({
    this.syloId,
    this.ownerUserId,
    this.syloName,
    this.syloPic,
    this.questionCount,
    this.displayName,
    this.syloMakerName,
    this.active
  });

  int syloId;
  int ownerUserId;
  String syloName;
  String syloPic;
  String questionCount;
  String displayName;
  String syloMakerName;
  bool active = false;

  factory SharedSyloItem.fromJson(Map<String, dynamic> json) => SharedSyloItem(
    syloId: json["syloId"],
    ownerUserId: json["ownerUserId"],
    syloName: json["syloName"],
    syloPic: json["syloPic"],
    active: json["active"],
    displayName: json["displayName"],
    syloMakerName: json["syloMakerName"],
    questionCount: json["questionCount"] == null ? "0" : json["questionCount"],
  );

  Map<String, dynamic> toJson() => {
    "syloId": syloId,
    "ownerUserId": ownerUserId,
    "syloName": syloName,
    "syloPic": syloPic,
    "syloMakerName": syloMakerName,
    "displayName": displayName,
    "active": active,
    "questionCount": questionCount == null ? "0" : questionCount,
  };
}

class SyloMediaCountItem {
  SyloMediaCountItem({
    this.photo,
    this.video,
    this.text,
    this.audio,
    this.qcast,
    this.songs,
    this.vtag,
  });

  int photo;
  int video;
  int text;
  int audio;
  int qcast;
  int songs;
  int vtag;

  factory SyloMediaCountItem.fromJson(Map<String, dynamic> json) => SyloMediaCountItem(
    photo: json["photo"],
    video: json["video"],
    text: json["text"],
    audio: json["audio"],
    qcast: json["qcast"],
    songs: json["songs"],
    vtag: json["vtag"],
  );

  Map<String, dynamic> toJson() => {
    "photo": photo,
    "video": video,
    "text": text,
    "audio": audio,
    "qcast": qcast,
    "songs": songs,
    "vtag": vtag,
  };
}

class SyloQuestionItem {
  int questionId;
  String postedDate;
  int syloId;
  String title;
  String coverPhoto;
  String mediaType;
  String txtMsg;
  List<String> rawMediaIds;
  int userId;
  bool addedToQcast;

  SyloQuestionItem({
    this.questionId,
    this.postedDate,
    this.syloId,
    this.title,
    this.coverPhoto,
    this.mediaType,
    this.txtMsg,
    this.rawMediaIds,
    this.userId,
    this.addedToQcast,
  });

  factory SyloQuestionItem.fromJson(Map<String, dynamic> json) => SyloQuestionItem(
    questionId: json["questionId"],
    postedDate: json["postedDate"],
    syloId: json["syloID"],
    title: json["title"],
    coverPhoto: json["coverPhoto"] == null ? null : json["coverPhoto"],
    mediaType: json["mediaType"],
    txtMsg: json["txtMsg"] == null ? null : json["txtMsg"],
    rawMediaIds: json["rawMediaIds"] == null ? null : List<String>.from(json["rawMediaIds"].map((x) => x)),
    userId: json["userId"],
    addedToQcast: json["addedToQcast"] == null ? null : json["addedToQcast"],
  );

  Map<String, dynamic> toJson() => {
    "questionId": questionId,
    "postedDate": postedDate,
    "syloID": syloId,
    "title": title,
    "coverPhoto": coverPhoto == null ? null : coverPhoto,
    "mediaType": mediaType,
    "txtMsg": txtMsg == null ? null : txtMsg,
    "rawMediaIds": rawMediaIds == null ? null : List<dynamic>.from(rawMediaIds.map((x) => x)),
    "userId": userId,
  };
}
class FaqModel {
  FaqModel({
    this.faqId,
    this.category,
    this.question,
    this.answer,
  });

  int faqId;
  String category;
  String question;
  String answer;

  factory FaqModel.fromJson(Map<String, dynamic> json) => FaqModel(
    faqId: json["faqId"],
    category: json["category"],
    question: json["question"],
    answer: json["answer"],
  );

  Map<String, dynamic> toJson() => {
    "faqId": faqId,
    "category": category,
    "question": question,
    "answer": answer,
  };
}

class EditAlbumResponse {
  int id;
  String msg;

  EditAlbumResponse({this.id, this.msg});

  EditAlbumResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['msg'] = this.msg;
    return data;
  }
}
      class AlbumDeleteResponse {
        int id;
        String msg;

        AlbumDeleteResponse({this.id, this.msg});

        AlbumDeleteResponse.fromJson(Map<String, dynamic> json) {
          id = json['id'];
          msg = json['msg'];
        }

        Map<String, dynamic> toJson() {
          final Map<String, dynamic> data = new Map<String, dynamic>();
          data['id'] = this.id;
          data['msg'] = this.msg;
          return data;
        }
      }

class UserStorage {
  int id;
  String msg;
  Data data;

  UserStorage({this.id, this.msg, this.data});

  UserStorage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  double bytes;
  double mB;
  double kB;
  double gB;

  Data({this.bytes, this.mB, this.kB, this.gB});

  Data.fromJson(Map<String, dynamic> json) {
    bytes = json['Bytes'].toDouble();
    mB = json['MB'].toDouble();
    kB = json['KB'].toDouble();
    gB = json['GB'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Bytes'] = this.bytes;
    data['MB'] = this.mB;
    data['KB'] = this.kB;
    data['GB'] = this.gB;
    return data;
  }
}