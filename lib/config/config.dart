import 'dart:math';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';
import 'package:rsiap_dokter/screen/home.dart';
import 'package:rsiap_dokter/screen/menu.dart';
import 'package:rsiap_dokter/screen/profile.dart';


// API Config
const String baseUrl = 'https://sim.rsiaaisyiyah.com/rsiap-api';
const String apiUrl = '$baseUrl/api';
String jwtSignature = randomString(32);

// App Config
const String appName = 'RSIAP Dokter';
const String appVersion = '1.0.0';

// Light Color
Color primaryColor = Colors.blue[700]!;
Color successColor = Colors.green[700]!;
Color warningColor = Colors.orange[700]!;
Color errorColor = Colors.red[700]!;
Color infoColor = Colors.blue[700]!;
Color secaondaryColor = Colors.grey[700]!;

// Dark Color
Color primaryColorDark = HexColor('#2bdaa8');
Color secondaryColorDark = HexColor('#cbf6ea');
Color accentColorDark = HexColor('#23c799');

Color successColorDark = Colors.teal;
Color warningColorDark = Colors.orange;
Color errorColorDark = Colors.pink;
Color infoColorDark = Colors.blue;

// background color
Color backgroundColor = HexColor('#d8f8ef');
Color backgroundColorDark = Colors.grey[900]!;

// text color
Color textColor = HexColor("#020d0a");
Color textColorLight = HexColor("#ffffff");

// font weight
FontWeight fontWeightLight = FontWeight.w300;
FontWeight fontWeightNormal = FontWeight.w400;
FontWeight fontWeightMedium = FontWeight.w500;
FontWeight fontWeightSemiBold = FontWeight.w600;
FontWeight fontWeightBold = FontWeight.w700;

// Other Config
const int snackBarDuration = 2;

// navigation bar
const List<Map<String, Object>> navigationItems = [
  {
    'icon': Icons.home,
    'label': 'Home',
    'widget': HomePage(),
  },
  {
    'icon': Icons.grid_view_rounded,
    'label': 'Menu',
    'widget': MenuPage(),
  },
  {
    'icon': Icons.person,
    'label': 'Profile',
    'widget': ProfilePage(),
  },
];

// Functions
String randomString(int length) {
  var rand = Random();
  var codeUnits = List.generate(length, (index) {
    return rand.nextInt(33) + 89;
  });

  return String.fromCharCodes(codeUnits);
}