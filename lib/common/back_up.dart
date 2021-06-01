

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

import '../app.dart';

Widget get camView{

  return ClipRRect(
    child: Container(
      color: colorOvalBorder,
      //width: w - 19,
      //height: w - 19,
      ////padding: EdgeInsets.all(5), // removed
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          AspectRatio(
            child: ClipOval(
              //child: CameraPreview(model.controller),
            ),
            aspectRatio: 1.0,
          ),
        ],
      ),
    ),
    //borderRadius: BorderRadius.circular(w),
  );
}