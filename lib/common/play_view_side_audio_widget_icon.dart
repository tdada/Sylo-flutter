import 'dart:async';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:testsylo/app.dart';
import 'package:testsylo/bloc_item/audio_timer_bloc.dart';
import 'package:testsylo/common/waves.dart';
import 'package:testsylo/model/model.dart';

import 'common_widget.dart';

enum PlayerState { stopped, playing, paused }

class PlayViewSideAudioWidgetIcon extends StatefulWidget {
  final String url;
  final PlayerMode mode = PlayerMode.MEDIA_PLAYER;
  final bool isLocal;
  void Function(double) callback;
  void Function() playCall;
  final double icon_size;
  //GifController gifController;
  List<PostPhotoModel> voiceTagLink = List();


  PlayViewSideAudioWidgetIcon(
      {@required this.url,
      this.isLocal,
      this.callback,
      this.icon_size,
      this.playCall,
      this.voiceTagLink});

  @override
  State<StatefulWidget> createState() {
    print(url);
    return _PlayerWidgetStateIcon(url, mode);
  }
}

class _PlayerWidgetStateIcon extends State<PlayViewSideAudioWidgetIcon> with SingleTickerProviderStateMixin {
  String url;
  PlayerMode mode;

  AudioPlayer _audioPlayer;
  AudioPlayerState _audioPlayerState;
  Duration _duration;
  Duration _position;
  //GifController gifController;
  PlayerState _playerState = PlayerState.stopped;
  StreamSubscription _durationSubscription;
  StreamSubscription _positionSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;
  StreamSubscription _playerStateSubscription;

  get _isPlaying => _playerState == PlayerState.playing;

  get _isPaused => _playerState == PlayerState.paused;

  get _durationText => _duration?.toString()?.split('.')?.first ?? '';

  get _positionText => _position?.toString()?.split('.')?.first ?? '0:00:00';

  _PlayerWidgetStateIcon(this.url, this.mode);

  @override
  void initState() {
    super.initState();
   //gifController = GifController(vsync: this);
    _initAudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.playCall != null
            ? null
            : () {
                Navigator.pop(context);
              },
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: widget.playCall != null ? 0.0 : 4.0,
            sigmaY: widget.playCall != null ? 0.0 : 4.0,
          ),
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: (widget.voiceTagLink != null &&
                          widget.voiceTagLink.length > 0)
                      ? Container(
                          child: Container(

                          height: MediaQuery.of(context).size.height - 16,
                          width: MediaQuery.of(context).size.width - 16,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(
                              top: widget.voiceTagLink.length == 1 ? 0 : 10),
                          child: GridView.builder(
                            physics: widget.voiceTagLink.length == 1
                                ? NeverScrollableScrollPhysics()
                                : ScrollPhysics(),
                            itemCount: widget.voiceTagLink.length,
                            gridDelegate:
                                new SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        widget.voiceTagLink.length == 1 ? 1 : 2,
                                    childAspectRatio: 1.0),
                            shrinkWrap: true,
                            itemBuilder: (c, i) {
                              return Container(
                                margin: EdgeInsets.all(10),
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.all(15),
                                        child: widget.voiceTagLink[i].isCircle
                                            ? ClipOval(
                                                child: Container(
                                                  child: ClipOval(
                                                    child: Container(
                                                      child:
                                                          ImageFromNetworkView(
                                                        path: widget
                                                                .voiceTagLink[i]
                                                                .link ??
                                                            "",
                                                        boxFit: BoxFit.cover,
                                                      ),
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.all(3),
                                                  color: colorSectionHead,
                                                ),
                                              )
                                            : Container(
                                                padding: EdgeInsets.only(
                                                    left: 4, right: 4),
                                                child: Container(
                                                  color: colorSectionHead,
                                                  padding: EdgeInsets.all(2),
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    child: ImageFromNetworkView(
                                                      path: widget
                                                              .voiceTagLink[i]
                                                              .link ??
                                                          "",
                                                      boxFit: BoxFit.cover,
                                                    ),
                                                  ),
                                                )),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ))
                      : Container(

                          child: Stack(
                          children: [
                            Stack(
                              alignment: Alignment.topCenter,
                              children: <Widget>[
                                /*Positioned(
                                  right: 0,
                                  top: 0,

                                  child: FloatingActionButton(
                                    child: Icon(
                                      Icons.close,
                                      size: 24,
                                    ),
                                    heroTag: "home",
                                    mini: true,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),*/
                                !_isPlaying ? Container() : new WavesView(),
                                /*Container(
                                  height: MediaQuery.of(context).size.height/2,
                                  width: MediaQuery.of(context).size.width,
                                  child:
                                  Image.asset(
                                    App.ic_big_wave,
                                    height: double.infinity,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),*/

                                Center(
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Image.asset(
                                      App.ic_mic_record,
                                      width: 75,
                                      height: 75,
                                    ),
                                  ),
                                ),

                              ],
                            ),

                          ],
                        ),
                      ),
                ),

                widget.url != ""
                    ? Container(
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Container(
                              child: ClipOval(
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
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
                                  )),
                                  child: InkWell(
                                    onTap: () {
                                      if (widget.playCall != null) {
                                        widget.playCall.call();
                                      } else {
                                        if (_isPlaying) {
                                          _pause();

                                        } else {
                                          _play();
                                        }
                                      }
                                    },
                                    child: Icon(
                                      !_isPlaying
                                          ? Icons.play_arrow
                                          : Icons.pause,
                                      size: 28,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer(mode: mode);

    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);

      // TODO implemented for iOS, waiting for android impl
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        // (Optional) listen for notification updates in the background
        _audioPlayer.startHeadlessService();

        // set at least title to see the notification bar on ios.
        _audioPlayer.setNotification(
            title: 'App Name',
            artist: 'Artist or blank',
            albumTitle: 'Name or blank',
            imageUrl: 'url or blank',
            forwardSkipInterval: const Duration(seconds: 30),
            // default is 30s
            backwardSkipInterval: const Duration(seconds: 30),
            // default is 30s
            duration: duration,
            elapsedTime: Duration(seconds: 0));
      }
    });

