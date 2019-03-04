import 'package:flutter/material.dart';

import './LoadingDot.dart';
import '../config/settings.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.width * 0.3),
                    child: Column(children: [
                      Image.asset('assets/logo.png',
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.topCenter,
                          width: 220.0),
                      Container(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width * 0.2),
                          child: Image.asset('assets/bot.png',
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width * 0.35)),
                    ])),
              )
            ])),
        Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.width * 0.3),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              LoadingDot(delay: 0.0, size: 20.0),
              LoadingDot(delay: 0.3, size: 20.0),
              LoadingDot(delay: 0.6, size: 20.0),
            ]))
      ],
    );
  }
}
