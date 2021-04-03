import 'package:flutter/material.dart';
import 'package:trippytip/authentication/Login.dart';
import 'package:trippytip/authentication/Register.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthenticScreen extends StatefulWidget {
  @override
  _AuthenticScreenState createState() => _AuthenticScreenState();
}

class _AuthenticScreenState extends State<AuthenticScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
            ),
            title: Text(
              "Trippy Tips",
              style: TextStyle(
                fontSize: 50.0,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                  text: "Login",
                ),
                Tab(
                  icon: Icon(
                    Icons.perm_contact_calendar,
                    color: Colors.white,
                  ),
                  text: "Register",
                ),
              ],
              indicatorColor: Colors.white38,
              indicatorWeight: 5.0,
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: TabBarView(
              children: [
                Login(),
                Register(),
              ],
            ),
          ),
        ));
  }
}
