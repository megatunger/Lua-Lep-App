import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lualepapp/ui/on_boarding.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter_sentry/flutter_sentry.dart';

Future<void> main() => FlutterSentry.wrap(
      () async {
        runApp(MyApp());
  },
  dsn: 'https://b0222c59b32743b09cb6c0486b86694e@o353025.ingest.sentry.io/5285504',
);

class MyApp extends StatelessWidget {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  static Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
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
  
  @override
  Widget build(BuildContext context) {
    pushMessageInit();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
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
}
