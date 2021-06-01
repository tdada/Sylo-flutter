import 'package:rxdart/rxdart.dart';

class ForwardTimerBloc {
  BehaviorSubject<String> controller;

  ForwardTimerBloc() {
    controller = BehaviorSubject<String>();
  }

  addTime(m){
    controller.sink.add(m);
  }

  Stream<String> get badgeStream => controller.stream;

  void dispose() {
    controller.close();
  }
}
