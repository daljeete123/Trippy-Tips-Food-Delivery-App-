import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trippytip/Widget/CustomAppBar.dart';
import 'package:trippytip/models/Items.dart';
import 'package:trippytip/orders/placeOrder.dart';
import 'package:trippytip/Main/MainScreen.dart';

class Search extends StatefulWidget {
  static String id = 'Search';
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Future<QuerySnapshot> doclist;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          bottom: PreferredSize(
            child: searchWidget(),
            preferredSize: Size(56.0, 56.0),
          ),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: doclist,
          builder: (context, snap) {
            return snap.hasData
                ? ListView.builder(
                    itemCount: snap.data.docs.length,
                    itemBuilder: (context, index) {
                      ItemModel model =
                          ItemModel.fromJson(snap.data.docs[index].data());
                      return sourceInfo(model, context);
                    })
                : Text("No data available.");
          },
        ),
      ),
    );
  }

  Widget searchWidget() {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: 80.0,
      decoration: new BoxDecoration(
        color: Colors.black87,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width - 40.0,
        height: 50.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.search,
                color: Colors.blueGrey,
              ),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: TextField(
                  onChanged: (val) {
                    startSearch(val);
                  },
                  decoration:
                      InputDecoration.collapsed(hintText: "Search here..."),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future startSearch(String query) async {
    doclist = FirebaseFirestore.instance
        .collection("items")
        .where("shortInfo", isGreaterThanOrEqualTo: query)
        .get();
  }
}
