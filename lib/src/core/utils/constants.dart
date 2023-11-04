import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LocalKey {
  static String tokenKey = "token";
  static String nearbyKey = "nearby";
  static String attractionKey = "attraction";
  static String placesKey = "places";
}

class ApiUrl {
  static final String _baseUrl = dotenv.get(
    'BASE_URL',
    fallback: 'http://192.168.50.111:3000',
  );

  static String logIn = "$_baseUrl/auth/log-in";
  static String signUp = "$_baseUrl/auth/sign-up";
  static String resetPassword = "$_baseUrl/auth/reset-password";
  static String userInfo = "$_baseUrl/user/info";
  static String placeList = "$_baseUrl/place/list";
  static String placeGoogleText = "$_baseUrl/place/google-text";
  static String placeGoogleNearby = "$_baseUrl/place/google-nearby";
  static String placeGoogleDetails = "$_baseUrl/place/google-details";
  static String placeGoogleDirection = "$_baseUrl/place/google-direction";
}

class PrimaryColor {
  static Color navyBlack = const Color(0xff13181F);
  static Color pureGrey = const Color(0xFF7D7D7D);
  static Color pureWhite = const Color(0xffFFFFFF);
  static Color pureRed = const Color(0xFFFF0000);
  static Color lightGrey = const Color(0x7B000000);
  static Color backgroundGrey = const Color(0xffFBFBFD);
}
