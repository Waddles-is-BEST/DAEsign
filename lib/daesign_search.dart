import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'daesign_drawer.dart';
import 'daesign_navcircle.dart';

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

  static final List<Map<String, dynamic>> samplePosts = [
    {
      'title': 'Remembering Steve',
      'author': '@apolover',
      'image': 'assets/images/Placeholders/steve_jobs.png',
      'likes': 298,
      'comments': 254,
      'views': 3454,
    },
    {
      'title': 'The Girl in my dream',
      'author': '@telenov...',
      'image': 'assets/images/Placeholders/pretty_girl.png',
      'likes': 298,
      'comments': 254,
      'views': 3454,
    },
    {
      'title': 'Portrait Study',
      'author': '@artlover',
      'image': 'assets/images/Placeholders/pink_girl.png',
      'likes': 120,
      'comments': 41,
      'views': 980,
    },
    {
      'title': 'Floral Dream',
      'author': '@flower',
      'image': 'assets/images/Placeholders/pretty_girl.png',
      'likes': 77,
      'comments': 14,
      'views': 600,
    },
    // duplicate to show more rows
    {
      'title': 'Digital Sketch',
      'author': '@digi',
      'image': 'assets/images/Placeholders/steve_jobs.png',
      'likes': 55,
      'comments': 8,
      'views': 420,
    },
    {
      'title': 'Evening Portrait',
      'author': '@luna',
      'image': 'assets/images/Placeholders/pink_girl.png',
      'likes': 180,
      'comments': 20,
      'views': 1300,
    },
  ];

  List<Map<String, dynamic>> get filteredPosts {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return samplePosts;
    return samplePosts.where((p) {
      final title = (p['title'] as String).toLowerCase();
      final author = (p['author'] as String).toLowerCase();
      return title.contains(q) || author.contains(q);
    }).toList();
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

                    // Results header (count)
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
                          Text(
                            '(${filteredPosts.length})',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Responsive grid of posts (Wrap)
                    LayoutBuilder(builder: (context, constraints) {
                      final outerPadding = 18.0;
                      final spacing = 14.0;
                      final cardWidth = (deviceWidth - outerPadding * 2 - spacing) / 2;

                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: outerPadding),
                        child: Wrap(
                          runSpacing: 18,
                          spacing: spacing,
                          children: filteredPosts.map((post) {
                            return SizedBox(
                              width: cardWidth,
                              child: _PostCard(
                                title: post['title'] as String,
                                author: post['author'] as String,
                                imageAsset: post['image'] as String,
                                likes: post['likes'] as int,
                                comments: post['comments'] as int,
                                views: post['views'] as int,
                                textTheme: textTheme,
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    }),

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
                      DaeSignNavCircle(icon: Icons.home, label: 'Home', selected: false, onTap: () {}),
                      const SizedBox(width: 16),
                      DaeSignNavCircle(icon: Icons.add, label: 'Add', selected: false, onTap: () {}),
                      const SizedBox(width: 16),
                      DaeSignNavCircle(icon: Icons.search, label: 'Search', selected: true, onTap: () {}),
                      const SizedBox(width: 16),
                      DaeSignNavCircle(icon: Icons.notifications, label: 'Alerts', selected: false, onTap: () {}),
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
class _PostCard extends StatelessWidget {
  const _PostCard({
    required this.title,
    required this.author,
    required this.imageAsset,
    required this.likes,
    required this.comments,
    required this.views,
    required this.textTheme,
  });

  final String title;
  final String author;
  final String imageAsset;
  final int likes;
  final int comments;
  final int views;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(title),
            content: Text('Open post by $author (front-end only)'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
            ],
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
                child: Image.asset(
                  imageAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.image, size: 48, color: Colors.white70),
                  ),
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
