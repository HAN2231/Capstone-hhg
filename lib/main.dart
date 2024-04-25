import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logintest/pages/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid ?
  await Firebase.initializeApp(
      options: FirebaseOptions(
      apiKey: 'AIzaSyBayTSx3oKg_hMNslP0Go4awUc-txZDHfI',
      appId: '1:929179227423:android:c6472589c65e32ad8c0c2a',
      messagingSenderId: '929179227423',
      projectId: 'seng-c94ca',))
  : await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: true,
      home: AuthPage(), //AuthPage()가 기본
    );
  }
}