import 'package:flutter/material.dart';

import '../services/clippers.dart';
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
              child: ClipPath(
                clipper: HeroClipper(35.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment(0.3, 0.6),
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).highlightColor
                        ]),
                  ),
                  child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 100.0),
                      child: Column(children: [
                        Image.asset('assets/bot.png',
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.topCenter,
                            width: 270.0),
                        Text(
                          Settings.introText,
                          style: TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ])),
                ),
              ))
        ]),
        Flexible(
            fit: FlexFit.tight,
            child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 50.0),
                child: Text('loading...',
                    style: TextStyle(
                        fontSize: 25.0, fontWeight: FontWeight.w700))))
      ],
    );
  }
}
