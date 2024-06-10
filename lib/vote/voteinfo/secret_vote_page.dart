import 'dart:ui';

import 'package:animated_emoji/emoji.dart';
import 'package:animated_emoji/emojis.g.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../bottom_chat_page.dart';
import '../chat/chat_page.dart';
import '../chat/chat_service.dart';
import '../check_voter_page.dart';
import '../premium/off_premium_page.dart';

class SecretVotePage extends StatelessWidget {
  final String greeting;

  const SecretVotePage({Key? key, required this.greeting}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '시크릿 모드 사용자에게 투표 받았습니다.',
            style: TextStyle(fontSize: 18.sp, color: Colors.black),
          ),
          SizedBox(height: 20.h),
          Text(
            '인사말: $greeting',
            style: TextStyle(fontSize: 16.sp, color: Colors.black),
          ),
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('닫기'),
          ),
        ],
      ),
    );
  }
}
