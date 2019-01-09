import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

Future<String> initNotifications(convo) async {
  final handleNotification = (Map<String, dynamic> message) {
    String trigger = message['trigger'];
    List quickReplies = message['quick_replies'] != null
        ? json.decode(message['quick_replies'])
        : null;
    if (message['data'] != null) {
      if (message['data']['trigger'] != null) {
        trigger = message['data']['trigger'];
      }
      if (message['data']['quick_replies'] != null) {
        quickReplies = json.decode(message['data']['quick_replies']);
      }
    }
    if (trigger == null) return;
    convo.sendEvent(trigger, quickReplies: quickReplies);
  };
  _firebaseMessaging.configure(
      onMessage: handleNotification,
      onResume: handleNotification,
      onLaunch: handleNotification);
  _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true));
  _firebaseMessaging.onIosSettingsRegistered
      .listen((IosNotificationSettings settings) {});
  final token = _firebaseMessaging.getToken();
  assert(token != null);
  return token;
}
