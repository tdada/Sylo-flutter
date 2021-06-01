import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testsylo/page/account/account_page/security_page/security_page_view_model.dart';

import '../../../../app.dart';

class SecurityPage extends StatefulWidget {
  @override
  SecurityPageState createState() => SecurityPageState();
}

class SecurityPageState extends State<SecurityPage> {
  SecurityPageViewModel model;
  bool fingerPrintStatus = false;
  bool faceUnlockStatus = false;

  get dividerView => Container(
    padding: EdgeInsets.only(top: 16, bottom: 16),
    child:Divider(
      thickness: 1,
      color: Color(0xFFFFEEDE),
    ),
  );

  get fingerPrintSwitchView => Container(
    padding: EdgeInsets.only(left: 16, right: 16, top:20),
    child: ListView(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
                height: 38.0,
                width: 38.0,
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                      color: colorOvalBorder,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  padding: EdgeInsets.all(10),
                  child: Image.asset(App.ic_finger_print_security),
                )),
            SizedBox(width: 8,),
            Text("Secure Login",
              style: getTextStyle(color: model.isAvailableInDevice ? Colors.black : colorSubTextPera, size: 14),),
            Expanded(
              child: model.isAvailableInDevice ? Container(
                alignment: Alignment.centerRight,
                child:  Transform.scale( scale: 0.8,
                  child: CupertinoSwitch(
                    activeColor: colorDark,
                    value: fingerPrintStatus,
                    onChanged: (bool value) { model.updateFingerPrintStatus(value); },
                  ),
                ),
              ):Container(),
            ),
          ],
        ),
        dividerView,
        /*Row(
          children: <Widget>[
            Container(
                height: 38.0,
                width: 38.0,
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                      color: colorOvalBorder,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  padding: EdgeInsets.all(10),
                  child: Image.asset(App.ic_face_security),
                )),
            SizedBox(width: 8,),
            Text("Face Unlock",
              style: getTextStyle(color: Colors.black, size: 14),),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child:  Transform.scale( scale: 0.8,
                  child: CupertinoSwitch(
                    activeColor: colorDark,
                    value: faceUnlockStatus,
                    onChanged: (bool value) {
                      model.updateFaceUnlockStatus(value);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        dividerView,*/

      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = SecurityPageViewModel(this));

    return Scaffold(
      backgroundColor: getColorBg(),
      appBar: AppBar(
        title: Text(
          "Security",
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
            shrinkWrap: true,
            children: <Widget>[
              fingerPrintSwitchView,
//              notificationListView,
            ],
          )),
    );
  }
}
