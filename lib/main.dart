import 'package:flutter/material.dart';
import 'package:momants/pages/HomePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:momants/service/authentication.dart';
import 'package:momants/service/mapping.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.amber),
      title: 'Moments',
      home: MappingPage(
        auth: Auth(),
      ),
    );
  }
}