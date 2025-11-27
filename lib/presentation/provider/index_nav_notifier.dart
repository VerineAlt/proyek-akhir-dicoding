import 'package:flutter/widgets.dart';

class IndexNavNotifier extends ChangeNotifier {
  int _indexBottomNavBar = 0;
  int get indexBottomNavBar => _indexBottomNavBar;

  set setIndextBottomNavBar(int value) {
    _indexBottomNavBar = value;
    notifyListeners();
  }
}
