import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../config/settings.dart';

class Auth {
  String _uid;

  Auth() {
    fetchUID();
  }

  fetchUID() async {
    _uid = await this.uid;
  }

  Future _register() async {
    var response = await http.get(Settings.registerURI);
    if (response != null &&
        response.body != null &&
        json.decode(response.body)['success']) {
      return json.decode(response.body)['id'];
    } else {
      print('registration failed: retrying');
      sleep(Duration(seconds: 2));
      return _register();
    }
  }

  set uid(uid) {
    _uid = uid;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('uid', uid);
    });
  }

  Future<String> get uid async {
    if (_uid != null) {
      return _uid;
    }
    var prefs = await SharedPreferences.getInstance();
    var uid = prefs.getString('uid');
    if (uid == null) {
      uid = await _register();
      print('got it');
      print(uid);
      this.uid = uid;
    }
    _uid = uid;
    return uid;
  }
}
