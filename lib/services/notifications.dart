import 'package:firebase_messaging/firebase_messaging.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

Future<String> initNotifications(convo) async {
  final handleNotification = (Map<String, dynamic> message) {
    String trigger = message['trigger'];
    if (message['data'] != null && message['data']['trigger'] != null) {
      trigger = message['data']['trigger'];
    }
    if (trigger == null) return;
    convo.send(trigger: trigger);
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
