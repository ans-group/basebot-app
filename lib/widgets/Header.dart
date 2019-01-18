import 'package:flutter/material.dart';

import '../services/clippers.dart';
import '../config/settings.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 0.0,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width / 4,
        child: Row(children: [
          Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Transform.scale(
                  scale: 1.2,
                  alignment: Alignment.topCenter,
                  child: ClipPath(
                    clipper:
                        HeroClipper(MediaQuery.of(context).size.width / 12),
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
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width / 17),
                          child: Column(children: [
                            Image.asset('assets/bot.png',
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.topCenter,
                                width: MediaQuery.of(context).size.width / 7),
                            Text(
                              Settings.botName.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ])),
                    ),
                  )))
        ]));
  }
}
