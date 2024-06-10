import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class More4PrevotePage extends StatefulWidget {
  const More4PrevotePage({Key? key}) : super(key: key);

  @override
  _PrevotePageState createState() => _PrevotePageState();
}

class _PrevotePageState extends State<More4PrevotePage> {
  int _friendCount = 0;
  double _imageWidth = 300; // 이미지의 너비를 조절할 수 있도록 변수 추가
  double _imageHeight = 200;

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            color: Colors.black,
            padding: const EdgeInsets.all(0.0),
            child: Text(
              'Flirter',
              style: TextStyle(
                  fontFamily: 'continuous',
                  fontSize: 35,
                  fontWeight: FontWeight.w900),
              textAlign: TextAlign.left,
            ),
          ),
          Divider(
            color: Colors.black,
            thickness: 2, // 선의 두께를 설정
          ),
          ElevatedButton(
            onPressed: () {
              // 버튼이 눌렸을 때 수행할 작업 추가
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                Color.fromRGBO(222, 255, 255, 1), // #7EC8E3 색상
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // 모서리가 둥근 직사각형
                ),
              ),
            ),
            child: SizedBox(
              child: Container(
                color: Colors.grey,
                padding: const EdgeInsets.all(17.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center, // 가운데 정렬
                  children: [
                    Text(
                      '이번 주 인기투표가 오픈되었어요!',
                      textAlign: TextAlign.center, // 텍스트 가운데 정렬
                      style: TextStyle(
                        fontFamily: 'waguri',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(179, 200, 255, 1), // 검정색으로 변경
                      ),
                    ),
                    SizedBox(height: 10), // 텍스트 사이 간격 추가
                    Text(
                      '우리 학교 최고의 엄친아는? >',
                      textAlign: TextAlign.center, // 텍스트 가운데 정렬
                      style: TextStyle(
                        fontFamily: 'waguri',
                        fontSize: 22,
                        fontWeight: FontWeight.normal,
                        color: Colors.blue, // 검정색으로 변경
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Container(
            color: Colors.red,
            padding: const EdgeInsets.all(40.0),
            child: Text(
              '투표를 시작할 수 있어요!',
              style: TextStyle(
                  fontFamily: 'waguri',
                  fontSize: 30,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),

          Image.asset(
            'lib/images/friends3.png',
            width: _imageWidth = 300, // 이미지 너비 조정
            height: _imageHeight = 200, // 이미지 높이 조정
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: Text(
              '위로 밀어서 투표 시작하기!',
              style: TextStyle(
                fontFamily: 'waguri',
                fontSize: 25,
                color: Colors.blueAccent, // 텍스트 색상을 파란색으로 지정
              ),
            ),
          )
        ],
      ),
    );
  }
}
