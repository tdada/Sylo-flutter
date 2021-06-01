import 'dart:convert';
import 'dart:io';


import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'app.dart';
import 'page/start/start_page.dart';
import 'service/secure_service/service_locator.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.

  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: getColorPrimary(),
    //statusBarBrightness: Brightness.dark,
    statusBarColor: getColorPrimary(),
  ));
  setupLocator();
  /*await Firebase.initializeApp().whenComplete(() => {
    print("When Completed")
  });*/

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(new MyApp()),onError:FirebaseCrashlytics.instance.recordError);
  // runApp(new MyApp());
}

const platform = const MethodChannel('flutter.native/app_route');
RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}



class _MyAppState extends State<MyApp> {

  FirebaseMessaging firebaseMessaging;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();

    initPlatformState();

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    registerNotification();
    configLocalNotification();

  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup(App.revenue_cart_key);

  }

  @override
  Widget build(BuildContext context) {
    /*SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
      Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));*/

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routeObserver],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales:
      [
        Locale('en','GB'),
        Locale('en','US'),
      ],
      title: App.app_name,
      theme: ThemeData(
        primarySwatch: getColorPrimary(),
        brightness: Brightness.light,
        //platform: TargetPlatform.iOS,
        fontFamily: App.font_name,
      ),
      home: StartPage(),
    );
  }


  void registerNotification() {
    //firebaseMessaging.requestNotificationPermissions();
    FirebaseMessaging.instance.getToken().then((t){
      print("Token : ${t ?? ""}");
    });

    /*firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: 1 ');
      showNotification(message);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume:');
      showNotification(message);
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch:');
      showNotification(message);
      return;
    });*/
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: 'ic_logo',
              ),
            ));
      }
    });


  }

  void configLocalNotification() {
    print("configLocalNotification -> ");
    var initializationSettingsAndroid =
    new AndroidInitializationSettings("ic_logo");
    var initializationSettingsIOS = new IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelection);
  }

  Future onSelection(String payLoad) async {

    print("PayLoad data : $payLoad");
    var decode = jsonDecode(payLoad);
    print("decode");
    print(decode["dEmail"]);
    Navigator.pushNamed(context, '/chat');
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text("title"),
        content: Text("body message"),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {


            },
          )
        ],
      ),
    );
  }

  BuildContext context;

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {

    print("onDidReceiveLocalNotification");
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {


            },
          )
        ],
      ),
    );
  }

  void showNotification(Map<String, dynamic> message) async {
    print("show Notification - >");
    print(message);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid ? 'com.sylo.android' : 'com.appsylo',
      'Sylo app',
      'Sylo app',
      playSound: true,
      icon: AndroidInitializationSettings("ic_logo").defaultIcon,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true);
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    print("Local notification -> ");
    await flutterLocalNotificationsPlugin.show(int.parse(message['data']['id']??"0"), message['notification']['title'],
        message['notification']['body'], platformChannelSpecifics,
        payload: json.encode(message));
  }
}


class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
