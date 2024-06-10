import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:logintest/chat/chat_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../chat/chat_service.dart';

class DmRoomPage extends StatefulWidget {
  const DmRoomPage({Key? key}) : super(key: key);

  @override
  _DmRoomPageState createState() => _DmRoomPageState();
}

class _DmRoomPageState extends State<DmRoomPage> with AutomaticKeepAliveClientMixin<DmRoomPage> {
  Stream<QuerySnapshot>? _chatRoomsStream;
  late String _currentUserId;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _getCurrentUserId();
  }

  void _getCurrentUserId() {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      setState(() {
        _currentUserId = userId;
        _loadChatRooms();
      });
    }
  }

  void _loadChatRooms() {
    _chatRoomsStream = ChatService().getChatRooms(_currentUserId);
  }

  void _confirmDeleteChatRoom(String chatRoomId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('삭제 확인'),
          content: Text('정말로 이 채팅방을 삭제하시겠습니까?'),
          actions: [
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('삭제'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteChatRoom(chatRoomId);
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteChatRoom(String chatRoomId) {
    FirebaseFirestore.instance.collection('chat_rooms').doc(chatRoomId).delete();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // Initialize ScreenUtil
    ScreenUtil.init(
      context,
      designSize: Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('채팅 목록', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700)),
      ),
      body: _chatRoomsStream == null
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
        stream: _chatRoomsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('아직 받은 카드가 없어요.'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var chatRoom = snapshot.data!.docs[index];
              var users = List<String>.from(chatRoom['users']);
              users.remove(_currentUserId);
              String otherUserId = users.first;
              String voteId = chatRoom.id; // 채팅방의 voteId 사용

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(otherUserId).get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return ListTile(title: Text('Loading...'));
                  }
                  String otherUserEmail = userSnapshot.data!['email'];
                  String major = userSnapshot.data!['major'] ?? 'Unknown Major';
                  String hint1 = userSnapshot.data!['userhint1'] ?? 'No Hint';
                  String hint2 = userSnapshot.data!['userhint2'] ?? 'No Hint';
                  String hint3 = userSnapshot.data!['userhint3'] ?? 'No Hint';
                  String gender = userSnapshot.data!['gender'] ?? 'Unknown';

                  String lastMessage = chatRoom['lastMessage'];

                  String profileImage = gender == '남자' ? 'assets/men.png' : 'assets/female.png';

                  return Slidable(
                    key: Key(voteId),
                    endActionPane: ActionPane(
                      motion: const StretchMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) => _confirmDeleteChatRoom(voteId),
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: '삭제',
                          padding: EdgeInsets.symmetric(horizontal: 20),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(profileImage),
                        radius: 30.r,
                      ),
                      title: Text(
                        major,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                        ),
                      ),
                      subtitle: Text(
                        lastMessage,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14.sp,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(
                              voterId: otherUserId,
                              receiverEmail: otherUserEmail,
                              hint1: hint1,
                              hint2: hint2,
                              hint3: hint3,
                              greeting: '',
                              voteId: voteId,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
