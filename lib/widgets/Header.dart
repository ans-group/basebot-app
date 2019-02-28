import 'package:flutter/material.dart';

import '../services/clippers.dart';
import '../config/settings.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0.0,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width / 3.7,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(230, 230, 230, 1.0),
                Color.fromRGBO(220, 220, 220, 1.0),
              ]),
        ),
        child: Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.width / 17,
                left: MediaQuery.of(context).size.width / 20,
                right: MediaQuery.of(context).size.width / 20),
            child: Row(children: [
              Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Container(
                      padding:EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width / 15),
                      child: Image.asset('assets/logo.png',
                          fit: BoxFit.fitHeight,
                          alignment: Alignment.centerLeft))),
              CircleAvatar(
                  backgroundImage: AssetImage('assets/bot_icon.png'),
                  backgroundColor: Colors.transparent,
                  radius: MediaQuery.of(context).size.width / 14)
            ])),
      ),
    );
  }
}
