import 'dart:math';

import 'package:flutter/material.dart';
import 'package:testsylo/app.dart';
import 'package:testsylo/common/audio_wave.dart';
//import 'package:video_trimmer/trim_editor_painter.dart';
import 'package:video_trimmer/video_trimmer.dart';
class TrimEditor extends StatefulWidget {
  final double viewerWidth;
  final double viewerHeight;
  final double circleSize;
  final double circleSizeOnDrag;
  final Color circlePaintColor;
  final Color borderPaintColor;
  final Color scrubberPaintColor;
  final int thumbnailQuality;
  final bool showDuration;
  final TextStyle durationTextStyle;
  final Function(double startValue) onChangeStart;
  final Function(double endValue) onChangeEnd;
  final Function(bool isPlaying) onChangePlaybackState;
  final int videoDuration;

  /// Widget for displaying the video trimmer.
  ///
  /// This has frame wise preview of the video with a
  /// slider for selecting the part of the video to be
  /// trimmed.
  ///
  /// The required parameters are [viewerWidth] & [viewerHeight]
  ///
  /// * [viewerWidth] to define the total trimmer area width.
  ///
  ///
  /// * [viewerHeight] to define the total trimmer area height.
  ///
  ///
  /// The optional parameters are:
  ///
  /// * [circleSize] for specifying a size to the holder at the
  /// two ends of the video trimmer area, while it is `idle`.
  /// By default it is set to `5.0`.
  ///
  ///
  /// * [circleSizeOnDrag] for specifying a size to the holder at
  /// the two ends of the video trimmer area, while it is being
  /// `dragged`. By default it is set to `8.0`.
  ///
  ///
  /// * [circlePaintColor] for specifying a color to the circle.
  /// By default it is set to `Colors.white`.
  ///
  ///
  /// * [borderPaintColor] for specifying a color to the border of
  /// the trim area. By default it is set to `Colors.white`.
  ///
  ///
  /// * [scrubberPaintColor] for specifying a color to the video
  /// scrubber inside the trim area. By default it is set to
  /// `Colors.white`.
  ///
  ///
  /// * [thumbnailQuality] for specifying the quality of each
  /// generated image thumbnail, to be displayed in the trimmer
  /// area.
  ///
  ///
  /// * [showDuration] for showing the start and the end point of the
  /// video on top of the trimmer area. By default it is set to `true`.
  ///
  ///
  /// * [durationTextStyle] is for providing a `TextStyle` to the
  /// duration text. By default it is set to
  /// `TextStyle(color: Colors.white)`
  ///
  ///
  /// * [onChangeStart] is a callback to the video start position.
  ///
  ///
  /// * [onChangeEnd] is a callback to the video end position.
  ///
  ///
  /// * [onChangePlaybackState] is a callback to the video playback
  /// state to know whether it is currently playing or paused.
  ///
  TrimEditor({
    @required this.viewerWidth,
    @required this.viewerHeight,
    this.circleSize = 5.0,
    this.circleSizeOnDrag = 8.0,
    this.circlePaintColor = Colors.white,
    this.borderPaintColor = Colors.white,
    this.scrubberPaintColor = Colors.white,
    this.thumbnailQuality = 75,
    this.showDuration = true,
    this.durationTextStyle = const TextStyle(
      color: Colors.white,
    ),
    this.onChangeStart,
    this.onChangeEnd,
    this.onChangePlaybackState,
    this.videoDuration
  })
      : assert(viewerWidth != null),
        assert(viewerHeight != null),
        assert(circleSize != null),
        assert(circleSizeOnDrag != null),
        assert(circlePaintColor != null),
        assert(borderPaintColor != null),
        assert(scrubberPaintColor != null),
        assert(thumbnailQuality != null),
        assert(showDuration != null),
        assert(durationTextStyle != null);

