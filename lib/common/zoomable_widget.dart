import 'package:flutter/material.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:zoom_widget/zoom_widget.dart';

class ZoomableWidget extends StatefulWidget {
  final Widget child;
  final bool isScale;
  const ZoomableWidget({Key key, this.child, this.isScale}) : super(key: key);

  @override
  _ZoomableWidgetState createState() => _ZoomableWidgetState();
}

class _ZoomableWidgetState extends State<ZoomableWidget> {
  Matrix4 matrix = Matrix4.identity();

  @override
  Widget build(BuildContext context) {
    return MatrixGestureDetector(
      onMatrixUpdate: (Matrix4 m, Matrix4 tm, Matrix4 sm, Matrix4 rm) {
        setState(() {
          matrix = m;
        });
      },
      shouldRotate: false,
      shouldScale: widget.isScale??false,
      shouldTranslate: widget.isScale??false,
      clipChild: widget.isScale??true,
      child: Transform(
        transform: matrix,
        child: widget.child,
      ),
    );
    /*return Zoom(
      *//* onMatrixUpdate: (Matrix4 m, Matrix4 tm, Matrix4 sm, Matrix4 rm) {
        setState(() {
          matrix = m;
        });
      },
      shouldRotate: false,
      shouldTranslate: true,*//*

      width: 1600,
      height: 2200,
      canvasColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      colorScrollBars: Colors.transparent,
      opacityScrollBars: 0.0,
      scrollWeight: 10.0,
      centerOnScale: true,
      enableScroll: true,
      doubleTapZoom: true,
      zoomSensibility: 2.3,
      initZoom: 0.0,
      child: Center(child: widget.child),
    );*/
  }
}
