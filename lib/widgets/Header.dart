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
                        HeroClipper(MediaQuery.of(context).size.width / 8),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment(0.3, 0.6),
                            colors: [
                              Color.fromRGBO(220,220,220,1.0),
                                Color.fromRGBO(210,210,210,1.0)
                            ]),
                      ),
                      child: Container(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width / 17),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            Text(
                              Settings.botName.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 23.0,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ])),
                    ),
                  )))
        ]));
  }
}
