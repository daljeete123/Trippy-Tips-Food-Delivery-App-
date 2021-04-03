import 'package:flutter/material.dart';
import 'package:trippytip/Dialog/ErrorDialog.dart';
import 'package:trippytip/Dialog/LoadingDialog.dart';
import 'package:trippytip/Widget/CustomTextField.dart';
import 'package:trippytip/admin/adminLogin.dart';
import 'package:trippytip/config/config.dart';
import 'package:trippytip/Main/MainScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatefulWidget {
  static String id = 'Login';
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(25.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    "Trippy Tips",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Login to your account",
                    style: TextStyle(
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _emailTextEditingController,
                        isObscure: false,
                        data: Icons.email,
                        hintText: "Email",
                      ),
                      CustomTextField(
                        controller: _passwordTextEditingController,
                        isObscure: true,
                        data: Icons.person,
                        hintText: "Password",
                      ),
                    ],
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    _emailTextEditingController.text.isNotEmpty &&
                            _passwordTextEditingController.text.isNotEmpty
                        ? loginUser()
                        : showDialog(
                            context: context,
                            builder: (c) {
                              return ErrorAlertDialog(
                                message: "Please write email and password",
                              );
                            });
                  },
                  color: Colors.red,
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Container(
                  height: 4.0,
                  width: _screenWidth * .8,
                  color: Colors.red,
                ),
                SizedBox(
                  height: 10.0,
                ),
                FlatButton.icon(
                  onPressed: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => AdminSignInPage());
                    Navigator.pushReplacement(context, route);
                  },
                  icon: (Icon(
                    Icons.nature_people,
                    color: Colors.red,
                  )),
                  label: Text(
                    "I'm Admin",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void loginUser() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: "Authenticating Please wait...",
          );
        });
    User firebaseUser;
    await _auth
        .signInWithEmailAndPassword(
            email: _emailTextEditingController.text.trim(),
            password: _passwordTextEditingController.text.trim())
        .then((authUser) {
      firebaseUser = authUser.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });
    if (firebaseUser != null) {
      readData(firebaseUser).then((s) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => MainScreen());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future readData(User fUser) async {
    FirebaseFirestore.instance.collection("users").doc(fUser.uid).get().then(
      (dataSnapshot) async {
        await TrippyTips.sharedPreferences.setString(
            TrippyTips.userUid, dataSnapshot.get(TrippyTips.userUid));
        await TrippyTips.sharedPreferences.setString(
            TrippyTips.userEmail, dataSnapshot.get(TrippyTips.userEmail));
        await TrippyTips.sharedPreferences.setString(
            TrippyTips.userName, dataSnapshot.get(TrippyTips.userName));
        await TrippyTips.sharedPreferences.setString(TrippyTips.userAvatarUrl,
            dataSnapshot.get(TrippyTips.userAvatarUrl));
        List<String> cartList =
            dataSnapshot.get(TrippyTips.userCartList).cast<String>();
        await TrippyTips.sharedPreferences
            .setStringList(TrippyTips.userCartList, cartList);
      },
    );
  }
}
