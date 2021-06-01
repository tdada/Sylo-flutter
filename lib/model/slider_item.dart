import 'package:flutter/material.dart';

import '../app.dart';

class SliderItem {
  final String description;
  final String imageUrl;
  final String title;
  final String heading;

  SliderItem({
    @required this.description,
    @required this.imageUrl,
    @required this.title,
    @required this.heading,
  });
}

final listSlide = [
  SliderItem(
    description:
        'Get started by creating your first Sylos and assign them to well deserveing Recipients.',
    imageUrl: App.ic_onboarding_one,
    title: 'Create Sylos',
    heading: '',
  ),
  SliderItem(
    description:
        'Send personal messages to your Sylos in many media formats, including new photo format Annograph and Circular Video.',
    imageUrl: App.ic_onboarding_two,
    title: 'TimePost to Sylos',
    heading: '',
  ),
  SliderItem(
    description:
        'Setup your personal interviews with Sylo\'s revolutionary feature Qcast, which empowers you to answer questions for your Sylo Recipients.',
    imageUrl: App.ic_onboarding_three,
    title: 'Sylo Qcasts',
    heading: '',
  ),
];
