import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:just_debounce_it/just_debounce_it.dart';
import 'dart:convert';
import 'dart:async';

import './auth.dart';
import '../config/settings.dart';

final auth = Auth();

class Conversation {
  String _convoId;
  String pushToken;
  String dlToken;

  Function onMessage;
  Function onQuickReplies;
  Function onAttachments;
  Function onReady;

  Conversation(
      {Function onMessage,
      Function onQuickReplies,
      Function onAttachments,
      Function onReady}) {
    this.onMessage = onMessage;
    this.onQuickReplies = onQuickReplies;
    this.onAttachments = onAttachments;
    this.onReady = onReady;
    _startConversation(
        onMessage: onMessage,
        onQuickReplies: onQuickReplies,
        onAttachments: onAttachments,
        onReady: onReady);
    Timer.periodic(Duration(minutes: 2), (Timer t) => refreshToken());
  }

  void send({text, trigger}) async {
    if (text == null && trigger == null) {
      return;
    }
    final user = await auth.user;
    assert(_convoId != null);
    assert(user != null);

    final from = {
      "id": "dl_${user.uid}",
      "name": user.displayName != "" ? user.displayName : "Anonymous"
    };
    final body = {
      "from": from,
      "pushToken": this.pushToken,
      "authToken": await auth.jwt
    };
    if (text != null) {
      body['type'] = 'message';
      body['text'] = text;
    } else if (trigger != null) {
      body['type'] = 'event';
      body['trigger'] = trigger;
    }
    final postActivityUrl =
        "https://directline.botframework.com/v3/directline/conversations/$_convoId/activities";
    final data = text != null ? text : trigger;
    final type = text != null ? 'text' : 'trigger';
    Debounce.milliseconds(
        900, _postActivity, [postActivityUrl, body, data, type]);
  }

  void _postActivity(url, body, data, type) async {
    final token = this.dlToken;
    assert(token != null);
    final response = await http.post(url, body: json.encode(body), headers: {
      "Authorization": "Bearer $token",
      "Content-Type": 'application/json'
    });
    final responseBody = json.decode(response.body);
    print(responseBody);
    if (responseBody['error'] != null) {
      //something went wrong so we should try start a new conversation
      await _startConversation(
          onMessage: this.onMessage,
          onQuickReplies: this.onQuickReplies,
          onAttachments: this.onAttachments,
          onReady: this.onReady);
      if (type == 'text') {
        send(text: data);
      } else {
        send(trigger: data);
      }
    }
  }

  Future<bool> _startConversation(
      {onMessage, onQuickReplies, onAttachments, onReady}) async {
    final streamUrl = await _getStreamUrl();
    final channel = IOWebSocketChannel.connect(streamUrl);
    assert(channel != null);

    onReady();
    channel.stream.listen((message) {
      if (message != null) {
        try {
          final activities = json.decode(message)['activities'];
          if (activities == null) {
            return false;
          }
          final item = activities[0];
          if (onMessage != null && item['type'] == 'message') {
            final message = {
              "from":
                  item['from']['id'] != null ? item['from']['id'] : 'Anonymous',
              "text": item['text'],
              "typing": item['typing'] != null
            };
            onMessage(message);
            if (onAttachments != null &&
                item['attachments'] != null &&
                item['attachments'].length > 0) {
              item['attachments']
                  .forEach((attachment) => onAttachments(attachment));
            }
          }
          if (onQuickReplies != null &&
              item['quick_replies'] != null &&
              item['quick_replies'].length > 0) {
            onQuickReplies(item['quick_replies']);
          }
        } catch (err) {
          return false;
        }
      }
    });
    return true;
  }

  Future<String> _getStreamUrl() async {
    // final convoId = await this.convoId;
    // final streamUrl = convoId == null ? await _createConversation() : await _reconnectToConversation();
    final streamUrl = await _createConversation();
    assert(streamUrl != null);
    return streamUrl;
  }

  Future<String> _createConversation() async {
    final user = await auth.user;
    final secret = Settings.dlSecret;
    assert(user != null);
    assert(secret != null);
    final uid = user.uid;
    final userData = {"Id": "dl_$uid"};
    final url =
        "https://directline.botframework.com/v3/directline/conversations";

    final response = await http.post(url,
        body: json.encode({"User": userData}),
        headers: {
          "Authorization": "Bearer $secret",
          'Content-Type': 'application/json'
        });
    Map body = json.decode(response.body);
    print(body);
    assert(body['conversationId'] != null);
    assert(body['streamUrl'] != null);
    this.convoId = body['conversationId'];
    this.dlToken = body['token'];
    return body['streamUrl'];
  }

//   Future<String> _reconnectToConversation() async {
//     final secret = Credentials.dlSecret;
//     final convoId = await this.convoId;
//     assert(secret != null);
//     final watermark = await this.watermark;
//     final url =
//         "https://directline.botframework.com/v3/directline/conversations/${convoId}?watermark=${watermark}";

//     final response =
//         await http.get(url, headers: {"Authorization": "Bearer $secret"});
//     final body = json.decode(response.body);
//     return body['streamUrl'];
//   }

  Future<int> refreshToken() async {
    final token = this.dlToken;
    if (token == null) {
      return 0;
    }
    final response = await http.post(
        'https://directline.botframework.com/v3/directline/tokens/refresh',
        headers: {"Authorization": "Bearer $token"});
    return response.statusCode;
  }

  set convoId(convoId) {
    _convoId = convoId;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('convo_id', convoId);
    });
  }

  Future<String> get convoId async {
    if (_convoId != null) {
      return _convoId;
    }
    final prefs = await SharedPreferences.getInstance();
    final conversationId = prefs.getString('convo_id');
    _convoId = conversationId;
    return conversationId;
  }

  set watermark(watermark) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('watermark', watermark);
    });
  }

  Future<String> get watermark async {
    final prefs = await SharedPreferences.getInstance();
    final watermark = prefs.getString('watermark');
    return watermark != null ? watermark : '0';
  }
}
