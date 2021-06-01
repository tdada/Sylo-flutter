import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/page/common/verify_otp_page.dart';
import 'package:testsylo/page/sign_up/profile/sign_up_profile_page_view_model.dart';

import '../../../app.dart';

class SignUpVerificationSentPage extends StatefulWidget {
  String email;
  String from;
  SignUpVerificationSentPage(this.email, this.from);

  @override
  SignUpVerificationSentPageState createState() =>
      SignUpVerificationSentPageState();
}

class SignUpVerificationSentPageState
    extends State<SignUpVerificationSentPage> {
  get onPressedVerify => () async {
        bool isBack = await showDialog(
          context: context,
          builder: (BuildContext context) => VerifyOtpPage(widget.email, widget.from),
        );
        if(isBack != null && isBack){
//          await showDialog(
//              context: context,
//              builder: (BuildContext context) {
//                // return object of type Dialog
//                return AlertDialog(
//                  title: new Text(
//                    "Message",
//                    style: TextStyle(fontWeight: FontWeight.w700),
//                  ),
//                  content:
//                  new Text("Your Email is Verified.", style: TextStyle(fontWeight: FontWeight.w500)),
//                  actions: <Widget>[
//                    // usually buttons at the bottom of the dialog
//                    new FlatButton(
//                      child: new Text(
//                        "Go to Home",
//                        style: TextStyle(fontWeight: FontWeight.w700),
//                      ),
//                      onPressed: () {
//                        Navigator.of(context).pop();
//                      },
//                    ),
//                  ],
//                );
//              }
//          ).then((value) => goToHome(context));
          goToHome(context, "signup");
        }
      };

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: getColorBg(),
      appBar: AppBar(
        title: Text(
          "Sign Up",
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
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: Container(
        height: 55,
        child: commonButton(onPressedVerify, "Verify"),
        padding: EdgeInsets.only(left: 16, right: 16, ),
        margin: EdgeInsets.only(bottom: 16),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 32),
                alignment: Alignment.center,
                child: Image.asset(App.img_color_sylo, height: 80, width: 150),
              ),
              Container(
                padding: EdgeInsets.only(
                  top: 64,
                ),
                alignment: Alignment.center,
                child: Text(
                  "Verification email sent",
                  style: getTextStyle(
                      color: Colors.black,
                      size: 20,
                      fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 12,left: 16, right: 16),
                child: Text(
                  App.emailVerificationInstructionOnSignup,
                  textAlign: TextAlign.center,
                  style: getTextStyle(color: Color(0x00ffC3C3C3), size: 15),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 16),
                        alignment: Alignment.center,
                        child: Image.asset(App.ic_mail_sent,
                            height: 110, width: 175),
                      ),
                    ],
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
