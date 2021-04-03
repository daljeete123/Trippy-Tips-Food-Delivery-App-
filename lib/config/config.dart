import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrippyTips {
  static SharedPreferences sharedPreferences;
  static FirebaseAuth auth;

  static String collectionUser = "users";
  static String collectionOrders = "orders";
  static String subCollectionAddress = 'userAddress';
  static String userCartList = "usercart";
  static String foodTitle = "foodTitle";
  static String foodRestraunt = "foodRestraunt";
  static String foodPrice = "foodPrice";

  static final String userName = 'name';
  static final String userEmail = 'email';
  static final String userPhotoUrl = 'photourl';
  static final String userUid = 'uid';
  static final String userAvatarUrl = 'url';

  static final String addressID = 'addressID';
  static final String totalAmount = 'totalAmount';
  static final String productID = 'productIDs';
  static final String paymentDetails = 'paymentDetails';
  static final String orderTime = 'orderTime';
  static final String isSuccess = 'isSuccess';
}
