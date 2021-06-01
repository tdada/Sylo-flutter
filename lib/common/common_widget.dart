import 'dart:io';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:testsylo/bloc_item/progress_bloc.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/model/draft_model.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/page/common/round_dialog_page.dart';
import 'package:testsylo/page/common/round_dialog_page_new.dart';
import 'package:testsylo/page/sign_up/profile/sign_up_verification_sent_page.dart';
import 'package:testsylo/util/navigate_effect.dart';
import 'package:testsylo/util/shar_pref.dart';

import '../app.dart';

/*animatedDialogueWithTextFieldAndButton(context){

  var mediaQuery = MediaQuery.of(context);
  return AnimatedContainer(
    padding: mediaQuery.viewInsets,
    duration: const Duration(milliseconds: 300),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.only(top: 32, bottom: 32, left: 16, right: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Container(

                  child: SafeArea(
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.vertical(top: Radius.circular(0)),
                          ),
                          padding: EdgeInsets.only(left: 8, right: 8),
                          child:  ListView(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            children: <Widget>[

                              appBar(),
                              Form(
                                key: _logInformKey,
                                child: Container(
                                  padding: EdgeInsets.only(top: 16, ),
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
                                      padding: EdgeInsets.only(left: 8),
                                      child: TextFormField(
                                        autofocus: true,
                                        focusNode: myFocusNodeEmailLogin,
                                        controller: textEditingController,
                                        keyboardType: TextInputType.emailAddress,
                                        style: getTextStyle(size: 16),
                                        decoration: InputDecoration(
                                          //border: InputBorder.none,
                                          icon: Icon(
                                            Icons.person,
                                            color: getColorIcon(),
                                            size: 22.0,
                                          ),
                                          hintText: "Email ID/Mobile No.",
                                          hintStyle: TextStyle(fontSize: 17.0),
                                        ),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return App.errorEmail;
                                          }
                                          else if(!isNumeric(value) && !RegExp(
                                              r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                              .hasMatch(value)){
                                            return App.errorEmailInValid;
                                          }
                                          else if (isNumeric(value) && value.trim().length<7) {
                                            return App.errorMobileInValid;
                                          }
                                          else {
                                            return null;
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 54, right: 54, top: 24),
                                child: RaisedButton(
                                  elevation: 7,
                                  color: getColorPrimary(),
                                  padding: EdgeInsets.all(0),
                                  child: Container(
                                      alignment: Alignment.center,
                                      height: 50,
                                      child: Text(
                                        "GET OTP",
                                        style: getTextStyle(color: Colors.white, size: 20),
                                      )),
                                  onPressed: () {
                                    if (_logInformKey.currentState.validate()) {
                                      _logInformKey.currentState.save();
                                    }
                                  },
                                ),
                              ),

                              SizedBox(height: 16,),

                            ],
                          )
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );

}*/
exitDialogue(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) => new CupertinoAlertDialog(
      title: new Text(App.app_name),
      content: Row(
        children: [
          new Text("Are you sure you want to exit?"),
          new Image.asset(App.ic_alert_new),
        ],
      ),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text("Yes"),
          onPressed: () {
            SystemNavigator.pop(animated: true);
          },
        ),
        CupertinoDialogAction(
          child: Text("No"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

logOutDialogue(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        title: Row(
          children: [
            new Text(
              "Alert",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            new Image.asset(App.ic_alert_new),
          ],
        ),
        content:
            new Text("Logout?", style: TextStyle(fontWeight: FontWeight.w500)),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text(
              "No",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),

          new FlatButton(
            child: new Text(
              "Yes",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Shared_Preferences.clearPref(Shared_Preferences.keyUserData);
              //Navigator.pushAndRemoveUntil(context, App.createRoute(page: LogInPage()),(Route<dynamic> route) => false);
            },
          ),
        ],
      );
    },
  );
}

