import 'package:flutter/material.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';

import '../config/theme.dart';
import './LoadingDot.dart';

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
                  mainAxisAlignment: this.name == 'saga'
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(right: 7.0),
                      child: this.name == 'saga'
                          ? CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/netty_icon.jpg'),
                              backgroundColor: theme.primaryColor,
                              radius: 11.0)
                          : null,
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 8.0),
                        constraints: BoxConstraints(
                          maxWidth: 320.0,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment(0.3, 0.6),
                              colors: this.name == 'saga'
                                  ? [Colors.white, Colors.white]
                                  : [
                                      theme.primaryColor,
                                      Color.alphaBlend(
                                          Color.fromRGBO(255, 255, 255, 0.1),
                                          theme.primaryColor)
                                    ]),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        child: this.loading
                            ? Row(mainAxisSize: MainAxisSize.min, children: [
                                LoadingDot(delay: 0.0),
                                LoadingDot(delay: 0.3),
                                LoadingDot(delay: 0.6),
                              ])
                            : Text(text,
                                style: TextStyle(
                                    color: this.name == 'saga'
                                        ? null
                                        : Colors.white))
                        // Markdown is supported by QNA Maker so supporting the rendering of markdown
                        // Could be good, and while the solution below does work, it messes up the width
                        // of the message boxes. So, for the meantime we're just falling back to regular Text
                        // : MarkdownBody(
                        //     data: text,
                        //     styleSheet: MarkdownStyleSheet.fromTheme(
                        //             Theme.of(context))
                        //         .copyWith(
                        //             p: Theme.of(context)
                        //                 .textTheme
                        //                 .body1
                        //                 .copyWith(
                        //                     color: this.name == 'saga' ? null : Colors.white,
                        //                     fontSize: 14.0)),
                        //   )
                        )
                  ],
                ),
              ),
            ));
  }
}
