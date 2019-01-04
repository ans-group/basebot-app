import 'package:firebase_messaging/firebase_messaging.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

Future<String> initNotifications() async {
  _firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) async {
    print("onMessage: $message");
    print(message);
  });
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
