import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _user;
  String _jwt;

  Future<FirebaseUser> get user async {
    if (_user != null) {
      return _user;
    } else {
      final user = await _signInAnonymouslyIfNeeded();
      _user = user;
      return user;
    }
  }

  Future<String> get jwt async {
    if (_jwt != null) {
      return _jwt;
    } else {
      final user = await this.user;
      final jwt = await user.getIdToken(refresh: true);
      _jwt = jwt;
      return jwt;
    }
  }

  Future<FirebaseUser> _signInAnonymouslyIfNeeded() async {
    var currentUser = await _auth.currentUser();
    if (currentUser != null) {
      return currentUser;
    }
    final FirebaseUser user = await _auth.signInAnonymously();
    assert(user != null);
    assert(user.isAnonymous);
    assert(!user.isEmailVerified);
    assert(await user.getIdToken() != null);

    currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return user;
  }
}
