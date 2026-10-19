import 'package:flutter/foundation.dart';

enum AppTab { home, plan, log, pantry, discover }

/// Holds the selected bottom-nav tab so any screen can switch tabs.
class ShellViewModel extends ChangeNotifier {
  AppTab _current = AppTab.home;

  AppTab get current => _current;

  void goTo(AppTab tab) {
    if (tab == _current) return;
    _current = tab;
    notifyListeners();
  }
}
