import 'package:flutter/material.dart';

class TotalMoney extends ChangeNotifier {
  double _totalMoney = 0;
  double get totalMoney => _totalMoney;

  display(double no) async {
    _totalMoney = no;
    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}
