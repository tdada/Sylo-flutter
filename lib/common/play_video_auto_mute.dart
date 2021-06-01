import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'common_widget.dart';

class PlayVideoAutoMutePage extends StatefulWidget {
  String url = "";
  bool isFile = false;
  bool isPause = false;
  void Function(int, int) callback;
  PlayVideoAutoMutePage({Key key, this.url, this.isFile, this.isPause, this.callback}) : super(key: key);

  @override
  _PlayVideoPageMuteState createState() => _PlayVideoPageMuteState();
}

class _PlayVideoPageMuteState extends State<PlayVideoAutoMutePage> {
  VideoPlayerController _controller;
   Duration _duration;
  Duration _position;
  bool isPauseAuto = false;
  bool isAutoPlayOnce = false;
  bool isInit = false;


  @override
  void initState() {
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    //dataManager = DataManager(flickManager: flickManager, urls: widget.url);
    if (widget.isFile) {
      _controller = VideoPlayerController.file(
        File(widget.url),
      );

    } else {
       _controller = VideoPlayerController.network(
        widget.url,
      );
    }

    _controller.initialize().then((on) {
      Future.delayed(Duration(milliseconds: 100)).then((onValue) {

        isInit = true;
        callRecDelay();
        setState(() {});

      });
    });
    _controller.setLooping(true);
    _controller.addListener(() {

      if (_controller.value.isPlaying) {
        if(widget.callback!=null){
          widget.callback(_controller.value.duration.inSeconds, _controller.value.position.inSeconds);
        }
        setState(() {
          _position = _controller.value.position;
          print(_position.inSeconds.toString());
          if(_position.inSeconds!=_controller.value.duration.inSeconds && _position.inSeconds > 1){
            //delayAfterPause;
            isPauseAuto = false;
          }
          if(!isPauseAuto && _position.inSeconds==_controller.value.duration.inSeconds){
            _controller.pause();
            isPauseAuto = true;
          }
        });

      }
      else{
        print("addListener ->" + _controller.value.position.inSeconds.toString());
      }
    });


    super.initState();
  }

  callRecDelay() async {
    print("callRecDelay ->");
    if(!isAutoPlayOnce){
      if(isInit && !_controller.value.isPlaying){
        isAutoPlayOnce = true;
        _controller.play();
      }
      else{
        //callRecDelay();
      }
    }


  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();
    super.dispose();
  }

  get _positionText => _position?.toString()?.split('.')?.first ?? '';

  get _durationText => _duration?.toString()?.split('.')?.first ?? '';

  @override
  Widget build(BuildContext context) {
    print("widget.queLink[queIndex]12"+widget.url);
    if (_controller != null && isInit) {
      _duration = _controller.value.duration;
    }
    if((widget?.isPause??false) && _controller != null && isInit){
      if (_controller.value.isPlaying) {
        _controller.pause();
      }
    }

    return Material(
        color: Colors.transparent,
        child: Container(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                child: isInit
                    ? AspectRatio(aspectRatio:_controller.value.aspectRatio,child: VideoPlayer(_controller))
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
              IconButton(
                icon: Icon(_controller.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow, size: 42, ),
                padding: EdgeInsets.all(0),
                onPressed: (){

                  if(!isInit){
                    return;
                  }
                  setState(() {
                    // If the video is playing, pause it.
                    if (_controller.value.isPlaying) {
                      _controller.pause();

                    } else {
                      // If the video is paused, play it.
                      _controller.play();

                    }
                  });

                },
              )

            ],
          ),
        ));
  }

  Widget get videoView {
    return GestureDetector(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  color: Colors.black38,
                  width: double.infinity,
                  height: (MediaQuery.of(context).size.height / 1.4),
                  margin: EdgeInsets.only(top: 50),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: FloatingActionButton(
                    child: Icon(
                      Icons.close,
                      size: 15,
                    ),
                    heroTag: "home",
                    mini: true,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.only(left: 10, bottom: 10),
                    child: Text(
                      " " + getFileNameFromPath(widget.url),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  )),
                ],
              ),
              width: double.infinity,
              color: Colors.white,
            )
          ],
        ),
        color: Colors.black38,
      ),
      onTap: () {},
    );
  }
}
