import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News Feed',
      home: ViewPostsPage(),
    );
  }
}
class ViewPostsPage extends StatelessWidget {
  const ViewPostsPage({super.key});

  Widget perpost(String? userid) {
    return Text(
      userid ?? 'Anonymous',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  Widget percontent(String? content) {
    return Text(
      content ?? 'No content',
      style: TextStyle(fontSize: 16),
    );
  }

  Widget perdate(Timestamp? timestamp) {
    if (timestamp == null) {
      return Text(
        'Just now',
        style: TextStyle(fontSize: 12, color: Colors.grey),
      );
    }
    return Text(
      timestamp.toDate().toString().split('.')[0],
      style: TextStyle(fontSize: 12, color: Colors.grey),
    );
  }

  Widget perlikes(int? likes) {
    return Row(
      children: [
        Icon(Icons.thumb_up_alt_outlined, color: Colors.green),
        SizedBox(width: 5),
        Text('${likes ?? 0}'),
      ],
    );
  }

  Widget percomments(int? comments) {
    return Row(
      children: [
        Icon(Icons.comment_outlined, color: Colors.red),
        SizedBox(width: 5),
        Text('${comments ?? 0}'),
      ],
    );
  }

  Widget perimage(String? imageUrl) {
    if (imageUrl == null) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.network(
          imageUrl,
          height: 220,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],

        appBar: AppBar(
          elevation: 0,
          title: const Text(
            "News Feed",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),

        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      child: Icon(Icons.person),
                    ),
                    const SizedBox(height: 10),
                    Text(FirebaseAuth.instance.currentUser?.displayName ?? "User"),
                    Text(
                      FirebaseAuth.instance.currentUser?.email ?? "",
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("Logout"),
                onTap: () async {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),

        body: Column(
          children: [
            SizedBox(height: 30),

            Container(
              color: Colors.white,
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  SizedBox(width: 10),

                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Post(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 12,
                        ),
                        alignment: Alignment.centerLeft,
                        side: BorderSide(color: Colors.grey.shade400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      child: Text(
                        "What's on your mind?",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('tbl_posts')
                    .orderBy('createdAT', descending: true)
                    .limit(50)
                    .snapshots(),
                builder: (context, snapshot) {
                  print('StreamBuilder state: ${snapshot.connectionState}');
                  if (snapshot.hasError) {
                    print('Firestore Error: ${snapshot.error}');
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Error: ${snapshot.error}'),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewPostsPage(),
                                ),
                              );
                            },
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text('No posts yet. Be the first to post!'),
                    );
                  }

                  final posts = snapshot.data!.docs;

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      final postData = post.data() as Map<String, dynamic>;

                      return Container(
                        margin: EdgeInsets.only(bottom: 12),
                        padding: EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  child: Icon(Icons.person, color: Colors.white),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      perpost(postData['user_idAT'] as String?),
                                      perdate(postData['createdAT'] as Timestamp?),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 15),
                            percontent(postData['contentAT'] as String?),

                            perimage(postData['imageurlAT'] as String?),

                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                perlikes(postData['nooflikeAT'] as int?),
                                percomments(postData['noofcommentsAT'] as int?),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        )
    );
  }
}