confirmBack(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
  showDialog(
    context: context,
    builder: (BuildContext c) {
      // return object of type Dialog
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        title: new Text(
          "Alert",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: new Text("Going Back without changes?",
            style: TextStyle(fontWeight: FontWeight.w500)),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text(
              "No",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            onPressed: () {
              Navigator.of(c).pop();
            },
          ),

          new FlatButton(
            child: new Text(
              "Yes",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            onPressed: () {
              Navigator.of(c).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Widget getAvtar(String userProfile) {
  if (userProfile != null && userProfile.length > 0) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Container(
          width: 24,
          height: 24,
          color: Colors.grey,
          child: Image.network(
            userProfile,
            fit: BoxFit.cover,
          ),
        ));
  } else {
    return ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Container(
          width: 24,
          height: 24,
          color: Colors.grey,
          child: Icon(
            Icons.person,
            size: 14,
          ),
        ));
  }
}

Widget commonTextFormView(
    TextEditingController textEditingController, String hint, String sufTxt,
    {TextInputType textInputType}) {
  return Container(
    padding: EdgeInsets.only(top: 16),
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
        padding: EdgeInsets.only(left: 8),
        child: TextFormField(
          controller: textEditingController,
          keyboardType:
              textInputType == null ? TextInputType.number : textInputType,
          style: getTextStyle(size: 16),
          decoration: InputDecoration(
            //border: InputBorder.none,
            suffixText: sufTxt,
            hintText: hint,
            hintStyle: TextStyle(fontSize: 17.0),
          ),
          onChanged: (t) {},
        ),
      ),
    ),
  );
}

void commonMessage(BuildContext c, String message,
    {Function(String) callback, email, isSuccessIcon}) {
  /*showCupertinoDialog(
    context: context,
    builder: (context) => new CupertinoAlertDialog(
      title: Text(
        'Message',
        style: TextStyle(fontFamily: AppTheme.fontName),
      ),
      content: Text(
        message,
        style: TextStyle(fontFamily: AppTheme.fontName),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: new Text(
            'Ok',
            style: TextStyle(fontFamily: AppTheme.fontName),
          ),
        ),
      ],
    ),
  );*/

  showDialog(
    context: c,
    builder: (BuildContext context) => RoundDialogPage(message,
        callback: callback, email: email, isSuccessIcon: isSuccessIcon),
  );
}

void commonMessageToken(BuildContext c, String message,
    {Function(String) callback, email, isSuccessIcon}) {
  /*showCupertinoDialog(
    context: context,
    builder: (context) => new CupertinoAlertDialog(
      title: Text(
        'Message',
        style: TextStyle(fontFamily: AppTheme.fontName),
      ),
      content: Text(
        message,
        style: TextStyle(fontFamily: AppTheme.fontName),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: new Text(
            'Ok',
            style: TextStyle(fontFamily: AppTheme.fontName),
          ),
        ),
      ],
    ),
  );*/

  showDialog(
    context: c,
    builder: (BuildContext context) => RoundDialogPageNew(message,
        callback: callback, email: email, isSuccessIcon: isSuccessIcon),
  );
}



void commonCupertinoDialogMessage(
    BuildContext context, Widget content, VoidCallback positiveAction) {
  showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      content: content,
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: new Text(
            'Cancel',
            style: getTextStyle(color: colorDark, size: 18),
          ),
        ),
        FlatButton(
          onPressed: () {
            positiveAction.call();
          },
          child: new Text(
            'Yes',
            style: getTextStyle(color: colorSubTextPera, size: 18),
          ),
        ),
      ],
    ),
  );
}

void zoomFileImageDialogue(context, Widget fileWidget) {
  FocusScope.of(context).requestFocus(FocusNode());
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (BuildContext bc) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              padding: EdgeInsets.only(top: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              margin: EdgeInsets.only(top: 80),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            size: 32,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      //padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                      child: Material(
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[fileWidget],
                        ),
                        elevation: 7.0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.only(
                                topRight: Radius.circular(1),
                                topLeft: Radius.circular(1),
                                bottomLeft: Radius.circular(1),
                                bottomRight: Radius.circular(1))),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      });
}

void zoomFileImageDialogueContainWidth(context, Widget fileWidget,
    {double height, double width}) {
  FocusScope.of(context).requestFocus(FocusNode());
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (BuildContext bc) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              padding: EdgeInsets.only(top: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              margin: EdgeInsets.only(top: 80),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            size: 32,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      //padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                      child: Material(
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Container(
                                child: fileWidget,
                                width:
                                    width ?? MediaQuery.of(context).size.width,
                                height:
                                    height ?? MediaQuery.of(context).size.width)
                          ],
                        ),
//                        elevation: 7.0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.only(
                                topRight: Radius.circular(1),
                                topLeft: Radius.circular(1),
                                bottomLeft: Radius.circular(1),
                                bottomRight: Radius.circular(1))),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      });
}

