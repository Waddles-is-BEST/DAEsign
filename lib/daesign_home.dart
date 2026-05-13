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
import 'services/likes_service.dart';
import 'daesign_category.dart';


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
  String _selectedTag = 'all';

  static final List<Map<String, dynamic>> exploreItems = [
    {
      'title': 'Classical Art',
      'subtitle': 'Vincent Van Gogh - Starry Night',
      'image': 'assets/images/Explore/starry_night.png',
      'description':
      'Classic art refers to traditional artistic styles rooted in balance, realism, harmony, and timeless beauty, often inspired by ancient Greek and Roman ideals.',
    },
    {
      'title': 'Anime Art',
      'subtitle': 'AkiraRosuki - Paint',
      'image': 'assets/images/Explore/anime_girl.png',
      'description':
      'Anime art focuses on expressive characters, bright palettes, and stylized visuals inspired by Japanese animation and illustration.',
    },
    {
      'title': 'Digital',
      'subtitle': 'Contemporary Works',
      'image': 'assets/images/Explore/starry_night.png',
      'description':
      'Digital art includes modern creative work produced with digital tools, from concept art to experimental mixed-media visuals.',
    },
  ];



  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.titilliumWebTextTheme(Theme.of(context).textTheme);
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const DaeSignDrawer(activeItem: DaeSignDrawerItem.home),
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
                            print('⚠️ Error loading current user profile image: ${authService.currentUser?.photoURL}');
                            print('   Error: $error');
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
                    SizedBox(
                      height: 205,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: exploreItems.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 14),
                          itemBuilder: (context, index) {
                            final item = exploreItems[index];
                            const double totalWidth = 280;
                            const double imageHeight = 116; // reduced to fit inside 205px total height

                            return SizedBox(
                              width: totalWidth,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DaeSignCategoryPage(
                                        title: item['title'] as String,
                                        subtitle: item['subtitle'] as String,
                                        bannerAsset: item['image'] as String,
                                        description: item['description'] as String,
                                      ),
                                    ),
                                  );
                                },

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
                                    const SizedBox(height: 6),
                                  ],
                                ),
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
                      DaeSignNavCircle(icon: Icons.home, label: 'Home', target: DaeSignNavTarget.home, selected: true),
                      const SizedBox(width: 16),
                      DaeSignNavCircle(icon: Icons.add, label: 'Add', target: DaeSignNavTarget.create, selected: false),
                      const SizedBox(width: 16),
                      DaeSignNavCircle(icon: Icons.search, label: 'Search', target: DaeSignNavTarget.search, selected: false),
                      const SizedBox(width: 16),
                      DaeSignNavCircle(icon: Icons.notifications, label: 'Alerts', target: DaeSignNavTarget.alerts, selected: false),
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

class _PostCard extends StatefulWidget {
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
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  late bool _isLiked;
  late int _likes;
  bool _isLoadingLike = false;

  @override
  void initState() {
    super.initState();
    _isLiked = false;
    _likes = widget.likes;
    _checkIfUserLiked();
  }

  Future<void> _checkIfUserLiked() async {
    if (widget.postId == null || widget.postId!.isEmpty) return;

    final hasLiked = await LikesService.hasUserLikedPost(widget.postId!);
    if (mounted) {
      setState(() {
        _isLiked = hasLiked;
      });
    }
  }

  Future<void> _toggleLike() async {
    if (widget.postId == null || widget.postId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Invalid post ID')),
      );
      return;
    }

    if (_isLoadingLike) return; // Prevent multiple taps

    setState(() {
      _isLoadingLike = true;
    });

    // Optimistic update for better UX
    final wasLiked = _isLiked;
    setState(() {
      _isLiked = !_isLiked;
      _likes = _isLiked ? _likes + 1 : _likes - 1;
    });

    // Perform the actual like/unlike operation
    final success = await LikesService.toggleLike(widget.postId!, wasLiked);

    setState(() {
      _isLoadingLike = false;
    });

