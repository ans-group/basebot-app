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
              begin: Alignment.topLeft,
              end: Alignment(0.3, 0.6),
              colors: [
                Color.fromRGBO(220, 220, 220, 1.0),
                Color.fromRGBO(210, 210, 210, 1.0)
              ]),
        ),
        child: Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.width / 17,
                left: MediaQuery.of(context).size.width / 20,
                right: MediaQuery.of(context).size.width / 20),
            child: Row(children: [
              Expanded(
                  child: Text(
                Settings.botName,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 11,
                    fontWeight: FontWeight.bold),
              )),
              CircleAvatar(
                  backgroundImage: AssetImage('assets/bot_icon.jpg'),
                  backgroundColor: Colors.transparent,
                  radius: MediaQuery.of(context).size.width / 15)
            ])),
      ),
    );
  }
}
