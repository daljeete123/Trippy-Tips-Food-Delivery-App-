import 'package:flutter/material.dart';
import 'package:trippytip/Dialog/ErrorDialog.dart';
import 'package:trippytip/Widget/CustomTextField.dart';
import 'package:trippytip/admin/upoadItem.dart';
import 'package:trippytip/authentication/Login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminSignInPage extends StatelessWidget {
  static String id = 'AdminSignInPage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AdminSignInScreen(),
    );
  }
}

class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen> {
  final TextEditingController _adminIDTextEditingController =
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
                      fontSize: 22.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Admin",
                    style: TextStyle(
                      color: Colors.lightBlueAccent,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _adminIDTextEditingController,
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
                    _adminIDTextEditingController.text.isNotEmpty &&
                            _passwordTextEditingController.text.isNotEmpty
                        ? loginAdmin()
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
                    Route route = MaterialPageRoute(builder: (c) => Login());
                    Navigator.pushReplacement(context, route);
                  },
                  icon: (Icon(
                    Icons.nature_people,
                    color: Colors.red,
                  )),
                  label: Text(
                    "I'm not an Admin",
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

  loginAdmin() {
    FirebaseFirestore.instance.collection("admins").get().then((snapshot) {
      snapshot.docs.forEach((result) {
        if (result.get("id") != _adminIDTextEditingController.text.trim()) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Your id is not correct."),
          ));
        } else if (result.get("password") !=
            _passwordTextEditingController.text.trim()) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Your password is not correct."),
          ));
        } else {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Welcome Dear Admin " + result.get("name")),
          ));
          setState(() {
            _adminIDTextEditingController.text = "";
            _passwordTextEditingController.text = "";
          });
          Route route = MaterialPageRoute(builder: (c) => UploadPage());
          Navigator.pushReplacement(context, route);
        }
      });
    });
  }
}
