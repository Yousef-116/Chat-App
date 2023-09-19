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

var TextColor = Color(0xFF000000);
var primeColor = Color(0xFF158FD3);
var backgroundColor = Color(0xFFFAFAFA);
var sendMessageColor = Color(0xFFC2DCFB);
var ReceiveMessageColor = Color(0xFFFFFFFF);
var TextBoxBackgroundColor = Color(0xFFECF0F0);

void lightMode() {
  TextColor = Color(0xFF000000);
  primeColor = Color(0xFF158FD3);
  backgroundColor = Color(0xFFFAFAFA);
  sendMessageColor = Color(0xFFC2DCFB);
  ReceiveMessageColor = Color(0xFFFFFFFF);
  TextBoxBackgroundColor = Color(0xFFECF0F0);
}

void darkMode() {
  TextColor = Color(0xFFFEFEFE);
  primeColor = Color(0xFF314CAC);
  backgroundColor = Color(0xFF141414);
  sendMessageColor = Color(0xFF0D407C);
  ReceiveMessageColor = Color(0xFF1A1A1A);
  TextBoxBackgroundColor = Color(0xFF2E2E2E);
}
