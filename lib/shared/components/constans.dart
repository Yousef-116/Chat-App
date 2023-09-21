import 'package:flutter/material.dart';

var scaffoldKey = GlobalKey<ScaffoldState>();
bool editState = false;
late int idedit;
var formKey = GlobalKey<FormState>();
var titleController = TextEditingController();
var dateController = TextEditingController();
var timeController = TextEditingController();
var chatUser;
var code;

bool Mode = true;

var TextColor = const Color(0xFF000000);
var primeColor = const Color(0xFF158FD3);
var backgroundColor = const Color(0xFFFAFAFA);
var sendMessageColor = const Color(0xFFC2DCFB);
var ReceiveMessageColor = const Color(0xFFFFFFFF);
var TextBoxBackgroundColor = const Color(0xFFECF0F0);
var ImageLogo = "https://i.imgur.com/GvODQ4X.png";

void lightMode() {
  TextColor = const Color(0xFF000000);
  primeColor = const Color(0xFF158FD3);
  backgroundColor = const Color(0xFFFAFAFA);
  sendMessageColor = const Color(0xFFC2DCFB);
  ReceiveMessageColor = const Color(0xFFFFFFFF);
  TextBoxBackgroundColor = const Color(0xFFECF0F0);
  ImageLogo = "https://i.imgur.com/GvODQ4X.png";
}

void darkMode() {
  TextColor = const Color(0xFFFEFEFE);
  primeColor = const Color(0xFF314CAC);
  backgroundColor = const Color(0xFF141414);
  sendMessageColor = const Color(0xFF0D407C);
  ReceiveMessageColor = const Color(0xFF1A1A1A);
  TextBoxBackgroundColor = const Color(0xFF2E2E2E);
  ImageLogo = "https://i.imgur.com/f555ppd.png";
}
