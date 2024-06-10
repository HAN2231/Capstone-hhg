import 'dart:async';
import 'package:flutter/material.dart';
import 'package:logintest/pages/more4_prevote_page.dart';

import '../home_page.dart';
import '4more_prevote_page.dart';

class WaitingVotePage extends StatefulWidget {
  @override
  _WaitingVotePageState createState() => _WaitingVotePageState();
}

class _WaitingVotePageState extends State<WaitingVotePage> {
  late Timer _timer;
  int _secondsRemaining = 5; // 10분 = 600초

  @override
  void initState() {
    super.initState();
    // 1초마다 _updateTimer 함수를 호출하여 타이머 갱신
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          // 10분이 지나면 More4PrevotePage로 이동
          _timer.cancel(); // 타이머 종료
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // 페이지가 dispose될 때 타이머 종료
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 시간을 분과 초로 변환하여 표시
    int minutes = _secondsRemaining ~/ 60;
    int seconds = _secondsRemaining % 60;

    return Scaffold(
      appBar: AppBar(
        title: Text('Waiting Vote'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '투표를 마치고 있습니다.',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              '남은 시간: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
