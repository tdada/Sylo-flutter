
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../app.dart';

class Vibes {
  Vibes(this.height, this.color);

  final double height;
  final Color color;

  Vibes get collapsed => new Vibes(0.0, color);

  static Vibes lerp(Vibes begin, Vibes end, double t) {
    return new Vibes(
      lerpDouble(begin.height, end.height, t),
      Color.lerp(begin.color, end.color, t),
    );
  }
}

class WaveItem {
  WaveItem(this.wave);

  factory WaveItem.empty(Size size) {
    return new WaveItem(<Vibes>[]);
  }

  factory WaveItem.random(Size size, Random random) {

    final waveLenght = 150;

    final color = colorDark;
     final bars = new List.generate(
      waveLenght,
          (i) =>
      new Vibes(
        random.nextDouble(),
        color,
      ),
    );
    return new WaveItem(bars);
  }

  final List<Vibes> wave;

  static WaveItem lerp(WaveItem begin, WaveItem end, double t) {
    final waveLength = max(begin.wave.length, end.wave.length);
    final waves = new List.generate(
      waveLength,
          (i) =>
          Vibes.lerp(
            begin._getWaves(i) ?? end.wave[i].collapsed,
            end._getWaves(i) ?? begin.wave[i].collapsed,
            t,
          ),
    );
    return new WaveItem(waves);
  }

  Vibes _getWaves(int index) => (index < wave.length ? wave[index] : null);
}