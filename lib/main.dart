import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact-Less Attendance System',
      theme: ThemeData(
        primaryColor: Colors.purple,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Contact-Less Attendance System'),
        ),
        body: const WelcomePage(),
      ),
    );
  }
}
