import 'package:flutter/material.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/page/forgot_password/forgot_password_page_view_model.dart';
import 'package:testsylo/page/forgot_password/forgot_password_verification_send_page.dart';
import 'package:testsylo/page/sign_up/sign_up_page.dart';
import 'package:testsylo/util/navigate_effect.dart';

import '../../app.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  ForgotPasswordPageState createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {
  ForgotPasswordPageViewModel model;

  var _forgotPasswordformKey = GlobalKey<FormState>();

  final FocusNode myFocusNodeEmailSignup = FocusNode();

  TextEditingController signupEmailController = new TextEditingController();

  get formView => Column(
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
              child: Text("Enter the email address below",
                  style: getTextStyle(
                      color: Colors.black,
                      size: 18,
                      fontWeight: FontWeight.w800))),
          SizedBox(
            height: 4,
          ),
          Container(
            padding: EdgeInsets.only(top: 12),
            child: Text(
              "We will email you a link to reset your password.",
              style: getTextStyle(color: Color(0x00ffC3C3C3), size: 15),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Form(
            key: _forgotPasswordformKey,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 12),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Email",
                    style: getTextStyle(color: Color(0x00ffC3C3C3), size: 14),
                  ),
                ),
                Container(
                  child: Material(
                    color: getMatColorBg(),
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.only(
                            topRight: Radius.circular(1),
                            topLeft: Radius.circular(1),
                            bottomLeft: Radius.circular(1),
                            bottomRight: Radius.circular(1))),
                    child: Container(
                      child: TextFormField(
                        focusNode: myFocusNodeEmailSignup,
                        controller: signupEmailController,
                        keyboardType: TextInputType.emailAddress,
                        style: getTextStyle(size: 16, color: Colors.black),
                        validator: (value) {
                          if (value.isEmpty) {
                            return App.errorEmail;
                          } else if (!RegExp(
                                  r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                              .hasMatch(value)) {
                            return App.errorEmailInValid;
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: commonButton(
                    () async {
                      if (_forgotPasswordformKey.currentState.validate()) {
                        _forgotPasswordformKey.currentState.save();
                        model.callPutForgotPasswordSentLink();
                       /* var result = await Navigator.push(
                                      context, NavigatePageRoute(context,
                            ForgotPasswordVerificationSentPage()
                                  ));*/
                      }
                    },
                    "Send",
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  get btnView => Column(
    children: <Widget>[
      Container(
          child: Text("Already have an account?",
              style: getTextStyle(
                  color: Colors.black87,
                  size: 16,
                  fontWeight: FontWeight.w400))),
      SizedBox(
        height: 8,
      ),
      Container(
        child: RaisedButton(
          onPressed: () {
            Navigator.push(
                context,
                NavigatePageRoute(
                    context, SignUpPage()));
          },
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(width: 0.5, color: colorDark)),
          padding: EdgeInsets.all(0.0),
          child: Container(
            constraints: BoxConstraints(minHeight: 50.0),
            alignment: Alignment.center,
            child: Text(
              "Sign up now",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: colorDark,
                  fontSize: 18),
            ),
          ),
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = ForgotPasswordPageViewModel(this));

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
      bottomNavigationBar: Container(
        height: 100,


        child:btnView,
        padding: EdgeInsets.only(left: 16, right: 16, ),
        margin: EdgeInsets.only(bottom: 16),
      ),
      body: SafeArea(
          child: ListView(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: formView,
          ),
          Container(height: 75,)

        ],
      )),
    );
  }
}
