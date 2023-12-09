import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_fly/Student_login.dart';
import 'package:food_fly/Student_details_view_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Students_detilas.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home:  PROJEC(),
    );
  }
}
