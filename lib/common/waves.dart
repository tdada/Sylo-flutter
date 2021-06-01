import 'dart:math';
import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:testsylo/animation/CirclePainter.dart';
import 'package:testsylo/animation/PolygonUtil.dart';
import 'package:testsylo/animation/const/size_const.dart';
import 'package:testsylo/app.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/model/wave_item.dart';

SizeUtil get _sizeUtil {
  return SizeUtil.getInstance(key: SizeKeyConst.ROUND_ANGLE_KEY);
}

class VibesTween extends Tween<WaveItem> {
  VibesTween(WaveItem begin, WaveItem end) : super(begin: begin, end: end);

  @override
  WaveItem lerp(double t) => WaveItem.lerp(begin, end, t);
}

class WaveItemsPainter extends CustomPainter {
  WaveItemsPainter(Animation<WaveItem> animation)
      : animation = animation,
        super(repaint: animation);

  final Animation<WaveItem> animation;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = new Paint();

    var chart = animation.value;

    for (final wave in chart.wave) {
      List<Point> list1 = [
        Point(250.0, 0.0),
        Point(425.0, 75.0),
        Point(500.0, 250.0),
        Point(425.0, 425.0),
        Point(250.0, 500.0),
        Point(75.0, 426.0),
        Point(0.0, 250.0),
        Point(75.0, 75.0),
      ];
      paint.color = Colors.black;
      _drawWithPoint(canvas, paint, list1);
      canvas.rotate(10 * pi * 5);
    }

    canvas.save();

    canvas.restore();
  }

  void _drawWithPoint(canvas, paint, list, {hasShadow = false}) {
    list = _resizePoint(list);
    var path = PolygonUtil.drawRoundPolygon(list, canvas, paint, distance: 2.0);
    if (hasShadow) {
      canvas.drawShadow(path, Colors.black26, 10.0, true);
    }
    canvas.drawPath(path, paint);
  }

  List<Point> _resizePoint(List<Point> list) {
    List<Point> l = List<Point>();
    for (var p in list) {
      l.add(Point(_sizeUtil.getAxisX(p.x), _sizeUtil.getAxisY(p.y)));
    }
    return l;
  }

  @override
  bool shouldRepaint(WaveItemsPainter old) => true;
}

class WavesView extends StatefulWidget {
  final state = new WaveItemsState();
  String max;
  String min;
  WavesView();

  @override
  WaveItemsState createState() => state;

  void changeWaveItems() {
    state.changeWaveItem();
  }
}

class WaveItemsState extends State<WavesView> with TickerProviderStateMixin {
  static const size = const Size(200.0, 10.0);
  final random = new Random();
  AnimationController _breathingController;
  var _breathe = 0.0;
  AnimationController _angleController;
  var _angle = 0.0;

  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    tenet();
    /*_breathingController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    _breathingController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _breathingController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _breathingController.forward();
      }
    });
    _breathingController.addListener(() {
      setState(() {
        _breathe = _breathingController.value;
      });
    });
    _breathingController.forward();
    _angleController =
        AnimationController(vsync: this, duration: Duration(microseconds: 200));
    _angleController.addListener(() {
      setState(() {
        _angle = _angleController.value * 45/360 * 2 * pi;  //value is always between 0 and 1
      });
    });*/


    /*Future.delayed(Duration(seconds: 1)).then((onValue) {
      changeWaveItem();
      if (_angleController.status == AnimationStatus.completed) {
        _angleController.reverse();
      } else if (_angleController.status == AnimationStatus.dismissed) {
        _angleController.forward();
      }
    });*/
  }

  void tenet() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 1.0, end: 20.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    //_angleController.dispose();
    _animationController.dispose();
    _animation.removeListener(() {});
    //animation.dispose();
    //_controller.dispose();
    super.dispose();
  }

  void changeWaveItem() {
    if (!mounted) return;
    Future.delayed(Duration(seconds: 1)).then((onValue) {
      changeWaveItem();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child:Container(
        width: 200,
        height: 200,
        decoration:BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: colorDarkPurple,
              blurRadius: _animation.value,
              spreadRadius: _animation.value,
            ),
          ],
        )));
  }

}

