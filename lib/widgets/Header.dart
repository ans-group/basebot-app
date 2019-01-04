import 'package:flutter/material.dart';

import '../services/clippers.dart';
import '../config/theme.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: ClipPath(
            clipper: HeroClipper(),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment(0.3, 0.6),
                    colors: [
                      theme.primaryColor,
                      Color.fromRGBO(237, 101, 47, 1.0)
                    ]),
              ),
              child: Container(
                  padding: EdgeInsets.only(top: 29.0, bottom: 50.0),
                  child: Column(children: [
                    Image.asset('assets/netty.png',
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.topCenter,
                        width: 70.0),
                    Text(
                      'NETTY',
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ])),
            ),
          ))
    ]);
  }
}
