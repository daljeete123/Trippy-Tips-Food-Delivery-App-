import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trippytip/Main/MainScreen.dart';
import 'package:trippytip/Widget/CustomAppBar.dart';
import 'package:trippytip/config/config.dart';
import 'package:trippytip/models/address.dart';
import 'package:fluttertoast/fluttertoast.dart';

class addAddress extends StatelessWidget {
  static String id = 'addAddress';
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final cName = TextEditingController();
  final cPhoneNumber = TextEditingController();
  final cFlatNumber = TextEditingController();
  final cCity = TextEditingController();
  final cState = TextEditingController();
  final cPinCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: MyAppBar(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (formKey.currentState.validate()) {
              final model = AddressModel(
                name: cName.text.trim(),
                phoneNumber: cPhoneNumber.text,
                city: cCity.text.trim(),
                flatNumber: cFlatNumber.text,
                state: cState.text.trim(),
                pincode: cPinCode.text,
              ).toJson();
              FirebaseFirestore.instance
                  .collection("users")
                  .doc(TrippyTips.sharedPreferences
                      .getString(TrippyTips.userUid))
                  .collection("userAddress")
                  .doc(DateTime.now().microsecondsSinceEpoch.toString())
                  .set(model)
                  .then((value) {
                Fluttertoast.showToast(msg: "New Address added successfully");
                formKey.currentState.reset();
              });
              Route route = MaterialPageRoute(builder: (c) => MainScreen());
              Navigator.pushReplacement(context, route);
            }
          },
          label: Text("Done"),
          backgroundColor: Colors.pink,
          icon: Icon(Icons.check),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Add new address",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    MyTextField(
                      hint: "Name",
                      controller: cName,
                    ),
                    MyTextField(
                      hint: "Phone Number",
                      controller: cPhoneNumber,
                    ),
                    MyTextField(
                      hint: "Hose Number",
                      controller: cFlatNumber,
                    ),
                    MyTextField(
                      hint: "City",
                      controller: cCity,
                    ),
                    MyTextField(
                      hint: "State",
                      controller: cState,
                    ),
                    MyTextField(
                      hint: "Pin Code",
                      controller: cPinCode,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  MyTextField({Key key, this.hint, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration.collapsed(hintText: hint),
        validator: (val) => val.isEmpty ? "Field cannot be empty" : null,
      ),
    );
  }
}
