import 'package:flutter/foundation.dart';

import 'auth_session.dart';

class AuthSessionController extends ChangeNotifier {
  AuthSession? _session;

  AuthSession? get session => _session;

  bool get isSignedIn => _session != null;

  void signIn(AuthSession session) {
    _session = session;
    notifyListeners();
  }

  void signOut() {
    if (_session == null) {
      return;
    }

    _session = null;
    notifyListeners();
  }
}
