import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'daesign_drawer.dart';

class DaeSignCategoryPage extends StatelessWidget {
  const DaeSignCategoryPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.bannerAsset,
    required this.description,
  });

  final String title;
  final String subtitle;
  final String bannerAsset;
  final String description;

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.titilliumWebTextTheme(
      Theme.of(context).textTheme,
    );
    final deviceWidth = MediaQuery.of(context).size.width;
    final cardWidth = (deviceWidth - 14 * 2 - 14) / 2;

    // Replace these with your real category thumbnails if you have them
    final featuredPosts = <Map<String, dynamic>>[
      {
        'title': 'Remembering Steve',
        'author': '@apolover',
        'image': bannerAsset,
        'likes': 298,
        'comments': 254,
        'views': 3454,
      },
      {
        'title': 'The Girl in my dream',
        'author': '@telenov...',
        'image': bannerAsset,
        'likes': 298,
        'comments': 254,
        'views': 3454,
      },
      {
        'title': 'Untitled Portrait',
        'author': '@artist',
        'image': bannerAsset,
        'likes': 182,
        'comments': 93,
        'views': 1820,
      },
      {
        'title': 'Soft Light Study',
        'author': '@studio',
        'image': bannerAsset,
        'likes': 121,
        'comments': 42,
        'views': 945,
      },
    ];

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
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.black54,
              child: const Icon(
                Icons.person,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                child: Image.asset(
                  bannerAsset,
                  width: double.infinity,
                  height: 290,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: double.infinity,
                    height: 290,
                    color: Colors.grey.shade300,
                    alignment: Alignment.center,
                    child: const Icon(Icons.image, size: 60, color: Colors.white70),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  title,
                  style: textTheme.headlineSmall?.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  description,
                  style: textTheme.bodyLarge?.copyWith(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              Center(
                child: Text(
                  'Featured Posts',
                  style: textTheme.headlineSmall?.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 22),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Wrap(
                  spacing: 14,
                  runSpacing: 18,
                  children: featuredPosts.map((post) {
                    return SizedBox(
                      width: cardWidth,
                      child: _CategoryPostCard(
                        title: post['title'] as String,
                        author: post['author'] as String,
                        image: post['image'] as String,
                        likes: post['likes'] as int,
                        comments: post['comments'] as int,
                        views: post['views'] as int,
                        textTheme: textTheme,
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryPostCard extends StatelessWidget {
  const _CategoryPostCard({
    required this.title,
    required this.author,
    required this.image,
    required this.likes,
    required this.comments,
    required this.views,
    required this.textTheme,
  });

  final String title;
  final String author;
  final String image;
  final int likes;
  final int comments;
  final int views;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Image.asset(
                image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade300,
                  alignment: Alignment.center,
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
                  children: [
                    _Stat(icon: Icons.thumb_up_alt_outlined, value: likes),
                    const SizedBox(width: 10),
                    _Stat(icon: Icons.comment_outlined, value: comments),
                    const SizedBox(width: 10),
                    _Stat(icon: Icons.remove_red_eye_outlined, value: views),
                  ],
                ),
              ],
            ),
          ),
        ],
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
        const SizedBox(width: 5),
        Text(
          '$value',
          style: GoogleFonts.titilliumWeb(
            fontSize: 13,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
