import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import './LoadingDot.dart';
import '../config/settings.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage({
    this.text,
    this.name,
    this.typing,
    this.loading,
    this.transitionController,
  });
  final AnimationController transitionController;
  final String text;
  final String name;
  final bool typing;
  final bool loading;
  @override
  Widget build(BuildContext context) {
    return text == null
        ? Text('')
        : SlideTransition(
            position: new Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
                parent: this.transitionController, curve: Curves.easeOut)),
            child: FadeTransition(
              opacity: CurvedAnimation(
                  parent: this.transitionController, curve: Curves.easeOut),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: this.name == Settings.botHandle
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(right: 7.0),
                      child: this.name == Settings.botHandle
                          ? CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/bot_icon.png'),
                              backgroundColor: Colors.transparent,
                              radius: 20.0)
                          : null,
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 8.0),
                        constraints: BoxConstraints(
                          maxWidth: 320.0,
                        ),
                        decoration: BoxDecoration(
                            color: this.loading ? Colors.transparent : (this.name == Settings.botHandle 
                                ? Theme.of(context).primaryColor
                                : Color.fromRGBO(220,220,220,1.0)),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        child: this.loading
                            ? Row(mainAxisSize: MainAxisSize.min, children: [
                                LoadingDot(delay: 0.0),
                                LoadingDot(delay: 0.3),
                                LoadingDot(delay: 0.6),
                              ])
                            : MarkdownBody(
                                data: text,
                                styleSheet: MarkdownStyleSheet.fromTheme(
                                        Theme.of(context))
                                    .copyWith(
                                        p: Theme.of(context)
                                            .textTheme
                                            .body1
                                            .copyWith(
                                                color: this.name != Settings.botHandle
                                                    ? null
                                                    : Colors.white,
                                                fontSize: 14.0)),
                              ))
                  ],
                ),
              ),
            ));
  }
}