void zoomFileImageDialogueContainWidthNew(context, SubAlbumData imageList,
    {double height, double width}) {
  FocusScope.of(context).requestFocus(FocusNode());
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (BuildContext bc) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              PageView.builder(
                  allowImplicitScrolling: true  ,
                  itemCount: imageList.mediaUrls.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Center(
                      child: Container(
                        padding: EdgeInsets.only(top: 6),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(32)),
                        ),
                        margin: EdgeInsets.only(top: 10),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  /*IconButton(
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 32,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),*/
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                /*padding: EdgeInsets.only(
                                    left: 16, right: 16),*/
                                child: Material(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      Container(
                                          child: dialogImageView(index, imageList),
                                          width: width ??
                                              MediaQuery.of(context).size.width,
                                          height: height ??
                                              MediaQuery.of(context).size.width)
                                    ],
                                  ),
//                        elevation: 7.0,
                                  color: Colors.transparent,
                                  /*shape: RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.only(
                                          topRight: Radius.circular(1),
                                          topLeft: Radius.circular(1),
                                          bottomLeft: Radius.circular(1),
                                          bottomRight: Radius.circular(1))),*/
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
              Container(
                margin: EdgeInsets.only(top: 50,right: 10),
                alignment: Alignment.topRight,
                child: InkWell(
                    child: Icon(
                      Icons.clear,
                      size: 28,
                      color: Colors.white,
                    ),
                    onTap: () {
                      Navigator.pop(context);

                    }
                ),
              ),
            ],
          ),
        );
      });
}

void zoomFileImageDialogueContainWidthDraft(context, MyDraft imageList,
    {double height, double width}) {
  FocusScope.of(context).requestFocus(FocusNode());
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (BuildContext bc) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              PageView.builder(
                  allowImplicitScrolling: true  ,
                  itemCount: imageList.myDraftMedia.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Center(
                      child: Container(
                        padding: EdgeInsets.only(top: 6),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius:
                          BorderRadius.vertical(top: Radius.circular(32)),
                        ),
                        margin: EdgeInsets.only(top: 10),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  /*IconButton(
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 32,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),*/
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                /*padding: EdgeInsets.only(
                                    left: 16, right: 16),*/
                                child: Material(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      Container(
                                          child: dialogImageViewDraft(index,imageList.myDraftMedia[index]),
                                          width: width ??
                                              MediaQuery.of(context).size.width,
                                          height: height ??
                                              MediaQuery.of(context).size.width)
                                    ],
                                  ),
//                        elevation: 7.0,
                                  color: Colors.transparent,
                                  /*shape: RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.only(
                                          topRight: Radius.circular(1),
                                          topLeft: Radius.circular(1),
                                          bottomLeft: Radius.circular(1),
                                          bottomRight: Radius.circular(1))),*/
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
              Container(
                margin: EdgeInsets.only(top: 50,right: 10),
                alignment: Alignment.topRight,
                child: InkWell(
                    child: Icon(
                      Icons.clear,
                      size: 28,
                      color: Colors.white,
                    ),
                    onTap: () {
                      Navigator.pop(context);

                    }
                ),
              ),
            ],
          ),
        );
      });
}

void zoomFileImageDialogueContainWidthOneImage(context, Widget fileWidget,
    {double height, double width}) {
  FocusScope.of(context).requestFocus(FocusNode());
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (BuildContext bc) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              padding: EdgeInsets.only(top: 16),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              margin: EdgeInsets.only(top: 80),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            size: 32,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                      child: Material(
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Container(
                                child: fileWidget,
                                width:
                                width ?? MediaQuery.of(context).size.width,
                                height:
                                height ?? MediaQuery.of(context).size.width)
                          ],
                        ),
//                        elevation: 7.0,
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.only(
                                topRight: Radius.circular(1),
                                topLeft: Radius.circular(1),
                                bottomLeft: Radius.circular(1),
                                bottomRight: Radius.circular(1))),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      });
}

Widget fileWidget(File file, w, h) {
  return Image.file(
    file,
    fit: BoxFit.cover,
    width: w,
    height: h,
  );
}

