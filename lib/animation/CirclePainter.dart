import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:math' as math show sin, pi, sqrt;
import 'package:flutter/animation.dart';

class CirclePainter extends CustomPainter {
  CirclePainter(
    this._wave,
    this._animation, {
    @required this.color,
  }) : super(repaint: _animation);
  final Color color;
  final Animation<double> _animation;
  final int _wave;
  void circle(Canvas canvas, Rect rect, double value) {
    final double opacity = (1.0 - (value / 4.0)).clamp(0.0, 1.0);
    final Color _color = color.withOpacity(opacity);
    final double size = rect.width / 3;
    final double area = size * size;
    final double radius = math.sqrt(area * value / 2);
    final double maxradius = math.sqrt(area * value / 2);
    final double minradius = math.sqrt(area * value * 2);
    //final double radius1 = (10 % 1000)/1000 * (maxradius - minradius) + minradius; // whatever, find a nice ripple value(time) function

    final Paint paint = Paint()..color = _color;

    canvas.drawCircle(rect.center, radius, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    print("Wave Length"+_wave.toString());
    final Rect rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    for (int wave = 1; wave >= 0; wave--) {
      circle(canvas, rect, _wave + _animation.value);
    }
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) => true;
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
  AnimationController _controller;
  AnimationController _breathingController;
  var _breathe = 0.0;
  AnimationController _angleController;
  var _angle = 0.0;
  //VibesTween tween;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat();

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
    });


    _controller.forward();
    Future.delayed(Duration(seconds: 1)).then((onValue) {
      if (_angleController.status == AnimationStatus.completed) {
        _angleController.reverse();
      } else if (_angleController.status == AnimationStatus.dismissed) {
        _angleController.forward();
      }
      changeWaveItem();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void changeWaveItem() {
    if (!mounted) return;
    setState(() {});
    Future.delayed(Duration(milliseconds: 300)).then((onValue) {
      changeWaveItem();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: 330.00,
      height: 330.00,
      child: Transform.rotate(
        angle: 45 / 360 * pi * 2, //45 degree in radius
        child: Material(
          borderRadius: BorderRadius.circular(10 / 3),
          color: Colors.pinkAccent,
          child: Transform.rotate(
            angle: _angle,
            child: Icon(
              Icons.clear,
              size: 10,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}


class CurveWave extends Curve {

  @override
  double transform(double t) {
    if (t == 0 || t == 1) {
      return 0.01;
    }
    return math.sin(t * math.pi);
  }
}
