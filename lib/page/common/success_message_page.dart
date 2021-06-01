import 'package:flutter/material.dart';
import 'package:testsylo/common/common_route.dart';

import '../../app.dart';

class SuccessMessageDialog extends StatefulWidget {
  String msg;

  SuccessMessageDialog(this.msg);

  @override
  _SuccessMessageDialogState createState() => _SuccessMessageDialogState();
}

class _SuccessMessageDialogState extends State<SuccessMessageDialog> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        goToLoginPage(context);
        return false;
      },
      child: animatedDialogueWithTextFieldAndButton(context),
    );
  }

  Widget appBar() {
    return Material(
      color: getMatColorBg(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Center(
              /*child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  "Message",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 17),
                ),
              ),*/
              child:Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child:Image.asset(
                App.ic_thumb,
                height: 35,
                width: 35,
              )),
            ),
          ),
          /*InkWell(
            child: Container(
              padding: EdgeInsets.only(right: 16),
              child: Icon(
                Icons.close,
                color: getColorLabel(),
              ),
              width: 32,
              height: 32,
            ),
            onTap: () {
              goToLoginPage(context);
            },
          )*/
        ],
      ),
    );
  }

  Widget animatedDialogueWithTextFieldAndButton(context) {
    var mediaQuery = MediaQuery.of(context);
    return AnimatedContainer(
      //padding: mediaQuery.viewInsets,
      duration: const Duration(milliseconds: 300),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Material(
                color: Colors.transparent,
                child: Container(
                  padding:
                      EdgeInsets.only(top: 1, bottom: 8, left: 16, right: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Container(
                      child: SafeArea(
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(0)),
                              ),
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: ListView(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                children: <Widget>[
                                  appBar(),
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 16, right: 16, left: 16),
                                    alignment: Alignment.center,
                                    child: Text(
                                      widget.msg,
                                      style: getTextStyle(size: 16),
                                    ),
                                  ),

                                  Container(
                                    alignment: Alignment.center,
                                    child: InkWell(
                                      child: Text(
                                        "Ok",
                                        style: getTextStyle(size: 16),
                                      ),
                                      onTap: () {
                                        goToLoginPage(context);
                                      },
                                    ),
                                    padding: EdgeInsets.only(
                                         top: 16, bottom: 16),
                                  ),
                                ],
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
