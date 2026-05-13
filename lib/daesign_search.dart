import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'daesign_drawer.dart';
import 'daesign_navcircle.dart';
import 'daesign_home.dart';
import 'daesign_create.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DaeSignSearchPage(),
  ));
}

class DaeSignSearchPage extends StatefulWidget {
  const DaeSignSearchPage({super.key});

  @override
  State<DaeSignSearchPage> createState() => _DaeSignSearchPageState();
}

class _DaeSignSearchPageState extends State<DaeSignSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _selectedTag = 'all';
  int _selectedTab = 1;

  // Fetch posts from Firestore
  Stream<QuerySnapshot> _getPostsStream() {
    return FirebaseFirestore.instance.collection('tbl_posts').snapshots();
  }

  // Convert Firestore documents to display format
  List<Map<String, dynamic>> _convertFirestorePosts(List<DocumentSnapshot> docs) {
    return docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final tagsStr = (data['tagsAT'] as String?)?.trim() ?? '';
      final tags = tagsStr.isEmpty ? [] : tagsStr.split(',').map((t) => t.trim().toLowerCase()).toList();
      
      return {
        'id': doc.id,
        'postId': doc.id,
        'title': (data['contentAT'] as String?)?.split('\n').first ?? 'Untitled',
        'author': '@${(data['user_idAT'] as String?)?.replaceAll(' ', '') ?? 'user'}',
        'image': (data['imageurlAT'] as String?) ?? '',
        'likes': (data['nooflikeAT'] as int?) ?? 0,
        'comments': (data['noofcommentsAT'] as int?) ?? 0,
        'views': 0,
        'tags': tags,
      };
    }).toList();
  }

  List<Map<String, dynamic>> _filterPosts(List<Map<String, dynamic>> posts) {
    final q = _query.trim().toLowerCase();
    var filtered = posts;
    
    // Filter by search query (title and author)
    if (q.isNotEmpty) {
      filtered = filtered.where((p) {
        final title = (p['title'] as String).toLowerCase();
        final author = (p['author'] as String).toLowerCase();
        return title.contains(q) || author.contains(q);
      }).toList();
    }
    
    // Filter by selected tag
    if (_selectedTag != 'all') {
      filtered = filtered.where((p) {
        final tags = p['tags'] as List<dynamic>? ?? [];
        return tags.contains(_selectedTag.toLowerCase());
      }).toList();
    }
    
    return filtered;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme =
    GoogleFonts.titilliumWebTextTheme(Theme.of(context).textTheme);
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const DaeSignDrawer(activeItem: DaeSignDrawerItem.search),
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
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Profile tapped')));
              },
              child: const CircleAvatar(radius: 18, backgroundColor: Colors.black54),
            ),
          )
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
                  children: [
                    const SizedBox(height: 18),

                    // Centered pill search field
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Center(
                        child: SizedBox(
                          width: deviceWidth - 64,
                          height: 64,
                          child: TextField(
                            controller: _searchController,
                            onChanged: (v) => setState(() => _query = v),
                            textInputAction: TextInputAction.search,
                            style: textTheme.titleMedium?.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search...',
                              hintStyle: textTheme.titleMedium?.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey.shade600,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide: const BorderSide(color: Color(0xFF737373), width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide: const BorderSide(color: Color(0xFF737373), width: 2),
                              ),
                              prefixIcon: const Icon(Icons.search, color: Color(0xFF737373)),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // Results header (count) - will be updated by StreamBuilder
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Row(
                        children: [
                          Text(
                            'Results',
                            style: textTheme.headlineSmall?.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 8),
                          StreamBuilder<QuerySnapshot>(
                            stream: _getPostsStream(),
                            builder: (context, snapshot) {
                              final allPosts = _convertFirestorePosts(snapshot.data?.docs ?? []);
                              final filteredPosts = _filterPosts(allPosts);
                              return Text(
                                '(${filteredPosts.length})',
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade700,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Tag filter chips
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _TagChip(
                              label: 'All',
                              selected: _selectedTag == 'all',
                              onTap: () => setState(() => _selectedTag = 'all'),
                            ),
                            const SizedBox(width: 8),
                            _TagChip(
                              label: 'Portrait',
                              selected: _selectedTag == 'portrait',
                              onTap: () => setState(() => _selectedTag = 'portrait'),
                            ),
                            const SizedBox(width: 8),
                            _TagChip(
                              label: 'Digital',
                              selected: _selectedTag == 'digital',
                              onTap: () => setState(() => _selectedTag = 'digital'),
                            ),
                            const SizedBox(width: 8),
                            _TagChip(
                              label: 'Nature',
                              selected: _selectedTag == 'nature',
                              onTap: () => setState(() => _selectedTag = 'nature'),
                            ),
                            const SizedBox(width: 8),
                            _TagChip(
                              label: 'Character',
                              selected: _selectedTag == 'character',
                              onTap: () => setState(() => _selectedTag = 'character'),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Responsive grid of posts from Firestore
                    StreamBuilder<QuerySnapshot>(
                      stream: _getPostsStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.all(32),
                            child: CircularProgressIndicator(),
                          );
                        }
                        
                        if (snapshot.hasError) {
                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text('Error loading posts: ${snapshot.error}'),
                          );
                        }
                        
                        final allPosts = _convertFirestorePosts(snapshot.data?.docs ?? []);
                        final filteredPosts = _filterPosts(allPosts);
                        
                        if (filteredPosts.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(32),
                            child: Text(
                              'No posts found',
                              style: textTheme.titleMedium?.copyWith(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          );
                        }

                        return LayoutBuilder(builder: (context, constraints) {
                          final outerPadding = 18.0;
                          final spacing = 14.0;
                          final cardWidth = (deviceWidth - outerPadding * 2 - spacing) / 2;

                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: outerPadding),
                            child: Wrap(
                              runSpacing: 18,
                              spacing: spacing,
                              children: filteredPosts.map((post) {
                                final title = post['title'] as String? ?? 'Untitled';
                                final author = post['author'] as String? ?? 'Unknown';
                                final imageUrl = post['image'] as String? ?? '';
                                final likes = (post['likes'] as int?) ?? 0;
                                final comments = (post['comments'] as int?) ?? 0;
                                final views = (post['views'] as int?) ?? 0;
                                final postId = post['postId'] as String? ?? '';

                                return SizedBox(
                                  width: cardWidth,
                                  child: _PostCard(
                                    title: title,
                                    author: author,
                                    imageAsset: imageUrl,
                                    likes: likes,
                                    comments: comments,
                                    views: views,
                                    textTheme: textTheme,
                                    postId: postId,
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        });
                      },
                    ),

                    const SizedBox(height: 140),
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
                    border: Border.all(color: const Color(0xFF737373), width: 2),
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
                        selected: true,
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

/// Post card used by search (kept local to match app card style)
class _PostCard extends StatefulWidget {
  const _PostCard({
    required this.title,
    required this.author,
    required this.imageAsset,
    required this.likes,
    required this.comments,
    required this.views,
    required this.textTheme,
    required this.postId,
  });

  final String title;
  final String author;
  final String imageAsset;
  final int likes;
  final int comments;
  final int views;
  final TextTheme textTheme;
  final String postId;

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  late int _likes;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _likes = widget.likes;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => _PostDetailsSheet(
            title: widget.title,
            author: widget.author,
            imageAsset: widget.imageAsset,
            likes: _likes,
            comments: widget.comments,
            textTheme: widget.textTheme,
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
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: _buildPostImage(widget.imageAsset),
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
                      Flexible(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isLiked = !_isLiked;
                              _likes += _isLiked ? 1 : -1;
                            });
                          },
                          child: _Stat(
                            icon: _isLiked ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined,
                            value: _likes,
                            isActive: _isLiked,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: _Stat(icon: Icons.comment_outlined, value: widget.comments),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: _Stat(icon: Icons.remove_red_eye_outlined, value: widget.views),
                      ),
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

  Widget _buildPostImage(String imageUrl) {
    if (imageUrl.isEmpty) {
      return Container(
        color: Colors.grey.shade300,
        child: const Icon(Icons.image, size: 48, color: Colors.white70),
      );
    }

    if (imageUrl.startsWith('http')) {
      // Network image from Firestore
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          color: Colors.grey.shade300,
          child: const Icon(Icons.image, size: 48, color: Colors.white70),
        ),
      );
    } else {
      // Asset image (from sample/placeholder)
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          color: Colors.grey.shade300,
          child: const Icon(Icons.image, size: 48, color: Colors.white70),
        ),
      );
    }
  }
}

class _PostDetailsSheet extends StatefulWidget {
  final String title;
  final String author;
  final String imageAsset;
  final int likes;
  final int comments;
  final TextTheme textTheme;

  const _PostDetailsSheet({
    required this.title,
    required this.author,
    required this.imageAsset,
    required this.likes,
    required this.comments,
    required this.textTheme,
  });

  @override
  State<_PostDetailsSheet> createState() => _PostDetailsSheetState();
}

class _PostDetailsSheetState extends State<_PostDetailsSheet> {
  late int _likes;
  late int _comments;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _likes = widget.likes;
    _comments = widget.comments;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: double.infinity,
                    height: 280,
                    child: widget.imageAsset.startsWith('http')
                        ? Image.network(
                            widget.imageAsset,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.image, size: 56, color: Colors.white70),
                            ),
                          )
                        : Image.asset(
                            widget.imageAsset,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.image, size: 56, color: Colors.white70),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.title,
                  style: widget.textTheme.headlineSmall?.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.author,
                  style: widget.textTheme.bodyLarge?.copyWith(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isLiked = !_isLiked;
                          _likes += _isLiked ? 1 : -1;
                        });
                      },
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
                  children: [
                    'portrait',
                    'digital',
                    'character',
                  ]
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
              ],
            ),
          ),
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

class _TagChip extends StatelessWidget {
  const _TagChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.blue.shade100 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? Colors.blue : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.titilliumWeb(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.blue : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}
