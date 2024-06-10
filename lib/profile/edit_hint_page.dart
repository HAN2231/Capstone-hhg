import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileSettingPage extends StatefulWidget {
  final String hint1;
  final String hint2;
  final String hint3;

  ProfileSettingPage({
    required this.hint1,
    required this.hint2,
    required this.hint3,
  });

  @override
  _ProfileSettingPageState createState() => _ProfileSettingPageState();
}

class _ProfileSettingPageState extends State<ProfileSettingPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late TextEditingController _hint1Controller;
  late TextEditingController _hint2Controller;
  late TextEditingController _hint3Controller;

  @override
  void initState() {
    super.initState();
    _hint1Controller = TextEditingController(text: widget.hint1);
    _hint2Controller = TextEditingController(text: widget.hint2);
    _hint3Controller = TextEditingController(text: widget.hint3);
  }

  @override
  void dispose() {
    _hint1Controller.dispose();
    _hint2Controller.dispose();
    _hint3Controller.dispose();
    super.dispose();
  }

  Future<void> _updateUserData(BuildContext context) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      await _firestore.collection('users').doc(currentUser.uid).update({
        'userhint1': _hint1Controller.text,
        'userhint2': _hint2Controller.text,
        'userhint3': _hint3Controller.text,
      }).then((_) {
        Navigator.pop(context, {
          'hint1': _hint1Controller.text,
          'hint2': _hint2Controller.text,
          'hint3': _hint3Controller.text,
        });
      }).catchError((error) {
        // Handle error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('프로필 수정'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '프로필 힌트를 수정하세요',
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _hint1Controller,
                decoration: InputDecoration(
                  labelText: '힌트 1',
                  prefixIcon: Icon(Icons.lightbulb_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _hint2Controller,
                decoration: InputDecoration(
                  labelText: '힌트 2',
                  prefixIcon: Icon(Icons.lightbulb_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _hint3Controller,
                decoration: InputDecoration(
                  labelText: '힌트 3',
                  prefixIcon: Icon(Icons.lightbulb_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 32.0),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _updateUserData(context);
                  },
                  label: Text('저장',),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
