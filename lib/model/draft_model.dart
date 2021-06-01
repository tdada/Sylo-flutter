import 'dart:convert';

import '../app.dart';
import 'model.dart';

class MyDraft {

  int id;
  String title;
  String tag;
  String mediaType;
  String createTime;
  List<MyDraftMedia> myDraftMedia;
  String textMsg;
  String coverPhoto;
  String description;
  String directURL;
  int qcastId;
  String qcastCoverPhoto;
  String qcastDuration;
  String qcastQuestionList;
  String onlyMessage;
  String postType;

  MyDraft({this.id, this.title, this.tag, this.mediaType, this.createTime, this.myDraftMedia, this.textMsg,
    this.coverPhoto, this.description, this.onlyMessage, this.postType,
    this.directURL, this.qcastId, this.qcastCoverPhoto, this.qcastDuration, this.qcastQuestionList
  });

  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['title'] = title;
    map['tag'] = tag;
    map['media_type'] = mediaType;
    map['create_time'] = App.getDateByFormat(DateTime.now(),  App.formatDateWithTime);
    map['cover_photo'] = coverPhoto;
    map['description'] = description;
    map['directURL'] = directURL;
    map['qcastId'] = qcastId;
    map['qcastDuration'] = qcastDuration;
    map['qcast_cover_photo'] = qcastCoverPhoto;
    map['qcast_question_list']  = qcastQuestionList;
    map['onlyMessage'] = onlyMessage;
    map['post_type'] = postType;
    return map;
  }

  MyDraft.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.title = map['title'];
    this.tag = map['tag'];
    this.mediaType = map['media_type'];
    this.createTime = map['create_time'];
    this.coverPhoto = map['cover_photo'] != null ? map['cover_photo'] : null;
    this.description = map['description'] != null ? map['description'] : null;
    this.directURL = map['directURL'] != null ? map['directURL'] : null;
    this.qcastId = map['qcastId'] != null ? map['qcastId'] : null;
    this.qcastDuration = map['qcastDuration'] != null ? map['qcastDuration'] : null;
    this.qcastCoverPhoto = map['qcast_cover_photo'] != null ? map['qcast_cover_photo'] : null;
    this.qcastQuestionList = map['qcast_question_list'] != null ? map['qcast_question_list'] : null;
    this.onlyMessage = map['onlyMessage'] !=null ? map['onlyMessage'] : null;
    this.postType = map['post_type'] !=null ? map['post_type'] : null;
  }
}

class MyDraftMedia {

  int id;
  int draftId;
  String image;
  String link;
  String isCircle;

  MyDraftMedia({this.id, this.draftId, this.image, this.link, this.isCircle});

  factory MyDraftMedia.fromPostPhotoModel(PostPhotoModel postPhotoModel) => MyDraftMedia(
    image: postPhotoModel?.image?.path??null,
    link: postPhotoModel.link,
    isCircle: postPhotoModel.isCircle.toString(),
  );

  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    map['draft_id'] = draftId;
    map['image'] = image;
    map['link'] = link;
    map['is_circle'] = isCircle;

    return map;
  }

  MyDraftMedia.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id']==null ? 0 : map['id'];
    this.draftId = map['draft_id']==null ? 0 : map['draft_id'];
    this.image = map['image']==null ? null : map['image'];
    this.link = map['link']==null ? null : map['link'];
    this.isCircle = map['is_circle']==null ? null : map['is_circle'];
  }
}

class DisplayDraftItem {
  String title;
  List<MyDraft> myDraftList;

  DisplayDraftItem({this.title, this.myDraftList});
}