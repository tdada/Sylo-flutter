

import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testsylo/bloc_item/seek_bloc.dart';
import 'package:testsylo/common/play_video_auto.dart';
import 'package:video_player/video_player.dart';
import 'package:video_trimmer/video_trimmer.dart';
import '../app.dart';
import 'common_widget.dart';

class PlayViewSideVideoPage extends StatefulWidget {
  String url = "";
  bool isFile = false;
  bool isPause = false;
  List<String> queLink = List();
  List<int> strtTimingList = List();
  String thumbImageLink;
  CameraState cameraState;
  bool playIndicator = true;
  String title;

  PlayViewSideVideoPage(
      {Key key,
        this.url,
        this.isFile,
        this.isPause,
        this.queLink,
        this.playIndicator,
        this.strtTimingList,
        this.thumbImageLink,
        this.title,
        this.cameraState = CameraState.R})
      : super(key: key);

  @override
  _PlayVideoPageState createState() => _PlayVideoPageState();
}

class _PlayVideoPageState extends State<PlayViewSideVideoPage> with WidgetsBindingObserver {
  VideoPlayerController _controller;

  Duration _duration;
  Duration _position;
  bool isPauseAuto = false;
  bool isAutoPlayOnce = false;
  bool isInit = false;
  int queIndex =0;

  @override
  void initState() {

    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    WidgetsBinding.instance.addObserver(this);
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
    _controller.setLooping(false);
    _controller.addListener(() {
      if (_controller.value.isPlaying) {
        /*if(widget.callback!=null){
          //widget.callback(_controller.value.duration.inSeconds, _controller.value.position.inSeconds);
        }*/
        setState(() {
          _position = _controller.value.position;
          print(_position.inSeconds.toString());
          if (_position.inSeconds != _controller.value.duration.inSeconds &&
              _position.inSeconds > 1) {
            //delayAfterPause;
            isPauseAuto = false;
          }
          if (!isPauseAuto &&
              _position.inSeconds == _controller.value.duration.inSeconds) {
            _controller.pause();
            isPauseAuto = true;
          }
        });
      } else {
        print(
            "addListener ->" + _controller.value.position.inSeconds.toString());
      }
    });

    super.initState();
  }

  callRecDelay() async {
    print("callRecDelay1 ->");
    if (!isAutoPlayOnce) {
      if (isInit && !_controller.value.isPlaying) {
        isAutoPlayOnce = true;
        _controller.play();
      } else {
        //callRecDelay();
      }
    }
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    WidgetsBinding.instance.addObserver(this);
    _controller.dispose();
    super.dispose();
  }

  get _positionText => _position?.toString()?.split('.')?.first ?? '';

  get _durationText => _duration?.toString()?.split('.')?.first ?? '';

  @override
  Widget build(BuildContext context) {
    if (_controller != null && isInit) {
      _duration = _controller.value.duration;
    }
    if ((widget?.isPause ?? false) && _controller != null && isInit) {
      if (_controller.value.isPlaying) {
        _controller.pause();
      }
    }

    MediaQueryData queryData = MediaQuery.of(context);
    double w = queryData.size.width - 48;
    return Material(
            color: Colors.black54,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 4.0,
                  sigmaY: 4.0,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    /*GestureDetector(
                      child: Container(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Center(
                          child: !isInit ? CircularProgressIndicator() : Container(
                            width: w,
                            height: widget.cameraState == CameraState.R ? w  : null,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  widget.cameraState == CameraState.R ? w  : 0),
                              child: AspectRatio(
                                aspectRatio: _controller.value.size.aspectRatio,
                                child: FittedBox(fit:BoxFit.fitWidth,child: Container(width:w,height: w,child: VideoPlayer(_controller))),
                              ),
                            ),
                          ),
                          // this is my CameraPreview
                        ),
                      ),
                      onTap: () {},
                    ),*/
                    Container(
                      width: w,
                      height:(widget.cameraState == CameraState.R
                          ? w
                          : w *
                          (1 +
                              _controller.value
                                  .aspectRatio)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            widget.cameraState == CameraState.R ? w : 0),
                        child: OverflowBox(
                          alignment: Alignment.center,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Container(
                              width: w,
                              height: w /
                                  _controller.value.aspectRatio
                                ,child:
                              VideoPlayer(_controller), // this is my CameraPreview
                            ),
                          ),
                        ),
                      ),
                    ),
                    /*Center(
                      child: Positioned(
                          child: Container(
                            margin: EdgeInsets.only(top: 24),
                            child: ClipOval(
                              child: Container(
                                padding: EdgeInsets.all(12),
                                *//*decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xff9F00C5),
                                        Color(0xff9405BD),
                                        Color(0xff7913A7),
                                        Color(0xff651E96),
                                        Color(0xff522887),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    )),*//*
                                child: InkWell(
                                  onTap: () {
                                    *//*if (!isInit) {
                                      return;
                                    }*//*
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
                                  child: Icon(
                                    !_controller.value.isPlaying
                                        ? Icons.play_arrow
                                        : Icons.pause,
                                    size: 40,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          )),
                    ),*/
                    widget.cameraState == CameraState.S ?
                    widget.playIndicator == true
                        ? Container()
                        : Container():widget.playIndicator == true
                        ? GestureDetector(
                      onTap: () {},
                      child: commonDurationIndicator(functionGetProgress(),
                          MediaQuery.of(context).size.width - 40, 2.5),
                    )
                        : Container(),


