import 'package:urban_voyager/screen/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:urban_voyager/screen/ui.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // initialize app
  await Firebase.initializeApp(); // initialize Firebase
  runApp(MyApp()); // run app
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: splash(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isStudent = true;

  void toggleLoginOption() {
    setState(() {
      isStudent = isStudent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return UI();
  }
}
