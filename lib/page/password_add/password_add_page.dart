import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/page/forgot_password/forgot_password_page.dart';
import 'package:testsylo/page/log_in/login_page.dart';
import 'package:testsylo/page/log_in/login_page_view_model.dart';
import 'package:testsylo/page/password_add/password_add_page_view_model.dart';
import 'package:testsylo/page/sign_up/profile/sign_up_profile_page.dart';
import 'package:testsylo/page/sign_up/sign_up_page.dart';
import 'package:testsylo/page/sylo/add_sylo_page/add_sylo_page.dart';
import 'package:testsylo/util/navigate_effect.dart';

import '../../app.dart';

class PasswordAddPage extends StatefulWidget {
  String email;
  PasswordAddPage({this.email});

  @override
  PasswordAddPageState createState() => PasswordAddPageState();
}

class PasswordAddPageState extends State<PasswordAddPage> {
  PasswordAddPageViewModel model;

  var _logInformKey = GlobalKey<FormState>();


  TextEditingController newPasswordController = new TextEditingController();
  TextEditingController newConfirmPasswordController = new TextEditingController();

  bool _obscureTextLogin = true;
  bool _obscureTextConfirmLogin = true;

  get btnView =>
      Column(
        children: <Widget>[
          Container(
              child: Text("Don't have an account?",
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

  get formView =>
      Column(
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
            key: _logInformKey,
            child: Column(
              children: <Widget>[
                Container(
//                        padding: EdgeInsets.only(top: 12),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "New Password",
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
                        controller: newPasswordController,
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
                            return App.errorNewPwdRequired;
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(top: 12),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Confirm Password",
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
                        controller: newConfirmPasswordController,
                        obscureText: _obscureTextConfirmLogin,
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                        decoration: InputDecoration(
                          suffixIcon: InkWell(
                            onTap: _toggleConfirmLogin,
                            child: Icon(
                              _obscureTextConfirmLogin
                                  ? FontAwesomeIcons.eyeSlash
                                  : FontAwesomeIcons.eye,
                              size: 15.0,
                              color: colorDark,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return App.errorConfirmPwdRequired;
                          }
                          if (value.trim() != newPasswordController.text.trim()) {
                            return App.errorPwdMismatch;
                          }
                          else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 24,
                ),
                Container(
                  child: commonButton(
                        () async {
                          if (_logInformKey.currentState.validate()) {
                            _logInformKey.currentState.save();
                            String newPassword = newPasswordController.text.toString().trim();

                            await model.setNewPassword(widget.email, newPassword);

                          }
                        },
                    "Submit",
                  ),
                ),
                Container(height: 75,)
              ],
            ),
          ),
        ],
      );

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  void _toggleConfirmLogin() {
    setState(() {
      _obscureTextConfirmLogin = !_obscureTextConfirmLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = PasswordAddPageViewModel(this));

    return Scaffold(
        backgroundColor: getColorBg(),
        appBar: AppBar(
          title: Text(
            "Update Password",
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
          child: ListView(


            physics: BouncingScrollPhysics(),
            children: <Widget>[


              Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: formView,
              ),
            ],
          ),
        )
    );
  }
}
