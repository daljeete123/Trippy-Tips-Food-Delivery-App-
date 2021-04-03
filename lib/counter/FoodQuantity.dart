import 'package:flutter/material.dart';

class FoodQuantity with ChangeNotifier {
  int _numberOfItems = 0;
  int get numberOfItems => _numberOfItems;
  display(int no) {
    _numberOfItems = no;
    notifyListeners();
  }
}
