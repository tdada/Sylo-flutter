import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testsylo/page/start/start_page_view_model.dart';
import 'package:testsylo/util/navigate_effect.dart';

import '../../app.dart';

class StartPage extends StatefulWidget {
  @override
  StartPageState createState() => StartPageState();
}

class StartPageState extends State<StartPage> {
  StartPageViewModel model;
  bool isTokenGet = false;
  bool isTimerClose = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = StartPageViewModel(this));
    return Scaffold(
      backgroundColor: getColorBg(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom:10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: Container(
                  width: 76,height: 76,
                  child: ShaderMask(child: Image.asset(App.ic_logo_purple, fit: BoxFit.fill, height: double.infinity, width: double.infinity,color: colorDark),shaderCallback: (Rect bounds){
                    return LinearGradient(
                      colors: [colorgradient,colorgradient1],
                    ).createShader(bounds);
                  },blendMode: BlendMode.srcATop,),
                )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom:40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: Container(
                  width: 60,height: 37,
                  child: ShaderMask(child: Image.asset(App.img_color_sylo, fit: BoxFit.fill, height: double.infinity, width: double.infinity,color: colorDark),shaderCallback: (Rect bounds){
                    return LinearGradient(
                      colors: [colorgradient,colorgradient1],
                    ).createShader(bounds);
                  },blendMode: BlendMode.srcATop,),
                )),
              ],
            ),
          ),
        ],
      ),

      );
  }


}