void commonAlert(BuildContext context, String message) {
/*  showCupertinoDialog(
    context: context,
    builder: (context) => new CupertinoAlertDialog(
      title: Text(
        'Alert',
        style: TextStyle(color: Colors.red, fontFamily: AppTheme.fontName),
      ),
      content: Text(
        message,
        style: TextStyle(color: Colors.red, fontFamily: AppTheme.fontName),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: new Text('Ok'),
        ),
      ],
    ),
  );*/

  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        title: new Text(
          "Message",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        content: new Text(
          message,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text(
              "OK",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Widget getInfoIcon(String desc, BuildContext context, {double size}) {
  return InkWell(
    child: Container(
      child: Image.asset(
        App.ic_info,
        width: 20,
        height: 20,
      ),
      padding: EdgeInsets.only(left: 2, right: 2),
    ),
    onTap: () {
      commonMessage(context, desc);
    },
  );
}

Widget commonButton(VoidCallback onPressed, String label,
    {double red, double font_size}) {
  return Container(
    child: RaisedButton(
      onPressed: () {
        onPressed.call();
      },
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(red ?? 20.0)),
      padding: EdgeInsets.all(0.0),
      child: Ink(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff9F00C5),
                Color(0xff9405BD),
                Color(0xff7913A7),
                Color(0xff651E96),
                Color(0xff522887)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(red ?? 20.0)),
        child: Container(
          constraints: BoxConstraints(minHeight: 55.0),
          alignment: Alignment.center,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: font_size ?? 18),
          ),
        ),
      ),
    ),
  );
}

Widget commonGradButtonWithIcon(String ic, String label) {
  return Container(
    width: 95,
    height: 30,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        decoration: new BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff9F00C5),
              Color(0xff9405BD),
              Color(0xff7913A7),
              Color(0xff651E96),
              Color(0xff522887)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              ic,
              width: 20,
              height: 14,
            ),
            Text(
              label,
              style: getTextStyle(
                  color: Colors.white, size: 14, fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    ),
  );
}

Widget commonButtonWithCorner(
    VoidCallback onPressed, String label, Widget image,
    {double font_size,
    Color color,
    double red,
    double borderWidth,
    FontWeight fontWeight}) {
  return Container(
    child: RaisedButton(
      onPressed: () {
        onPressed.call();
      },
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(red ?? 10.0)),
      padding: EdgeInsets.all(0.0),
      child: Ink(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(red ?? 10.0),
            border: Border.all(
                color: color ?? colorDark, width: borderWidth ?? 1.1)),
        child: Container(
          constraints: BoxConstraints(minHeight: 50.0),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              image == null ? Container() : image,
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: color ?? colorDark,
                    fontWeight: fontWeight ?? FontWeight.w800,
                    fontSize: font_size ?? 18),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget commontextFieldLabel(String hint, {double size}) {
  return Container(
    height: 20,
    child: Text(
      hint,
      style: getTextStyle(color: Color(0x00ffC3C3C3), size: size ?? 16),
    ),
  );
}

Widget commonTextField(TextEditingController textEditingController,
    TextInputType textInputType, String hint,
    {Widget suffixWidget,
    bool enabled = true,
    VoidCallback callback,
    Function(String) onChange,
    int maxLength,
    int maxLines = 1,
    bool autoFocus = false}) {
  return Material(
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
        enabled: enabled,
        controller: textEditingController,
        keyboardType: textInputType,
        autofocus: autoFocus,

        style: getTextStyle(
            size: 18,
            fontWeight: FontWeight.w500,
            color: !enabled ? Color(0x00ffC3C3C3) : getColorLabel()),
        decoration: InputDecoration(
          //border: InputBorder.none,

          hintText: hint,
          hintStyle: TextStyle(
              fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.w400),
          suffixIcon: suffixWidget != null ? suffixWidget : null,
//          suffixIcon:
        ),
        onChanged: onChange,
        onTap: callback,
        validator: (value) {
          if (value.isEmpty && enabled == true) {
            return App.errorFieldRequired;
          } else {
              return null;

          }
        },
        maxLength: maxLength,
        maxLengthEnforced: true,
        maxLines: maxLines,
      ),
    ),
  );
}

Widget commonButtonWithFilledSingleColorCorner(
    VoidCallback onPressed, Widget text, Color buttonColor,
    {double red, Color borderColor}) {
  return Container(
    child: RaisedButton(
      onPressed: () {
        onPressed.call();
      },
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(red ?? 10.0)),
      padding: EdgeInsets.all(0.0),
      child: Ink(
        decoration: BoxDecoration(
            color: buttonColor != null ? buttonColor : Colors.white,
            borderRadius: BorderRadius.circular(red ?? 10.0),
            border: Border.all(color: borderColor ?? colorDark, width: 1.1)),
        child: Container(
          constraints: BoxConstraints(minHeight: 50.0),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[text],
          ),
        ),
      ),
    ),
  );
}

