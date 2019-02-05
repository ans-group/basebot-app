import 'package:flutter/material.dart';

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
                  margin: EdgeInsets.only(
                      left: 4.0, right: 6.0, top: 15.0, bottom: 12.0),
                  child: OutlineButton(
                    child: Text(text),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    color: Theme.of(context).primaryColor,
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                    highlightColor: Theme.of(context).highlightColor,
                    highlightedBorderColor: Theme.of(context).highlightColor,
                    splashColor: Theme.of(context).splashColor,
                    textColor: Theme.of(context).primaryColor,
                    onPressed: action,
                  )),
            )));
  }
}
