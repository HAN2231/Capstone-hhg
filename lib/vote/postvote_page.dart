import 'package:flutter/material.dart';
import 'package:logintest/pages/Prevote/waiting_vote_page.dart';
import 'package:logintest/pages/home_page.dart';

class PostvotePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => WaitingVotePage()),
            );
          },
          child: Text(
            '투표 마치기',
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
