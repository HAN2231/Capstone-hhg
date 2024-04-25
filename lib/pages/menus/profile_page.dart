import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logintest/components/text_box.dart';
import 'package:logintest/pages/setting_page.dart';

class ProfilePage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser;
  // all users
  final usersCollection = FirebaseFirestore.instance.collection('users');

  // edit field
  Future<void> editField(String field, BuildContext context) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Edit $field",
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          autocorrect: true,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter new $field",
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
        actions: [
          // cancel button
          TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.pop(context),
          ),

          // save button
          TextButton(
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.of(context).pop(newValue),
          ),
        ],
      ),
    );

    // update in firestore
    if (newValue.trim().length > 0 ) {
      // only update if there is somthing
      await usersCollection.doc(currentUser!.email).update({field: newValue});
    }
  }

  Future<Map<String, dynamic>?> getCurrentUserInfo() async {
    if (currentUser != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUser!.uid).get();
      return userDoc.data() as Map<String, dynamic>?;
    }
    return null;
  }

  Future<void> addFriend(BuildContext context, String friendId) async {
    if (currentUser != null) {
      // 현재 사용자의 'friends' 컬렉션에 새로운 친구를 추가합니다.
      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('friends')
          .doc()
          .set({
        'friendId': friendId,
        'addedOn': FieldValue.serverTimestamp(), // 친구 추가 시간
      }).then((_) {
        Fluttertoast.showToast(
            msg: "친구가 추가되었습니다.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      }).catchError((error) {
        Fluttertoast.showToast(
            msg: "친구 추가에 실패했습니다: $error",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream =
        _firestore.collection('users').snapshots();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        actions: [
          /*IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => setting_Page()),
              );
            },
            icon: const Icon(Icons.settings_sharp, color: Colors.white),
          )*/
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),

            //profile pic
            Icon(
              Icons.person,
              size: 72,
            ),
            const SizedBox(
              height: 50,
            ),

            //user email
            Text(
              currentUser!.email!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(
              height: 50,
            ),

            //user details
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child:
                  Text("My Details", style: TextStyle(color: Colors.grey[600])),
            ),

            //username
            MyTextBox(
              text: 'fuck',
              sectionName: 'first name',
              onPressed: () => editField('first name',context),
            ),

            MyTextBox(
              text: 'empty bio',
              sectionName: 'bio',
              onPressed: () => editField('bio',context),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child:
                  Text("My Posts", style: TextStyle(color: Colors.grey[600])),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 25.0, left: 25.0),
              child: Text("Make friends",
                  style: TextStyle(color: Colors.grey[600])),
            ),

            StreamBuilder<QuerySnapshot>(
              stream: _usersStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    // 내부 ListView 스크롤 비활성화
                    shrinkWrap: true,
                    // 내용물 크기만큼 ListView 크기 조정
                    itemCount: streamSnapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[index];
                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          title: Text(documentSnapshot['first name']),
                          subtitle: Text(documentSnapshot['email']),
                          trailing: IconButton(
                            icon: const Icon(Icons.person_add),
                            onPressed: () =>
                                addFriend(context, documentSnapshot.id),
                          ),
                        ),
                      );
                    },
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
