import 'package:firebase_messaging/firebase_messaging.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

Future<String> initNotifications(handleMessage) async {
  final handleNotification = (Map<String, dynamic> rawMessage) async {
    print("onMessage: $rawMessage");
    String text = rawMessage['text'];
    if (rawMessage['data'] != null && rawMessage['data']['text'] != null) {
      text = rawMessage['data']['text'];
    }
    if (rawMessage['notification'] != null &&
        rawMessage['notification']['body'] != null) {
      text = rawMessage['notification']['body'];
    }
    if (text == null) return false;
    final message = {"text": text, "from": 'saga', "typing": false};
    handleMessage(message);
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
