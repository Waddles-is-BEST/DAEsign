import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'daesign_drawer.dart';
import 'daesign_navcircle.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DaeSignHomePage(),
  ));
}

class DaeSignHomePage extends StatelessWidget {
  const DaeSignHomePage({super.key});

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
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.titilliumWebTextTheme(Theme.of(context).textTheme);
    final deviceWidth = MediaQuery.of(context).size.width;

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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile tapped')),
                );
              },
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.black54,
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

                    // Responsive two-column posts grid (Wrap)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Wrap(
                        runSpacing: 18,
                        spacing: 14,
                        children: samplePosts.map((post) {
                          final cardWidth = (deviceWidth - 14 * 2 - 14) / 2;
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
                      SizedBox(width: 16),  // ADD: spacing between icons
                      DaeSignNavCircle(icon: Icons.add, label: 'Add', onTap: () {}),
                      SizedBox(width: 16),  // ADD: spacing
                      DaeSignNavCircle(icon: Icons.search, label: 'Search', onTap: () {}),
                      SizedBox(width: 16),  // ADD: spacing
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
            // Post image — slightly taller look, rounded top corners
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



