import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('전체보기'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: UserSearchDelegate());
            },
          ),
        ],
      ),
      body: UserList(),
    );
  }
}

class UserSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return UserList(searchQuery: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SizedBox();
  }
}

class UserList extends StatefulWidget {
  final String? searchQuery;

  UserList({Key? key, this.searchQuery}) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<String> friendIds = [];
  String? currentUserMajor;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('데이터를 불러오는 중 오류가 발생했습니다.');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        final users = snapshot.data!.docs;
        final Map<String, List<DocumentSnapshot>> usersByMajor = {};

        users.forEach((user) {
          final major = user['major'] ?? '기타';
          if (!usersByMajor.containsKey(major)) {
            usersByMajor[major] = [];
          }
          if (!friendIds.contains(user.id) &&
              user.id != FirebaseAuth.instance.currentUser?.uid) {
            usersByMajor[major]!.add(user);
          }
        });

        List<String> sortedMajors = usersByMajor.keys.toList();
        sortedMajors.sort((a, b) => a.compareTo(b));

        if (currentUserMajor != null &&
            usersByMajor.containsKey(currentUserMajor)) {
          sortedMajors.remove(currentUserMajor);
          sortedMajors.insert(0, currentUserMajor!);
        }

        return ListView.builder(
          itemCount: sortedMajors.length,
          itemBuilder: (BuildContext context, int index) {
            final major = sortedMajors[index];
            final usersInMajor = usersByMajor[major]!;

            if (usersInMajor.isEmpty) {
              return SizedBox();
            }

            final filteredUsers = widget.searchQuery != null &&
                widget.searchQuery!.isNotEmpty
                ? usersInMajor.where((user) {
              final firstName = user['firstname']?.toString() ?? '';
              final fullName = '$firstName';
              return fullName.toLowerCase().contains(
                  widget.searchQuery!.toLowerCase());
            }).toList()
                : usersInMajor;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  child: Text(
                    major,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: filteredUsers.length,
                  itemBuilder: (BuildContext context, int index) {
                    final user = filteredUsers[index];
                    final firstName = user['firstname'] ?? '';
                    final fullName = '$firstName';
                    final userId = user.id;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(fullName),
                          trailing: IconButton(
                            icon: const Icon(Icons.person_add),
                            onPressed: () {
                              _addFriend(context, userId);
                            },
                          ),
                        ),
                        SizedBox(height: 8), // Add some space between users
                      ],
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadFriendList();
    _loadCurrentUserMajor();
  }

  Future<void> _loadCurrentUserMajor() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(
          currentUser.uid).get();
      setState(() {
        currentUserMajor = userDoc['major'];
      });
    }
  }

  Future<void> _loadFriendList() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userRef = FirebaseFirestore.instance.collection('users').doc(
          currentUser.uid);
      final friendSnapshot = await userRef.collection('friends').get();
      setState(() {
        friendIds = friendSnapshot.docs.map((doc) => doc.id).toList();
      });
    }
  }

  Future<void> _addFriend(BuildContext context, String friendId) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userRef = FirebaseFirestore.instance.collection('users').doc(
            currentUser.uid);
        final friendRef = FirebaseFirestore.instance.collection('users').doc(
            friendId);
        final friendDoc = await friendRef.get();

        if (friendDoc.exists) {
          final friendData = friendDoc.data() as Map<String,
              dynamic>; // 친구의 데이터를 가져옵니다.

          // Firestore에 친구 정보를 저장합니다. 이 때, department, firstname, major 정보도 함께 저장합니다.
          await userRef.collection('friends').doc(friendDoc.id).set({
            'friendId': friendDoc.id,
            'addedAt': DateTime.now(),
            'department': friendData['department'], // 친구의 부서
            'firstname': friendData['firstname'], // 친구의 이름
            'major': friendData['major'] // 친구의 전공
          });

          setState(() {
            friendIds.add(friendDoc.id);
          });

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('친구가 추가되었습니다.'),
            duration: Duration(seconds: 2),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('친구를 찾을 수 없습니다.'),
            duration: Duration(seconds: 2),
          ));
        }
      }
    } catch (error) {
      print('친구 추가 오류: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('친구 추가 중 오류가 발생했습니다.'),
        duration: Duration(seconds: 2),
      ));
    }
  }
}