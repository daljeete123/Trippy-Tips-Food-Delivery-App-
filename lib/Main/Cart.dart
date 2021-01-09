import 'package:flutter/material.dart';
import 'package:trippytip/Main/MainScreen.dart';
import 'package:trippytip/counter/cartItemCounter.dart';
import 'package:provider/provider.dart';
import 'package:trippytip/models/Items.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trippytip/Widget/loadingWidget.dart';
import 'package:trippytip/config/config.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trippytip/Widget/CartFoods.dart';
import 'package:trippytip/models/cartItem.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

double width;

class Cart extends StatelessWidget {
  static String id = 'Cart';
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: new BoxDecoration(
              color: Colors.black,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Route route = MaterialPageRoute(builder: (c) => MainScreen());
              Navigator.pushReplacement(context, route);
            },
          ),
          title: Text(
            "My Cart",
            style: TextStyle(
              color: Colors.white,
              fontSize: 25.0,
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
                        child: Consumer<CartData>(
                          builder: (context, counter, _) {
                            return Text(
                              counter.itemCount.toString(),
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
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Consumer<CartData>(
                builder: (context, cart, _) {
                  return ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (ctx, i) => CartFoods(
                        cart.items.values.toList()[i].id,
                        cart.items.keys.toList()[i],
                        cart.items.values.toList()[i].price,
                        cart.items.values.toList()[i].quantity,
                        cart.items.values.toList()[i].name,
                        cart.items.values.toList()[i].restraunt),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Center(
                child: InkWell(
                  onTap: () => print("Check Out"),
                  child: Container(
                    decoration: new BoxDecoration(
                      color: Colors.lightBlueAccent,
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    child: Center(
                      child: Text(
                        "Check Out",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
