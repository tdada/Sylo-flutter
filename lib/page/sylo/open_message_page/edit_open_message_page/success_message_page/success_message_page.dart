import 'package:flutter/material.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';

import '../../../../../app.dart';

class SuccessMessagePage extends StatefulWidget {
  String headerName;
  String message;

  SuccessMessagePage({this.headerName, this.message});

  @override
  _SuccessMessagePageState createState() => _SuccessMessagePageState();
}

class _SuccessMessagePageState extends State<SuccessMessagePage> {
  get onPressed => (){

    goToHome(context, runtimeType.toString());

  };

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());

    return WillPopScope(
      onWillPop: () async{
          onPressed();
          return false;
        },
      child: Scaffold(
          backgroundColor: getColorBg(),
          appBar: AppBar(
            title: Text(
              widget.headerName!=null?widget.headerName:"Opening Message",
              style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w800, fontSize: 17),
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
            elevation: 0,
            leading: InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Image.asset(
                      App.ic_back,
                      fit: BoxFit.contain,
                      width: 16,
                      height: 16,
                    ),
                  ),
                ],
              ),
              onTap: () {
                onPressed();
              },
            ),
            backgroundColor: Colors.white,
          ),
          body: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Text(
                        widget.message!=null?widget.message:
                        "Your post has been saved successfully",
                        style: getTextStyle(
                            color: Colors.black,
                            size: 18,
                            fontWeight: FontWeight.w800),
                        textAlign: TextAlign.center,
                      )),
                  Container(child: commonButton(onPressed, "Back to Sylos"), padding: EdgeInsets.only(top: 16, left: 16, right: 16),),
                ],
              ),
            ),
          )),
    );
  }
}