String getFileNameFromPath(String file) {
  String path = file;
  return path.substring(path.lastIndexOf("/") + 1, path.length);
}

Widget coundIndicatorBanner(int subScribers, int qcastSeries, int questions) {
  return ClipRRect(
    child: Container(
        padding: EdgeInsets.fromLTRB(12, 6, 12, 6),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
          color: Color(0x00ffECE8F2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Image.asset(
                  App.ic_heart,
                  width: 34,
                  height: 34,
                ),
                Text(
                  "$subScribers",
                  style: getTextStyle(size: 20),
                ),
                Text(
                  "Subscribers",
                  style: getTextStyle(color: colorSubTextPera, size: 16),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Image.asset(
                  App.ic_play_pink,
                  width: 30,
                  height: 30,
                ),
                Text(
                  "$qcastSeries",
                  style: getTextStyle(size: 20),
                ),
                Text(
                  "Qcast Series",
                  style: getTextStyle(color: colorSubTextPera, size: 16),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Image.asset(
                  App.ic_group_info,
                  width: 30,
                  height: 30,
                ),
                Text(
                  "$questions",
                  style: getTextStyle(size: 20),
                ),
                Text(
                  "Questions",
                  style: getTextStyle(color: colorSubTextPera, size: 16),
                ),
              ],
            ),
          ],
        )),
  );
}

ProgressBloc progressBloc = ProgressBloc(false);
List<Color> listProgressColor = [
  Colors.orange,
  Colors.red,
  colorDark,
  colorSectionHead,
  Colors.green
];
Random random = new Random();

Widget appLoader(bool isLoad, {Color color}) {
  progressBloc = ProgressBloc(isLoad);
  return IgnorePointer(
    child: Visibility(
      child: Container(
        alignment: Alignment.center,
        color: color ?? Colors.black45,
        child: Stack(
          children: <Widget>[
            StreamBuilder<Object>(
                stream: progressBloc.controller,
                builder: (context, snapshot) {
                  int randomNumber =
                      random.nextInt(listProgressColor.length) + 0;
                  //print("ProgressBloc -> " + randomNumber.toString());
                  return CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        listProgressColor[randomNumber]),
                  );
                }),
          ],
        ),
      ),
      visible: isLoad,
    ),
  );
}

commonActionAlbumIconButton(VoidCallback callback, Widget icon,
    {bool isGradient, Color viewColor, bool isBadge, int countNumber = 0}) {
  return Container(
    height: 54,
    width: 54,
    child: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          child: ClipOval(
            child: Container(
              child: ClipOval(
                child: InkWell(
                  onTap: () async {
                    callback.call();
                  },
                  child: Container(
                    height: 45,
                    width: 45,
                    padding: EdgeInsets.all(13),
//            color: Colors.white,
                    decoration: BoxDecoration(
                        gradient: getTapBackColor(
                            isGradient ?? false, viewColor ?? Colors.white)),
                    child: InkWell(
                      child: icon,
                    ),
                  ),
                ),
              ),
              padding: EdgeInsets.all(1),
//        color: colorOvalBorder,
              decoration: BoxDecoration(
                  gradient:
                      getTapBackColor(isGradient ?? false, colorOvalBorder)),
            ),
          ),
        ),
        isBadge == null && countNumber <= 0
            ? Container()
            : Positioned(
                child: ClipOval(
                  child: Container(
                    color: colorDisable,
                    padding: EdgeInsets.all(1),
                    child: ClipOval(
                      child: Container(
                        child: AutoSizeText(
                          "${countNumber}",
                          style: getTextStyle(
                            color: colorDisable,
                            fontWeight: FontWeight.w500,
                          ),
                          minFontSize: 6,
                          maxFontSize: 11,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        color: Colors.white,
                        alignment: Alignment.center,
                        width: 18,
                        height: 18,
                        padding: EdgeInsets.only(top: 3),
                      ),
                    ),
                  ),
                ),
                top: 1,
                right: 1,
              )
      ],
    ),
  );
}


