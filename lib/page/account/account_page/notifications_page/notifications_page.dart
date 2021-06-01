import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:testsylo/model/model.dart';

import '../../../../app.dart';
import 'notifications_page_view_model.dart';

class NotificationsPage extends StatefulWidget {
  @override
  NotificationsPageState createState() => NotificationsPageState();
}

class NotificationsPageState extends State<NotificationsPage> {
  NotificationsPageViewModel model;
  bool pushNotifyStatus;

  @override
  void initState() {
    super.initState();
    model = NotificationsPageViewModel(this);
    pushNotifyStatus = appState.notificationItem.isNotificationOn;
  }

  get notificationSwitchView => Container(
    padding: EdgeInsets.only(left: 16, right: 16),
    child: Row(
      children: <Widget>[
        Text("Push Notification",
        style: getTextStyle(color: Colors.black, size: 16),),
        Expanded(
          child: Container(
            alignment: Alignment.bottomRight,
            child:  Transform.scale( scale: 0.8,
              child: CupertinoSwitch(
              activeColor: colorDark,
              value: pushNotifyStatus,
              onChanged: (bool value) {
                  model.callChangePushNotifySetting(value);
                },
            ),
            ),
          ),
        ),
      ],
    ),
  );

  get notificationListView => ListView.separated(
      physics: BouncingScrollPhysics(),
      itemCount: model.notificationList.length,
      shrinkWrap: true,
      separatorBuilder: (c, i) =>SizedBox(height: 10,),
      padding: EdgeInsets.only(top: 18, bottom: 18, left: 16, right: 16),
      itemBuilder: (c, i) {
        NotificationList notificationItem = model.notificationList[i];
        return Slidable(
              actionPane: SlidableDrawerActionPane(),
              secondaryActions: <Widget>[
                Card(
                  color: Colors.red,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () {
                        model.callDeleteNotification(notificationItem.notifyId);
                      },
                    ),
                  ),
                )
              ],
              key: Key(i.toString()),
                child: Card(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ListTile(
                        leading: ClipOval(
                          child: Container(
                            child: Image.asset(
                              notificationItem.notifyType!=null && notificationItem.notifyType==App.notificationStatus[0]?App.ic_success_noti
                                  :notificationItem.notifyType==App.notificationStatus[1]?App.ic_rejected_noti
                                  :App.ic_update_noti,
                              fit: BoxFit.cover,
                              width: 40,
                              height: 40,
                            ),
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          notificationItem.title??"",
                          style: getTextStyle(color: Colors.black, size: 16),
                        ),
                        subtitle: Text(
                          notificationItem.description??"",
                          style: getTextStyle(color: colorSubTextPera,size: 11),
                        ),
                        /*trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              child: InkWell(
                                child: Image.asset(
                                  notificationItem.readUnread==true ? App.ic_mark_email_read : App.ic_mark_email_unread,
                                  color: notificationItem.readUnread==true ? Colors.green : colorDark,
                                  width:18,
                                  height: 18,
                                ),
                                onTap: () {
                                  model.callMarkReadFlag(!notificationItem.readUnread, notificationItem.notifyId);
                                },
                              ),
                            ),
                          ],
                        ),*/
                      ),
                      Positioned(
                        right: 4,
                        bottom: 18,
                        child: InkWell(
                          child: Container(
                            padding: EdgeInsets.only(left: 2, top: 2),
                            child: Image.asset(
                              notificationItem.readUnread==true ? App.ic_mark_email_read : App.ic_mark_email_unread,
                              color: notificationItem.readUnread==true ? Colors.green : colorDark,
                              width:22,
                              height: 22,
                            ),
                          ),
                          onTap: () {
                            model.callMarkReadFlag(!notificationItem.readUnread, notificationItem.notifyId);
                          },
                        ),
                      )
                    ],
                  ),
                ),
          );
      });

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = NotificationsPageViewModel(this));

    return Scaffold(
      backgroundColor: getColorBg(),
      appBar: AppBar(
        title: Text(
          "Notifications",
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
              notificationSwitchView,
              notificationListView,
            ],
          )),
    );
  }
}
