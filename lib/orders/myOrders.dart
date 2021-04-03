import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trippytip/Widget/CustomAppBar.dart';
import 'package:trippytip/config/config.dart';
import 'package:trippytip/Widget/loadingWidget.dart';
import 'package:trippytip/Widget/orderCard.dart';
import 'dart:async';

class MyOrder extends StatefulWidget {
  static String id = 'MyOrder';
  @override
  _MyOrderState createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          flexibleSpace: Container(
            decoration: new BoxDecoration(
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          title: Text(
            "My Orders",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.arrow_drop_down_circle,
                color: Colors.white,
              ),
              onPressed: () {
                SystemNavigator.pop();
              },
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(TrippyTips.collectionUser)
              .doc(TrippyTips.sharedPreferences.getString(TrippyTips.userUid))
              .collection(TrippyTips.collectionOrders)
              .snapshots(),
          builder: (c, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (c, index) {
                      return FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection("items")
                            .where("shortInfo",
                                whereIn: snapshot.data.docs[index]
                                    .get(TrippyTips.productID))
                            .get(),
                        builder: (c, snap) {
                          return snap.hasData
                              ? orderCard(
                                  itemCount: snap.data.docs.length,
                                  data: snap.data.docs,
                                  orderId: snapshot.data.docs[index].documentID,
                                )
                              : Center(
                                  child: circularProgress(),
                                );
                        },
                      );
                    },
                  )
                : Center(
                    child: circularProgress(),
                  );
          },
        ),
      ),
    );
  }
}