                    widget.title != null ? Container(
                      margin: EdgeInsets.only(top: 10,right: 10),
                      alignment: Alignment.topCenter,
                      child: Text(
                        widget.title.toString(),
                        style: getTextStyle(
                            color: Colors.white,
                            size: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ):SizedBox(),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 24),
                        child: ClipOval(
                          child: Container(
                            padding: EdgeInsets.all(12),
                            /*decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xff9F00C5),
                                    Color(0xff9405BD),
                                    Color(0xff7913A7),
                                    Color(0xff651E96),
                                    Color(0xff522887),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                )),*/
                            child: InkWell(
                              onTap: () {
                                if (!isInit) {
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
                              child: Icon(
                                !_controller.value.isPlaying
                                    ? Icons.play_arrow
                                    : Icons.pause,
                                size: 60,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10,right: 10),
                      alignment: Alignment.topRight,
                      child: InkWell(
                          child: Icon(
                            Icons.clear,
                            size: 28,
                            color: Colors.white,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            setState(() {
                              if (_controller.value.isPlaying) {
                                _controller.pause();
                              } else {
                                _controller.play();
                              }
                            });
                          }
                      ),
                    ),
                    (widget.queLink == null || widget.queLink.length==0)
                        ? Container()
                        : Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: <Widget>[
                          Container(
                            width: 112,
                            height: 112,
                            margin: EdgeInsets.only(right: 32),
                            child: _controller.value.isPlaying ? FutureBuilder(
                                future: getQuestionThumbIfQueListNotNull(),
                                builder: (context, snapshot) {
                                  return snapshot.data==null ?  Container(
                                      child: ClipOval(
                                        child: Container(
                                            color: colorOvalBorder,
                                            width: 90,
                                            height: 90,
                                            child: Container(
                                                padding: EdgeInsets.all(40),
                                                child: CircularProgressIndicator())
                                        ),
                                      )
                                  ): ClipOval(
                                    child: Container(
                                        color: colorOvalBorder,
                                        width: 90,
                                        height: 90,
                                        child:
                                        PlayVideoAutoPage(
                                          isFile: false,
                                          url: widget.queLink[queIndex],
                                        )
                                    ),
                                  );
                                }
                            ) : ClipOval(
                                child: ImageFromNetworkView(
                                  path: widget.thumbImageLink??"",
                                  boxFit: BoxFit.cover,
                                )),
                          ),
                        ],
                      ),
                    ),

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
              ),
            ),

    );
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

  double functionGetProgress() {
    if (_controller.value.duration != null &&
        _controller.value.duration.inSeconds > 0) {
      double progressMod = _controller.value.position.inSeconds /
          _controller.value.duration.inSeconds;
      return progressMod;
    } else {
      return 0.0;
    }
  }

  int totalDur = 0, currDur = 0;

  Future<Function> functionGetProgressQue(t, p) async {
    //print("total Second -> " + t.toString());
    //print("current Second -> " + p.toString());
    currDur = p;
    totalDur = t;
    if (totalDur > 0) {
      double progressMod = currDur / totalDur;
      seekBloc.addProgress(progressMod);
    } else {
      seekBloc.addProgress(0.0);
    }

    return null;
  }

  SeekBloc seekBloc = SeekBloc();

  getQuestionThumbIfQueListNotNull()  async {
    if (widget.queLink != null && widget.queLink.length==widget.strtTimingList.length) {
      Duration duration = _controller.value.position;
      if(duration.inSeconds==0){
        return 0;
      }
      if(widget.strtTimingList.contains(duration.inSeconds)){
        setState(() {
          queIndex = widget.strtTimingList.indexOf(duration.inSeconds);
        });
        return null;
      }
      return queIndex;
    }
    else{
      return null;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //do your stuff
      if(_controller!=null) {
        if(_controller.value.isPlaying) {
          _controller.play();
        }
      }

    }
    else if(state == AppLifecycleState.paused)
    {
      if(_controller!=null) {
        _controller.pause();
      }
    }
    else if(state == AppLifecycleState.inactive)
    {

    }
    else if(state == AppLifecycleState.detached)
    {

    }
  }
}
