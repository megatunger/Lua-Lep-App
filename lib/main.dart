import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sentry/flutter_sentry.dart';
import 'package:lualepapp/ui/on_boarding.dart';
import 'package:lualepapp/utils/ads_helper.dart';

import 'blocs/admob_bloc.dart';

Future<void> main() => FlutterSentry.wrap(
      () async {
        runApp(MyApp());
      },
      dsn:
          'https://b0222c59b32743b09cb6c0486b86694e@o353025.ingest.sentry.io/5285504',
    );

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  final Firestore _db = Firestore.instance;

  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  var paddingBottom = 56.0;

  @override
  void initState() {
    admobBloc.showBannerAd(state: false);
    super.initState();
    AdsHelper.showBannerAd();
  }

  @override
  Widget build(BuildContext context) {
    pushMessageInit();
    _saveDeviceToken();
    return MaterialApp(
      title: 'Lúa Lếp',
      debugShowCheckedModeBanner: false,
      builder: (context, widget) {
        return StreamBuilder(
          stream: admobBloc.bannerAdInit,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData && snapshot.data == true) {
              return Container(
                  color: Colors.black,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: paddingBottom),
                    child: SafeArea(child: widget),
                  ));
            }
            return widget;
          },
        );
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: OnBoarding(),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
    );
  }

  void pushMessageInit() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));

    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
    });
  }

  _saveDeviceToken() async {
    final user = await FirebaseAuth.instance.currentUser();
    String uid = user.uid;

    // Get the token for this device
    String fcmToken = await _firebaseMessaging.getToken();

    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = _db
          .collection('users')
          .document(uid)
          .collection('tokens')
          .document(fcmToken);

      await tokens.setData({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(), // optional
        'platform': Platform.operatingSystem // optional
      });
    }
  }
}
