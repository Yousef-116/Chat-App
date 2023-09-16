import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Chat_App/Register.dart';
import 'Chat_App/chatpage.dart';
import 'Chat_App/login.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //Bloc.observer = MyBlocObserver();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          "RegisterPage": (context) => RegisterPage(),
          "LoginPage": (context) => LoginPage(),
          "ChatPage": (context) => ChatPage()
        },
        initialRoute: "LoginPage");
  }
}
