import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/common/play_view_side_audio_widget.dart';
import 'package:testsylo/common/play_view_side_video.dart';
import 'package:testsylo/model/api_request.dart';
import 'package:testsylo/model/draft_model.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/model/question_item.dart';
import 'package:testsylo/model/record_file_item.dart';
import 'package:testsylo/page/dashboard/sylo_action_circular_page/my_drafts_page/my_draft_page_view_model.dart';
import 'package:testsylo/page/post_media/post_photo/record_voice_tag_page/review_voice_tag_page/review_voice_tag_page.dart';
import 'package:testsylo/page/post_media/post_photo/review_photo_post_page/review_photo_post_page.dart';
import 'package:testsylo/page/post_media/post_song/song_post_review_page/song_post_review_page.dart';
import 'package:testsylo/page/post_media/post_sound_bite/edit_sound_bite_post_page/edit_sound_bite_post_page.dart';
import 'package:testsylo/page/post_media/post_text/edit_letter_post_page.dart';
import 'package:testsylo/page/post_media/reposts_page/repost_review_page/repost_review_page.dart';
import 'package:testsylo/page/qcast/qcat_tab/questions_page/qcasts_page/qcasts_video_record_page/qcasts_video_record_page.dart';
import 'package:testsylo/page/qcast/qcat_tab/questions_page/que_ans_record_edit/que_ans_record_edit_page.dart';
import 'package:testsylo/page/sylo/view_sylo_page/sylo_album_page/sylo_album_page.dart';
import 'package:testsylo/util/navigate_effect.dart';

import '../../../../app.dart';

class MyDraftsPage extends StatefulWidget {
  @override
  MyDraftsPageState createState() => MyDraftsPageState();
}

class MyDraftsPageState extends State<MyDraftsPage> {
  MyDraftsPageViewModel model;

