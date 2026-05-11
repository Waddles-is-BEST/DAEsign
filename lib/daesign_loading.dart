import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'daesign_login.dart';

class DaeSignLoadingPage extends StatefulWidget {
  const DaeSignLoadingPage({super.key});

  @override
  State<DaeSignLoadingPage> createState() => _DaeSignLoadingPageState();
}

class _DaeSignLoadingPageState extends State<DaeSignLoadingPage> {
  @override
  void initState() {
    super.initState();
    // Navigate to login page after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DaeSignLoginPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/watercolor_landscape.png',
              fit: BoxFit.cover,
            ),
          ),

          // Centered loading box
          Center(
            child: Container(
              width: size.width * 0.85,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 64,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // DAEsign logo text
                  Text(
                    '𝔻Æ𝕤𝕚𝕘𝕟',
                    style: GoogleFonts.inter(
                      fontSize: 56,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Loading spinner
                  const SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
