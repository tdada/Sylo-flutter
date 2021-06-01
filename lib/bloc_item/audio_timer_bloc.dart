import 'package:rxdart/rxdart.dart';

class AudioTimerBloc {
  BehaviorSubject<double> controller;

  AudioTimerBloc() {
    controller = BehaviorSubject<double>();
  }

  addTime(m){
    controller.sink.add(m);
  }

  void dispose() {
    controller.close();
  }
}