  topText(String title) => Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            Divider()
          ],
        ),
      );

  listItemProfilePic(MyDraft myDraft) => Container(
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 5, right: 5),
              child: ClipOval(
                child: Container(
                  child: ClipOval(
                    child: Container(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () {
                          /*var result = await Navigator.push(
                                    context,
                                    NavigatePageRoute(
                                        context, SyloAlbumPage()));*/
                        },
                        child: getImageToDisplay(myDraft),
                      ),
                    ),
                  ),
                  padding: EdgeInsets.all(3),
                  color: colorOvalBorder,
                ),
              ),
            ),
            myDraft.mediaType != "QCAST"
                ? Positioned(
                    child: ClipOval(
                      child: Container(
                        padding: EdgeInsets.all(6),
                        child: Image.asset(
                            getImageOfContentType(myDraft.mediaType)),
                        color: colorOvalBorder,
                        alignment: Alignment.center,
                        width: 28,
                        height: 28,
                      ),
                    ),
                    right: 1,
                    top: 0,
                  )
                : SizedBox(),
            myDraft.mediaType == "QCAST"
                ? Positioned(
                    child: ClipOval(
                      child: Container(
                        padding: EdgeInsets.all(2),
                        child: ClipOval(
                          child: Container(
                            width: 24,
                            height: 24,
                            child: ImageFromNetworkView(
                              path: myDraft.qcastCoverPhoto != null
                                  ? myDraft.qcastCoverPhoto
                                  : "",
                              boxFit: BoxFit.cover,
                            ),
                          ),
                        ),
                        color: colorOvalBorder,
                        alignment: Alignment.center,
                      ),
                    ),
                    right: 0,
                    bottom: 0,
                  )
                : SizedBox()
          ],
        ),
      );

  postToSyloButton(MyDraft myDraft) => Container(
      width: 100,
      margin: EdgeInsets.only(top: 8),
      child: InkWell(
        child: Material(
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Ink(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: colorDark, width: 0.9)),
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 1, right: 1, top: 5, bottom: 5),
              child: Text(
                "Post to Sylo",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: colorDark,
                    fontWeight: FontWeight.w500,
                    fontSize: 13),
              ),
            ),
          ),
        ),
        onTap: () {
          clickOnItem(myDraft);
        },
      ));

  preveiewButton(MyDraft myDraft) => Container(
      width: 100,
      margin: EdgeInsets.only(top: 8, left: 5),
      child: InkWell(
        child: Material(
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Ink(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: colorDark, width: 0.9)),
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 1, right: 1, top: 5, bottom: 5),
              child: Text(
                "Preview",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: colorDark,
                    fontWeight: FontWeight.w500,
                    fontSize: 13),
              ),
            ),
          ),
        ),
        onTap: () {
          clickOnItemPreview(myDraft);
        },
      ));

  listItemContent(MyDraft myDraft) => Expanded(
        child: Container(
          padding: EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      getTitleString(myDraft?.title ?? ""),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () {
                      model.deleteDraftItem(myDraft.id, myDraft.mediaType);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Image.asset(
                        App.ic_delete_drafts,
                        height: 14,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                "Created at " + myDraft.createTime.toString(),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: colorSubTextPera,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
              ),
              SizedBox(
                height: 6,
              ),
              Row(
                children: [
                  postToSyloButton(myDraft),
                  myDraft.mediaType == "VIDEO" ||
                          myDraft.mediaType == "AUDIO" ||
                          myDraft.mediaType == "PHOTO"
                      ? preveiewButton(myDraft)
                      : Container()
                ],
              )
            ],
          ),
        ),
      );

  get myDraftsListView => Container(
          child: ListView.builder(
        itemCount: model?.myAllDraftList?.length ?? 0,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          DisplayDraftItem displayDraftItem = model.myAllDraftList[index];
          return Container(
            child: Column(
              children: <Widget>[
                topText(displayDraftItem.title.toString()),
                ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: displayDraftItem.myDraftList?.length ?? 0,
                  shrinkWrap: true,
                  itemBuilder: (c, i) {
                    MyDraft myDraft = displayDraftItem.myDraftList[i];

                    return Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        children: <Widget>[
                          listItemProfilePic(myDraft),
                          listItemContent(myDraft),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ));

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = MyDraftsPageViewModel(this));

    return Scaffold(
      backgroundColor: getColorBg(),
      appBar: AppBar(
        title: Text(
          "My Drafts",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w800, fontSize: 17),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Image.asset(
                  App.ic_back,
                  fit: BoxFit.contain,
                  width: 16,
                  height: 16,
                ),
              ),
            ],
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Container(
          child: ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Column(
                children: <Widget>[
//                  topText,
                  myDraftsListView,
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  String getTitleString(String title) {
    if (title.isEmpty) {
      return "Unposted Photo";
    }
    return title;
  }

  getImageToDisplay(MyDraft myDraft) {
    if (myDraft.mediaType == "PHOTO") {
      if (myDraft.myDraftMedia != null && myDraft.myDraftMedia.length > 0) {
        return Container(
          child: ImageFromPhotoPostModel(
              PostPhotoModel.fromMyDraftMedia(myDraft.myDraftMedia.first),
              boxFit: BoxFit.cover),
          width: 74,
          height: 74,
        );
      } else {
        return Container(
          child: Image.asset(App.ic_place, fit: BoxFit.contain),
          width: 74,
          height: 74,
        );
      }
    }

    if (myDraft.mediaType == "VIDEO" || myDraft.mediaType == "QCAST") {
      try {
        File file = File(myDraft.coverPhoto);
        return Container(
          child: Image.file(file, fit: BoxFit.cover),
          width: 74,
          height: 74,
        );
      } catch (e) {
        return Container(
          child: Image.asset(App.ic_placeholder, fit: BoxFit.cover),
          width: 74,
          height: 74,
        );
      }
    }
    return getAlbumThumbIcon(myDraft.mediaType, myDraft.coverPhoto,
        cHeight: 74, cWidth: 74);
  }

  clickOnItem(MyDraft myDraft) async {
    isQuickPost = true;
    switch (myDraft.mediaType) {
      case "QCAST":
      case "VIDEO":
        {
          if (myDraft.myDraftMedia.length > 0) {
            CameraState cameraState = CameraState.R;
            if (myDraft.myDraftMedia.first.isCircle == "false") {
              cameraState = CameraState.S;
            }
            List<RecordFileItem> listRecordWithThumb = List();
            myDraft.myDraftMedia.forEach((draftMediaItem) {
              RecordFileItem recordFileItem =
                  RecordFileItem.fromMyDraftMedia(draftMediaItem);
              recordFileItem.thumbPath = File(myDraft.coverPhoto);
              listRecordWithThumb.add(recordFileItem);
            });
            List<QuestionItem> listQuestion;
            if (myDraft.mediaType == "QCAST") {
              appState.selectedDownloadedQcast =
                  CreateQcastItem(qcastId: myDraft.qcastId);
              listQuestion = getQcastQuestionListFromDraftString(myDraft);
            }
            Navigator.push(
                context,
                NavigatePageRoute(
                    context,
                    QcastsVideoRecordPage(
                        listRecordWithThumb, null, cameraState,
                        from: runtimeType.toString(), myDraft: myDraft)));
          } else {
            commonToast("This Draft not contain video.");
          }
        }
        break;
      case "PHOTO":
        {
          List<PostPhotoModel> pickedImages = List();
          myDraft.myDraftMedia.forEach((draftMediaItem) {
            pickedImages.add(PostPhotoModel.fromMyDraftMedia(draftMediaItem));
          });
          Navigator.push(
              context,
              NavigatePageRoute(
                  context,
                  ReviewPhotoPostPage(
                      pickedImages: pickedImages,
                      from: runtimeType.toString(),
                      myDraft: myDraft)));
        }
        break;
      case "AUDIO":
        {
          String path = myDraft.directURL;
          Navigator.push(
              context,
              NavigatePageRoute(
                  context,
                  EditSoundBitePostPage(
                    from: runtimeType.toString(),
                    path: File(path),
                    myDraft: myDraft,
                  )));
        }
        break;
      case "TEXT":
        {
          Navigator.push(
              context,
              NavigatePageRoute(
                  context,
                  EditLetterPostPage(
                      from: runtimeType.toString(), myDraft: myDraft)));
        }
        break;
      case "SONGS":
        {
          Navigator.push(
              context,
              NavigatePageRoute(
                  context,
                  SongPostReviewPage(
                      from: runtimeType.toString(),
                      link: myDraft.directURL,
                      myDraft: myDraft,
                      type: myDraft.postType)));
        }
        break;
      case "REPOST":
        {
          Navigator.push(
              context,
              NavigatePageRoute(
                  context,
                  RepostReviewPage(
                      from: runtimeType.toString(),
                      link: myDraft.directURL,
                      myDraft: myDraft,
                      type: myDraft.postType)));
        }
        break;
      case "VTAG":
        {
          List<PostPhotoModel> pickedImages = List();
          myDraft.myDraftMedia.forEach((draftMediaItem) {
            pickedImages.add(PostPhotoModel.fromMyDraftMedia(draftMediaItem));
          });
          Navigator.push(
              context,
              NavigatePageRoute(
                  context,
                  ReviewVoiceTagPage(
                      from: runtimeType.toString(),
                      myDraft: myDraft,
                      pickedImages: pickedImages)));
        }
        break;
      /*
      case "REPOST": {
        var result = await Navigator.push(
            context, NavigatePageRoute(context,
            CompletedSyloRepostPage(from: runtimeType.toString(), albumMediaData: albumMediaData)
        ));
        if(result!=null && result==true){
          appState.albumList = null;
          model.getAlbumMediaData(isReCall: true);
        }
      }
      break;

      case "QCAST": {
        var result = await Navigator.push(
            context, NavigatePageRoute(context,
            CompletedViewVideoPage(from: runtimeType.toString(), albumMediaData: albumMediaData)
        ));
        if(result!=null && result==true){
          appState.albumList = null;
          model.getAlbumMediaData(isReCall: true);
        }
      }
      break;*/
      default:
        {}
        break;
    }
  }

  clickOnItemPreview(MyDraft myDraft) async {
    isQuickPost = true;
    switch (myDraft.mediaType) {
      case "QCAST":
      case "VIDEO":
        {
          if (myDraft.myDraftMedia.length > 0) {
            CameraState cameraState = CameraState.R;
            if (myDraft.myDraftMedia.first.isCircle == "false") {
              cameraState = CameraState.S;
            }
            List<RecordFileItem> listRecordWithThumb = List();
            myDraft.myDraftMedia.forEach((draftMediaItem) {
              RecordFileItem recordFileItem =
                  RecordFileItem.fromMyDraftMedia(draftMediaItem);
              recordFileItem.thumbPath = File(myDraft.coverPhoto);
              listRecordWithThumb.add(recordFileItem);
            });
            List<QuestionItem> listQuestion;
            if (myDraft.mediaType == "QCAST") {
              appState.selectedDownloadedQcast =
                  CreateQcastItem(qcastId: myDraft.qcastId);
              listQuestion = getQcastQuestionListFromDraftString(myDraft);
            }
            /* Navigator.push(
              context,
              NavigatePageRoute(
                  context, QcastsVideoRecordPage(
                  listRecordWithThumb,
                  null,
                  cameraState, from: runtimeType.toString(), myDraft: myDraft)));*/

            showDialog(
              context: context,
              builder: (BuildContext context) => PlayViewSideVideoPage(
                isFile: true,
                url: listRecordWithThumb[0].file.path,
                //queLink: listRecordWithThumb[0].videoThumb,
                //cameraState: getVideoShape(model.subAlbumData.mediaUrls[0]),
                playIndicator: true,
              ),
            );
          } else {
            commonToast("This Draft not contain video.");
          }
        }
        break;
      case "PHOTO":
        {
          if (myDraft.myDraftMedia.length > 0) {
            List<PostPhotoModel> pickedImages = List();
            myDraft.myDraftMedia.forEach((draftMediaItem) {
              pickedImages.add(PostPhotoModel.fromMyDraftMedia(draftMediaItem));
            });

            /*Navigator.push(
            context,
            NavigatePageRoute(
                context, ReviewPhotoPostPage(pickedImages: pickedImages, from: runtimeType.toString(), myDraft: myDraft)));*/

            zoomFileImageDialogueContainWidthDraft(
              context,
              myDraft,
            );
          } else {
            commonToast("This Draft not contain video.");
          }
        }
        break;
      case "AUDIO":
        {
          if (myDraft.directURL != null) {
            String path = myDraft.directURL;
            /*Navigator.push(
            context, NavigatePageRoute(context,
            EditSoundBitePostPage(from: runtimeType.toString(), path: File(path),myDraft: myDraft,)
        ));*/

            showDialog(
              context: context,
              builder: (BuildContext context) => PlayViewSideAudioWidget(
                url: myDraft.directURL,
                icon_size: 32.0,
                isLocal: true,
              ),
            );
          } else {
            commonToast("This Draft not contain video.");
          }
        }
        break;
      case "TEXT":
        {
          Navigator.push(
              context,
              NavigatePageRoute(
                  context,
                  EditLetterPostPage(
                      from: runtimeType.toString(), myDraft: myDraft)));
        }
        break;
      case "SONGS":
        {
          Navigator.push(
              context,
              NavigatePageRoute(
                  context,
                  SongPostReviewPage(
                      from: runtimeType.toString(),
                      link: myDraft.directURL,
                      myDraft: myDraft,
                      type: myDraft.postType)));
          /*showDialog(
          context: context,
          builder: (BuildContext context) => PlayViewSideAudioWidget(
            url: myDraft.directURL,
            icon_size: 32.0,
            isLocal: false,
          ),
        );*/
        }
        break;
      case "REPOST":
        {
          Navigator.push(
              context,
              NavigatePageRoute(
                  context,
                  RepostReviewPage(
                      from: runtimeType.toString(),
                      link: myDraft.directURL,
                      myDraft: myDraft,
                      type: myDraft.postType)));
        }
        break;
      case "VTAG":
        {
          /*List<PostPhotoModel> pickedImages = List();
        myDraft.myDraftMedia.forEach((draftMediaItem) {
          pickedImages.add(PostPhotoModel.fromMyDraftMedia(draftMediaItem));
        });
        Navigator.push(
            context, NavigatePageRoute(context,
            ReviewVoiceTagPage(from: runtimeType.toString(), myDraft: myDraft, pickedImages: pickedImages)
        ));*/

          zoomFileImageDialogueContainWidthDraft(
            context,
            myDraft,
          );
        }
        break;
      /*
      case "REPOST": {
        var result = await Navigator.push(
            context, NavigatePageRoute(context,
            CompletedSyloRepostPage(from: runtimeType.toString(), albumMediaData: albumMediaData)
        ));
        if(result!=null && result==true){
          appState.albumList = null;
          model.getAlbumMediaData(isReCall: true);
        }
      }
      break;

      case "QCAST": {
        var result = await Navigator.push(
            context, NavigatePageRoute(context,
            CompletedViewVideoPage(from: runtimeType.toString(), albumMediaData: albumMediaData)
        ));
        if(result!=null && result==true){
          appState.albumList = null;
          model.getAlbumMediaData(isReCall: true);
        }
      }
      break;*/
      default:
        {}
        break;
    }
  }
}