commonActionAlbumColorIconButton(VoidCallback callback, Widget icon,
    {bool isGradient, Color viewColor, bool isBadge, int countNumber = 0}) {
  return Container(
    height: 54,
    width: 54,
    child: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          child: ClipOval(
            child: Container(
              child: ClipOval(
                child: InkWell(
                  onTap: () async {
                    callback.call();
                  },
                  child: Container(
                    height: 45,
                    width: 45,
                    padding: EdgeInsets.all(13),
//            color: Colors.white,
                    decoration: BoxDecoration(
                        //color: Colors.white,
                        gradient: getTapBackColorTint(
                            isGradient ?? false, viewColor ?? colorOvalBorder2)),
                    child: InkWell(
                      child: icon,
                    ),
                  ),
                ),
              ),
              padding: EdgeInsets.all(1),
//        color: colorOvalBorder,
              decoration: BoxDecoration(
                  //color: Colors.white,
                  gradient:
                  getTapBackColorTint(isGradient ?? false, Colors.white)),
            ),
          ),
        ),
        isBadge == null && countNumber <= 0
            ? Container()
            : Positioned(
          child: ClipOval(
            child: Container(
              color: colorDisable,
              padding: EdgeInsets.all(1),
              child: ClipOval(
                child: Container(
                  child: AutoSizeText(
                    "${countNumber}",
                    style: getTextStyle(
                      color: colorDisable,
                      fontWeight: FontWeight.w500,
                    ),
                    minFontSize: 6,
                    maxFontSize: 11,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  color: Colors.white,
                  alignment: Alignment.center,
                  width: 18,
                  height: 18,
                  padding: EdgeInsets.only(top: 3),
                ),
              ),
            ),
          ),
          top: 1,
          right: 1,
        )
      ],
    ),
  );
}

commonGradientIconButton(VoidCallback callback, Widget icon,
    {bool isGradient, Color viewColor, bool isBadge}) {
  return Container(
    height: 54,
    width: 54,
    child: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          child: ClipOval(
            child: Container(
              child: ClipOval(
                child: InkWell(
                  onTap: () async {
                    callback.call();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    padding: EdgeInsets.all(15),
//            color: Colors.white,
                    decoration: BoxDecoration(
                        gradient: getTapBackGradientIconColor(
                            isGradient ?? false, viewColor ?? Colors.white)),
                    child: InkWell(
                      child: icon,
                    ),
                  ),
                ),
              ),
              padding: EdgeInsets.all(1),
//        color: colorOvalBorder,
              decoration: BoxDecoration(
                  gradient:
                      getTapBackColor(isGradient ?? false, colorOvalBorder)),
            ),
          ),
        ),
        isBadge == null
            ? Container()
            : Positioned(
                child: ClipOval(
                  child: Container(
                    color: colorDisable,
                    padding: EdgeInsets.all(1),
                    child: ClipOval(
                      child: Container(
                        child: AutoSizeText(
                          "3",
                          style: getTextStyle(
                            color: colorDisable,
                            fontWeight: FontWeight.w500,
                          ),
                          minFontSize: 6,
                          maxFontSize: 11,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        color: Colors.white,
                        alignment: Alignment.center,
                        width: 18,
                        height: 18,
                        padding: EdgeInsets.only(top: 3),
                      ),
                    ),
                  ),
                ),
                top: 1,
                right: 1,
              )
      ],
    ),
  );
}

Widget commonEndView({h}) {
  return Container(height: h ?? 100);
}

Widget commonDurationIndicator(double m, double r, double w) {
  return CircularPercentIndicator(
    radius: r,
    lineWidth: w,
    percent: m,
    animation: false,
    backgroundColor: Color(0x00ffECECEC),
    circularStrokeCap: CircularStrokeCap.square,
    animationDuration: 1000,
    reverse: false,
    animateFromLastPercent: true,
    progressColor: colorSectionHead,
    restartAnimation: false,
  );
}

Widget commonRecordCamDurationIndicator(double m, double r, double w) {
  return CircularPercentIndicator(
    radius: r,
    lineWidth: w,
    percent: m,
    animation: false,
    //backgroundColor: Color(0x00ffECECEC),
    backgroundColor: Colors.transparent,
    circularStrokeCap: CircularStrokeCap.round,
    animationDuration: 1000,
    reverse: false,
    animateFromLastPercent: true,
    progressColor: colorSectionHead,
  );
}

class ImageFromNetworkView extends StatelessWidget {
  String path = "";
  BoxFit boxFit;

  ImageFromNetworkView({this.path, this.boxFit});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: path,
      fit: boxFit ?? BoxFit.contain,
      placeholder: (context, url) => Image.asset(
        App.ic_placeholder,
        fit: boxFit ?? BoxFit.cover,
      ),
      errorWidget: (context, url, error) =>
          Image.asset(App.ic_placeholder, fit: boxFit ?? BoxFit.cover),
    );
  }
}

