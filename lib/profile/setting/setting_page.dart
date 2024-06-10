import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'setting/flirter_dev_page.dart';
import 'setting/privacy_policy_page.dart'; // 개인정보 처리방침 페이지 import

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _logout(BuildContext context) async {
    try {
      await _auth.signOut();
      Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);
      // 로그아웃 후 로그인/회원가입 페이지로 이동하고 이전 페이지 스택을 모두 삭제합니다.
    } catch (e) {
      // 로그아웃 중 오류가 발생한 경우 처리
      print("로그아웃 중 오류가 발생했습니다: $e");
      // 필요한 경우 오류 처리 코드를 추가할 수 있습니다.
    }
  }

  Future<void> _deleteUser(BuildContext context) async {
    User? user = _auth.currentUser;
    final navigator = Navigator.of(context);

    if (user != null) {
      // Firestore에서 사용자 데이터 삭제
      try {
        await _firestore.collection('users').doc(user.uid).delete();
      } catch (e) {
        print("Firestore 데이터 삭제 중 오류가 발생했습니다: $e");
        return;
      }

      // Firebase Authentication에서 사용자 삭제
      try {
        await user.delete();
        // Navigator를 안전하게 호출하기 위해 addPostFrameCallback 사용
        WidgetsBinding.instance.addPostFrameCallback((_) {
          navigator.pushNamedAndRemoveUntil('/auth', (route) => false);
        });
      } catch (e) {
        print("사용자 삭제 중 오류가 발생했습니다: $e");
        // 필요한 경우 오류 처리 코드를 추가할 수 있습니다.
      }
    }
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('탈퇴하기'),
          content: Text('정말로 탈퇴하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: Text('아니오'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('예'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteUser(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('설정', style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.w700,)),
      ),
      backgroundColor: Colors.white, // 배경색을 흰색으로 설정
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  foregroundColor: Colors.black, backgroundColor: Colors.grey[100], // 버튼 텍스트 색상 설정
                  padding: EdgeInsets.all(16), // 버튼 패딩 설정
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // 테두리 반경 설정
                  ),
                ),
                onPressed: () {
                  // 개인정보 처리방침 페이지로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrivacyPolicyPage(), // 개인정보 처리방침 페이지
                    ),
                  );
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '개인정보 처리방침',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  foregroundColor: Colors.black, backgroundColor: Colors.grey[100], // 버튼 텍스트 색상 설정
                  padding: EdgeInsets.all(16), // 버튼 패딩 설정
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // 테두리 반경 설정
                  ),
                ),
                onPressed: () => _logout(context),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '로그아웃',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(

                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  foregroundColor: Colors.black, backgroundColor: Colors.grey[100], // 버튼 텍스트 색상 설정
                  padding: EdgeInsets.all(16), // 버튼 패딩 설정
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // 테두리 반경 설정
                  ),
                ),
                onPressed: () {
                  // 개인정보 처리방침 페이지로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FlirterDevPage(), // 개인정보 처리방침 페이지
                    ),
                  );
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Flirt를 만든 사람들',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(

                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  foregroundColor: Colors.red, backgroundColor: Colors.grey[100], // 버튼 텍스트 색상 설정
                  padding: EdgeInsets.all(16), // 버튼 패딩 설정
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // 테두리 반경 설정
                  ),
                ),
                onPressed: () => _showDeleteAccountDialog(context),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '탈퇴하기',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
