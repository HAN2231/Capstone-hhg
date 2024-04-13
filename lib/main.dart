import 'package:flutter/material.dart';
import 'package:logintest/pages/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  //kakao login
  // runApp() 호출 전 Flutter SDK 초기화
  /*KakaoSdk.init(
    nativeAppKey: '242188026172368458f992be803ed3da',
    javaScriptAppKey: '9f57343ed28cd3119326dcb449d4c53e',
  );*/

  //firebase login
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(), //AuthPage()가 기본
    );
  }
}