import 'package:flutter/material.dart';
import 'package:trippytip/Main/MainScreen.dart';
import 'dart:io';
import 'dart:async';
import 'package:trippytip/Widget/CustomTextField.dart';
import 'package:trippytip/Dialog/ErrorDialog.dart';
import 'package:trippytip/Dialog/LoadingDialog.dart';
import 'package:trippytip/config/config.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Register extends StatefulWidget {
  static String id = 'register';
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameTextEditingController =
      TextEditingController();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final TextEditingController _cpasswordTextEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userImageUrl = "";
  File _imageFile;

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
                GestureDetector(
                  onTap: _selectAndPickImage,
                  child: CircleAvatar(
                    radius: _screenWidth * 0.15,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        _imageFile == null ? null : FileImage(_imageFile),
                    child: _imageFile == null
                        ? Icon(
                            Icons.add_photo_alternate,
                            size: _screenWidth * .15,
                            color: Colors.grey,
                          )
                        : null,
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _nameTextEditingController,
                        isObscure: false,
                        data: Icons.person,
                        hintText: "Name",
                      ),
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
                      CustomTextField(
                        controller: _cpasswordTextEditingController,
                        isObscure: true,
                        data: Icons.person,
                        hintText: "Confirm Password",
                      ),
                    ],
                  ),
                ),
                RaisedButton(
                  onPressed: _uploadAndSaveImage,
                  color: Colors.red,
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Container(
                  height: 4.0,
                  width: _screenWidth * .8,
                  color: Colors.red,
                ),
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectAndPickImage() async {
    _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<void> _uploadAndSaveImage() async {
    if (_imageFile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: "Please select an image file.",
            );
          });
    } else {
      _passwordTextEditingController.text ==
              _cpasswordTextEditingController.text
          ? _cpasswordTextEditingController.text.isNotEmpty &&
                  _passwordTextEditingController.text.isNotEmpty &&
                  _nameTextEditingController.text.isNotEmpty &&
                  _emailTextEditingController.text.isNotEmpty
              ? uploadToStorage()
              : displayDialog("Please fill the form completely")
          : displayDialog("Password is not matching");
    }
  }

  displayDialog(String msg) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: msg,
          );
        });
  }

  uploadToStorage() async {
    showDialog(
      context: context,
      builder: (c) {
        return LoadingAlertDialog(
          message: "Registrating Please Wait....",
        );
      },
    );

    String imageFileName = DateTime.now().microsecondsSinceEpoch.toString();
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child(imageFileName);
    UploadTask uploadTask = ref.putFile(_imageFile);
    uploadTask.whenComplete(() async {
      userImageUrl = await ref.getDownloadURL();
      print("111111");
      print(userImageUrl);
      _registerUser();
    }).catchError((onError) {
      print(onError);
    });
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void _registerUser() async {
    User firebaseUser;
    await _auth
        .createUserWithEmailAndPassword(
      email: _emailTextEditingController.text.trim(),
      password: _passwordTextEditingController.text.trim(),
    )
        .then((auth) {
      firebaseUser = auth.user;
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
      saveUserIntoFireStore(firebaseUser).then((value) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => MainScreen());
        Navigator.pushReplacement(context, route);
      });
    }
    return;
  }

  Future saveUserIntoFireStore(User fUser) async {
    FirebaseFirestore.instance.collection("users").doc(fUser.uid).set({
      "uid": fUser.uid,
      "email": fUser.email,
      "name": _nameTextEditingController.text.trim(),
      "url": userImageUrl,
      TrippyTips.userCartList: ["garbageValue"],
    });

    await TrippyTips.sharedPreferences.setString(TrippyTips.userUid, fUser.uid);
    await TrippyTips.sharedPreferences
        .setString(TrippyTips.userEmail, fUser.email);
    await TrippyTips.sharedPreferences
        .setString(TrippyTips.userName, _nameTextEditingController.text);
    await TrippyTips.sharedPreferences
        .setString(TrippyTips.userAvatarUrl, userImageUrl);
    await TrippyTips.sharedPreferences
        .setStringList(TrippyTips.userCartList, ["garbageValue"]);
  }
}