    _positionSubscription =
        _audioPlayer.onAudioPositionChanged.listen((p) => setState(() {
              _position = p;
              if (_position != null &&
                  _duration != null &&
                  _position.inMilliseconds > 0) {
                double v = 0;
                if (_position.inMilliseconds < _duration.inMilliseconds) {
                  v = _position.inMilliseconds / _duration.inMilliseconds;
                }

                if (widget.callback != null) {
                  widget.callback.call(v);
                }
              }
            }));

    _playerCompleteSubscription =
        _audioPlayer.onPlayerCompletion.listen((event) {
      _onComplete();
      setState(() {
        _position = _duration;
      });
    });

    _playerErrorSubscription = _audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      setState(() {
        _playerState = PlayerState.stopped;
        _duration = Duration(seconds: 0);
        _position = Duration(seconds: 0);
      });
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _audioPlayerState = state;
      });
    });

    _audioPlayer.onNotificationPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() => _audioPlayerState = state);
    });

    if (widget.playCall == null) {
      Future.delayed(const Duration(milliseconds: 150), () {
        _play();
      });
    }
  }

  Future<int> _play() async {
    final playPosition = (_position != null &&
            _duration != null &&
            _position.inMilliseconds > 0 &&
            _position.inMilliseconds < _duration.inMilliseconds)
        ? _position
        : null;
    final result = await _audioPlayer.play(url,
        position: playPosition, isLocal: widget.isLocal);
    if (result == 1) setState(() => _playerState = PlayerState.playing);

    // default playback rate is 1.0
    // this should be called after _audioPlayer.play() or _audioPlayer.resume()
    // this can also be called everytime the user wants to change playback rate in the UI
    _audioPlayer.setPlaybackRate(playbackRate: 1.0);
    //gifController.repeat(min:0,max:200,period:Duration(milliseconds: 10000));

    return result;
  }

  Future<int> _pause() async {
    final result = await _audioPlayer.pause();
    if (result == 1) setState(() => _playerState = PlayerState.paused);
    //gifController.value = 0;
    return result;
  }

  Future<int> _stop() async {
    final result = await _audioPlayer.stop();
    if (result == 1) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration();
      });
    }
    return result;
  }

  void _onComplete() {
    setState(() => _playerState = PlayerState.stopped);
    if (widget.callback != null) {
      widget.callback.call(1.0);
    }
  }
}
