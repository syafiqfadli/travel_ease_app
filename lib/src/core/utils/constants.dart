import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LocalKey {
  static String logInKey = "token";
}

class ApiUrl {
  static final String _baseUrl = dotenv.get(
    'BASE_URL',
    fallback: 'http://192.168.50.111:3000',
  );

  static String logIn = "$_baseUrl/auth/log-in";
  static String signUp = "$_baseUrl/auth/sign-up";
  static String userInfo = "$_baseUrl/user/info";
  static String placeGoogle = "$_baseUrl/place/google";
}

class PrimaryColor {
  static Color navyBlack = const Color(0xff13181F);
  static Color pureGrey = const Color(0xFF7D7D7D);
  static Color pureWhite = const Color(0xffFFFFFF);
  static Color backgroundGrey = const Color(0xffFBFBFD);
  static Color lightGrey = const Color.fromARGB(124, 0, 0, 0);
}
