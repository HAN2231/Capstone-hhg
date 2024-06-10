import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Less4PrevotePage extends StatefulWidget {
  const Less4PrevotePage({Key? key}) : super(key: key);

  @override
  _PrevotePageState createState() => _PrevotePageState();
}

class _PrevotePageState extends State<Less4PrevotePage> {
  int _friendCount = 0;

  @override
  void initState() {
    super.initState();
    _loadFriendCount();
  }

  Future<void> _loadFriendCount() async {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    QuerySnapshot friendsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('friends')
        .get();

    setState(() {
      _friendCount = friendsSnapshot.size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prevote Page'),
      ),
      body: Center(
          child: Text(
          '4명 미만.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
