import 'package:flutter/material.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/page/common/round_dialog_page.dart';
import 'package:testsylo/page/common/verify_otp_page.dart';
import 'package:testsylo/page/password_add/password_add_page.dart';
import 'package:testsylo/util/navigate_effect.dart';

import '../../app.dart';

class ForgotPasswordVerificationSentPage extends StatefulWidget {
  String email;
  ForgotPasswordVerificationSentPage({this.email});
  @override
  ForgotPasswordVerificationSentPageState createState() => ForgotPasswordVerificationSentPageState();
}

class ForgotPasswordVerificationSentPageState extends State<ForgotPasswordVerificationSentPage> {

  get onPressedVerify => () async {
    bool isBack = await showDialog(
      context: context,
      builder: (BuildContext context) => VerifyOtpPage(widget.email, runtimeType.toString()),
    );
    if(isBack != null && isBack){
      await showDialog(
          context: context,
          builder: (BuildContext context) => RoundDialogPage(
              "Your Email is Verified.",
              positiveActionText:"Go to Update Password",
              isSuccessIcon:true)).then((value) async {
        var result = await Navigator.push(
            context, NavigatePageRoute(
            context, PasswordAddPage(email: widget.email,)));
      });
    }
  };

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    return Scaffold(
      backgroundColor: getColorBg(),
      appBar: AppBar(
        title: Text(
          "Forgot Password",
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
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Container(
                child: Image.asset(App.img_color_sylo, height: 80, width: 150),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                alignment: Alignment.center,
                child: Text("Password reset link sent", style: getTextStyle(color: Colors.black, size: 20, fontWeight: FontWeight.w800), textAlign: TextAlign.center,),
              ),
              Container(
                padding: EdgeInsets.only(top: 12,left: 16, right: 16),
                child: Text(
                  App.emailVerificationInstruction,
                  textAlign: TextAlign.center,
                  style: getTextStyle(color: Color(0x00ffC3C3C3), size: 15),
                ),
              ),

              Container(child: commonButton(onPressedVerify, "Verify"), padding: EdgeInsets.only(top:24,left: 16, right: 16, bottom: 16),),

            ],
          ),
        ),
      ),
    );
  }
}
