import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trippytip/config/config.dart';
import 'package:provider/provider.dart';
import 'package:trippytip/counter/cartItemCounter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trippytip/Main/MainScreen.dart';

class PaymentPage extends StatefulWidget {
  final String addressId;
  final double totalAmount;

  PaymentPage({Key key, this.totalAmount, this.addressId}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: new BoxDecoration(
          color: Colors.black,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Image.network(
                  "images/placeOrder.png",
                  height: 180.0,
                  width: 180.0,
                ),
              ),
              SizedBox(height: 10.0),
              FlatButton(
                color: Colors.pinkAccent,
                splashColor: Colors.deepOrange,
                textColor: Colors.white,
                padding: EdgeInsets.all(8.0),
                onPressed: addOrderDetails(),
                child: Text(
                  "Place Order",
                  style: TextStyle(fontSize: 30.0),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  addOrderDetails() {
    writeOrderDetailsForUser({
      TrippyTips.addressID: widget.addressId,
      TrippyTips.totalAmount: widget.totalAmount,
      "orderBy": TrippyTips.sharedPreferences.getString(TrippyTips.userUid),
      TrippyTips.productID:
          TrippyTips.sharedPreferences.getStringList(TrippyTips.userCartList),
      TrippyTips.paymentDetails: "Cash On Delivery",
      TrippyTips.orderTime: DateTime.now().microsecondsSinceEpoch.toString(),
      TrippyTips.isSuccess: true,
    });
    writeOrderDetailsForAdmin({
      TrippyTips.addressID: widget.addressId,
      TrippyTips.totalAmount: widget.totalAmount,
      "orderBy": TrippyTips.sharedPreferences.getString(TrippyTips.userUid),
      TrippyTips.productID:
          TrippyTips.sharedPreferences.getStringList(TrippyTips.userCartList),
      TrippyTips.paymentDetails: "Cash On Delivery",
      TrippyTips.orderTime: DateTime.now().microsecondsSinceEpoch.toString(),
      TrippyTips.isSuccess: true,
    }).whenComplete(() => {
          emptyCartNow(),
        });
  }

  emptyCartNow() {
    TrippyTips.sharedPreferences
        .setStringList(TrippyTips.userCartList, ["garbageValue"]);
    List tempList =
        TrippyTips.sharedPreferences.getStringList(TrippyTips.userCartList);
    FirebaseFirestore.instance
        .collection("users")
        .doc(TrippyTips.sharedPreferences.getString(TrippyTips.userUid))
        .update({
      TrippyTips.userCartList: tempList,
    }).then((value) {
      TrippyTips.sharedPreferences
          .setStringList(TrippyTips.userCartList, tempList);
      Provider.of<cartItemCounter>(context, listen: false).displayResult();
    });
    Fluttertoast.showToast(msg: "Your Order has been successfully placed.");
    Route route = MaterialPageRoute(builder: (c) => MainScreen());
    Navigator.pushReplacement(context, route);
  }

  Future writeOrderDetailsForAdmin(Map<String, dynamic> data) async {
    FirebaseFirestore.instance
        .collection(TrippyTips.collectionOrders)
        .doc(TrippyTips.sharedPreferences.getString(TrippyTips.userUid) +
            data['orderTime'])
        .set(data);
  }

  Future writeOrderDetailsForUser(Map<String, dynamic> data) async {
    FirebaseFirestore.instance
        .collection(TrippyTips.collectionUser)
        .doc(TrippyTips.sharedPreferences.getString(TrippyTips.userUid))
        .collection(TrippyTips.collectionOrders)
        .doc(TrippyTips.sharedPreferences.getString(TrippyTips.userUid) +
            data['orderTime'])
        .set(data);
  }
}
