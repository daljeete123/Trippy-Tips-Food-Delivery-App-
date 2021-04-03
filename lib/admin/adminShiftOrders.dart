import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trippytip/Widget/loadingWidget.dart';
import 'package:flutter/services.dart';
import 'package:trippytip/config/config.dart';
import 'package:trippytip/admin/adminOrderCard.dart';

class AdminShiftOrders extends StatefulWidget {
  @override
  _AdminShiftOrdersState createState() => _AdminShiftOrdersState();
}

class _AdminShiftOrdersState extends State<AdminShiftOrders> {
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
            "Orders",
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
          stream: FirebaseFirestore.instance.collection("orders").snapshots(),
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
                              ? adminOrderCard(
                                  itemCount: snap.data.docs.length,
                                  data: snap.data.docs,
                                  orderId: snapshot.data.docs[index].documentID,
                                  orderBy:
                                      snapshot.data.docs[index].get("orderBy"),
                                  addressId: snapshot.data.docs[index]
                                      .get("addressID"),
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
