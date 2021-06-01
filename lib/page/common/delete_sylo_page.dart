import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/page/password_add/password_add_page.dart';
import 'package:testsylo/util/navigate_effect.dart';

import '../../app.dart';

class DeleteSyloPage extends StatefulWidget {
  DeleteSyloPage();

  @override
  DeleteSyloPageState createState() => DeleteSyloPageState();
}

class DeleteSyloPageState extends State<DeleteSyloPage> {
  TextEditingController nameAlbumController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return animatedDialogueWithTextFieldAndButton(context);
  }

  Widget appBar() {
    return Container(
      height: 45,
      child: Material(
        color: getMatColorBg(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 16),
              width: 32,
              height: 32,
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    "Add Question",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 17),
                  ),
                ),
              ),
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.only(right: 16),
                width: 32,
                height: 32,
              ),
            )
          ],
        ),
      ),
    );
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
                              child: ListView(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                children: <Widget>[
                                  SizedBox(
                                    height: 12,
                                  ),
                                  new Image.asset(
                                    App.ic_alert_new,
                                    height: 24,
                                    width: 24,
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    "Are you sure you want to Delete\nthis Sylo?",
                                    textAlign: TextAlign.center,
                                    style: getTextStyle(size: 18, height: 1.5),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Note: All content will be deleted",
                                    textAlign: TextAlign.center,
                                    style: getTextStyle(
                                        color: colorSubTextPera, size: 15),
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
                                              Navigator.pop(context);
                                            },
                                            child: Center(
                                              child: Text(
                                                "Cancel",
                                                style: getTextStyle(
                                                    color: Color(0x00ffC3C3C3),
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
                                              Navigator.pop(context, true);
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
