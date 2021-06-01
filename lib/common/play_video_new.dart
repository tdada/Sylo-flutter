import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../main.dart';
import 'common_widget.dart';

class PlayVideoNew extends StatefulWidget {
  String url = "";
  bool isFile = false;
  bool isPause = false;
  void Function(int, int) callback;
  PlayVideoNew({Key key, this.url, this.isFile, this.isPause, this.callback}) : super(key: key);

  @override
  _PlayVideoPageState createState() => _PlayVideoPageState();
}

class _PlayVideoPageState extends State<PlayVideoNew> with RouteAware {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  @override
  void initState() {
    if (widget.isFile) {
      _controller = VideoPlayerController.file(
        File(widget.url),
      );
    } else {
       _controller = VideoPlayerController.network(
        widget.url,
      );
    }
    _initializeVideoPlayerFuture = _controller.initialize().then((on) {
      Future.delayed(Duration(milliseconds: 100)).then((onValue) {
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
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    routeObserver.unsubscribe(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context));//Subscribe it here
    super.didChangeDependencies();
  }

  @override
  void didPushNext() {
    print("didPushNext");
    if (_controller.value.isPlaying) {
      _controller.pause();
      setState(() {
      });
    }
    super.didPushNext();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller != null && _controller.value.isInitialized) {
    }
    if((widget?.isPause??false) && _controller != null && _controller.value.isInitialized){
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
              AspectRatio(
                aspectRatio: 1,
                child: _controller.value.isInitialized
                    ? Container(
                  child: AspectRatio(aspectRatio:_controller.value.aspectRatio,child: VideoPlayer(_controller)),
                )
                    : Container(
                  child: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(_controller.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow, size: 42, ),
                padding: EdgeInsets.all(0),
                onPressed: (){

                  if(!_controller.value.isInitialized){
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

}