  @override
  _TrimEditorState createState() => _TrimEditorState();
}

  class _TrimEditorState extends State<TrimEditor> with TickerProviderStateMixin {
    double _videoStartPos = 0.0;
    double _videoEndPos = 0.0;
    bool _canUpdateStart = true;
    bool _isLeftDrag = true;
    Offset _startPos = Offset(0, 0);
    Offset _endPos = Offset(0, 0);
    double _startFraction = 0.0;
    double _endFraction = 1.0;
    int _videoDuration = 0;
    int _currentPosition = 0;
    double _thumbnailViewerW = 0.0;
    double _thumbnailViewerH = 0.0;
    int _numberOfThumbnails = 0;
    double _circleSize;

    //ThumbnailViewer thumbnailWidget;
    Animation<double> _scrubberAnimation;
    AnimationController _animationController;
    Tween<double> _linearTween;
    List<AudioWaveBar> audioWaveBar=List();

    Future<void> _initializeVideoController() async {
      /* videoPlayerController.addListener(() {
      final bool isPlaying = videoPlayerController.value.isPlaying;
      if (isPlaying) {
        widget.onChangePlaybackState(true);
        setState(() {
          _currentPosition =
              videoPlayerController.value.position.inMilliseconds;
          print("CURRENT POS: $_currentPosition");
          if (_currentPosition > _videoEndPos.toInt()) {
            widget.onChangePlaybackState(false);
            videoPlayerController.pause();
            _animationController.stop();
          } else {
            if (!_animationController.isAnimating) {
              widget.onChangePlaybackState(true);
              _animationController.forward();
            }
          }
        });
      } else {
        if (videoPlayerController.value.initialized) {
          if (_animationController != null) {
            print(
                'ANI VALUE: ${(_scrubberAnimation.value).toInt()} && END: ${(_endPos.dx).toInt()}');
            if ((_scrubberAnimation.value).toInt() == (_endPos.dx).toInt()) {
              _animationController.reset();
            }
            _animationController.stop();
            widget.onChangePlaybackState(false);
          }
        }
      }
    });*/
      //_videoDuration = videoPlayerController.value.duration.inMilliseconds;
      //print(_videoFile.path);
      _videoEndPos = _videoDuration.toDouble();
      widget.onChangeEnd(_videoEndPos);
    }

    void _setVideoStartPosition(DragUpdateDetails details) async {
      if (!(_startPos.dx + details.delta.dx < 0) &&
          !(_startPos.dx + details.delta.dx > _thumbnailViewerW) &&
          !(_startPos.dx + details.delta.dx > _endPos.dx)) {
        setState(() {
          _startPos += details.delta;
          _startFraction = (_startPos.dx / _thumbnailViewerW);
          _videoStartPos = _videoDuration * _startFraction;
          widget.onChangeStart(_videoStartPos);
        });
        _linearTween.begin = _startPos.dx;
        _animationController.duration =
            Duration(milliseconds: (_videoEndPos - _videoStartPos).toInt());
        _animationController.reset();
      }
    }

    void _setVideoEndPosition(DragUpdateDetails details) async {
      if (!(_endPos.dx + details.delta.dx > _thumbnailViewerW) &&
          !(_endPos.dx + details.delta.dx < 0) &&
          !(_endPos.dx + details.delta.dx < _startPos.dx)) {
        setState(() {
          _endPos += details.delta;
          _endFraction = _endPos.dx / _thumbnailViewerW;
          _videoEndPos = _videoDuration * _endFraction;
          widget.onChangeEnd(_videoEndPos);
        });
        _linearTween.end = _endPos.dx;
        _animationController.duration =
            Duration(milliseconds: (_videoEndPos - _videoStartPos).toInt());
        _animationController.reset();
      }
    }

    @override
    void initState() {
      super.initState();
      _circleSize = widget.circleSize;
      _videoDuration = widget.videoDuration;
      _thumbnailViewerH = widget.viewerHeight;
      _numberOfThumbnails = widget.viewerWidth ~/ _thumbnailViewerH;
      _thumbnailViewerW = _numberOfThumbnails * _thumbnailViewerH;
      _endPos = Offset(_thumbnailViewerW, _thumbnailViewerH);
      _initializeVideoController();
      // Defining the tween points
      _linearTween = Tween(begin: _startPos.dx, end: _endPos.dx);
      _animationController = AnimationController(
        vsync: this,
        duration: Duration(
            milliseconds: (_videoEndPos - _videoStartPos).toInt()),
      );
      _scrubberAnimation = _linearTween.animate(_animationController)
        ..addListener(() {
          setState(() {});
        })
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _animationController.stop();
          }
        });
        var bar= _videoDuration/100.floor()+1;
        Random random = new Random();
        int min = 30, max = 80;
        for(int i=0;i<75;i++)
          {
              int randomNumber = random.nextInt(90)+10;

              audioWaveBar.add(AudioWaveBar(height: randomNumber.toDouble(),color: colorOvalBorder2));
          }

    }

    @override
    void dispose() {
      widget.onChangePlaybackState(false);
      widget.onChangePlaybackState(false);
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return GestureDetector(
        onHorizontalDragStart: (DragStartDetails details) {
          if (_endPos.dx >= _startPos.dx) {
            if ((_startPos.dx - details.localPosition.dx).abs() >
                (_endPos.dx - details.localPosition.dx).abs()) {
              setState(() {
                _canUpdateStart = false;
              });
            } else {
              setState(() {
                _canUpdateStart = true;
              });
            }
          } else {
            if (_startPos.dx > details.localPosition.dx) {
              _isLeftDrag = true;
            } else {
              _isLeftDrag = false;
            }
          }
        },
        onHorizontalDragEnd: (DragEndDetails details) {
          setState(() {
            _circleSize = widget.circleSize;
          });
        },
        onHorizontalDragUpdate: (DragUpdateDetails details) {
          _circleSize = widget.circleSizeOnDrag;
          if (_endPos.dx >= _startPos.dx) {
            _isLeftDrag = false;
            if (_canUpdateStart && _startPos.dx + details.delta.dx > 0) {
              _isLeftDrag = false; // To prevent from scrolling over
              _setVideoStartPosition(details);
            } else if (!_canUpdateStart &&
                _endPos.dx + details.delta.dx < _thumbnailViewerW) {
              _isLeftDrag = true; // To prevent from scrolling over
              _setVideoEndPosition(details);
            }
          } else {
            if (_isLeftDrag && _startPos.dx + details.delta.dx > 0) {
              _setVideoStartPosition(details);
            } else if (!_isLeftDrag &&
                _endPos.dx + details.delta.dx < _thumbnailViewerW) {
              _setVideoEndPosition(details);
            }
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            widget.showDuration
                ? Container(
              width: _thumbnailViewerW,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                        Duration(milliseconds: _videoStartPos.toInt())
                            .toString()
                            .split('.')[0],
                        style: widget.durationTextStyle),
                    Text(
                      Duration(milliseconds: _videoEndPos.toInt())
                          .toString()
                          .split('.')[0],
                      style: widget.durationTextStyle,
                    ),
                  ],
                ),
              ),
            )
                : Container(),
            CustomPaint(
              foregroundPainter: TrimEditorPainter(
                startPos: _startPos,
                endPos: _endPos,
                scrubberAnimationDx: _scrubberAnimation.value,
                circleSize: _circleSize,
                circlePaintColor: widget.circlePaintColor,
                borderPaintColor: widget.borderPaintColor,
                scrubberPaintColor: widget.scrubberPaintColor,
              ),
              child: Container(
                color: Colors.white,
                height: _thumbnailViewerH,
                width: _thumbnailViewerW,
                child: AudioWave(
                  height: 42,
                  width: MediaQuery.of(context).size.width-20,
                  spacing: 7,
                  animation: false,
                  animationLoop: 0,
                  beatRate: Duration(milliseconds: 50),
                  bars: audioWaveBar
                ),
              ),
            ),
          ],
        ),
      );
    }
  }