class ImageCacheCatFromNetworkView extends StatelessWidget {
  String link;
  double w, h;
  Color c;

  ImageCacheCatFromNetworkView(this.link, this.w, this.h, this.c);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: link,
      width: w,
      height: h,
      color: c,
      fit: BoxFit.cover,
      placeholder: (context, url) => Image.asset(
        App.ic_placeholder,
        fit: BoxFit.cover,
        width: w,
        height: h,
      ),
      errorWidget: (context, url, error) => Image.asset(
        App.ic_placeholder,
        fit: BoxFit.cover,
        width: w,
        height: h,
      ),
    );
  }
}

Widget getAlbumThumbIcon(String mediaType, String link,
    {double cHeight,
    double cWidth,
    double textSize,
    double audioImagePadding}) {
  if (mediaType == null) {
    return Container(
      color: Colors.white,
      height: cHeight ?? 50,
      width: cWidth ?? 50,
      padding: EdgeInsets.all(audioImagePadding ?? 18),
      child: Image.asset(
        App.ic_empty_album,
      ),
    );
  } else {
    switch (mediaType) {
      case "AUDIO":
        {
          return Container(
            color: Colors.white,
            height: cHeight ?? 50,
            width: cWidth ?? 50,
            padding: EdgeInsets.all(audioImagePadding ?? 18),
            child: Image.asset(
              App.ic_mic,
            ),
          );
        }
        break;
      case "TEXT":
        {
          return Container(
            color: Colors.white,
            height: cHeight ?? 50,
            width: cWidth ?? 50,
            child: Center(
              child: Text(
                "Abc",
                style: getTextStyle(
                  color: colorSectionHead,
                  size: textSize ?? 15,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          );
        }
        break;
      case "REPOST":
        {
          return Container(
            color: Colors.white,
            height: cHeight ?? 50,
            width: cWidth ?? 50,
            padding: EdgeInsets.all(audioImagePadding ?? 18),
            child: Image.asset(
              App.ic_refresh_album,
            ),
          );
        }
        break;
      case "SONGS":
        {
          return Container(
            color: Colors.white,
            height: cHeight ?? 50,
            width: cWidth ?? 50,
            padding: EdgeInsets.all(audioImagePadding ?? 18),
            child: Image.asset(
              App.ic_music_album,
            ),
          );
        }
        break;

      default:
        {
          return Container(
            height: cHeight ?? 50,
            width: cWidth ?? 50,
            child: ImageFromNetworkView(
              path: link != null ? link : "",
              boxFit: BoxFit.cover,
            ),
          );
        }
        break;
    }
  }
}

String getImageOfContentType(String mediaType) {
  switch (mediaType) {
    case "VIDEO":
      {
        return App.ic_video;
      }
      break;
    case "PHOTO":
      {
        return App.ic_images_album;
      }
      break;
    case "SONGS":
      {
        return App.ic_music_album;
      }
      break;
    case "VTAG":
    case "AUDIO":
      {
        return App.ic_mic;
      }
      break;
    case "TEXT":
      {
        return App.ic_edit_album;
      }
      break;
    default:
      {
        return App.ic_refresh_album;
      }
      break;
  }
}

Future<bool> commonToast(String msg, {String bgColor, String color}) {
  return Fluttertoast.showToast(
    msg: msg ?? "",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: bgColor ?? colorDark,
    textColor: color ?? Colors.white,
    fontSize: 16.0,
  );
}



Widget getCircularIndicatorWithBackSheet({Alignment align}) {
  return Container(
    alignment: align ?? Alignment.topCenter,
    child: Material(
      elevation: 10.0,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 24),
          child: Container(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    ),
  );
}

Widget ImageFromPhotoPostModel(PostPhotoModel postPhotoModel, {BoxFit boxFit}) {
  return postPhotoModel.image != null
      ? Image.file(
          postPhotoModel.image,
          fit: boxFit ?? BoxFit.contain,
        )
      : ImageFromNetworkView(
          path: postPhotoModel.link ?? "",
          boxFit: boxFit,
        );
}

Widget commonDraftWarningCenterWidget() {
  return Column(
    children: <Widget>[
      SizedBox(
        height: 10,
      ),
      Text(
        "Do you want to save this media in your \nDrafts folder, for you to post later ?",
        textAlign: TextAlign.center,
        style: getTextStyle(size: 18, height: 1.5, fontWeight: FontWeight.w600),
      ),
      SizedBox(
        height: 10,
      ),
    ],
  );
}

Widget commonExitWarningCenterWidget() {
  return Column(
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
        "Are you sure\nyou want to exit ?",
        textAlign: TextAlign.center,
        style: getTextStyle(size: 18, height: 1.5, fontWeight: FontWeight.w600),
      ),
      SizedBox(
        height: 34,
      ),
    ],
  );
}

Widget commonTagField(BuildContext context, TextEditingController tagController,
    {List<String> tagStringList,
    List<TagModel> tagList,
    Function(String) onChangeCallback,
    Function(int) onRemoveCallback}) {
  ScrollController controller = ScrollController();
  return Column(
    children: <Widget>[
      Container(
        alignment: Alignment.topLeft,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                constraints: BoxConstraints(
                    minWidth: (MediaQuery.of(context).size.width - 16) * 0.3,
                    maxWidth: MediaQuery.of(context).size.width - 16),
                padding: EdgeInsets.only(left: 2),
                child: TextFormField(
                  controller: tagController,
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration.collapsed(
                    hintText: "Enter tag here",
                    hintStyle:
                        TextStyle(fontSize: 15.0, color: Color(0x00ffC3C3C3)),
                  ),
                  onChanged: (String str) {
                    if (str.isNotEmpty) {
                      if (str.contains(',')) {
                        print('contains comma');
                        str = str.replaceAll(RegExp(r'[,]'), '');
                      }
                    }
                    if (str.length > 0 && str[str.length - 1] == " ") {
                      if (str.trim().length > 0) {
                        onChangeCallback(str.trim());
                        /*controller.animateTo(
                            controller.position.maxScrollExtent,
                            duration: Duration(seconds: 1),
                            curve: Curves.ease);*/
                      }
                    }
                  },
                ),
              ),
            ),
            Container(
              constraints: BoxConstraints(
                minWidth: 0,
                maxWidth: (MediaQuery.of(context).size.width - 16) * 0.6,
                maxHeight: 35,
              ),
              child: ListView.builder(
                //controller: controller,
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemCount: tagList.length,
                shrinkWrap: true,
                itemBuilder: (c, i) {
                  var reversedList = List.from(tagList.reversed);
                  TagModel item = reversedList[i];
                  return Container(
                    padding: EdgeInsets.only(left: 4, right: 4),
                    height: 30,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(
                          color: colorOvalBorder,
                          borderRadius: new BorderRadius.all(
                            Radius.circular(7.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              offset: Offset(0.0, 0.5), //(x,y)
                              blurRadius: 1.0,
                            ),
                          ]),
                      child: Row(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                                top: 2, bottom: 2, left: 6, right: 2),
                            child: Text(
                              item.name,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              onRemoveCallback(i);
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: 4, bottom: 4, left: 2, right: 6),
                              child: Icon(
                                Icons.cancel,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      Container(
        child: Divider(
          color: colorTextPara,
          thickness: 1,
        ),
      ),
    ],
  );
}

dialogImageView(int index, SubAlbumData subAlbumData,{double height,double width}) {
  var arr = subAlbumData.mediaUrls[index].split('@');
  String mediaUrl = arr[1];
  Widget w;
  if (arr[0] == "0") {
    w = Container(
        padding: EdgeInsets.only(top: 2, bottom: 2, left: 2, right: 2),
        child: ImageFromNetworkView(
          path: mediaUrl,
          boxFit: BoxFit.fill,
        ));
  } else {
    w = Container(
      padding: EdgeInsets.all(2),
      child: ClipOval(
        child: Container(
          child: ImageFromNetworkView(
            path: mediaUrl,
            boxFit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
  return w;
}

dialogImageViewDraft(int index, MyDraftMedia subAlbumData,{double height,double width}) {
  //var arr = subAlbumData.isCircle[index].split('@');
  //String mediaUrl = arr[1];
  Widget w;
  if (subAlbumData.isCircle == "false") {
    w = Container(
        //padding: EdgeInsets.only(top: 2, bottom: 2, left: 2, right: 2),
        child:Image.file(
        File(subAlbumData.image),
        fit: BoxFit.fill,
        width: 54,
        height: 54,
      ),);
  } else {
    w = Container(
     // padding: EdgeInsets.all(2),
      child: ClipOval(
        child: Container(
          child:Image.file(
            File(subAlbumData.image),
            fit: BoxFit.fill,
            width: 24,
            height: 24,
          ),
        ),
      ),
    );
  }
  return w;
}
