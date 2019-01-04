import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../config/credentials.dart';
import './auth.dart';

final auth = Auth();

class DirectLine {
  String _token;

  DirectLine() {
    Timer.periodic(Duration(minutes: 2), (Timer t) => refreshToken(_token));
  }

  Future<String> get token async {
    String token = _token;
    if (token == null) {
      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString('dl_token');
      if (token == null) {
        token = await _generateToken();
      }
    }
    final refreshStatus = await refreshToken(token);
    if (refreshStatus == 403 || refreshStatus == 400) {
      token = await _generateToken();
    }
    return token;
  }

  set token(token) {
    _token = token;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('dl_token', token);
    });
  }

  Future<int> refreshToken(token) async {
    if (token == null) {
      return 0;
    }
    final response = await http.post(
        'https://directline.botframework.com/v3/directline/tokens/refresh',
        headers: {"Authorization": "Bearer $token"});
    return response.statusCode;
  }

  Future<String> _generateToken() async {
    final user = await auth.user;
    final userName = user.displayName;
    final uid = user.uid;
    print('generating token for $userName');
    final generateTokenUrl =
        "https://directline.botframework.com/v3/directline/tokens/generate";
    final secret = Credentials.dlSecret;
    final userData = {"Id": 'dl_$uid', "name": userName};
    final body = {'User': userData};
    final response = await http.post(generateTokenUrl,
        body: json.encode(body),
        headers: {
          "Authorization": "Bearer $secret",
          'Content-Type': 'application/json'
        });
    print(response);
    final responseBody = json.decode(response.body);
    final token = responseBody['token'];
    this.token = token;
    return token;
  }
}
