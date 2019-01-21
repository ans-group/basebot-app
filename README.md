# Basebot App

This repo contains the two native IOS and Android apps for Basebot - built with [Flutter](https://flutter.io)

Setup
---
To get started use the CLI tool:

- `npm i -g @webantic/basebot-cli`
- `basebot create`

---

Customisation & Building
---
The CLI tool will customise the name in various locations when you run `create`.

Aside from that you'll want to spend some time in the `lib/config` folder tweaking the theme and adding any missing credentials (the files you need will be created by the CLI tool). 

**Make sure you change `dlSecret` to a Direct Line secret in `lib/config/settings.dart` or your app won't work**

### Theming
To change the theme - head over to `lib/config/theme.dart`. Changing the colour scheme is a breeze. The 3 main colours you'll need are at the top and are written in a format that's identical to `rgba()` in CSS (for those not familiar with Dart). Everything else should be relatively self-explanatory. See [here](https://flutter.io/docs/cookbook/design/themes) for more info.

### Icons
To update the icons & images just use the ones currently in `play-store-listing` and `assets`. Each file is used for the following:

- **assets/bot_icon.jpg** - launcher icon
- **assets/bot_icon.png** - [adaptive](https://developer.android.com/guide/practices/ui_guidelines/icon_design_adaptive) launcher icon
- **assets/bot.png** The image of the bot to be used in-app
- **play-store-listing/banner** The banner image for the Play Store
- **play-store-listing/icon.png** The Play Store icon
- **play-store-listing/screen1/2/3.jpg** 3 screenshots for the Play Store

### Building
To build, you'll need the following:
- [Flutter SDK](https://flutter.io/docs/get-started/install/macos#get-the-flutter-sdk) (installed by the CLI tool)
- [Android Studio](https://developer.android.com/studio/install) or Android Studio SDKs (Android)
- A [keystore/key](https://flutter.io/docs/deployment/android#signing-the-app) (Android)
- [Xcode](https://flutter.io/docs/get-started/install/macos#install-xcode) (IOS)

When building for the first time you'll want to generate a keystore with:

`keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key` 

You then need to reference it in `android/key.properties` (key alias will be `key` and storeFile will be `~/key.jks` if you ran the commad as above)

Build with `basebot build`

--- 

Development
---
See Flutter's [getting started guide](https://flutter.io/docs/get-started/install)

You'll also need a copy of `config/credentials.dart`

---

Project Structure
---
Everything of revelance to development can be found in the **/lib** folder. 

Within that folder you will find the following:

### Widgets
All of the main Flutter widgets go here (they're kinda like React components). 

### Services
These are generally specialised dart classes that handle things like auth, conversation instances etc. It's a good place abstract non-visual logic.

### Config
The first attempts at abstracting some of the project variables. There's only a settings and theme file in there currently.

---

Libraries Used
---
There's a couple of Flutter packages which aren't worth enumerating here. The key here is understanding [Flutter](https://flutter.io)/[Dart](https://www.dartlang.org/) and you're good to go.

If this is your first Dart project I'd highly recommend taking some time out to learn the language. It really doesn't take long and will make development much easier. The [Language Tour](https://www.dartlang.org/guides/language/language-tour) is a great place to start if you're already fairly comfortable with general programming concepts as it will allow you to get a feel for the syntactical nuances and general language features. 

Happy coding!
