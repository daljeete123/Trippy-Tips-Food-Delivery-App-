import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trippytip/admin/adminOrderDetails.dart';
import 'package:trippytip/Widget/orderCard.dart';
import 'package:trippytip/models/Items.dart';

int counter = 0;

class adminOrderCard extends StatelessWidget {
  final int itemCount;
  final String orderId;
  final List<DocumentSnapshot> data;
  final String addressId;
  final String orderBy;

  adminOrderCard(
      {Key key,
      this.itemCount,
      this.orderId,
      this.data,
      this.addressId,
      this.orderBy})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Route route;
        if (counter == 0) {
          counter++;
          route = MaterialPageRoute(
              builder: (c) => adminOrderDetails(
                    orderId: orderId,
                    orderBy: orderBy,
                    addressId: addressId,
                  ));
        }
        Navigator.pushReplacement(context, route);
      },
      child: Container(
        decoration: new BoxDecoration(
          color: Colors.pinkAccent,
        ),
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(10.0),
        height: itemCount * 190.0,
        child: ListView.builder(
          itemCount: itemCount,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (c, index) {
            ItemModel model = ItemModel.fromJson(data[index].data());
            return sourceOrderInfo(model, context);
          },
        ),
      ),
    );
  }
}
