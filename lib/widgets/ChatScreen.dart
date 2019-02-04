import 'package:flutter/material.dart';
import 'dart:async';

import './Header.dart';
import './Loading.dart';
import './QuickReplyButton.dart';
import './ChatMessage.dart';
import './ChatAttachment.dart';
import '../services/conversation.dart';
import '../services/notifications.dart';
import '../config/settings.dart';

class ChatScreen extends StatefulWidget {
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  Conversation _conversation;
  final ScrollController _scrollController = new ScrollController();
  final TextEditingController _textController = TextEditingController();
  final List _messages = [];
  List<QuickReplyButton> _quickReplies = <QuickReplyButton>[];
  bool _loading = true;

  @override
  initState() {
    super.initState();
    _conversation = Conversation(
        onMessage: _handleMessage,
        onQuickReplies: _handleQuickReplies,
        onAttachments: _handleAttachment,
        onReady: _handleFinishedLoading);
    initNotifications(_conversation).then((pushToken) {
      _conversation.pushToken = pushToken;
    });
  }

  @override
  void dispose() {
    for (var message in _messages) {
      message.transitionController.dispose();
    }
    for (QuickReplyButton quickReply in _quickReplies) {
      quickReply.transitionController.dispose();
    }
    super.dispose();
  }

  void _handleFinishedLoading() {
    setState(() => _loading = false);
  }

  void _handleSubmitted(String text) async {
    _textController.clear();
    _conversation.send(text: text);
  }

  void _handleQuickReplies(List replies) {
    if (replies != null && replies.length > 0) {
      replies.forEach((reply) {
        var quickReplyWidget = QuickReplyButton(
            text: reply['title'],
            action: () => _handleSubmitted(reply['payload']),
            transitionController: AnimationController(
              duration: Duration(milliseconds: 300),
              vsync: this,
            ));
        _quickReplies.insert(0, quickReplyWidget);
        quickReplyWidget.transitionController.forward();
        _updateScroll();
      });
    }
  }

  void _handleAttachment(Map item) {
    print("handling attachment: $item");
    final title = item['title'];
    final image = item['image'];
    final buttons = item['buttons'];
    final thumb = item['thumb'];
    final text = item['text'];
    final color = item['color'];
    final values = item['values'];
    ChatAttachment attachment = ChatAttachment(
        title: title,
        image: image,
        text: text,
        color: color,
        thumb: thumb,
        buttons: buttons,
        values: values,
        transitionController: AnimationController(
          duration: Duration(milliseconds: 300),
          vsync: this,
        ));
    setState(() {
      _messages.insert(_messages.length, attachment);
    });
    attachment.transitionController.forward();
    _updateScroll();
  }

  void _handleMessage(Map item) {
    final name = item['from'];
    final text = item['text'];
    final typing = item['typing'];
    _quickReplies.clear();
    ChatMessage message = ChatMessage(
      text: text,
      name: name,
      typing: typing,
      loading: false,
      transitionController: AnimationController(
        duration: Duration(milliseconds: 300),
        vsync: this,
      ),
    );
    setState(() {
      _messages.insert(_messages.length, message);
    });
    message.transitionController.forward();
    _updateScroll();
  }

  void _updateScroll() {
    var scrollPosition = _scrollController.position;
    //FIXME: shitty workaround for this race condition
    Timer(Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        scrollPosition.maxScrollExtent,
        duration: new Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.only(left: 15.0, right: 5.0),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration:
                  InputDecoration.collapsed(hintText: "Ask me a question..."),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 4.0),
            child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => _handleSubmitted(_textController.text)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(246, 247, 247, 1.0),
        body: IconTheme(
            data: IconThemeData(color: Theme.of(context).primaryColor),
            child: _loading
                ? Loading()
                : Stack(children: [
                    Column(children: [
                      Flexible(
                          child: ListView.builder(
                        padding: new EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 130.0),
                        controller: _scrollController,
                        // reverse: true,
                        itemBuilder: (_, int index) {
                          print('MESSAGES: $_messages');
                          if ((index + 1) > _messages.length) {
                            if (_messages.length > 0 &&
                                _messages[_messages.length - 1].typing) {
                              ChatMessage _message = ChatMessage(
                                text: 'typing',
                                name: Settings.botHandle,
                                typing: true,
                                loading: true,
                                transitionController:
                                    _messages[0].transitionController,
                              );
                              return _message;
                            }
                          } else {
                            return _messages[index];
                          }
                        },
                        itemCount:
                            _messages.length > 0 ? _messages.length + 1 : 0,
                      )),
                      Container(
                          height: _quickReplies.length > 0 ? 65.0 : 0.0,
                          alignment: Alignment.centerRight,
                          child: ListView(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              children: _quickReplies
                                  .map((reply) => reply)
                                  .toList())),
                      Divider(
                          height: 1.0,
                          color: Color.fromRGBO(229, 230, 230, 1.0)),
                      Container(
                          decoration:
                              BoxDecoration(color: Theme.of(context).cardColor),
                          child: _buildTextComposer())
                    ]),
                    Header()
                  ])));
  }
}
