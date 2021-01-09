import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:trippytip/config/config.dart';

class cartItemCounter extends ChangeNotifier {
  int _counter = TrippyTips.sharedPreferences
          .getStringList(TrippyTips.userCartList)
          .length -
      1;
  int get count => _counter;
  Future<void> displayResult() async {
    int _counter = TrippyTips.sharedPreferences
            .getStringList(TrippyTips.userCartList)
            .length -
        1;
    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}
