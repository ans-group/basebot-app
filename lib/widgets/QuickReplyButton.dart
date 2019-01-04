import 'package:flutter/material.dart';

import '../config/theme.dart';

class QuickReplyButton extends StatelessWidget {
  QuickReplyButton({this.text, this.action, this.transitionController});
  final String text;
  final Function action;
  final AnimationController transitionController;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: SlideTransition(
            position: new Tween<Offset>(
              begin: const Offset(1.5, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
                parent: this.transitionController, curve: Curves.easeOut)),
            child: FadeTransition(
              opacity: CurvedAnimation(
                  parent: this.transitionController, curve: Curves.easeOut),
              child: Container(
                  margin: EdgeInsets.all(5.0),
                  child: OutlineButton(
                        child: Text(text),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                        color: theme.primaryColor,
                        borderSide: BorderSide(color: theme.primaryColor),
                        highlightColor: theme.primaryColor,
                        highlightedBorderColor: theme.primaryColor,
                        splashColor: theme.primaryColor,
                        textColor: theme.primaryColor,
                        onPressed: action,
                  )
              ),
            )));
  }
}
