import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

Future<String> initNotifications(handleMessage, handleQuickReplies) async {
  final handleNotification = (Map<String, dynamic> rawMessage) async {
    print("notifaction received: $rawMessage");
    String text = rawMessage['text'];
    List quickReplies = rawMessage['quick_replies'] != null
        ? json.decode(rawMessage['quick_replies'])
        : null;
    if (rawMessage['data'] != null) {
      if (rawMessage['data']['text'] != null) {
        text = rawMessage['data']['text'];
      }
      if (rawMessage['data']['quick_replies'] != null) {
        quickReplies = json.decode(rawMessage['data']['quick_replies']);
      }
    }
    if (rawMessage['notification'] != null &&
        rawMessage['notification']['body'] != null) {
      text = rawMessage['notification']['body'];
    }
    if (text == null) return false;
    final message = {"text": text, "from": 'saga', "typing": false};
    handleMessage(message);
    if (quickReplies != null) {
      handleQuickReplies(quickReplies);
    }
  };
  _firebaseMessaging.configure(
      onMessage: handleNotification,
      onResume: handleNotification,
      onLaunch: handleNotification);
  _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true));
  _firebaseMessaging.onIosSettingsRegistered
      .listen((IosNotificationSettings settings) {
    print("Settings registered: $settings");
  });
  final token = _firebaseMessaging.getToken();
  assert(token != null);
  print("Push Messaging token: $token");
  return token;
}
