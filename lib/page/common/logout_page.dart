import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/service/common_service.dart';

import '../../app.dart';

class LogoutPage extends StatefulWidget {
  LogoutPage();

  @override
  LogoutPageState createState() => LogoutPageState();
}

class LogoutPageState extends State<LogoutPage> {
  CommonService commonService = CommonService();
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
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Column(
                                    children: [
                                      new Image.asset(
                                        App.ic_alert_new,
                                        height: 24,
                                        width: 24,
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Text(
                                        "Are you sure you want to \nlogout?",
                                        textAlign: TextAlign.center,
                                        style:
                                            getTextStyle(size: 18, height: 1.5),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 24,
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
                                              commonService.loggedOut();
                                              goToLoginPage(context);
                                            },
                                            child: Center(
                                              child: Text(
                                                "Yes",
                                                style: getTextStyle(
                                                    color: Color(0x00ffC3C3C3),
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
