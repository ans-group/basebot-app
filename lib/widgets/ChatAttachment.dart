import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/iconsByName.dart';
import '../config/theme.dart';

class ChatAttachment extends StatelessWidget {
  ChatAttachment({
    this.title,
    this.image,
    this.link,
    this.values,
    this.transitionController,
  });
  final transitionController;
  final title;
  final image;
  final link;
  final values;
  final typing = false;
  @override
  Widget build(BuildContext context) {
    List<Widget> valuePairs = values.map<Widget>((item) {
      return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            item['type'] == 'icon'
                ? Icon(iconsByName[item['key']])
                : Text("${item['key']}:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
            Text(" ${item['value']}")
          ]);
    }).toList();
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        child: SlideTransition(
            position: new Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
                parent: this.transitionController, curve: Curves.easeOut)),
            child: FadeTransition(
              opacity: CurvedAnimation(
                  parent: this.transitionController, curve: Curves.easeOut),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  child: Container(
                      padding: EdgeInsets.all(0.0),
                      constraints: BoxConstraints(
                        maxWidth: 320.0,
                      ),
                      decoration: BoxDecoration(color: Colors.white),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AspectRatio(
                              aspectRatio: 15.0 / 8.0,
                              child: Image.network(image, fit: BoxFit.cover),
                            ),
                            Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 15.0),
                                child: Text(
                                  title,
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontSize: 24.0,
                                  ),
                                )),
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Wrap(
                                    spacing: 20.0,
                                    runSpacing: 4.0,
                                    direction: Axis.horizontal,
                                    children: valuePairs)),
                            Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(
                                    right: 10.0,
                                    left: 10.0,
                                    bottom: 15.0,
                                    top: 35.0),
                                child: RaisedButton(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 9.0, horizontal: 19.0),
                                  child: Text("${link['text']}",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w400)),
                                  color: theme.primaryColor,
                                  highlightColor: theme.primaryColor,
                                  splashColor: Colors.white,
                                  textColor: Colors.white,
                                  onPressed: () async {
                                    var url = link['url'];
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    }
                                  },
                                ))
                          ]))),
            )));
  }
}
