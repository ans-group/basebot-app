import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

import '../services/iconsByName.dart';

class LinkButton extends StatelessWidget {
  LinkButton({this.text, this.url});
  final text;
  final url;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.symmetric(vertical: 9.0, horizontal: 19.0),
      child: Text("$text",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400)),
      color: Theme.of(context).primaryColor,
      highlightColor: Theme.of(context).highlightColor,
      splashColor: Theme.of(context).splashColor,
      textTheme: Theme.of(context).buttonTheme.textTheme,
      onPressed: () async {
        try {
          await launch(
            url,
            option: new CustomTabsOption(
                toolbarColor: Theme.of(context).primaryColor,
                enableDefaultShare: true,
                enableUrlBarHiding: true,
                showPageTitle: true,
                animation: new CustomTabsAnimation.slideIn()),
          );
        } catch (e) {
          // An exception is thrown if browser app is not installed on Android device.
          print(e.toString());
        }
      },
    );
  }
}

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
  bool shouldShowButtonOnly() {
    return title == null &&
        image == null &&
        link != null &&
        link['url'] != null &&
        link['text'] != null &&
        values == null;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> valuePairs = values == null
        ? []
        : values.map<Widget>((item) {
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
    List<Widget> attachmentItems = [];
    if (image != null) {
      attachmentItems.add(AspectRatio(
          aspectRatio: 15.0 / 8.0,
          child: Image.network(image, fit: BoxFit.cover)));
    }
    if (title != null) {
      attachmentItems.add(Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
          child: Text(
            title,
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
              fontSize: 24.0,
            ),
          )));
    }
    if (values != null) {
      attachmentItems.add(Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Wrap(
              spacing: 20.0,
              runSpacing: 4.0,
              direction: Axis.horizontal,
              children: valuePairs)));
    }
    if (link != null && link['url'] != null && link['text'] != null) {
      attachmentItems.add(Container(
          alignment: Alignment.center,
          padding:
              EdgeInsets.only(right: 10.0, left: 10.0, bottom: 15.0, top: 35.0),
          child: LinkButton(text: link['text'], url: link['url'])));
    }
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
              child: shouldShowButtonOnly()
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Container(
                              width: 200.0,
                              child: LinkButton(
                                  text: link['text'], url: link['url']))
                        ])
                  : ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      child: Container(
                          padding: EdgeInsets.all(0.0),
                          constraints: BoxConstraints(
                            maxWidth: 320.0,
                          ),
                          decoration: BoxDecoration(color: Colors.white),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: attachmentItems))),
            )));
  }
}
