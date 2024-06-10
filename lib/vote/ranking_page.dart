import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RankingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ranking Page'),

      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('votes')
            .orderBy('receiverID', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          Map<String, Map<String, int>> questionVotes = {};

          snapshot.data!.docs.forEach((doc) {
            String receiverID = doc['receiverID'];
            String greeting = doc['greeting'];

            if (!questionVotes.containsKey(greeting)) {
              questionVotes[greeting] = {};
            }
            questionVotes[greeting]?[receiverID] =
                (questionVotes[greeting]?[receiverID] ?? 0) + 1;
          });

          return ListView.builder(
            itemCount: questionVotes.length,
            itemBuilder: (context, index) {
              String greeting = questionVotes.keys.elementAt(index);
              Map<String, int> voteCountMap = questionVotes[greeting]!;

              List<String> topUsers = [];
              List<int> voteCounts = [];
              voteCountMap.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value))
                ..forEach((entry) {
                  topUsers.add(entry.key);
                  voteCounts.add(entry.value);
                });

              return Card(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question: $greeting',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: topUsers.length,
                        itemBuilder: (context, index) {
                          return FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('users')
                                .doc(topUsers[index])
                                .get(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return ListTile(
                                  title: Text('Loading...'),
                                );
                              }

                              var userData =
                              snapshot.data!.data() as Map<String, dynamic>;
                              String userName = userData['firstname'];

                              return ListTile(
                                title: Text(userName),
                                subtitle: Text('${voteCounts[index]} votes'),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
