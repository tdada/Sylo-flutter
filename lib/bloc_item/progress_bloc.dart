import 'package:rxdart/rxdart.dart';

class ProgressBloc {
  BehaviorSubject<bool> controller;
  bool isLoad = false;

  ProgressBloc(isLoad) {
    this.isLoad = isLoad;
    controller = BehaviorSubject<bool>();
    if(isLoad){
      controller.sink.add(isLoad);
      //isCall = isLoad;
      recusrsionCall();
    }

  }
  //bool isCall = false;
  recusrsionCall() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      //isCall = !isCall;
      controller.sink.add(isLoad);
      if (isLoad) {
        recusrsionCall();
      }
    });
  }

  Stream<bool> get badgeStream => controller.stream;

  void dispose() {
    controller.close();
  }
}
