# Netty App

![Netty Banner](https://i.imgur.com/9hjOCRZ.jpg)

This repo contains the two native IOS and Android apps for Netty - built with [Flutter](https://flutter.io)




Getting Started
---
See Flutter's [getting started guide](https://flutter.io/docs/get-started/install)

You'll also need a copy of `config/credentials.dart`

Project Structure
---

Everything of revelance to development can be found in the **/lib** folder. 

Within that folder you will find the following:

### Widgets
All of the main Flutter widgets go here (they're kinda like React components). 

### Services
These are generally specialised dart classes that handle things like auth, conversation instances etc. It's a good place abstract non-visual logic.

### Config
The first attempts at abstracting some of the project variables. There's only a credentials (not included in repo) and theme file in there currently. 

Libraries Used
---
There's a couple of Flutter packages which aren't worth enumerating here. The key here is understanding [Flutter](https://flutter.io)/[Dart](https://www.dartlang.org/) and you're good to go.

If this is your first Dart project I'd highly recommend taking some time out to learn the language. It really doesn't take long and will make development much easier. The [Language Tour](https://www.dartlang.org/guides/language/language-tour) is a great place to start if you're already fairly comfortable with general programming concepts as it will allow you to get a feel for the syntactical nuances and general language features. 

Happy coding!
