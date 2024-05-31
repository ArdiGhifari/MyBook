import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mybook/firebase_options.dart';
import 'package:mybook/screens/home_screen.dart';
import 'package:mybook/screens/login.dart';
import 'package:mybook/screens/post_book_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:  'Mybook',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