    if (!success) {
      // Revert on failure
      setState(() {
        _isLiked = wasLiked;
        _likes = wasLiked ? _likes + 1 : _likes - 1;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error updating like')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DaeSignPostInformationPage(
              postId: widget.postId ?? '',
              imageurlAT: widget.imageUrl,
              contentAT: widget.title,
              userIdAT: widget.author,
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
                child: widget.imageUrl != null
                    ? Image.network(
                  widget.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    print('Error loading image: ${widget.imageUrl}');
                    print('Error: $error');
                    return Container(
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image, size: 48, color: Colors.white70),
                    );
                  },
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
                    widget.title,
                    style: widget.textTheme.titleMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.author,
                    style: widget.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: _isLoadingLike ? null : _toggleLike,
                        child: _Stat(
                          icon: _isLiked ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined,
                          value: _likes,
                          isActive: _isLiked,
                        ),
                      ),
                      const SizedBox(width: 12),
                      _Stat(icon: Icons.comment_outlined, value: widget.comments),
                      const SizedBox(width: 12),
                      _Stat(icon: Icons.remove_red_eye_outlined, value: widget.views),
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
    this.isActive = false,
  });

  final IconData icon;
  final int value;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: isActive ? Colors.blue : Colors.grey.shade700,
        ),
        const SizedBox(width: 6),
        Text(
          '$value',
          style: GoogleFonts.titilliumWeb(
            fontSize: 13,
            color: isActive ? Colors.blue : Colors.grey.shade700,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }
}

class _ExploreDetailsSheet extends StatefulWidget {
  final String title;
  final String subtitle;
  final String image;
  final int likes;
  final int comments;
  final List<String> tags;
  final TextTheme textTheme;

  const _ExploreDetailsSheet({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.likes,
    required this.comments,
    required this.tags,
    required this.textTheme,
  });

  @override
  State<_ExploreDetailsSheet> createState() => _ExploreDetailsSheetState();
}

class _ExploreDetailsSheetState extends State<_ExploreDetailsSheet> {
  late int _likes;
  late int _comments;
  bool _isLiked = false;
  bool _isLoadingLike = false;

  @override
  void initState() {
    super.initState();
    _likes = widget.likes;
    _comments = widget.comments;
  }

  Future<void> _toggleLike() async {
    if (_isLoadingLike) return;

    setState(() {
      _isLoadingLike = true;
    });

    final wasLiked = _isLiked;
    setState(() {
      _isLiked = !_isLiked;
      _likes = _isLiked ? _likes + 1 : _likes - 1;
    });

    // For explore items, we don't persist likes to Firestore
    // (they're static demo items, not real posts)
    // If you want to persist them, you'd need a postId field

    setState(() {
      _isLoadingLike = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    widget.image,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: double.infinity,
                      height: 250,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image, size: 56, color: Colors.white70),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  widget.title,
                  style: widget.textTheme.headlineSmall?.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),

                // Subtitle
                Text(
                  widget.subtitle,
                  style: widget.textTheme.bodyLarge?.copyWith(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                // Stats row
                Row(
                  children: [
                    GestureDetector(
                      onTap: _isLoadingLike ? null : _toggleLike,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: _isLiked ? Colors.blue.shade100 : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _isLiked ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined,
                              size: 18,
                              color: _isLiked ? Colors.blue : Colors.grey.shade700,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '$_likes',
                              style: GoogleFonts.titilliumWeb(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _isLiked ? Colors.blue : Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.comment_outlined, size: 18, color: Colors.grey.shade700),
                          const SizedBox(width: 6),
                          Text(
                            '$_comments',
                            style: GoogleFonts.titilliumWeb(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Tags section
                Text(
                  'Tags',
                  style: widget.textTheme.titleMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.tags
                      .map(
                        (tag) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Text(
                        '#$tag',
                        style: GoogleFonts.titilliumWeb(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  )
                      .toList(),
                ),
                const SizedBox(height: 20),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Added to favorites!')),
                          );
                        },
                        icon: const Icon(Icons.favorite_border),
                        label: const Text('Add Favorite'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade200,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Shared!')),
                          );
                        },
                        icon: const Icon(Icons.share),
                        label: const Text('Share'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




