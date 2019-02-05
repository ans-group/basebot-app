import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../config/settings.dart';

class Auth {
  String _uid;

  Auth() {
    fetchUID();
  }

  fetchUID() async {
    _uid = await this.uid;
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
      final response = await http.get(Settings.registerURI);
      uid = response.body;
      this.uid = uid;
    }
    _uid = uid;
    return uid;
  }
}
