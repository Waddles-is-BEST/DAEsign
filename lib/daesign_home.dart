import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'daesign_drawer.dart';
import 'daesign_navcircle.dart';
import 'services/auth_service.dart';
import 'daesign_login.dart';
import 'daesign_profile.dart';
import 'daesign_create.dart';
import 'daesign_search.dart';
import 'daesign_post_information.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DaeSignHomePage(),
  ));
}

class DaeSignHomePage extends StatefulWidget {
  const DaeSignHomePage({super.key});

  @override
  State<DaeSignHomePage> createState() => _DaeSignHomePageState();
}

class _DaeSignHomePageState extends State<DaeSignHomePage> {
  final authService = AuthService();

  static final List<Map<String, String>> exploreItems = [
    {
      'title': 'Classical Art',
      'subtitle': 'Vincent Van Gogh - Starry Night',
      'image': 'assets/images/Explore/starry_night.png'
    },
    {
      'title': 'Anime Art',
      'subtitle': 'AkiraRosuki - Paint',
      'image': 'assets/images/Explore/anime_girl.png'
    },
    {
      'title': 'Digital',
      'subtitle': 'Contemporary Works',
      'image': 'assets/images/Explore/starry_night.png'
    },
  ];

  Future<void> _handleDrawerItemTap(DaeSignDrawerItem item) async {
    switch (item) {
      case DaeSignDrawerItem.signOut:
        _handleLogout();
        break;
      case DaeSignDrawerItem.profile:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DaeSignProfilePage()),
        );
        break;
      case DaeSignDrawerItem.createPost:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DaeSignCreatePage()),
        );
        break;
      case DaeSignDrawerItem.search:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DaeSignSearchPage()),
        );
        break;
      case DaeSignDrawerItem.home:
      case DaeSignDrawerItem.notifications:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${item.toString().split('.').last} tapped')),
        );
        break;
    }
  }

  Future<void> _handleLogout() async {
    try {
      await authService.signOut();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logged out successfully')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DaeSignLoginPage()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error logging out: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.titilliumWebTextTheme(Theme.of(context).textTheme);
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: DaeSignDrawer(
        activeItem: DaeSignDrawerItem.home,
        onItemTap: _handleDrawerItemTap,
      ),
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black, size: 28),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DaeSignProfilePage()),
                );
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.black54,
                child: authService.currentUser?.photoURL != null
                    ? ClipOval(
                        child: Image.network(
                          authService.currentUser!.photoURL!,
                          fit: BoxFit.cover,
                          width: 36,
                          height: 36,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.person,
                              size: 18,
                              color: Colors.white,
                            );
                          },
                        ),
                      )
                    : const Icon(
                        Icons.person,
                        size: 18,
                        color: Colors.white,
                      ),
              ),
            ),
          )
        ],
      ),

      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.zero,// keep space for pill nav
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 18),

                    // Explore header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Text(
                        'Explore',
                        style: textTheme.headlineSmall?.copyWith(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Horizontal Explore list - fixed height to match wireframe
// Horizontal Explore list - fixed height to match wireframe
                    SizedBox(
                      height: 170,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: exploreItems.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 14),
                          itemBuilder: (context, index) {
                            final item = exploreItems[index];
                            const double totalWidth = 280;
                            const double imageHeight = 116; // reduced to fit inside 170px total height

                            return SizedBox(
                              width: totalWidth,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _ExploreImageCard(
                                    imageAsset: item['image']!,
                                    width: totalWidth,
                                    height: imageHeight,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    item['title']!,
                                    style: textTheme.titleMedium?.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    item['subtitle']!,
                                    style: textTheme.bodySmall?.copyWith(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          },
                      ), // <-- end of ListView.separated
                    ),


                    const SizedBox(height: 18),

                    // Posts header row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Posts',
                            style: textTheme.headlineSmall?.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 12), // small gap between title and filters
                          _FilterChipLabel(label: 'Hot'),
                          const SizedBox(width: 8),
                          _FilterChipLabel(label: 'Trending'),
                          const SizedBox(width: 8),
                          _FilterChipLabel(label: 'New'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('tbl_posts')
                            .orderBy('createdAT', descending: true)
                            .limit(50)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  'No posts yet',
                                  style: textTheme.bodyLarge?.copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            );
                          }

                          var posts = snapshot.data!.docs;

                          return Wrap(
                            runSpacing: 18,
                            spacing: 14,
                            children: posts.map((post) {
                              var postData = post.data() as Map<String, dynamic>;
                              final cardWidth = (deviceWidth - 14 * 2 - 14) / 2;
                              return SizedBox(
                                width: cardWidth,
                                child: _PostCard(
                                  title: postData['contentAT'] ?? '',
                                  author: postData['user_idAT'] ?? '',
                                  imageUrl: postData['imageurlAT'] as String?,
                                  likes: postData['nooflikeAT'] ?? 0,
                                  comments: postData['noofcommentsAT'] ?? 0,
                                  views: 0,
                                  textTheme: textTheme,
                                  postId: post.id,
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // centered bottom pill
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 6)),
                    ],
                    border: Border.all(color: Color(0xFF737373), width: 2),

                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DaeSignNavCircle(icon: Icons.home, label: 'Home', selected: true, onTap: () {}),
                      SizedBox(width: 16),
                      DaeSignNavCircle(icon: Icons.add, label: 'Add', onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const DaeSignCreatePage()),
                        );
                      }),
                      SizedBox(width: 16),
                      DaeSignNavCircle(icon: Icons.search, label: 'Search', onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const DaeSignSearchPage()),
                        );
                      }),
                      SizedBox(width: 16),
                      DaeSignNavCircle(icon: Icons.notifications, label: 'Alerts', onTap: () {}),
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

class _ExploreImageCard extends StatelessWidget {
  const _ExploreImageCard({
    required this.imageAsset,
    required this.width,
    required this.height,
  });

  final String imageAsset;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.asset(
          imageAsset,
          width: width,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: Colors.grey.shade300,
            alignment: Alignment.center,
            child: const Icon(Icons.image, size: 48, color: Colors.white70),
          ),
        ),
      ),
    );
  }
}


class _FilterChipLabel extends StatelessWidget {
  const _FilterChipLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.titilliumWeb(
        fontSize: 14,
        color: Colors.grey.shade700,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({
    required this.title,
    required this.author,
    this.imageUrl,
    required this.likes,
    required this.comments,
    required this.views,
    required this.textTheme,
    this.postId,
  });

  final String title;
  final String author;
  final String? imageUrl;
  final int likes;
  final int comments;
  final int views;
  final TextTheme textTheme;
  final String? postId;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DaeSignPostInformationPage(
              postId: postId ?? '',
              imageurlAT: imageUrl,
              contentAT: title,
              userIdAT: author,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: imageUrl != null
                    ? Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.image, size: 48, color: Colors.white70),
                        ),
                      )
                    : Container(
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.image, size: 48, color: Colors.white70),
                      ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.titleMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    author,
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _Stat(icon: Icons.thumb_up_alt_outlined, value: likes),
                      const SizedBox(width: 12),
                      _Stat(icon: Icons.comment_outlined, value: comments),
                      const SizedBox(width: 12),
                      _Stat(icon: Icons.remove_red_eye_outlined, value: views),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.icon,
    required this.value,
  });

  final IconData icon;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade700),
        const SizedBox(width: 6),
        Text(
          '$value',
          style: GoogleFonts.titilliumWeb(
            fontSize: 13,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }
}



