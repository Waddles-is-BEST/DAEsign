import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'daesign_drawer.dart';
import 'daesign_navcircle.dart';



void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DaeSignPostInformationPage(),
  ));
}

class DaeSignPostInformationPage extends StatefulWidget {
  const DaeSignPostInformationPage({super.key});

  @override
  State<DaeSignPostInformationPage> createState() =>
      _DaeSignPostInformationPageState();
}

class _DaeSignPostInformationPageState
    extends State<DaeSignPostInformationPage> {
  int _selectedTab = 0;

  static const String _heroImage =
      'assets/images/Placeholders/pretty_girl.png';

  static const List<Map<String, String>> _comments = [
    {
      'name': 'Alyssa',
      'handle': '@alyssaart',
      'comment': 'This palette is beautiful. Love the softness.',
    },
    {
      'name': 'Marco',
      'handle': '@marco_d',
      'comment': 'The lighting and expression are amazing.',
    },
    {
      'name': 'Nina',
      'handle': '@nina.sketch',
      'comment': 'Feels like a dream scene — very expressive.',
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
                                scale: 1.15, // zoom in a bit
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
                      // Artist line
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
                                text: '@telenovela',
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

                      // Description
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 44),
                        child: Text(
                          'Drew this based on the women that I met in one of my most memorable lucid dreams. Took me the whole day of when I woke up to process that it was a dream...',
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
                        child: Column(
                          children: _comments
                              .map(
                                (comment) => Container(
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
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  const CircleAvatar(
                                    radius: 22,
                                    backgroundColor: Colors.black54,
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${comment['name']}  ${comment['handle']}',
                                          style:
                                          textTheme.titleMedium?.copyWith(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          comment['comment']!,
                                          style: textTheme.bodyMedium
                                              ?.copyWith(
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
                            ),
                          )
                              .toList(),
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