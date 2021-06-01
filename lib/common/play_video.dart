import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'common_widget.dart';

class PlayVideoPage extends StatefulWidget {
  String url = "";
  bool isFile = false;
  bool isPause = false;
  void Function(int, int) callback;
  PlayVideoPage({Key key, this.url, this.isFile, this.isPause, this.callback}) : super(key: key);

  @override
  _PlayVideoPageState createState() => _PlayVideoPageState();
}

class _PlayVideoPageState extends State<PlayVideoPage> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  Duration _duration;
  Duration _position;
  bool isPauseAuto = false;

  @override
  void initState() {
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
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
          _position = _controller.value.position;
          print(_position.inSeconds.toString());
          if(_position.inSeconds!=_controller.value.duration.inSeconds){
            //delayAfterPause;
            isPauseAuto = false;
          }
          if(!isPauseAuto && _position.inSeconds==_controller.value.duration.inSeconds){
            if (_controller.value.isPlaying) {
              _controller.pause();
              isPauseAuto = true;
            }
          }
        });
      }
    });

    super.initState();
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
    if (_controller != null && _controller.value.isInitialized) {
      _duration = _controller.value.duration;
    }
    if((widget?.isPause??false) && _controller != null && _controller.value.isInitialized){
      if (_controller.value.isPlaying) {
        _controller.pause();
      }
    }
    MediaQueryData queryData = MediaQuery.of(context);
    double w = queryData.size.width - 48;

    return Material(
        color: Colors.transparent,
        child: Container(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                child: _controller.value.isInitialized
                    ? /*AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )*/Container(
                  width: w,
                  height: w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: OverflowBox(
                      alignment: Alignment.center,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child:  Container(
                          width: w,
                          height:
                          w,
                          child: VideoPlayer(
                              _controller), // this is my CameraPreview
                        ),
                      ),
                    ),
                  ),
                )
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
              /* Padding(
                    padding: const EdgeInsets.only(right: 16, bottom: 16),
                    child: FloatingActionButton(
                      onPressed: () {
                        // Wrap the play or pause in a call to `setState`. This ensures the
                        // correct icon is shown.
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
                      // Display the correct icon depending on the state of the player.
                      child: Icon(
                        _controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                      ),
                    ),
                  ),
                  widget.isFile
                      ? Container()
                      : Positioned(
                          top: 16,
                          right: 16,
                          child: Container(
                            padding: EdgeInsets.only(right: 4),
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: Icon(
                                Icons.close,
                                size: 24,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),*/
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
