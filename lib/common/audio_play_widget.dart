import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:testsylo/app.dart';
import 'package:testsylo/bloc_item/audio_timer_bloc.dart';

enum PlayerState { stopped, playing, paused }

class AudioPlayWidget extends StatefulWidget {
  final String url;
  final PlayerMode mode = PlayerMode.MEDIA_PLAYER;
  final bool isLocal;
  void Function(double) callback;
  void Function(AudioPlayer _audioPlayer) onPlay;
  void Function() onPause;
  final double icon_size;

  AudioPlayWidget({@required this.url, this.isLocal, this.callback, this.icon_size,this.onPlay, this.onPause});

  @override
  State<StatefulWidget> createState() {
    print(url);
    return _PlayerWidgetState(url, mode);
  }
}

class _PlayerWidgetState extends State<AudioPlayWidget> {
  String url;
  PlayerMode mode;

  AudioPlayer _audioPlayer;
  AudioPlayerState _audioPlayerState;
  Duration _duration;
  Duration _position;

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

  _PlayerWidgetState(this.url, this.mode);

  @override
  void initState() {
    super.initState();
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
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
                decoration: new BoxDecoration(
                    //color: Colors.amberAccent[100],
                    /*  border: Border.all(
                        width: 0.3,
                        color: Colors
                            .grey //                   <--- border width here
                        ),*/
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(4.0),
                        bottomLeft: const Radius.circular(4.0),
                        bottomRight: const Radius.circular(4.0),
                        topRight: const Radius.circular(4.0))),
                child: Column(
                  children: <Widget>[
                    widget.url!=null && widget.url!="" ? IconButton(
                        onPressed: () {
                          //_isPlaying ? null : () => _play()
                          if (_isPlaying) {
                            _pause();
                            /*if(widget.gifController!=null) {
                              widget.gifController.value = 0;*/
                              if(widget.onPause!=null) {
                                widget.onPause();
                              //}
                            }
                          } else {
                            _play();
                            /*if(widget.gifController!=null) {
                              widget.gifController.repeat(min:0,max:8,period:Duration(milliseconds: 1000));*/
                              if(widget.onPlay!=null) {
                                widget.onPlay(_audioPlayer);


                              }
                            //}
                          }
                        },
                        iconSize: widget.icon_size,
                        icon: Icon(_isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_filled),
                        color: Color(0x59707070)):SizedBox(),

                    /* Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _positionText,
                        style: TextStyle(fontSize: 14.0, color: Colors.white),
                      ),
                    ),*/
                  ],
                ),
              ),
              /* IconButton(
                  onPressed: _isPlaying ? () => _pause() : null,
                  iconSize: 24.0,
                  icon: Icon(Icons.pause),
                  color: AppTheme.colorPrimary_),*/
              /*IconButton(
                  onPressed: _isPlaying || _isPaused ? () => _stop() : null,
                  iconSize: 24.0,
                  icon: Icon(Icons.stop),
                  color: AppTheme.colorPrimary_),*/
              /*Slider(
                onChanged: (v) {
                  final Position = v * _duration.inMilliseconds;
                  _audioPlayer
                      .seek(Duration(milliseconds: Position.round()));
                },
                value: (_position != null &&
                    _duration != null &&
                    _position.inMilliseconds > 0 &&
                    _position.inMilliseconds < _duration.inMilliseconds)
                    ? _position.inMilliseconds / _duration.inMilliseconds
                    : 0.0,
              ),*/
            ],
          ),

          //Text("State: $_audioPlayerState")
        ],
      ),
    );
  }

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer(mode: mode);
    AudioPlayer.
    logEnabled = true;
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

                if(widget.callback!=null){
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

    return result;
  }

  Future<int> _pause() async {
    final result = await _audioPlayer.pause();
    if (result == 1) setState(() => _playerState = PlayerState.paused);
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
    if(widget.callback!=null){
      widget.callback.call(1.0);
    }
    /*if(widget.gifController!=null) {
      widget.gifController.value = 0;*/
      if(widget.onPause!=null) {
        widget.onPause();
      //}
    }
  }
}
