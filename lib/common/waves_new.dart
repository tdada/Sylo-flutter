import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:testsylo/app.dart';
import 'package:testsylo/model/wave_item.dart';

class VibesTween extends Tween<WaveItem> {
  VibesTween(WaveItem begin, WaveItem end) : super(begin: begin, end: end);

  @override
  WaveItem lerp(double t) => WaveItem.lerp(begin, end, t);
}

class WaveItemsPainter extends CustomPainter {
  var wavePaint = Paint()
    ..color = colorSectionHead
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0
    ..isAntiAlias = true;

  WaveItemsPainter(Animation<WaveItem> animation)
      : animation = animation,
        super(repaint: animation);

  final Animation<WaveItem> animation;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = new Paint();
    canvas.translate(size.width / 2, size.height / 2);

    canvas.save();

    final radius = size.width / 2;
    final chart = animation.value;
    print("animation value:" + chart.wave.length.toString());
    for (final wave in chart.wave) {
      paint.color = wave.color;
      double centerX = size.width / 2.0;
      double centerY = size.height / 2.0;


      canvas.drawLine(
        new Offset(centerX, centerY),
        new Offset(centerY - (wave.height * 50), centerY),
        wavePaint,
      );


      canvas.rotate(2 * 3.14 / chart.wave.length);
      //canvas.skew(centerY,centerX);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(WaveItemsPainter old) => true;
}

class WavesView1 extends StatefulWidget {

  final state = new WaveItemsState();

  @override
  WaveItemsState createState() => state;

  void changeWaveItems() {
    state.changeWaveItem();
  }
}

class WaveItemsState extends State<WavesView1> with TickerProviderStateMixin {
  static const size = const Size(100.0, 5.0);
  final random = new Random();
  AnimationController animation;
  VibesTween tween;
  AnimationController _breathingController;
  var _breathe = 0.0;
  AnimationController _angleController;
  var _angle = 0.0;

  @override
  void initState() {
    super.initState();
    animation = new AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    tween = new VibesTween(
      new WaveItem.empty(size),
      new WaveItem.random(size, random),
    );
    _breathingController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    _breathingController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _breathingController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _breathingController.forward();
      }
    });
    _breathingController.addListener(() {
     /* setState(() {
        _breathe = _breathingController.value;
      });*/
    });
    _breathingController.forward();
    _angleController =
        AnimationController(vsync: this, duration: Duration(microseconds: 200));
    _angleController.addListener(() {
      setState(() {
        _angle = _angleController.value * 45 / 360 * 2 *
            pi; //value is always between 0 and 1
      });
    });
    animation.forward();
    Future.delayed(Duration(seconds: 1)).then((onValue) {
      changeWaveItem();
      if (_angleController.status == AnimationStatus.completed) {
        _angleController.reverse();
      } else if (_angleController.status == AnimationStatus.dismissed) {
        _angleController.forward();
      }
    });
  }

  @override
  void dispose() {
    animation.dispose();
    _angleController.dispose();
    super.dispose();
  }

  void changeWaveItem() {
    if (!mounted) return;
    setState(() {
      tween = new VibesTween(
        tween.evaluate(animation),
        new WaveItem.random(size, random),
      );
      animation.forward(from: 0.0);
    });
    Future.delayed(Duration(milliseconds: 300)).then((onValue) {
      changeWaveItem();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = 200.0 - 20.0 * _breathe;
    return new Container(
        width: 330.00,
    height: 330.00,
    padding: const EdgeInsets.all(55.0),

    child: Transform.rotate(
      angle: 45 / 360 * pi * 2, //45 degree in radius
      child: Material(
        borderRadius: BorderRadius.circular(size / 3),
        color: Colors.pinkAccent,
        child: Transform.rotate(
          angle: _angle,
          child: Icon(
            Icons.clear,
            size: size,
            color: Colors.white,
          ),
        ),
      ),
    ));
  }
}