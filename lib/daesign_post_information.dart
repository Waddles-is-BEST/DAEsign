import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'daesign_drawer.dart';
import 'daesign_navcircle.dart';



void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DaeSignPostInformationPage(postId: ''),
  ));
}

class DaeSignPostInformationPage extends StatefulWidget {
  final String postId;
  final String? imageurlAT;
  final String? contentAT;
  final String? userIdAT;

  const DaeSignPostInformationPage({
    super.key,
    required this.postId,
    this.imageurlAT,
    this.contentAT,
    this.userIdAT,
  });

  @override
  State<DaeSignPostInformationPage> createState() =>
      _DaeSignPostInformationPageState();
}

class _DaeSignPostInformationPageState
    extends State<DaeSignPostInformationPage> {
  int _selectedTab = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme =
    GoogleFonts.titilliumWebTextTheme(Theme.of(context).textTheme);

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const DaeSignDrawer(
        activeItem: DaeSignDrawerItem.home,
      ),

      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black, size: 30),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          '𝔻Æ𝕤𝕚𝕘𝕟',
          style: textTheme.titleLarge?.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.w400,
            color: Colors.black,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile tapped')),
                );
              },
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.black54,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.zero,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    SizedBox(
                      height: 520,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: ClipRect(
                              child: Transform.scale(
                                scale: 1.15,
                                child: ImageFiltered(
                                  imageFilter: ImageFilter.blur(
                                    sigmaX: 4,
                                    sigmaY: 4,
                                  ),
                                  child: widget.imageurlAT != null
                                      ? Image.network(
                                          widget.imageurlAT!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            print('Error loading image in post info (blurred): ${widget.imageurlAT}');
                                            print('Error: $error');
                                            return Container(
                                              color: Colors.grey.shade300,
                                            );
                                          },
                                        )
                                      : Container(color: Colors.grey.shade300),
                                ),
                              ),
                            ),
                          ),

                          Positioned.fill(
                            child: Container(
                              color: Colors.white.withOpacity(0.55),
                            ),
                          ),
                          Center(
                            child: FractionallySizedBox(
                              widthFactor: 0.72,
                              child: AspectRatio(
                                aspectRatio: 0.76,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 18,
                                        offset: Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(18),
                                    child: widget.imageurlAT != null
                                        ? Image.network(
                                            widget.imageurlAT!,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              print('Error loading image in post info: ${widget.imageurlAT}');
                                              print('Error: $error');
                                              return Container(
                                                color: Colors.grey.shade300,
                                                alignment: Alignment.center,
                                                child: const Icon(
                                                  Icons.image,
                                                  size: 56,
                                                  color: Colors.white70,
                                                ),
                                              );
                                            },
                                          )
                                        : Container(
                                            color: Colors.grey.shade300,
                                            alignment: Alignment.center,
                                            child: const Icon(
                                              Icons.image,
                                              size: 56,
                                              color: Colors.white70,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Tabs
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 44),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedTab = 0),
                              child: Column(
                                children: [
                                  Text(
                                    'Information',
                                    style: textTheme.headlineSmall?.copyWith(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 2,
                                    color: _selectedTab == 0
                                        ? Colors.black
                                        : Colors.transparent,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedTab = 1),
                              child: Column(
                                children: [
                                  Text(
                                    'Comments',
                                    style: textTheme.headlineSmall?.copyWith(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey.shade700,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 2,
                                    color: _selectedTab == 1
                                        ? Colors.black
                                        : Colors.transparent,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    if (_selectedTab == 0) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 44),
                        child: RichText(
                          text: TextSpan(
                            style: textTheme.titleMedium?.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                            children: [
                              const TextSpan(text: 'Artist: '),
                              TextSpan(
                                text: widget.userIdAT ?? 'Unknown',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 44),
                        child: Text(
                          widget.contentAT ?? '',
                          style: textTheme.bodyLarge?.copyWith(
                            fontSize: 18,
                            height: 1.55,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ] else ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('tbl_comments')
                              .where('post_idAT', isEqualTo: widget.postId)
                              .snapshots(),
                          builder: (context, snapshot) {
                            // Show loading state
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: const CircularProgressIndicator(),
                                ),
                              );
                            }

                            // Show error state
                            if (snapshot.hasError) {
                              print('Error loading comments: ${snapshot.error}');
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'No comments yet',
                                        style: textTheme.bodyLarge?.copyWith(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Be the first to comment!',
                                        style: textTheme.bodySmall?.copyWith(
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            // Check if data exists and has comments
                            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Text(
                                    'No comments yet',
                                    style: textTheme.bodyLarge?.copyWith(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              );
                            }

                            var comments = snapshot.data!.docs;
                            // Sort comments by createdAT in descending order
                            comments.sort((a, b) {
                              final aTime = (a['createdAT'] as Timestamp?)?.toDate() ?? DateTime.now();
                              final bTime = (b['createdAT'] as Timestamp?)?.toDate() ?? DateTime.now();
                              return bTime.compareTo(aTime);
                            });

                            return Column(
                              children: comments.map((comment) {
                                var commentData = comment.data() as Map<String, dynamic>;
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 14),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      FutureBuilder<DocumentSnapshot>(
                                        future: FirebaseFirestore.instance
                                            .collection('tbl_users')
                                            .doc(commentData['user_idAT'])
                                            .get(),
                                        builder: (context, userSnapshot) {
                                          String? userPhotoURL;
                                          if (userSnapshot.hasData && userSnapshot.data != null) {
                                            final userData = userSnapshot.data!.data() as Map<String, dynamic>?;
                                            userPhotoURL = userData?['photoURL'] as String?;
                                          }

                                          return CircleAvatar(
                                            radius: 22,
                                            backgroundColor: Colors.black54,
                                            child: userPhotoURL != null
                                                ? ClipOval(
                                                    child: Image.network(
                                                      userPhotoURL,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context, error, stackTrace) {
                                                        print('⚠️ Error loading commenter profile image: $userPhotoURL');
                                                        return const Icon(
                                                          Icons.person,
                                                          color: Colors.white,
                                                        );
                                                      },
                                                    ),
                                                  )
                                                : const Icon(
                                                    Icons.person,
                                                    color: Colors.white,
                                                  ),
                                          );
                                        },
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              commentData['user_idAT'] ?? '',
                                              style: textTheme.titleMedium?.copyWith(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              commentData['contentAT'] ?? '',
                                              style: textTheme.bodyMedium?.copyWith(
                                                fontSize: 15,
                                                height: 1.4,
                                                color: Colors.grey.shade700,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _commentController,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Write a comment...',
                                  hintStyle: textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () async {
                                final text = _commentController.text.trim();
                                if (text.isEmpty) return;

                                try {
                                  await FirebaseFirestore.instance
                                      .collection('tbl_comments')
                                      .add({
                                    'post_idAT': widget.postId,
                                    'user_idAT':
                                        FirebaseAuth.instance.currentUser?.displayName ??
                                            "User",
                                    'contentAT': text,
                                    'createdAT': FieldValue.serverTimestamp(),
                                  });

                                  await FirebaseFirestore.instance
                                      .collection('tbl_posts')
                                      .doc(widget.postId)
                                      .update({
                                    'noofcommentsAT': FieldValue.increment(1),
                                  });

                                  _commentController.clear();
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("$e")),
                                  );
                                }
                              },
                              icon: const Icon(Icons.send, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),

            // Bottom pill nav
            Positioned(
              left: 20,
              right: 20,
              bottom: 18,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 6)),
                    ],
                    border: Border.all(color: Colors.black, width: 2),  // CHANGED: black instead of grey, width 2
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DaeSignNavCircle(
                        icon: Icons.home,
                        label: 'Home',
                        target: DaeSignNavTarget.home,
                        selected: false,
                      ),
                      const SizedBox(width: 16),
                      DaeSignNavCircle(
                        icon: Icons.add,
                        label: 'Add',
                        target: DaeSignNavTarget.create,
                        selected: false,
                      ),
                      const SizedBox(width: 16),
                      DaeSignNavCircle(
                        icon: Icons.search,
                        label: 'Search',
                        target: DaeSignNavTarget.search,
                        selected: false,
                      ),
                      const SizedBox(width: 16),
                      DaeSignNavCircle(
                        icon: Icons.notifications,
                        label: 'Alerts',
                        target: DaeSignNavTarget.alerts,
                        selected: false,
                      ),

                    ],
                  ),
                ),

              ),
            ),
          ],
        ),
      ),
    );
  }
}