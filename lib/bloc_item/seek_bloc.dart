import 'package:rxdart/rxdart.dart';

class SeekBloc {
  BehaviorSubject<double> controller;

  SeekBloc() {
    controller = BehaviorSubject<double>();
  }

  addProgress(m) {
    controller.sink.add(m);
  }

  Stream<double> get badgeStream => controller.stream;

  void dispose() {
    controller.close();
  }
}
