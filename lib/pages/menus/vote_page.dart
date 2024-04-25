import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logintest/components/greeting_data.dart'; // 예시 코드이므로 greetingList를 포함해야 합니다.

class VotePage extends StatefulWidget {
  @override
  _VotePageState createState() => _VotePageState();
}

class _VotePageState extends State<VotePage> {
  final _pageController = PageController();
  final int _maxPageCount = 10; // 페이지 수를 10으로 제한
  List<String> _currentOptions = [];
  List<String> _greetings = []; // 캐싱된 인사말 목록
  Map<int, List<String>> _optionsMap = {}; // 페이지 인덱스별 사용자 목록 캐싱

  @override
  void initState() {
    super.initState();
    _preloadGreetings();
    _preloadOptions();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _preloadGreetings() {
    for (int i = 0; i < _maxPageCount; i++) {
      _greetings.add(greetingList[Random().nextInt(greetingList.length)]);
    }
  }

  Future<void> _preloadOptions() async {
    for (int i = 0; i < _maxPageCount; i++) {
      _optionsMap[i] = await _fetchUserNames();
    }
    setState(() {});
  }

  Future<List<String>> _fetchUserNames() async {
    List<String> userIds = [];
    QuerySnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    userSnapshot.docs.forEach((doc) {
      userIds.add(doc.id);
    });

    // 사용자 수가 4보다 적은 경우 예외 처리
    int fetchCount = min(4, userIds.length);

    List<String> selectedUserNames = [];
    for (int i = 0; i < fetchCount; i++) {
      String randomUserId = userIds[Random().nextInt(userIds.length)];
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(randomUserId)
          .get();
      selectedUserNames.add(userDoc.get('last name'));
      // 이미 선택된 사용자는 목록에서 제거하여 중복 선택을 방지합니다.
      userIds.remove(randomUserId);
    }

    selectedUserNames.shuffle();
    return selectedUserNames;
  }

  Future<void> _reloadOptionsForCurrentPage(int pageIndex) async {
    _optionsMap[pageIndex] = await _fetchUserNames();
    setState(() {});
  }

  void _voteindex(int pageIndex, String option) async {
    // 현재 로그인한 사용자의 UID를 가져옴
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      print("로그인한 사용자가 없습니다.");
      return;
    }

    // 선택된 옵션의 인덱스를 찾음
    int optionIndex = _optionsMap[pageIndex]?.indexOf(option) ?? -1;
    if (optionIndex == -1) {
      print("선택된 옵션의 인덱스를 찾을 수 없습니다.");
      return;
    }

    // Firestore에 저장
    FirebaseFirestore.instance.collection('users').doc(userId).set({
      'voteIndex': optionIndex,
    }, SetOptions(merge: true)).then((_) {
      print("Vote index가 성공적으로 업데이트 되었습니다.");
    }).catchError((error) {
      print("Vote index 업데이트에 실패했습니다: $error");
    });
  }


  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: _maxPageCount, // 최대 페이지 수 제한
        itemBuilder: (context, index) => Container(
          child: Column(
            children: <Widget>[
              // 페이지 순서를 나타내는 Text 위젯을 추가합니다.
              const SizedBox(height: 30.0),
              // 페이지 순서
              Text(
                '${index + 1}/$_maxPageCount', // 인덱스는 0부터 시작하므로 1을 더해야 합니다.
                style: const TextStyle(fontSize: 25.0, color: Colors.white),
              ),
              const SizedBox(height: 30.0), // 간격을 조정하기 위해 SizedBox를 추가합니다.

              // 질문지
              Text(
                _greetings[index],
                style: TextStyle(fontSize: 40.0),
              ),
              const SizedBox(height: 40.0),

              // 사용자 목록
              Container(
                width: 350,
                height: 350,
                padding: EdgeInsets.fromLTRB(10,0,10,10),
                color: Colors.amber[600], // 전체 버튼 그룹을 감싸는 컨테이너의 배경색
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 한 행에 2개의 열을 표시
                    crossAxisSpacing: 10, // 열 사이의 간격
                    mainAxisSpacing: 10, // 행 사이의 간격
                    childAspectRatio: 1 / 0.9,
                  ),
                  itemCount: _optionsMap[index]?.length ?? 0,
                  itemBuilder: (context, i) {
                    String option = _optionsMap[index]![i];
                    return Container(
                      child: ElevatedButton(

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () => _voteindex(index, option),

                        child: Text(option, style: TextStyle(fontSize: 50)),
                      ),
                    );


                  },
                ),
              ),
              const SizedBox(height: 20.0),

              ElevatedButton(
                onPressed: () => _reloadOptionsForCurrentPage(index),
                child: Text('Shuffle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
