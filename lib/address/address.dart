import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trippytip/Widget/CustomAppBar.dart';
import 'package:trippytip/Widget/WideButton.dart';
import 'package:trippytip/address/AddNewAddress.dart';
import 'package:trippytip/config/config.dart';
import 'package:trippytip/counter/changeAddress.dart';
import 'package:trippytip/models/address.dart';
import 'package:provider/provider.dart';
import 'package:trippytip/orders/placeOrder.dart';
import 'package:trippytip/Widget/loadingWidget.dart';

class Address extends StatefulWidget {
  final double totalAmount;
  const Address({Key key, this.totalAmount}) : super(key: key);
  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: MyAppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Select Address",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
              ),
            ),
            Consumer<AddressChanger>(builder: (context, address, c) {
              return Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection(TrippyTips.collectionUser)
                      .doc(TrippyTips.sharedPreferences
                          .getString(TrippyTips.userUid))
                      .collection(TrippyTips.subCollectionAddress)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return !snapshot.hasData
                        ? Center(
                            child: circularProgress(),
                          )
                        : snapshot.data.docs.length == 0
                            ? noAddressCard()
                            : ListView.builder(
                                itemCount: snapshot.data.docs.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return AddressCard(
                                    currentIndex: address.count,
                                    value: index,
                                    addressId:
                                        snapshot.data.docs[index].documentID,
                                    totalAmount: widget.totalAmount,
                                    model: AddressModel.fromJson(
                                        snapshot.data.docs[index].data()),
                                  );
                                },
                              );
                  },
                ),
              );
            }),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Route route = MaterialPageRoute(builder: (c) => addAddress());
            Navigator.pushReplacement(context, route);
          },
          backgroundColor: Colors.pink,
          icon: Icon(Icons.add_location),
          label: Text("Add new address"),
        ),
      ),
    );
  }

  noAddressCard() {
    return Card(
      color: Colors.pink.withOpacity(0.5),
      child: Container(
        height: 100.0,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_location,
              color: Colors.white,
            ),
            Text("No address has been saved."),
            Text("Please add address"),
          ],
        ),
      ),
    );
  }
}

class AddressCard extends StatefulWidget {
  final AddressModel model;
  final String addressId;
  final int currentIndex;
  final int value;
  final double totalAmount;

  AddressCard(
      {Key key,
      this.totalAmount,
      this.model,
      this.addressId,
      this.currentIndex,
      this.value})
      : super(key: key);

  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        Provider.of<AddressChanger>(context, listen: false)
            .displayResult(widget.value);
      },
      child: Card(
        color: Colors.pinkAccent.withOpacity(0.4),
        child: Column(
          children: [
            Row(
              children: [
                Radio(
                  value: widget.value,
                  groupValue: widget.currentIndex,
                  activeColor: Colors.pink,
                  onChanged: (val) {
                    Provider.of<AddressChanger>(context, listen: false)
                        .displayResult(val);
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      width: screenWidth * 0.8,
                      child: Table(
                        children: [
                          TableRow(children: [
                            keyText(
                              msg: "Name",
                            ),
                            Text(widget.model.name),
                          ]),
                          TableRow(children: [
                            keyText(
                              msg: "Phone Number",
                            ),
                            Text(widget.model.phoneNumber),
                          ]),
                          TableRow(children: [
                            keyText(
                              msg: "Flat Number",
                            ),
                            Text(widget.model.flatNumber),
                          ]),
                          TableRow(children: [
                            keyText(
                              msg: "City",
                            ),
                            Text(widget.model.city),
                          ]),
                          TableRow(children: [
                            keyText(
                              msg: "State",
                            ),
                            Text(widget.model.state),
                          ]),
                          TableRow(children: [
                            keyText(
                              msg: "Pincode",
                            ),
                            Text(widget.model.pincode),
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            widget.value == Provider.of<AddressChanger>(context).count
                ? WideButton(
                    msg: "Proceed",
                    onpressed: () {
                      Route route = MaterialPageRoute(
                          builder: (c) => PaymentPage(
                                totalAmount: widget.totalAmount,
                                addressId: widget.addressId,
                              ));
                      Navigator.pushReplacement(context, route);
                    },
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class keyText extends StatelessWidget {
  final String msg;
  keyText({Key key, this.msg}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      msg,
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    );
  }
}
