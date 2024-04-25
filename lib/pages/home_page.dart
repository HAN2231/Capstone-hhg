import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
<<<<<<< HEAD
import 'package:logintest/pages/Menus/chat_page.dart';
import 'package:logintest/pages/Menus/chatroom_page.dart';
import 'package:logintest/pages/Menus/profile_page.dart';
import 'package:logintest/pages/Menus/reels_page.dart';
import 'package:logintest/pages/Menus/vote_page.dart';

=======
>>>>>>> parent of 9ce337d (add navigator bar)

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  //sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }
<<<<<<< HEAD

  final List<Widget> menus = [
    VotePage(),
    ReelsPage(),
    ChatroomPage(),
    ProfilePage(),
  ];

=======
>>>>>>> parent of 9ce337d (add navigator bar)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: signUserOut,
              icon: Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
          child: Text(
            "LOGGED IN AS: " + user.email!,
            style: TextStyle(fontSize: 20),
      )),
    );
  }
}