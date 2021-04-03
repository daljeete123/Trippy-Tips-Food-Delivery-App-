import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trippytip/Widget/loadingWidget.dart';
import 'package:flutter/services.dart';
import 'package:trippytip/address/address.dart';
import 'package:trippytip/config/config.dart';
import 'package:trippytip/admin/adminOrderCard.dart';
import 'package:trippytip/orders/orderDetailPage.dart';
import 'package:intl/intl.dart';
import 'package:trippytip/models/address.dart';
import 'package:fluttertoast/fluttertoast.dart';

String getOrderId = "";

class adminOrderDetails extends StatelessWidget {
  final String orderId;
  final String orderBy;
  final String addressId;

  adminOrderDetails({Key key, this.orderId, this.addressId, this.orderBy})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    getOrderId = orderId;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection(TrippyTips.collectionOrders)
                .doc(getOrderId)
                .get(),
            builder: (c, snapshot) {
              Map datamap;
              if (snapshot.hasData) {
                datamap = snapshot.data.data();
              }
              return snapshot.hasData
                  ? Container(
                      child: Column(
                        children: [
                          adminStatusBanner(
                            status: datamap[TrippyTips.isSuccess],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "₹" +
                                    datamap[TrippyTips.totalAmount].toString(),
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text("Order Id: " + getOrderId),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(
                              "Ordered at: " +
                                  DateFormat("dd MMMM, yyyy-hh:mm aa").format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(datamap["orderTime"]))),
                            ),
                          ),
                          Divider(
                            height: 2.0,
                          ),
                          FutureBuilder<QuerySnapshot>(
                            future: FirebaseFirestore.instance
                                .collection("items")
                                .where("shortInfo",
                                    whereIn: datamap[TrippyTips.productID])
                                .get(),
                            builder: (c, datasnapshot) {
                              return datasnapshot.hasData
                                  ? adminOrderCard(
                                      itemCount: datasnapshot.data.docs.length,
                                      data: datasnapshot.data.docs,
                                    )
                                  : Center(
                                      child: circularProgress(),
                                    );
                            },
                          ),
                          Divider(
                            height: 2.0,
                          ),
                          FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection(TrippyTips.collectionUser)
                                .doc(orderBy)
                                .collection(TrippyTips.subCollectionAddress)
                                .doc(addressId)
                                .get(),
                            builder: (c, snap) {
                              return snap.hasData
                                  ? adminDeliveryDetails(
                                      model: AddressModel.fromJson(
                                        snap.data.data(),
                                      ),
                                    )
                                  : Center(
                                      child: circularProgress(),
                                    );
                            },
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: circularProgress(),
                    );
            },
          ),
        ),
      ),
    );
  }
}

class adminStatusBanner extends StatelessWidget {
  final bool status;
  adminStatusBanner({Key key, this.status}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String msg;
    IconData iconData;
    status ? iconData = Icons.done : iconData = Icons.cancel;
    status ? msg = "Delivered" : msg = "Not Deliered Yet";
    return Container(
      decoration: new BoxDecoration(
        color: Colors.black,
      ),
      height: 40.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              SystemNavigator.pop();
            },
            child: Container(
              child: Icon(
                Icons.arrow_drop_down_circle,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          Text(
            "Order is " + msg,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            width: 5.0,
          ),
          CircleAvatar(
            radius: 8.0,
            backgroundColor: Colors.grey,
            child: Center(
              child: Icon(
                iconData,
                color: Colors.white,
                size: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class adminDeliveryDetails extends StatelessWidget {
  final AddressModel model;
  adminDeliveryDetails({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: Text(
            "Delivery Details: ",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 90.0, vertical: 5.0),
          width: screenWidth,
          child: Table(
            children: [
              TableRow(children: [
                keyText(
                  msg: "Name",
                ),
                Text(model.name),
              ]),
              TableRow(children: [
                keyText(
                  msg: "Phone Number",
                ),
                Text(model.phoneNumber),
              ]),
              TableRow(children: [
                keyText(
                  msg: "Flat Number",
                ),
                Text(model.flatNumber),
              ]),
              TableRow(children: [
                keyText(
                  msg: "City",
                ),
                Text(model.city),
              ]),
              TableRow(children: [
                keyText(
                  msg: "State",
                ),
                Text(model.state),
              ]),
              TableRow(children: [
                keyText(
                  msg: "Pincode",
                ),
                Text(model.pincode),
              ]),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: InkWell(
              onTap: () {
                confirmFoodDelivered(context, getOrderId);
              },
              child: Container(
                decoration: new BoxDecoration(
                  color: Colors.pink,
                ),
                height: 50.0,
                width: MediaQuery.of(context).size.width - 40.0,
                child: Center(
                  child: Text(
                    "Food Delivered",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  confirmFoodDelivered(BuildContext context, String morderId) {
    FirebaseFirestore.instance
        .collection(TrippyTips.collectionOrders)
        .doc(morderId)
        .delete();
    getOrderId = "";
    SystemNavigator.pop();
    Fluttertoast.showToast(msg: "Order has been Delivered.Confirmed");
  }
}
