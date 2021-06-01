import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/page/dashboard/dashboard_page.dart';
import 'package:testsylo/page/forgot_password/forgot_password_page.dart';
import 'package:testsylo/page/log_in/login_page_view_model.dart';
import 'package:testsylo/page/sign_up/profile/sign_up_profile_page.dart';
import 'package:testsylo/page/sign_up/sign_up_page.dart';
import 'package:testsylo/page/sylo/add_sylo_page/add_sylo_page.dart';
import 'package:testsylo/util/navigate_effect.dart';

import '../../app.dart';

class LogInPage extends StatefulWidget {
  String from;
  LogInPage({this.from});

  @override
  LogInPageState createState() => LogInPageState();
}

class LogInPageState extends State<LogInPage> {
  LogInPageViewModel model;

  var _logInformKey = GlobalKey<FormState>();

  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  bool _obscureTextLogin = true;

  @override
  initState(){
    super.initState();
    initData();

  }

  void initData() async {
    await requestPermission();
    //await requestPermission(Permission.storage);
  }

  requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
      Permission.photos,
      Permission.storage,
      Permission.mediaLibrary,
      Permission.unknown

    ].request();
    print(statuses);
  }

  get btnView => Column(
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
                    context, NavigatePageRoute(context, SignUpPage()));
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
                  style: TextStyle(color: colorDark, fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      );

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
            key: _logInformKey,
            child: Column(
              children: <Widget>[
                Container(
//                        padding: EdgeInsets.only(top: 12),
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
                        focusNode: myFocusNodeEmailLogin,
                        controller: loginEmailController,
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
                ),
                Container(
                  padding: EdgeInsets.only(top: 12),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Password",
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
                        focusNode: myFocusNodePasswordLogin,
                        controller: loginPasswordController,
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
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    FlatButton(
                        onPressed: () async {
                          Navigator.push(context,
                              NavigatePageRoute(context, ForgotPasswordPage()));
                        },
                        padding: EdgeInsets.all(0),
                        child: Text(
                          "Forgot password?",
                          style: getTextStyle(
                              size: 14,
                              fontWeight: FontWeight.w600,
                              color: colorDark),
                        )),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  child: commonButton(
                    () async {
                      if (_logInformKey.currentState.validate()) {
                        _logInformKey.currentState.save();
                        model.callGetSignInProcess();
                        //var result = await Navigator.push(context, NavigatePageRoute(context, DashBoardPage()));
                      }
                    },
                    "Login",
                  ),
                ),
                model.isAvailableInDevice ? Container(
                  child: commonButtonWithCorner(
                      model.secureLogin,
                      " Secure Login",
                      Container(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Image.asset(
                          App.ic_secure_lock,
                          width: 15,
                          height: 18,
                        ),
                      ),
                      fontWeight: FontWeight.w500,
                      borderWidth: 0.5,
                  ),
                  padding: EdgeInsets.only(top: 16, left: 4, right: 4),
                ): SizedBox(),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: btnView,
                )

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

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = LogInPageViewModel(this));

    return Scaffold(
        backgroundColor: getColorBg(),
        appBar: AppBar(
          title: Text(
            "Sign in",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w800, fontSize: 17),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: widget.from == "IntroPageState"?InkWell(
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
          ):null,
          backgroundColor: Colors.white,
        ),
        /*bottomNavigationBar: Container(
          height: 100,
          child: btnView,
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
          ),
          margin: EdgeInsets.only(bottom: 16),
        ),*/
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: formView,
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
