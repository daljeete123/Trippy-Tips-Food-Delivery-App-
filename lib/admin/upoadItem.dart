import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trippytip/admin/adminShiftOrders.dart';
import 'package:trippytip/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trippytip/Widget/loadingWidget.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadPage extends StatefulWidget {
  static String id = 'UploadPage';
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  TextEditingController _restrauntNameTextEditingController =
      TextEditingController();
  TextEditingController _titleTextEditingController = TextEditingController();
  TextEditingController _priceTextEditingController = TextEditingController();
  TextEditingController _addressTextEditingController = TextEditingController();
  TextEditingController _shortInfoTextEditingController =
      TextEditingController();
  String foodId = DateTime.now().microsecondsSinceEpoch.toString();
  bool uploading = false;
  File file;
  String downloadUrl = "";

  @override
  Widget build(BuildContext context) {
    return file == null ? displayAdminHomeScreen() : AdminFormScreen();
  }

  displayAdminHomeScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.border_color,
            color: Colors.white,
          ),
          onPressed: () {
            Route route = MaterialPageRoute(builder: (c) => AdminShiftOrders());
            Navigator.pushReplacement(context, route);
          },
        ),
        actions: [
          FlatButton(
            child: Text(
              "Logout",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Route route = MaterialPageRoute(builder: (c) => SplashScreen());
              Navigator.pushReplacement(context, route);
            },
          ),
        ],
      ),
      body: getAdminHomeScreenBody(),
    );
  }

  getAdminHomeScreenBody() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shop_two,
              color: Colors.black26,
              size: 200.0,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9.0)),
                child: Text(
                  "Add New Items",
                  style: TextStyle(color: Colors.black, fontSize: 20.0),
                ),
                color: Colors.lightBlueAccent,
                onPressed: () => takeImage(context),
              ),
            )
          ],
        ),
      ),
    );
  }

  takeImage(mContext) {
    return showDialog(
      context: mContext,
      builder: (con) {
        return SimpleDialog(
          title: Text(
            "Item Image",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            SimpleDialogOption(
              child: Text(
                "Upload with Camera",
              ),
              onPressed: capturePhotoWithCamera,
            ),
            SimpleDialogOption(
              child: Text(
                "Select From Gallery",
              ),
              onPressed: PickPhotoFromGallery,
            ),
            SimpleDialogOption(
                child: Text(
                  "Cancel",
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
        );
      },
    );
  }

  capturePhotoWithCamera() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 680.0,
      maxWidth: 970.0,
    );
    setState(() {
      file = imageFile;
    });
  }

  PickPhotoFromGallery() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      file = imageFile;
    });
  }

  AdminFormScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: clearFormInfo,
        ),
        title: Text(
          "New Product",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24.0),
        ),
        actions: [
          FlatButton(
              onPressed: uploading ? null : () => uploadImageAndSaveInfo(),
              child: Text(
                "Add",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              )),
        ],
      ),
      body: ListView(
        children: [
          uploading ? circularProgress() : Text(""),
          Container(
            height: 230.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(file),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12.0),
          ),
          ListTile(
            leading: Icon(
              Icons.perm_device_information,
              color: Colors.pink,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(
                  color: Colors.deepPurpleAccent,
                ),
                controller: _shortInfoTextEditingController,
                decoration: InputDecoration(
                  hintText: "Short Info",
                  helperStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.pink,
          ),
          ListTile(
            leading: Icon(
              Icons.perm_device_information,
              color: Colors.pink,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(
                  color: Colors.deepPurpleAccent,
                ),
                controller: _titleTextEditingController,
                decoration: InputDecoration(
                  hintText: "Title",
                  helperStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.pink,
          ),
          ListTile(
            leading: Icon(
              Icons.perm_device_information,
              color: Colors.pink,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                keyboardType: TextInputType.number,
                style: TextStyle(
                  color: Colors.deepPurpleAccent,
                ),
                controller: _priceTextEditingController,
                decoration: InputDecoration(
                  hintText: "Price",
                  helperStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.pink,
          ),
          ListTile(
            leading: Icon(
              Icons.perm_device_information,
              color: Colors.pink,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(
                  color: Colors.deepPurpleAccent,
                ),
                controller: _restrauntNameTextEditingController,
                decoration: InputDecoration(
                  hintText: "Restraunt",
                  helperStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.pink,
          ),
          ListTile(
            leading: Icon(
              Icons.perm_device_information,
              color: Colors.pink,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(
                  color: Colors.deepPurpleAccent,
                ),
                controller: _addressTextEditingController,
                decoration: InputDecoration(
                  hintText: "Address",
                  helperStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.pink,
          ),
        ],
      ),
    );
  }

  clearFormInfo() {
    setState(() {
      file = null;
      _priceTextEditingController.clear();
      _shortInfoTextEditingController.clear();
      _titleTextEditingController.clear();
      _restrauntNameTextEditingController.clear();
      _addressTextEditingController.clear();
    });
  }

  uploadImageAndSaveInfo() async {
    setState(() {
      uploading = true;
    });
    uploadImage(file);
  }

  Future uploadImage(File mFile) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("items").child("food_$foodId.jpg");
    UploadTask uploadTask = ref.putFile(mFile);
    uploadTask.whenComplete(() async {
      downloadUrl = await ref.getDownloadURL();
      print("111111");
      print(downloadUrl);
      saveImageInfo();
    }).catchError((onError) {
      print(onError);
    });
  }

  Future saveImageInfo() async {
    FirebaseFirestore.instance.collection("items").doc(foodId).set({
      "shortInfo": _shortInfoTextEditingController.text.trim(),
      "price": int.parse(_priceTextEditingController.text),
      "restrauntName": _restrauntNameTextEditingController.text.trim(),
      "address": _addressTextEditingController.text.trim(),
      "title": _titleTextEditingController.text.trim(),
      "status": "available",
      "thumbnailUrl": downloadUrl,
      "publishDate": DateTime.now(),
    });

    setState(() {
      file = null;
      uploading = false;
      foodId = DateTime.now().microsecondsSinceEpoch.toString();
      _priceTextEditingController.clear();
      _titleTextEditingController.clear();
      _shortInfoTextEditingController.clear();
      _restrauntNameTextEditingController.clear();
      _addressTextEditingController.clear();
    });
  }
}
