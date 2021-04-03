import 'package:flutter/material.dart';
import 'package:trippytip/Main/MainScreen.dart';
import 'package:trippytip/Widget/CustomAppBar.dart';
import 'package:trippytip/Widget/Mydrawer.dart';
import 'package:trippytip/counter/cartItemCounter.dart';
import 'package:provider/provider.dart';
import 'package:trippytip/main.dart';
import 'package:trippytip/models/Items.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trippytip/Widget/loadingWidget.dart';
import 'package:trippytip/config/config.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:trippytip/counter/totalMoney.dart';
import 'package:trippytip/address/address.dart';
import 'package:trippytip/Widget/CustomAppBar.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  double totalAmount;
  @override
  void initState() {
    super.initState();
    totalAmount = 0;
    Provider.of<TotalMoney>(context, listen: false).display(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (TrippyTips.sharedPreferences
                  .getStringList(TrippyTips.userCartList)
                  .length ==
              1) {
            Fluttertoast.showToast(msg: "Your cart is empty");
          } else {
            Route route = MaterialPageRoute(
                builder: (c) => Address(totalAmount: totalAmount));
            Navigator.pushReplacement(context, route);
          }
        },
        label: Text("Check out"),
        backgroundColor: Colors.pinkAccent,
        icon: Icon(Icons.navigate_next),
      ),
      appBar: MyAppBar(),
      drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Consumer2<TotalMoney, cartItemCounter>(
              builder: (context, amountProvider, cartProvider, c) {
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: cartProvider == 0
                        ? Container()
                        : Text(
                            "Total Price: ₹ ${amountProvider.totalMoney.toString()}",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 20.0),
                          ),
                  ),
                );
              },
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("items")
                .where("shortInfo",
                    whereIn: TrippyTips.sharedPreferences
                        .getStringList(TrippyTips.userCartList))
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? beginbuildingCart()
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          ItemModel model = ItemModel.fromJson(
                              snapshot.data.docs[index].data());
                          if (index == 0) {
                            totalAmount = 0;
                            totalAmount = totalAmount + model.price;
                          } else {
                            totalAmount = totalAmount + model.price;
                          }
                          if (snapshot.data.docs.length - 1 == index) {
                            WidgetsBinding.instance.addPostFrameCallback((t) {
                              Provider.of<TotalMoney>(context, listen: false)
                                  .display(totalAmount);
                            });
                          }
                          return sourceInfo(model, context,
                              removeCartFunction: () =>
                                  removeItemFromUserCart(model.shortInfo));
                        },
                        childCount:
                            snapshot.hasData ? snapshot.data.docs.length : 0,
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }

  beginbuildingCart() {
    return SliverToBoxAdapter(
      child: Card(
        color: Theme.of(context).primaryColor.withOpacity(0.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.insert_emoticon,
              color: Colors.white,
            ),
            Text("Cart is empty"),
            Text("Start adding food on your cart."),
          ],
        ),
      ),
    );
  }

  removeItemFromUserCart(String shortInfoAsId) {
    List tempCartList =
        TrippyTips.sharedPreferences.getStringList(TrippyTips.userCartList);
    tempCartList.remove(shortInfoAsId);

    FirebaseFirestore.instance
        .collection("users")
        .doc(TrippyTips.sharedPreferences.getString(TrippyTips.userUid))
        .update({
      TrippyTips.userCartList: tempCartList,
    }).then((v) {
      Fluttertoast.showToast(msg: "Item removed successfully");

      TrippyTips.sharedPreferences
          .setStringList(TrippyTips.userCartList, tempCartList);
      Provider.of<cartItemCounter>(context, listen: false).displayResult();
      totalAmount = 0;
    });
  }
}
