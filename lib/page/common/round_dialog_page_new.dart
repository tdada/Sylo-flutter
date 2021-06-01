import 'package:flutter/material.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/page/sign_up/profile/sign_up_verification_sent_page.dart';
import 'package:testsylo/util/navigate_effect.dart';

import '../../app.dart';

class RoundDialogPageNew extends StatefulWidget {
  String message;
  Function(String) callback;
  String email;
  String positiveActionText;
  bool isSuccessIcon;

  RoundDialogPageNew(this.message, {this.callback, this.email, this.positiveActionText, this.isSuccessIcon});

  @override
  RoundDialogPageState createState() => RoundDialogPageState();
}

class RoundDialogPageState extends State<RoundDialogPageNew> {
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
                    borderRadius: BorderRadius.all(Radius.circular(30)),
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
                                  Image.asset(
                                    getIcon(),
                                    height: 35,
                                    width: 35,
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 8, right: 8),
                                    child: Text(
                                      widget.message,
                                      textAlign: TextAlign.center,
                                      style: getTextStyle(size: 18, height: 1.5),
                                    ),
                                  ),
                                  SizedBox(
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
                                              goToLoginPage(context);
                                            },
                                            child: Center(
                                              child: Text(
                                                widget.positiveActionText??"OK",
                                                style: getTextStyle(
                                                  color: colorDark,
                                                  size: 16,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                        widget.email == null
                                            ? Container()
                                            : Container(
                                                width: 1,
                                                color: colorOvalBorder,
                                              ),
                                        widget.email == null
                                            ? Container()
                                            : Expanded(
                                                child: InkWell(
                                                  onTap: () async {
                                                    bool isSent = await widget.callback.call(widget.email);
                                                    if (isSent) {
                                                      Navigator.of(context)
                                                          .pop();
                                                      var result = await Navigator.push(
                                                          context,
                                                          NavigatePageRoute(
                                                              context,
                                                              SignUpVerificationSentPage(
                                                                  widget.email,
                                                                  context.widget
                                                                      .runtimeType
                                                                      .toString())));
                                                    }
                                                  },
                                                  child: Center(
                                                    child: Text(
                                                      "Send OTP",
                                                      style: getTextStyle(
                                                          color: colorDark,
                                                          size: 18,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  ),
                                                ),
                                              ),
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

  String getIcon() {
    if(widget.isSuccessIcon!=null&&widget.isSuccessIcon==true){
      return App.ic_thumb;
    }
    return App.ic_alert;
  }
}
