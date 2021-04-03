import 'dart:async';
import 'package:flutter/material.dart';
import 'package:trippytip/authentication/Login.dart';
import 'package:trippytip/authentication/Register.dart';
import 'package:trippytip/Widget/RoundButton.dart';
import 'package:trippytip/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:trippytip/counter/FoodQuantity.dart';
import 'package:trippytip/counter/cartItemCounter.dart';
import 'package:trippytip/counter/changeAddress.dart';
import 'package:trippytip/counter/totalMoney.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  TrippyTips.sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c) => cartItemCounter()),
        ChangeNotifierProvider(create: (c) => FoodQuantity()),
        ChangeNotifierProvider(create: (c) => AddressChanger()),
        ChangeNotifierProvider(create: (c) => TotalMoney()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  static String id = 'welcome_screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Trippy Tips",
                  style: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 14.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Food Ordering App",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              title: "Login",
              colour: Colors.lightBlueAccent,
              onPressed: () {
                Route route = MaterialPageRoute(builder: (c) => Login());
                Navigator.pushReplacement(context, route);
              },
            ),
            RoundedButton(
                title: "Register",
                colour: Colors.lightBlueAccent,
                onPressed: () {
                  Route route = MaterialPageRoute(builder: (c) => Register());
                  Navigator.pushReplacement(context, route);
                }),
          ],
        ),
      ),
    );
  }
}
