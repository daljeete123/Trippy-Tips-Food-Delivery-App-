import 'package:trippytip/Main/cart.dart';
import 'package:trippytip/counter/cartItemCounter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trippytip/config/config.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final PreferredSizeWidget bottom;
  MyAppBar({this.bottom});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: new BoxDecoration(
          color: Colors.black,
        ),
      ),
      title: Text(
        "trippy tips",
        style: TextStyle(
          color: Colors.white,
          fontSize: 30.0,
        ),
      ),
      centerTitle: true,
      actions: [
        Stack(
          children: [
            IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              onPressed: () {
                Route route = MaterialPageRoute(builder: (c) => Cart());
                Navigator.pushReplacement(context, route);
              },
            ),
            Positioned(
              child: Stack(
                children: [
                  Icon(
                    Icons.brightness_1,
                    size: 20.0,
                    color: Colors.green,
                  ),
                  Positioned(
                    top: 3.0,
                    bottom: 4.0,
                    left: 5.0,
                    child: Consumer<cartItemCounter>(
                      builder: (context, counter, _) {
                        return Text(
                          (TrippyTips.sharedPreferences
                                      .getStringList(TrippyTips.userCartList)
                                      .length -
                                  1)
                              .toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Size get preferredSize => bottom == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}
