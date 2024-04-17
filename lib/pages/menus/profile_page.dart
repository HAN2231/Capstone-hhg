import 'package:flutter/material.dart';
import '../home_page.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: Icon(Icons.logout, color: Colors.white),
          )
        ],
      ),
      body: Center(
          child: Text(
            "LOGGED IN AS: " + user.email!,
            style: TextStyle(fontSize: 20,color: Colors.white),
          )),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Center(
  //     child: Text(
  //       'Profile',
  //       style: TextStyle(fontSize: 50),
  //     ),
  //   );
  // }
}