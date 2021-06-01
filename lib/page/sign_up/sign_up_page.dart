import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/page/log_in/login_page.dart';
import 'package:testsylo/page/sign_up/sign_up_page_view_model.dart';
import 'package:testsylo/util/navigate_effect.dart';

import '../../app.dart';
import 'profile/sign_up_profile_page.dart';

class SignUpPage extends StatefulWidget {
  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  SignUpPageViewModel model;

  var _signUpformKey = GlobalKey<FormState>();

  final FocusNode myFocusNodeNameSignup = FocusNode();
  final FocusNode myFocusNodeEmailSignup = FocusNode();
  final FocusNode myFocusNodePasswordSignup = FocusNode();

  TextEditingController signupNameController = new TextEditingController();
  TextEditingController signupEmailController = new TextEditingController();
  TextEditingController signupPasswordController = new TextEditingController();

  bool _obscureTextLogin = true;

  get nameFieldLabel => Container(
        alignment: Alignment.centerLeft,
        child: Text(
          "Full Name",
          style: getTextStyle(color: Color(0x00ffC3C3C3), size: 14),
        ),
      );

  get nameFormField => Container(
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
              focusNode: myFocusNodeNameSignup,
              controller: signupNameController,
              keyboardType: TextInputType.text,
              style: getTextStyle(size: 16, color: Colors.black),
              validator: (value) {
                if (value.isEmpty) {
                  return App.errorNameOnly;
                }
                /*else if (isNumeric(value) &&
                                                    value.trim().length < 7) {
                                                  return App.errorMobileInValid;
                                                }*/
                else {
                  return null;
                }
              },
            ),
          ),
        ),
      );

  get emailFieldLabel => Container(
        padding: EdgeInsets.only(top: 12),
        alignment: Alignment.centerLeft,
        child: Text(
          "Email",
          style: getTextStyle(color: Color(0x00ffC3C3C3), size: 14),
        ),
      );

  get emailFormField => Container(
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
                }
                /*else if (isNumeric(value) &&
                                                    value.trim().length < 7) {
                                                  return App.errorMobileInValid;
                                                }*/
                else {
                  return null;
                }
              },
            ),
          ),
        ),
      );

  get passwordFieldLabel => Container(
        padding: EdgeInsets.only(top: 12),
        alignment: Alignment.centerLeft,
        child: Text(
          "Password",
          style: getTextStyle(color: Color(0x00ffC3C3C3), size: 14),
        ),
      );

  get passwordFormField => Container(
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
              focusNode: myFocusNodePasswordSignup,
              controller: signupPasswordController,
              obscureText: _obscureTextLogin,
              style: TextStyle(fontSize: 16.0, color: Colors.black),
              decoration: InputDecoration(
                suffixIcon: InkWell(
                  onTap: _toggleLogin,
                  child: Icon(
                    _obscureTextLogin
                        ? FontAwesomeIcons.eyeSlash
                        : FontAwesomeIcons.eye,
                    size: 15.0,
                    color: colorDark,
                  ),
                ),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return App.errorPassword;
                } else {
                  return null;
                }
              },
            ),
          ),
        ),
      );

  get signUpButton => Container(
        child: commonButton(
          () async {
            if (_signUpformKey.currentState.validate()) {
              _signUpformKey.currentState.save();
              model.callPostAddUser();

            }
          },
          "Sign up",
        ),
      );

  get haveAccountLink => Container(
        child: Text("Already have an account?",
            style: getTextStyle(
                color: Colors.black87, size: 16, fontWeight: FontWeight.w400)),
      );

  get signInButton => Container(
          child: RaisedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        elevation: 0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        padding: EdgeInsets.all(0.0),
        child: Ink(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: colorDark, width: 1.1)),
          child: Container(
            constraints: BoxConstraints(minHeight: 50.0),
            alignment: Alignment.center,
            child: Text(
              "Sign in now",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: colorDark,
//                                    fontWeight: FontWeight.w800,
                  fontSize: 18),
            ),
          ),
        ),
      ));

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
      Form(
        key: _signUpformKey,
        child: Column(
          children: <Widget>[
            nameFieldLabel,
            nameFormField,
            emailFieldLabel,
            emailFormField,
            passwordFieldLabel,
            passwordFormField,
            SizedBox(height: 12,),
            signUpButton,
            Container(height: 75,)
          ],
        ),
      ),
    ],
  );

  get btnView => Column(
    children: <Widget>[
      haveAccountLink,
      SizedBox(
        height: 8,
      ),
      signInButton,
      SizedBox(
        height: 8,
      ),
    ],
  );

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = SignUpPageViewModel(this));

    return Scaffold(
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
        ],
      )),
    );
  }
}
