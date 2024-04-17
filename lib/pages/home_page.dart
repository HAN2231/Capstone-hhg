import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logintest/pages/Menus/chat_page.dart';
import 'package:logintest/pages/Menus/profile_page.dart';
import 'package:logintest/pages/Menus/reels_page.dart';
import 'package:logintest/pages/Menus/vote_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}
  final user = FirebaseAuth.instance.currentUser!;

  //sign user out method
void signUserOut() {
    FirebaseAuth.instance.signOut();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> menus = [
    VotePage(),
    ReelsPage(),
    ChatPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: menus[_selectedIndex],
      backgroundColor: Colors.deepPurple,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.deepPurple,
        color: Colors.deepPurple.shade200,
        animationDuration: Duration(milliseconds: 300),
        onTap: _navigateBottomBar,
        items: [
          CurvedNavigationBarItem(
            child: Icon(Icons.touch_app,
              color: Colors.white),
            label: 'Vote',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.electric_bolt,
                color: Colors.white),
            label: 'Reels',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.chat,
                color: Colors.white),
            label: 'Chat',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.person,
                color: Colors.white),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}


//       appBar: AppBar(
//         actions: [
//           IconButton(
//               onPressed: signUserOut,
//               icon: Icon(Icons.logout),
//           )
//         ],
//       ),
//       body: Center(
//           child: Text(
//             "LOGGED IN AS: " + user.email!,
//             style: TextStyle(fontSize: 20),
//       )),
//     );
//   }
// }

