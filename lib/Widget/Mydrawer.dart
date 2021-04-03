import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trippytip/config/config.dart';
import 'package:trippytip/Main/MainScreen.dart';
import 'package:trippytip/orders/myOrders.dart';
import 'package:trippytip/Main/Cart.dart';
import 'package:trippytip/Main/search.dart';
import 'package:trippytip/address/AddNewAddress.dart';
import 'package:trippytip/authentication/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyDrawer extends StatelessWidget {
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 25.0, bottom: 10.0),
            decoration: new BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                Material(
                  borderRadius:
                      BorderRadiusDirectional.all(Radius.circular(80.0)),
                  elevation: 8.0,
                  child: Container(
                    height: 160.0,
                    width: 160.0,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(TrippyTips.sharedPreferences
                          .getString(TrippyTips.userAvatarUrl)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  TrippyTips.sharedPreferences.getString(TrippyTips.userName),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 35.0,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 12.0,
          ),
          Container(
            padding: EdgeInsets.only(top: 1.0),
            decoration: new BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Colors.black,
                  ),
                  title: Text(
                    "Home",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => MainScreen());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(
                  height: 10.0,
                  color: Colors.pink,
                  thickness: 6.0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.reorder,
                    color: Colors.black,
                  ),
                  title: Text(
                    "My Order",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Route route = MaterialPageRoute(builder: (c) => MyOrder());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(
                  height: 10.0,
                  color: Colors.pink,
                  thickness: 6.0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                  ),
                  title: Text(
                    "My Cart",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Route route = MaterialPageRoute(builder: (c) => Cart());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(
                  height: 10.0,
                  color: Colors.pink,
                  thickness: 6.0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  title: Text(
                    "Search Food",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Route route = MaterialPageRoute(builder: (c) => Search());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(
                  height: 10.0,
                  color: Colors.pink,
                  thickness: 6.0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.add_location,
                    color: Colors.black,
                  ),
                  title: Text(
                    "Add New Address",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => addAddress());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(
                  height: 10.0,
                  color: Colors.pink,
                  thickness: 6.0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.exit_to_app,
                    color: Colors.black,
                  ),
                  title: Text(
                    "Logout",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    _auth.signOut().then((c) {
                      Route route = MaterialPageRoute(builder: (c) => Login());
                      Navigator.pushReplacement(context, route);
                    });
                  },
                ),
                Divider(
                  height: 10.0,
                  color: Colors.pink,
                  thickness: 6.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
