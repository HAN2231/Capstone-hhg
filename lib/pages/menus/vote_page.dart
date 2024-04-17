import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VotePage extends StatefulWidget {
  @override
  _VotePageState createState() => _VotePageState();
}

class _VotePageState extends State<VotePage> {
  List<String> _options = [];
  String _correctAnswer = '';

  @override
  void initState() {
    super.initState();
    _fetchOptions(); // Firestore에서 보기 가져오기
  }

  void _fetchOptions() async {
    // Firebase Firestore에서 사용자 목록 가져오기
    List<String> userIds = [];
    QuerySnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').get();
    userSnapshot.docs.forEach((doc) {
      userIds.add(doc.id);
    });

    // 사용자 목록에서 랜덤으로 4명 선택
    List<String> selectedUserNames = [];
    for (int i = 0; i < 4; i++) {
      String randomUserId = userIds[Random().nextInt(userIds.length)];
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(randomUserId).get();
      selectedUserNames.add(userDoc.get('last name'));
    }

    // 보기로 사용될 사용자 이름들을 랜덤하게 섞기
    selectedUserNames.shuffle();

    setState(() {
      _options = selectedUserNames;
    });
  }

  void _onOptionSelected(String option) {
    // Do something when an option is selected
  }

  void _shuffleOptions() {
    _fetchOptions(); // 다른 사용자의 이름으로 보기를 다시 가져오도록 호출
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Vote'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white,),
            onPressed: _logout,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'What is your name?',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20.0),
            Column(
              children: _options.map((option) {
                return ElevatedButton(
                  onPressed: () => _onOptionSelected(option),
                  child: Text(option),
                );
              }).toList(),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _shuffleOptions,
              child: Text('Shuffle Options'),
            ),
          ],
        ),
      ),
    );
  }
}
