import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/util/navigate_effect.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app.dart';
import 'song_post_page.dart';
import 'song_post_review_page/song_post_review_page.dart';

class SongPostPageViewModel {
  SongPostPageState state;
  List<SongModel> songModel = List<SongModel>();
  ClipboardData clipboardData;
  SongPostPageViewModel(this.state);

  initSongModel(){
    songModel.add(SongModel(icon: App.ic_soptify, title: "Spotify", isCheck: false, nextPage: null, link: "https://www.spotify.com/", status: SongsApplication.S));
    songModel.add(SongModel(icon: App.ic_utube_music, title: "YouTube Music", isCheck: false, nextPage: null, link: "https://music.youtube.com/", status: SongsApplication.Y));
    songModel.add(SongModel(icon: App.ic_itunes, title: "iTunes", isCheck: false, nextPage: null, link: "https://www.apple.com/itunes/", status: SongsApplication.I));
    songModel.add(SongModel(icon: App.ic_soundcloud, title: "Soundcloud", isCheck: false, nextPage: null, link:"https://soundcloud.com/", status: SongsApplication.SC));
  }

  onClickItem(int index) async {
    /*var result = await Navigator.push(
        state.context,
        NavigatePageRoute(
            state.context, SongPostReviewPage(type:songModel[index].title)));*/
    if (await canLaunch(songModel[index].link)) {
      await Clipboard.setData(ClipboardData(text:""));
      await Clipboard.setData(ClipboardData(text:""));
      await launch(songModel[index].link);
      appState.songsApplication = songModel[index].status;
    } else {
      throw 'Could not launch ${songModel[index].link}';
    }
  }

  onResume() async {
    clipboardData = await Clipboard.getData('text/plain');
    String copiedLink = clipboardData.text;
    int i =  songModel.indexWhere((element) => element.status==appState.songsApplication);
    appState.songsApplication = SongsApplication.None;
    await Clipboard.setData(ClipboardData(text:""));
    if (copiedLink!=null&&copiedLink!="") {
      if (await canLaunch(copiedLink)) {
        var result = await Navigator.push(
            state.context,
            NavigatePageRoute(
                state.context, SongPostReviewPage(
                type: songModel[i].title, link: copiedLink)));
      } else {
        commonToast("Please copied link does not launchable.");
      }
    } else {
      commonToast("Please copy the link");
    }

  }

}