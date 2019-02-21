import 'package:flutter/material.dart';

import './LoadingDot.dart';
import '../config/settings.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 30.0, vertical: 100.0),
                child: Column(children: [
                  Text(
                    Settings.introText,
                    style: TextStyle(
                        fontSize: 42.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  Container(
                      padding: EdgeInsets.only(top: 70.0),
                      child: Image.asset('assets/bot.png',
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.topCenter,
                          width: 420.0)),
                ])),
          )
        ]),
        Flexible(
            fit: FlexFit.tight,
            child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(bottom: 100.0),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  LoadingDot(delay: 0.0, size: 20.0),
                  LoadingDot(delay: 0.3, size: 20.0),
                  LoadingDot(delay: 0.6, size: 20.0),
                ])))
      ],
    );
  }
}
