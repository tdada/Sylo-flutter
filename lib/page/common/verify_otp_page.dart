import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/local_data/app_state.dart';
import 'package:testsylo/page/password_add/password_add_page.dart';
import 'package:testsylo/service/common_service.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';
import 'package:testsylo/util/navigate_effect.dart';

import '../../app.dart';

class VerifyOtpPage extends StatefulWidget {
  String email;
  String from;
  VerifyOtpPage(this.email, this.from);

  @override
  VerifyOtpPageState createState() => VerifyOtpPageState();
}

class VerifyOtpPageState extends State<VerifyOtpPage> {
  TextEditingController otpController = TextEditingController();
  var _logInformKey = GlobalKey<FormState>();
  InterceptorApi interceptorApi;
  CommonService commonService = CommonService();

  get onPressedVerify => () async {
        if (_logInformKey.currentState.validate()) {
          String code = otpController.text.trim();
          print("widget.from -> "+widget.from);
          bool isSuccess = await interceptorApi.verifyEmailWithCode(
              widget.email, code);
          if (isSuccess) {
            print("widget.from -> "+widget.from);
            if(widget.from == "RoundDialogPage"){
              Navigator.pop(context, true);
            }
            else if (widget.from == "SignUpProfilePageState") {
              print("User id -> "+appState.userItem.userId.toString());
              commonService.setUserId(appState.userItem.userId.toString());
              Navigator.pop(context,true);
            } else if (widget.from == "ForgotPasswordVerificationSentPageState") {
              Navigator.pop(context,true);
            }
            /*var result = await Navigator.push(
                context, NavigatePageRoute(context, PasswordAddPage()));*/
          }
        }
      };

  get onPressReSend => () async {
    String email;
    if (widget.from == "ForgotPasswordVerificationSentPageState") {
      email = widget.email;
    } else {
      email = appState.userItem.email;
    }
    bool isSuccess = await interceptorApi.callResendOtpSentLink(email);
    print("widget.from -> " + widget.from);

    if (isSuccess) {
      print("Resent Otp for -> " + appState.userItem.email);
    }
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return animatedDialogueWithTextFieldAndButton(context);
  }

  Widget appBar() {
    return Material(
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
                  "Verify OTP",
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
              child: Icon(
                Icons.close,
                color: getColorLabel(),
              ),
              width: 32,
              height: 32,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  animatedDialogueWithTextFieldAndButton(context) {
    var mediaQuery = MediaQuery.of(context);
    if(interceptorApi==null){
      interceptorApi = InterceptorApi(context: context);
    }
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
                      EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
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
                                    top: Radius.circular(20),
                                    bottom: Radius.circular(20)
                                        
                                ),
                              ),
                              padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
                              child: ListView(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                children: <Widget>[
                                  appBar(),
                                  Container(
                                    padding: EdgeInsets.only(top: 16),
                                    alignment: Alignment.center,
                                    child: Image.asset(App.img_color_sylo,
                                        height: 80, width: 150),
                                  ),
                                  Form(
                                    key: _logInformKey,
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        top: 16,
                                      ),
                                      child: Material(
                                        color: getMatColorBg(),
                                        elevation: 0.0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: new BorderRadius.only(
                                                topRight: Radius.circular(1),
                                                topLeft: Radius.circular(1),
                                                bottomLeft: Radius.circular(1),
                                                bottomRight:
                                                    Radius.circular(1))),
                                        child: Container(
                                          padding: EdgeInsets.only(left: 8),
                                          child: TextFormField(
                                            autofocus: true,
                                            controller: otpController,
                                            keyboardType: TextInputType.number,
                                            style: getTextStyle(size: 16),
                                            decoration: InputDecoration(
                                              //border: InputBorder.none,
                                              icon: Icon(
                                                Icons.verified_user,
                                                color: getColorIcon(),
                                                size: 22.0,
                                              ),
                                              hintText: "OTP",
                                              hintStyle:
                                                  TextStyle(fontSize: 17.0),
                                            ),
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return App.errorFieldRequired;
                                              } else {
                                                return null;
                                              }
                                            },
                                            maxLength: 4,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 20),
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      child: Text(
                                        "RESEND",
                                        style: getTextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w800,
                                          size: 12,
                                        ),
                                      ),
                                      onTap: onPressReSend,
                                    ),
                                  ),
                                  Container(
                                    child:
                                        commonButton(onPressedVerify, "Verify"),
                                    padding: EdgeInsets.only(
                                        left: 16, right: 16, top: 16),
                                  ),
                                  SizedBox(
                                    height: 16,
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
