import 'package:flutter/material.dart';

import '../../app.dart';

class CupertinoDialogPage extends StatefulWidget {
  Widget centerWidget;
  VoidCallback positiveAction;
  VoidCallback negativeAction;
  String negativeActionLabel;
  CupertinoDialogPage({this.centerWidget, this.positiveAction, this.negativeAction, this.negativeActionLabel});
  @override
  CupertinoDialogPageState createState() => CupertinoDialogPageState();
}

class CupertinoDialogPageState extends State<CupertinoDialogPage> {
  @override
  Widget build(BuildContext context) {
    return animatedDialogueWithTextFieldAndButton(context);
  }

  animatedDialogueWithTextFieldAndButton(context) {
    var mediaQuery = MediaQuery.of(context);
    return AnimatedContainer(
      padding: mediaQuery.viewInsets,
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
                  EdgeInsets.only(top: 8, bottom: 8, left: 18, right: 18),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
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
                              child: ListView(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                children: <Widget>[
                                  widget.centerWidget!=null ? widget.centerWidget : SizedBox(
                                    height: 34,
                                  ),
                                  Container(
                                    height: 1,
                                    color: colorOvalBorder,
                                    margin: EdgeInsets.only(top: 16),
                                  ),
                                  Container(
                                    height: 50,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              if(widget.negativeAction!=null) {
                                                widget.negativeAction.call();
                                              } else {
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: Center(
                                              child: Text(
                                                widget.negativeActionLabel??"No",
                                                style: getTextStyle(
                                                    color: colorDark,
                                                    size: 18,
                                                    fontWeight:
                                                    FontWeight.w700),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 1,
                                          color: colorOvalBorder,
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              if(widget.positiveAction!=null) {
                                                widget.positiveAction.call();
                                              } else {
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: Center(
                                              child: Text(
                                                "Yes",
                                                style: getTextStyle(
                                                    color: colorDark,
                                                    size: 18,
                                                    fontWeight:
                                                    FontWeight.w700),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
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
