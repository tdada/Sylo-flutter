import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/page/post_media/reposts_page/reposts_page.dart';
import 'package:testsylo/util/navigate_effect.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app.dart';
import 'repost_review_page/repost_review_page.dart';

class RepostsPageViewModel {
  RepostsPageState state;
  List<RepostModel> repostModel = List<RepostModel>();
  ClipboardData clipboardData;
  RepostsPageViewModel(this.state);

  initRepostModel(){
    repostModel.add(RepostModel(icon: App.ic_fb_round, title: "Facebook",isCheck: false, nextPage: null, link: "https://www.facebook.com/", status: RePostApplication.F));
    repostModel.add(RepostModel(icon: App.ic_insta, title: "Instagram", isCheck: false, nextPage: null, link: "https://www.instagram.com/", status: RePostApplication.I));
    repostModel.add(RepostModel(icon: App.ic_twitter, title: "Twitter", isCheck: false, nextPage: null, link: "https://twitter.com/", status: RePostApplication.T));
    repostModel.add(RepostModel(icon: App.ic_utube, title: "YouTube", isCheck: false, nextPage: null, link: "https://www.youtube.com/", status: RePostApplication.Y));
  }
  onClickItem(int index) async {
    state.setState(() {
      repostModel[index].isCheck = true;
    });

    await Future.delayed(Duration(milliseconds: startDur));

/*    var result = await Navigator.push(
            state.context,
            NavigatePageRoute(
                state.context, RepostReviewPage(type:repostModel[index].title)));*/
    if (await canLaunch(repostModel[index].link)) {
      await Clipboard.setData(ClipboardData(text:""));
      await launch(repostModel[index].link);
      appState.rePostApplication = repostModel[index].status;

    } else {
      throw 'Could not launch ${repostModel[index].link}';
    }

    await Future.delayed(Duration(milliseconds: endDur));

    state.setState(() {
      repostModel[index].isCheck = false;
    });

  }

  onResume() async {
    clipboardData = await Clipboard.getData('text/plain');
    String copiedLink = clipboardData.text.toString();
    int i =  repostModel.indexWhere((element) => element.status==appState.rePostApplication);
    appState.rePostApplication = RePostApplication.None;
    await Clipboard.setData(ClipboardData(text:""));
    if (copiedLink!=null&&copiedLink!="") {
      if (await canLaunch(copiedLink)) {
        var result = await Navigator.push(
            state.context,
            NavigatePageRoute(
                state.context, RepostReviewPage(
                type: repostModel[i].title, link: copiedLink)));
      } else {
        commonToast("Please copied link does not launchable.");
      }
    } else {
      commonToast("Please copy the link");
    }
//    appState.songsPostApp = SongsPostApp.None;
//    await Clipboard.setData(ClipboardData(text:""));
  }

}