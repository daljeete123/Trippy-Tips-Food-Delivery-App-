import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  String title;
  String shortInfo;
  int price;
  String restrauntName;
  String status;
  String thumbnailUrl;
  String address;
  Timestamp publishDate;

  ItemModel({
    this.title,
    this.shortInfo,
    this.price,
    this.restrauntName,
    this.status,
    this.thumbnailUrl,
    this.address,
    this.publishDate,
  });

  ItemModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    shortInfo = json['shortInfo'];
    publishDate = json['publishedDate'];
    thumbnailUrl = json['thumbnailUrl'];
    restrauntName = json['restrauntName'];
    address = json['address'];
    status = json['status'];
    price = json['price'];
  }
}
