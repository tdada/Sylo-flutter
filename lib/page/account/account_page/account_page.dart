import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/main.dart';
import 'package:testsylo/page/account/account_page/account_page_view_model.dart';

//import 'package:testsylo/page/account/account_page/invite_friend_page/invitefriendpage.dart';
import 'package:testsylo/page/account/account_page/security_page/security_page.dart';
import 'package:testsylo/page/common/logout_page.dart';
import 'package:testsylo/page/common/round_dialog_page.dart';
import 'package:testsylo/page/dashboard/dashboard_page.dart';
import 'package:testsylo/page/home/home_sylo_page.dart';
import 'package:testsylo/util/navigate_effect.dart';
import '../../../app.dart';
import 'billing_page/billing_page.dart';
import 'edit_profile_page/edit_profile_page.dart';
import 'feed_back_page/feed_back_page.dart';
import 'help_info_page/help_info_page.dart';
import 'inactivity_period/inactivity_period_page.dart';
import 'notifications_page/notifications_page.dart';

class AccountPage extends StatefulWidget {

  String from;

  AccountPage({this.from});


  @override
  AccountPageState createState() => AccountPageState();
}




  class AccountPageState extends State<AccountPage> {
  AccountPageViewModel model;

  @override
  void initState() {
    super.initState();

  }

    get profileView =>
        Container(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Row(
            children: <Widget>[
              ClipOval(
                child: Container(
                  child: ClipOval(
                    child: Container(
                      height: 75,
                      width: 75,
                      child: ImageFromNetworkView(
                        path: appState.userItem.profilePic != null ? appState
                            .userItem.profilePic : "",
                        boxFit: BoxFit.cover,
                      ),
                    ),
                  ),
                  padding: EdgeInsets.all(3),
                  color: colorOvalBorder,
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      appState.userItem.username,
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      appState.userItem.email,
                      style: TextStyle(
                          color: colorSubTextPera,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                    editProfilebutton,
                  ],
                ),
              ),
            ],
          ),
        );

    get editProfilebutton =>
        Container(
            width: 80,
            margin: EdgeInsets.only(top: 8),
            child: InkWell(
              child: Material(
                elevation: 0,
                shape:
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Ink(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: colorDark, width: 0.9)),
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(
                        left: 4, right: 4, top: 6, bottom: 4),
                    child: Text(
                      "Edit Profile",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: colorDark,
                          fontWeight: FontWeight.w500,
                          fontSize: 12),
                    ),
                  ),
                ),
              ),
              onTap: () async {
                var result = await Navigator.push(
                    context, NavigatePageRoute(context, EditProfilePage()));
                if (result != null && result) {
                  print("Result --->> $result");
                  setState(() {});
                }
              },
            ));

    get dividerWidget =>
        Divider(
          thickness: 1,
        );


    get dividerView =>
        Container(
          padding: EdgeInsets.only(left: 16, right: 16, top: 16),
          child: dividerWidget,
        );

    get accountActionListView =>
        Container(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: <Widget>[
              listItemView(
                      () async {
                    var result = await Navigator.push(
                        context, NavigatePageRoute(context, BillingPage()));
                  },
                  App.ic_billing_acc, "Billing", true),
              dividerWidget,
              listItemView(
                      () async {
                    var result = await Navigator.push(
                        context,
                        NavigatePageRoute(context, NotificationsPage()));
                    setState(() {});
                  },
                  App.ic_notification_acc, "Notifications", true,),
              dividerWidget,
              listItemView(
                      () async {
                    var result = await Navigator.push(
                        context, NavigatePageRoute(context, SecurityPage()));
                  },
                  App.ic_security_acc, "Security", true),
              dividerWidget,
              listItemView(
                      () async {
                    var result = await Navigator.push(
                        context,
                        NavigatePageRoute(context, InActivityPeriodPage()));
                  },
                  App.ic_inact_acc, "Inactivity Period", true),
              dividerWidget,
              listItemView(
                      ()  {
                    //model.deliverSylos(appState.userItem.userId);
                        /*showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            // return object of type Dialog
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
                              title: Column(
                                children: [
                                  new Image.asset(App.ic_alert_new,height: 24,width: 24,),
                                  SizedBox(height: 10,),
                                  new Text(
                                    "Are you sure you want to deliver this Sylo?",
                                    style: TextStyle(fontWeight: FontWeight.w700),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 20,),
                                  new Text(
                                    "After sending it, it will no longer display on your dashboard. This operation can't be undone.",
                                    style: TextStyle(fontWeight: FontWeight.w700),
                                     textAlign: TextAlign.center,

                                  ),
                                ],
                              ),
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
                                  onPressed: () async {
                                    await model.deliverSylos(appState.userItem.userId);
                                    Navigator.of(context).pop();
                                    //Navigator.pushAndRemoveUntil(context, App.createRoute(page: LogInPage()),(Route<dynamic> route) => false);
                                  },
                                ),
                              ],
                            );
                          },
                        );*/
                        commonMessage(context, "This feature not yet functioning.");

                  },
                  App.ic_deliver_sylo_info, "Deliver Sylos", true),

              dividerWidget,
              listItemView(
                      () async {
                    await FlutterShare.share(
                        title: 'Get Sylo app',
                        text: 'Download Sylo app to receive and send memories from/to your loved ones.',
                        linkUrl: Platform.isIOS
                            ? 'https://apps.apple.com/us/app/mvs-business/id1535043789'
                            : 'https://play.google.com/store/apps/details?id=com.sylo.android',
                        chooserTitle: 'Sylo'
                    );
                  },
                  App.ic_invite_contacts, "Invite Contacts", true),
              dividerWidget,
              listItemView(
                      () async {
                    var result = await Navigator.push(
                        context, NavigatePageRoute(context, HelpInfoPage()));
                  },
                  App.ic_faq, "FAQ", true),
              dividerWidget,
              /*listItemView(
                      () async {
                    var result = await Navigator.push(
                        context, NavigatePageRoute(context, HelpInfoPage()));
                  },
                  App.ic_help_acc, "Help & Info", true),
              dividerWidget,*/
              listItemView(
                      () async {
                    var result = await Navigator.push(
                        context, NavigatePageRoute(context, FeedBackPage()));
                  },
                  App.ic_feedback, "Feedback", true),
              dividerWidget,





              listItemView(
                      () async {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) => LogoutPage(),
                    );
                  },
                  App.ic_logout_acc, "Logout", false),
              dividerWidget,
              SizedBox(height: 80,),
            ],
          ),
        );




    @override
    Widget build(BuildContext context) {
      print("runtimeType -> " + runtimeType.toString());
      model ?? (model = AccountPageViewModel(this));
      return Scaffold(
          backgroundColor: getColorBg(),
          appBar: AppBar(
            title: Text(
              "Account",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 17),
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Colors.white,
          ),
          body: SafeArea(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                Column(
                  children: <Widget>[
                    profileView,
                    dividerView,
                    accountActionListView,
                  ],
                ),
              ],
            ),
          ));
    }

    listItemView(VoidCallback callback, String icon, String title,
        bool showRightArrow, {int notificationCount}) {
      return Container(
        padding: EdgeInsets.only(left: 16, top: 16, bottom: 16),
        child: InkWell(
          child: Row(
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
                    child: Image.asset(icon),
                  )),
              SizedBox(width: 8,),
              Text(title,
                style: getTextStyle(color: Colors.black, size: 14),),
              SizedBox(width: 6),
              notificationCount != null && notificationCount > 0 ?
              ClipOval(
                child: Container(
                  height: 22,
                  width: 22,
                  color: Colors.red[500],
                  padding: EdgeInsets.all(4),
                  child: Center(
                    child: Text(notificationCount.toString(),
                      style: getTextStyle(color: Colors.black, size: 14),),
                  ),
                ),
              )
                  : SizedBox(),
              Expanded(
                child: showRightArrow ? Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.keyboard_arrow_right, size: 26,
                      color: colorSubTextPera,)
                ) : Container(),
              ),
            ],
          ),
          onTap: () {
            callback.call();
          },
        ),
      );
    }
  }

