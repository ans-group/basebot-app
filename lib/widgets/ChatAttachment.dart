import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../services/iconsByName.dart';

int getColorHexFromStr(String colorStr) {
  colorStr = "FF" + colorStr;
  colorStr = colorStr.replaceAll("#", "");
  int val = 0;
  int len = colorStr.length;
  for (int i = 0; i < len; i++) {
    int hexDigit = colorStr.codeUnitAt(i);
    if (hexDigit >= 48 && hexDigit <= 57) {
      val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
    } else if (hexDigit >= 65 && hexDigit <= 70) {
      // A..F
      val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
    } else if (hexDigit >= 97 && hexDigit <= 102) {
      // a..f
      val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
    } else {
      throw new FormatException("An error occurred when converting a color");
    }
  }
  return val;
}

class LinkButton extends StatelessWidget {
  LinkButton({this.text, this.url});
  final text;
  final url;

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      padding: EdgeInsets.symmetric(vertical: 9.0, horizontal: 19.0),
      child: Text("$text",
          style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
              color: Colors.black)),
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.elliptical(5.0, 5.0))),
      highlightColor: Theme.of(context).highlightColor,
      splashColor: Theme.of(context).splashColor,
      borderSide: BorderSide(color: Theme.of(context).primaryColor),
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

class TitleWithThumb extends StatelessWidget {
  TitleWithThumb({this.title, this.thumb});
  final title;
  final thumb;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(minHeight: 55.0),
        child: Stack(children: [
          Positioned(
            top: 0.0,
            right: 0.0,
            height: 55.0,
            width: 55.0,
            child: AspectRatio(
                aspectRatio: 1.0 / 1.0,
                child: Image.network(thumb, fit: BoxFit.cover)),
          ),
          Container(
              padding: EdgeInsets.only(right: 62.0),
              child: Text(
                title,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ))
        ]));
  }
}

class TitleNoThumb extends StatelessWidget {
  TitleNoThumb({this.title});
  final title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.left,
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      style: TextStyle(
        fontSize: 24.0,
      ),
    );
  }
}

class ChatAttachment extends StatelessWidget {
  ChatAttachment({
    this.title,
    this.image,
    this.buttons,
    this.color,
    this.text,
    this.thumb,
    this.values,
    this.transitionController,
  });
  final transitionController;
  final title;
  final image;
  final buttons;
  final color;
  final text;
  final thumb;
  final values;
  final typing = false;

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
    List<Widget> actions = [];
    if (image != null) {
      attachmentItems.add(Container(
          padding: EdgeInsets.only(bottom: 15.0),
          child: AspectRatio(
              aspectRatio: 15.0 / 8.0,
              child: Image.network(image, fit: BoxFit.cover))));
    }
    if (title != null) {
      attachmentItems.add(Container(
          padding: EdgeInsets.only(bottom: 15.0),
          child: thumb != null && image == null
              ? TitleWithThumb(title: title, thumb: thumb)
              : TitleNoThumb(title: title)));
    }
    if (text != null) {
      attachmentItems.add(Container(
          padding: EdgeInsets.only(bottom: 15.0),
          child: MarkdownBody(data: text)));
    }
    if (values != null) {
      attachmentItems.add(Container(
          padding: EdgeInsets.only(bottom: 15.0),
          child: Wrap(
              spacing: 20.0,
              runSpacing: 4.0,
              direction: Axis.horizontal,
              children: valuePairs)));
    }
    if (buttons != null) {
      buttons.forEach((button) {
        if (button['text'] != null && button['url'] != null) {
          actions.add(LinkButton(text: button['text'], url: button['url']));
        }
      });
      attachmentItems.add(Column(
          crossAxisAlignment: image == null && title == null
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.stretch,
          children: actions));
    }
    return Container(
        margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0, top: 2.0),
        child: SlideTransition(
            position: new Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
                parent: this.transitionController, curve: Curves.easeOut)),
            child: FadeTransition(
                opacity: CurvedAnimation(
                    parent: this.transitionController, curve: Curves.easeOut),
                child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                        border: Border(
                            left: BorderSide(
                                color: color != null
                                    ? Color(getColorHexFromStr(color))
                                    : Colors.black12,
                                width: 5.0))),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: attachmentItems)))));
  }
}
