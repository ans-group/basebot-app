import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import './auth.dart';
import './directLine.dart';

final auth = Auth();
final dl = DirectLine();

class Conversation {
  String _convoId;
  String pushToken;

  Conversation(
      {Function onMessage,
      Function onQuickReplies,
      Function onAttachments,
      Function onReady}) {
    _startConversation(
        onMessage: onMessage,
        onQuickReplies: onQuickReplies,
        onAttachments: onAttachments,
        onReady: onReady);
  }

  void send(text) async {
    if (text == null) {
      return;
    }
    final token = await dl.token;
    final user = await auth.user;
    assert(token != null);
    assert(_convoId != null);
    assert(user != null);

    final from = {"id": "dl_${user.uid}", "name": user.displayName};
    final body = {
      "from": from,
      "type": "message",
      "text": text,
      "pushToken": this.pushToken,
      "authToken": await auth.jwt
    };
    final postActivityUrl =
        "https://directline.botframework.com/v3/directline/conversations/$_convoId/activities";
    final response = await http.post(postActivityUrl,
        body: json.encode(body),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": 'application/json'
        });
    print(response.body);
  }

  void _startConversation(
      {onMessage, onQuickReplies, onAttachments, onReady}) async {
    final streamUrl = await _getStreamUrl();
    final channel = IOWebSocketChannel.connect(streamUrl);
    assert(channel != null);

    onReady();
    channel.stream.listen((message) {
      print(message);
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
            if (onQuickReplies != null &&
                item['quick_replies'] != null &&
                item['quick_replies'].length > 0) {
              onQuickReplies(item['quick_replies']);
            }
          }
        } catch (err) {
          print(err);
        }
      }
    });
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
    final token = await dl.token;
    assert(user != null);
    assert(token != null);
    final uid = user.uid;
    final userName = user.displayName;
    final url =
        "https://directline.botframework.com/v3/directline/conversations";

    final response = await http.post(url,
        body: {"User": '{"Id": "dl_$uid", "name": $userName}'},
        headers: {"Authorization": "Bearer $token"});
    Map body = json.decode(response.body);
    assert(body['conversationId'] != null);
    assert(body['streamUrl'] != null);
    this.convoId = body['conversationId'];
    return body['streamUrl'];
  }

//   Future<String> _reconnectToConversation() async {
//     final token = await DirectLine().token;
//     final convoId = await this.convoId;
//     assert(token != null);
//     final watermark = await this.watermark;
//     final url =
//         "https://directline.botframework.com/v3/directline/conversations/${convoId}?watermark=${watermark}";

//     final response =
//         await http.get(url, headers: {"Authorization": "Bearer ${token}"});
//     final body = json.decode(response.body);
//     print(body);
//     return body['streamUrl'];
//   }

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
