import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'daesign_drawer.dart';
import 'daesign_navcircle.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DaeSignPostCommentsPage(),
  ));
}

class DaeSignPostCommentsPage extends StatefulWidget {
  const DaeSignPostCommentsPage({super.key});

  @override
  State<DaeSignPostCommentsPage> createState() =>
      _DaeSignPostCommentsPageState();
}

class _DaeSignPostCommentsPageState extends State<DaeSignPostCommentsPage> {
  int _selectedTab = 1;

  static const String _heroImage =
      'assets/images/Placeholders/pretty_girl.png';

  static const List<Map<String, dynamic>> _comments = [
    {
      'name': 'malevolent_figma',
      'handle': '@malevolent_figma',
      'comment': 'This is the girl you meet 5 minutes before you wake up for a 9-5.',
      'likes': 447,
    },
    {
      'name': 'aintnoway',
      'handle': '@aintnoway',
      'comment': 'Glad to know I\'m not the only one having post-dream sadness.',
      'likes': 234,
    },
    {
      'name': 'alyssa',
      'handle': '@alyssaart',
      'comment': 'This palette is beautiful. Love the softness.',
      'likes': 156,
    },
  ];

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

                    // Hero / artwork area
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
                                  child: Image.asset(
                                    _heroImage,
                                    fit: BoxFit.cover,
                                  ),
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
                                    child: Image.asset(
                                      _heroImage,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
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
                                      color: Colors.grey.shade700,
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
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black,
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

                    // Comments List
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: _comments
                            .map(
                              (comment) => Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          comment['handle'],
                                          style: textTheme.titleMedium
                                              ?.copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.thumb_up,
                                            size: 18, color: Colors.black),
                                        const SizedBox(width: 6),
                                        Text(
                                          comment['likes'].toString(),
                                          style: textTheme.bodyMedium
                                              ?.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  comment['comment']!,
                                  style: textTheme.bodyLarge?.copyWith(
                                    fontSize: 16,
                                    height: 1.5,
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  height: 1,
                                  color: Colors.grey.shade300,
                                ),
                              ],
                            ),
                          ),
                        )
                            .toList(),
                      ),
                    ),

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
                    border: Border.all(color: Color(0xFF737373), width: 2),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DaeSignNavCircle(icon: Icons.home, label: 'Home', selected: false, onTap: () {}),
                      SizedBox(width: 16),
                      DaeSignNavCircle(icon: Icons.add, label: 'Add', selected: false, onTap: () {}),
                      SizedBox(width: 16),
                      DaeSignNavCircle(icon: Icons.search, label: 'Search', selected: false, onTap: () {}),
                      SizedBox(width: 16),
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
