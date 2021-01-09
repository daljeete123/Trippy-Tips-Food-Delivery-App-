import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrippyTips {
  static SharedPreferences sharedPreferences;
  static FirebaseAuth auth;

  static String userCartList = "usercart";

  static final String userName = 'name';
  static final String userEmail = 'email';
  static final String userPhotoUrl = 'photourl';
  static final String userUid = 'uid';
  static final String userAvatarUrl = 'url';
}
