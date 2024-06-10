import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendListPage extends StatelessWidget {
  final String currentUserId;

  FriendListPage({required this.currentUserId});

  Future<void> _deleteFriend(String friendId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('friends')
          .doc(friendId)
          .delete();
      // 친구를 삭제한 후에는 화면을 갱신하기 위해 setState를 호출할 필요는 없습니다.
    } catch (error) {
      print('친구 삭제 오류: $error');
      // 오류가 발생하면 사용자에게 메시지를 표시하거나 적절한 조치를 취할 수 있습니다.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('친구 목록'),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserId)
            .collection('friends')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            final List<DocumentSnapshot> documents = snapshot.data!.docs;

            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final friendDocument = documents[index];
                final String friendId = friendDocument.id; // Use document id as friendId

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('users').doc(friendId).get(),
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> friendSnapshot) {
                    if (friendSnapshot.connectionState == ConnectionState.done) {
                      if (friendSnapshot.hasData && friendSnapshot.data != null) {
                        final friendData = friendSnapshot.data!.data() as Map<String, dynamic>;
                        final String firstName = friendData['firstname'] ?? '';
                        final String lastName = friendData['lastname'] ?? '';
                        final String name = '$firstName $lastName'; // Combine first name and last name

                        final String email = friendData['email'] ?? '';

                        return ListTile(
                          title: Text(name),
                          subtitle: Text(email),
                          trailing: TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('이 친구를 삭제하시겠습니까??',
                                    style: TextStyle(
                                      fontSize: 18,
                                  ),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '친구를 삭제하시면 투표에서 선택을 할 수 없게 됩니다.',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('취소'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          _deleteFriend(friendId);
                                        },
                                        child: Text('삭제'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text('친구 삭제하기'),
                          ),
                        );
                      } else {
                        return Text('사용자 정보를 가져오지 못했습니다.');
                      }
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('친구 목록을 가져오는 중 오류가 발생했습니다.'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
